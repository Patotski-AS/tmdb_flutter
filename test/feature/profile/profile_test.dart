import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tmdb_flutter/core/storage/session_storage.dart';
import 'package:tmdb_flutter/core/storage/session_storage_provider.dart';
import 'package:tmdb_flutter/data/account/account_providers.dart';
import 'package:tmdb_flutter/data/account/account_repository.dart';
import 'package:tmdb_flutter/data/session/model/tmdb_account.dart';
import 'package:tmdb_flutter/data/session/session_providers.dart';
import 'package:tmdb_flutter/data/session/session_repository.dart';
import 'package:tmdb_flutter/data/session/tmdb_session_client.dart';
import 'package:tmdb_flutter/data/tmdb/model/movie.dart';
import 'package:tmdb_flutter/feature/profile/favorites_notifier.dart';
import 'package:tmdb_flutter/feature/profile/profile_notifier.dart';

void main() {
  test('blank login does not call the session client', () async {
    final client = _Client();
    final container = _container(client: client)
      ..listen(profileProvider, (_, _) {});

    await container
        .read(profileProvider.notifier)
        .signIn(username: '  ', password: '');

    expect(
      container.read(profileProvider).error,
      'Введите логин и пароль',
    );
    expect(client.calls, isEmpty);
  });

  test('guest favorites stay empty without account api', () async {
    final account = _Account();
    final container = _container(account: account);
    await container.read(sessionRepositoryProvider.future);
    container.listen(favoritesProvider, (_, _) {});
    await _turn();

    expect(container.read(favoritesProvider).movies, isEmpty);
    expect(container.read(favoritesProvider).isLoading, isFalse);
    expect(account.calls, 0);
  });

  test('logout clears the favorite list', () async {
    final account = _Account();
    final container = _container(
      stored: const StoredSession(
        sessionId: 'sid',
        accountId: 7,
        username: 'neo',
      ),
      account: account,
    );
    await container.read(sessionRepositoryProvider.future);
    container.listen(favoritesProvider, (_, _) {});
    await _until(
      () => container.read(favoritesProvider).movies.length == 1,
    );

    await container.read(sessionRepositoryProvider.notifier).logout();
    await _until(() => container.read(favoritesProvider).movies.isEmpty);

    expect(container.read(favoritesProvider).error, isNull);
    expect(account.calls, 1);
  });
}

Future<void> _turn() async {
  await Future<void>.delayed(Duration.zero);
  await Future<void>.delayed(Duration.zero);
}

Future<void> _until(bool Function() ready) async {
  for (var attempt = 0; attempt < 20; attempt++) {
    if (ready()) {
      return;
    }
    await Future<void>.delayed(Duration.zero);
  }
  fail('favorites did not settle');
}

ProviderContainer _container({
  StoredSession? stored,
  _Account? account,
  _Client? client,
}) {
  final container = ProviderContainer(
    overrides: [
      sessionStorageProvider.overrideWithValue(_Memory(stored)),
      if (account != null)
        accountRepositoryProvider.overrideWithValue(account),
      if (client != null) tmdbSessionClientProvider.overrideWithValue(client),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

final class _Memory implements SessionStorage {
  new([this.session]);

  StoredSession? session;

  @override
  Future<StoredSession?> read() async => session;

  @override
  Future<void> write(StoredSession value) async {
    session = value;
  }

  @override
  Future<void> clear() async {
    session = null;
  }
}

final class _Account implements AccountRepository {
  int calls = 0;

  @override
  Future<bool> isFavorite(int movieId) async => false;

  @override
  Future<void> setFavorite({
    required int movieId,
    required bool favorite,
  }) async {}

  @override
  Future<List<Movie>> getFavoriteMovies() async {
    calls += 1;
    return const [
      Movie(
        id: 5,
        title: 'Фильм',
        overview: '',
        posterUrl: null,
        voteAverage: 7,
        releaseDate: null,
      ),
    ];
  }
}

final class _Client implements TmdbSessionClient {
  final calls = <String>[];

  @override
  Future<String> createRequestToken() async {
    calls.add('token');
    return 'token';
  }

  @override
  Future<String> validateWithLogin({
    required String username,
    required String password,
    required String requestToken,
  }) async {
    calls.add('validate');
    return requestToken;
  }

  @override
  Future<String> createSession({required String requestToken}) async {
    calls.add('session');
    return 'sid';
  }

  @override
  Future<TmdbAccount> getAccount({required String sessionId}) async {
    calls.add('account');
    return const TmdbAccount(id: 1, username: 'neo');
  }
}
