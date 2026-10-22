import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tmdb_flutter/core/network/tmdb_exception.dart';
import 'package:tmdb_flutter/core/network/tmdb_session_interceptor.dart';
import 'package:tmdb_flutter/core/storage/session_storage.dart';
import 'package:tmdb_flutter/core/storage/session_storage_provider.dart';
import 'package:tmdb_flutter/data/session/model/tmdb_account.dart';
import 'package:tmdb_flutter/data/session/session_providers.dart';
import 'package:tmdb_flutter/data/session/session_repository.dart';
import 'package:tmdb_flutter/data/session/session_state.dart';
import 'package:tmdb_flutter/data/session/session_use_case.dart';
import 'package:tmdb_flutter/data/session/tmdb_session_client.dart';

void main() {
  test('restore reads account id and username', () async {
    const stored = StoredSession(
      sessionId: 'restored-session',
      accountId: 7,
      username: 'restored',
    );
    final container = _container(_MemorySessionStorage(stored));

    final state = await container.read(sessionRepositoryProvider.future);

    expect(state, const Authenticated(accountId: 7, username: 'restored'));
    expect(
      await container.read(sessionRepositoryProvider.notifier).getSessionId(),
      'restored-session',
    );
  });

  test('logout clears storage and becomes guest', () async {
    final storage = _MemorySessionStorage(
      const StoredSession(
        sessionId: 'restored-session',
        accountId: 7,
        username: 'restored',
      ),
    );
    final container = _container(storage);
    await container.read(sessionRepositoryProvider.future);

    await container.read(sessionRepositoryProvider.notifier).logout();

    expect(
      container.read(sessionRepositoryProvider).requireValue,
      const Guest(),
    );
    expect(await storage.read(), isNull);
    expect(
      await container.read(sessionRepositoryProvider.notifier).getSessionId(),
      isNull,
    );
  });

  test('missing session id or account id below 1 stays guest', () async {
    const invalid = <StoredSession?>[
      null,
      StoredSession(sessionId: '', accountId: 3, username: 'a'),
      StoredSession(sessionId: '   ', accountId: 3, username: 'a'),
      StoredSession(sessionId: 'sid', accountId: 0, username: 'a'),
      StoredSession(sessionId: 'sid', accountId: -2, username: 'a'),
    ];

    for (final stored in invalid) {
      final container = _container(_MemorySessionStorage(stored));
      expect(
        await container.read(sessionRepositoryProvider.future),
        const Guest(),
      );
      expect(
        await container.read(sessionRepositoryProvider.notifier).getSessionId(),
        isNull,
      );
    }
  });

  test('session id is sent only when the request opts in', () async {
    final container = _container(
      _MemorySessionStorage(
        const StoredSession(
          sessionId: 'session-1',
          accountId: 7,
          username: 'neo',
        ),
      ),
    );
    await container.read(sessionRepositoryProvider.future);
    final adapter = _RecordingAdapter();
    final dio = _dio(container, adapter);
    addTearDown(dio.close);

    await dio.get<void>('movie/popular');
    await dio.get<void>(
      'account',
      options: Options(extra: const {attachTmdbSessionKey: true}),
    );

    expect(adapter.requests, hasLength(2));
    expect(
      adapter.requests[0].queryParameters.containsKey('session_id'),
      isFalse,
    );
    expect(adapter.requests[1].queryParameters['session_id'], 'session-1');
  });

  test('missing session omits session_id instead of failing', () async {
    final container = _container(_MemorySessionStorage());
    await container.read(sessionRepositoryProvider.future);
    final adapter = _RecordingAdapter();
    final dio = _dio(container, adapter);
    addTearDown(dio.close);

    await dio.get<void>(
      'account',
      options: Options(extra: const {attachTmdbSessionKey: true}),
    );

    expect(
      adapter.requests.single.queryParameters.containsKey('session_id'),
      isFalse,
    );
  });

  test('password sign-in stores the validated session', () async {
    final harness = await _useCase();

    await harness.useCase.signInWithPassword(
      username: 'ada',
      password: 'secret',
    );

    expect(harness.client.calls, [
      'token',
      'validate:ada:secret:request-token',
      'session:validated-token',
      'account:session-id',
    ]);
    final stored = await harness.storage.read();
    expect(stored?.sessionId, 'session-id');
    expect(stored?.accountId, 12);
    expect(stored?.username, 'ada');
    expect(
      harness.container.read(sessionRepositoryProvider).requireValue,
      const Authenticated(accountId: 12, username: 'ada'),
    );
  });

  test('beginApproval returns a token and writes nothing', () async {
    final harness = await _useCase();

    final token = await harness.useCase.beginApproval();

    expect(token, 'request-token');
    expect(harness.client.calls, ['token']);
    expect(await harness.storage.read(), isNull);
    expect(
      harness.container.read(sessionRepositoryProvider).requireValue,
      const Guest(),
    );
  });

  test('completeApproval stores session and account', () async {
    final harness = await _useCase(username: null);

    await harness.useCase.completeApproval('approved-token');

    expect(harness.client.calls, [
      'session:approved-token',
      'account:session-id',
    ]);
    final stored = await harness.storage.read();
    expect(stored?.sessionId, 'session-id');
    expect(stored?.accountId, 12);
    expect(stored?.username, isNull);
    expect(
      harness.container.read(sessionRepositoryProvider).requireValue,
      const Authenticated(accountId: 12),
    );
  });

  test('failed account lookup does not store a session', () async {
    final harness = await _useCase();
    harness.client.failAt = 'account';

    await expectLater(
      harness.useCase.signInWithPassword(username: 'ada', password: 'secret'),
      throwsA(isA<TmdbResponseException>()),
    );
    expect(harness.client.calls, contains('account:session-id'));
    expect(
      harness.client.calls.where((call) => call.startsWith('session')),
      hasLength(1),
    );
    expect(await harness.storage.read(), isNull);
    expect(
      harness.container.read(sessionRepositoryProvider).requireValue,
      const Guest(),
    );
  });
}

ProviderContainer _container(SessionStorage storage) {
  final container = ProviderContainer(
    overrides: [sessionStorageProvider.overrideWithValue(storage)],
  );
  addTearDown(container.dispose);
  return container;
}

Dio _dio(ProviderContainer container, HttpClientAdapter adapter) {
  return Dio(BaseOptions(baseUrl: 'https://api.themoviedb.org/3/'))
    ..httpClientAdapter = adapter
    ..interceptors.add(
      TmdbSessionInterceptor(
        readSessionId: () =>
            container.read(sessionRepositoryProvider.notifier).getSessionId(),
      ),
    );
}

Future<_Harness> _useCase({String? username = 'ada'}) async {
  final storage = _MemorySessionStorage();
  final client = _Client(username: username);
  final container = ProviderContainer(
    overrides: [
      sessionStorageProvider.overrideWithValue(storage),
      tmdbSessionClientProvider.overrideWithValue(client),
    ],
  );
  addTearDown(container.dispose);
  await container.read(sessionRepositoryProvider.future);
  return _Harness(
    container: container,
    storage: storage,
    client: client,
    useCase: container.read(sessionUseCaseProvider),
  );
}

final class _Harness {
  new({
    required this.container,
    required this.storage,
    required this.client,
    required this.useCase,
  });

  final ProviderContainer container;
  final _MemorySessionStorage storage;
  final _Client client;
  final SessionUseCase useCase;
}

final class _MemorySessionStorage implements SessionStorage {
  new([this._session]);

  StoredSession? _session;

  @override
  Future<StoredSession?> read() async => _session;

  @override
  Future<void> write(StoredSession session) async {
    _session = session;
  }

  @override
  Future<void> clear() async {
    _session = null;
  }
}

final class _Client implements TmdbSessionClient {
  new({required this.username});

  final String? username;
  final calls = <String>[];
  String? failAt;

  @override
  Future<String> createRequestToken() async {
    calls.add('token');
    return 'request-token';
  }

  @override
  Future<String> validateWithLogin({
    required String username,
    required String password,
    required String requestToken,
  }) async {
    calls.add('validate:$username:$password:$requestToken');
    return 'validated-token';
  }

  @override
  Future<String> createSession({required String requestToken}) async {
    calls.add('session:$requestToken');
    return 'session-id';
  }

  @override
  Future<TmdbAccount> getAccount({required String sessionId}) async {
    calls.add('account:$sessionId');
    if (failAt == 'account') {
      throw const TmdbResponseException('Не удалось получить данные аккаунта');
    }
    return TmdbAccount(id: 12, username: username);
  }
}

final class _RecordingAdapter implements HttpClientAdapter {
  final requests = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return ResponseBody.fromString(
      '{}',
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
