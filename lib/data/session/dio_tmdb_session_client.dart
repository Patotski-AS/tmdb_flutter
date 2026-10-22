import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tmdb_flutter/core/network/tmdb_exception.dart';
import 'package:tmdb_flutter/core/network/tmdb_exception_mapper.dart';
import 'package:tmdb_flutter/data/session/dto/auth_dto.dart';
import 'package:tmdb_flutter/data/session/model/tmdb_account.dart';
import 'package:tmdb_flutter/data/session/tmdb_session_client.dart';

const String _requestTokenMessage = 'Не удалось получить request token';
const String _loginMessage = 'Неверный логин или пароль';
const String _accountMessage = 'Не удалось получить данные аккаунта';
const String _sessionMessage =
    'Не удалось создать сессию. '
    'Подтвердите вход на themoviedb.org';

/// [TmdbSessionClient] implemented with [Dio].
///
/// A [DioException] is unwrapped to the [TmdbException] stored in
/// `DioException.error`, or mapped when the interceptor did not run.
final class DioTmdbSessionClient implements TmdbSessionClient {
  /// Creates a client that sends auth requests through [dio].
  const new(this.dio);

  /// HTTP client pointed at the TMDB v3 root.
  final Dio dio;

  @override
  Future<String> createRequestToken() async {
    final body = await _get(
      'authentication/token/new',
      decode: RequestTokenResponseDto.fromJson,
    );
    return _requiredToken(
      success: body.success,
      value: body.requestToken,
      message: _requestTokenMessage,
    );
  }

  @override
  Future<String> validateWithLogin({
    required String username,
    required String password,
    required String requestToken,
  }) async {
    final body = await _post(
      'authentication/token/validate_with_login',
      data: ValidateWithLoginRequestDto(
        username: username,
        password: password,
        requestToken: requestToken,
      ).toJson(),
      decode: RequestTokenResponseDto.fromJson,
    );
    return _requiredToken(
      success: body.success,
      value: body.requestToken,
      message: _loginMessage,
    );
  }

  @override
  Future<String> createSession({required String requestToken}) async {
    final body = await _post(
      'authentication/session/new',
      data: SessionRequestDto(requestToken: requestToken).toJson(),
      decode: SessionResponseDto.fromJson,
    );
    return _requiredToken(
      success: body.success,
      value: body.sessionId,
      message: _sessionMessage,
    );
  }

  @override
  Future<TmdbAccount> getAccount({required String sessionId}) async {
    final body = await _get(
      'account',
      decode: AccountResponseDto.fromJson,
      queryParameters: {'session_id': sessionId},
    );
    if (body.id <= 0) {
      throw const TmdbResponseException(_accountMessage);
    }
    return TmdbAccount(id: body.id, username: body.username);
  }

  Future<T> _get<T>(
    String path, {
    required T Function(Map<String, dynamic> json) decode,
    Map<String, dynamic>? queryParameters,
  }) {
    return _guard(
      dio.get<Object?>(path, queryParameters: queryParameters),
      decode,
    );
  }

  Future<T> _post<T>(
    String path, {
    required Map<String, dynamic> data,
    required T Function(Map<String, dynamic> json) decode,
  }) {
    return _guard(
      dio.post<Object?>(
        path,
        data: data,
        options: Options(contentType: Headers.jsonContentType),
      ),
      decode,
    );
  }
}

Future<T> _guard<T>(
  Future<Response<Object?>> request,
  T Function(Map<String, dynamic> json) decode,
) async {
  try {
    final response = await request;
    return decode(_jsonObject(response.data));
  } on DioException catch (error) {
    throw _asTmdbException(error);
  } on CheckedFromJsonException catch (error) {
    throw TmdbResponseException('Неверный ответ TMDB.', cause: error);
  }
}

String _requiredToken({
  required bool success,
  required String? value,
  required String message,
}) {
  if (!success || value == null || value.trim().isEmpty) {
    throw TmdbResponseException(message);
  }
  return value;
}

Map<String, dynamic> _jsonObject(Object? data) {
  if (data is Map<String, dynamic>) {
    return data;
  }
  if (data is Map<Object?, Object?>) {
    final json = <String, dynamic>{};
    for (final entry in data.entries) {
      final key = entry.key;
      if (key is! String) {
        throw const TmdbResponseException('Неверный ответ TMDB.');
      }
      json[key] = entry.value;
    }
    return json;
  }
  throw const TmdbResponseException('Неверный ответ TMDB.');
}

TmdbException _asTmdbException(DioException error) {
  final cause = error.error;
  if (cause is TmdbException) {
    return cause;
  }
  return mapDioException(error);
}
