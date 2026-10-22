import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tmdb_flutter/core/network/tmdb_exception.dart';
import 'package:tmdb_flutter/core/network/tmdb_exception_mapper.dart';
import 'package:tmdb_flutter/core/network/tmdb_session_interceptor.dart';
import 'package:tmdb_flutter/data/session/dio_tmdb_session_client.dart';
import 'package:tmdb_flutter/data/session/model/tmdb_account.dart';

void main() {
  test('auth calls use snake_case and the given session id', () async {
    final adapter = _PathAdapter();
    final client = _client(adapter);

    expect(await client.createRequestToken(), 'req-1');
    expect(
      await client.validateWithLogin(
        username: 'ada',
        password: 'secret',
        requestToken: 'req-1',
      ),
      'req-2',
    );
    expect(await client.createSession(requestToken: 'req-2'), 'sess-1');
    expect(
      await client.getAccount(sessionId: 'sess-explicit'),
      const TmdbAccount(id: 9, username: 'neo'),
    );

    final token = _request(adapter, '/authentication/token/new');
    expect(token.method, 'GET');
    expect(token.queryParameters.containsKey('session_id'), isFalse);

    final login = _request(
      adapter,
      '/authentication/token/validate_with_login',
    );
    expect(login.method, 'POST');
    expect(_body(login), {
      'username': 'ada',
      'password': 'secret',
      'request_token': 'req-1',
    });
    expect(
      '${login.headers[Headers.contentTypeHeader]}',
      contains('application/json'),
    );

    final session = _request(adapter, '/authentication/session/new');
    expect(_body(session), {'request_token': 'req-2'});

    final account = _request(adapter, '/account');
    expect(account.queryParameters['session_id'], 'sess-explicit');
    expect(account.extra[attachTmdbSessionKey], isNot(true));
  });

  test('rejected request token throws the KMP phrase', () async {
    await _expectPhrase(
      (client) => client.createRequestToken(),
      '{"success":false,"request_token":"req-1"}',
      'Не удалось получить request token',
    );
    await _expectPhrase(
      (client) => client.createRequestToken(),
      '{"success":true,"request_token":"  "}',
      'Не удалось получить request token',
    );
  });

  test('rejected login throws the KMP phrase', () async {
    await _expectPhrase(
      (client) => client.validateWithLogin(
        username: 'ada',
        password: 'nope',
        requestToken: 'req-1',
      ),
      '{"success":false}',
      'Неверный логин или пароль',
    );
  });

  test('rejected session throws the KMP phrase', () async {
    await _expectPhrase(
      (client) => client.createSession(requestToken: 'req-1'),
      '{"success":false,"session_id":"sess-1"}',
      'Не удалось создать сессию. Подтвердите вход на themoviedb.org',
    );
    await _expectPhrase(
      (client) => client.createSession(requestToken: 'req-1'),
      '{"success":true,"session_id":""}',
      'Не удалось создать сессию. Подтвердите вход на themoviedb.org',
    );
  });

  test('account id below 1 throws the KMP phrase', () async {
    for (final id in [0, -1]) {
      await _expectPhrase(
        (client) => client.getAccount(sessionId: 'sess-explicit'),
        '{"id":$id,"username":"neo"}',
        'Не удалось получить данные аккаунта',
      );
    }
  });

  test('http errors stay TmdbHttpException', () async {
    final client = _client(
      _FixedAdapter(
        '{"status_code":30,"status_message":"Invalid username"}',
        statusCode: 401,
      ),
    );

    await expectLater(
      client.validateWithLogin(
        username: 'ada',
        password: 'nope',
        requestToken: 'req-1',
      ),
      throwsA(
        isA<TmdbHttpException>().having(
          (error) => error.statusMessage,
          'statusMessage',
          'Invalid username',
        ),
      ),
    );
  });
}

Future<void> _expectPhrase(
  Future<Object?> Function(DioTmdbSessionClient client) call,
  String body,
  String message,
) {
  return expectLater(
    call(_client(_FixedAdapter(body))),
    throwsA(
      isA<TmdbResponseException>().having(
        (error) => error.message,
        'message',
        message,
      ),
    ),
  );
}

DioTmdbSessionClient _client(HttpClientAdapter adapter) {
  final dio = Dio(BaseOptions(baseUrl: 'https://api.themoviedb.org/3/'))
    ..httpClientAdapter = adapter
    ..interceptors.add(const TmdbExceptionInterceptor());
  addTearDown(dio.close);
  return DioTmdbSessionClient(dio);
}

RequestOptions _request(_PathAdapter adapter, String suffix) {
  return adapter.requests.lastWhere(
    (request) => request.uri.path.endsWith(suffix),
  );
}

Map<String, dynamic> _body(RequestOptions options) {
  final data = options.data;
  if (data is Map<String, dynamic>) {
    return data;
  }
  if (data is String) {
    final decoded = jsonDecode(data);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }
    if (decoded is Map) {
      return decoded.map((key, value) => MapEntry('$key', value));
    }
  }
  fail('Unexpected body: $data');
}

final class _FixedAdapter implements HttpClientAdapter {
  new(this.body, {this.statusCode = 200});

  final String body;
  final int statusCode;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    return _json(body, statusCode);
  }

  @override
  void close({bool force = false}) {}
}

final class _PathAdapter implements HttpClientAdapter {
  final requests = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return _json(_bodyFor(options.uri.path));
  }

  @override
  void close({bool force = false}) {}
}

ResponseBody _json(String body, [int statusCode = 200]) {
  return ResponseBody.fromString(
    body,
    statusCode,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
  );
}

String _bodyFor(String path) {
  if (path.endsWith('/authentication/token/new')) {
    return '{"success":true,"request_token":"req-1"}';
  }
  if (path.endsWith('/authentication/token/validate_with_login')) {
    return '{"success":true,"request_token":"req-2"}';
  }
  if (path.endsWith('/authentication/session/new')) {
    return '{"success":true,"session_id":"sess-1"}';
  }
  if (path.endsWith('/account')) {
    return '{"id":9,"username":"neo","avatar":{"tmdb":{"avatar_path":null}}}';
  }
  return '{}';
}
