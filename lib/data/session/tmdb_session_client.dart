import 'package:tmdb_flutter/core/network/tmdb_exception.dart';
import 'package:tmdb_flutter/data/session/model/tmdb_account.dart';

/// TMDB authentication calls.
///
/// Failures are thrown as [TmdbException]. HTTP status errors stay
/// as the interceptor mapped them. `success: false`, or a blank
/// token or session, throws [TmdbResponseException].
abstract interface class TmdbSessionClient {
  /// `GET authentication/token/new`.
  ///
  /// Throws when `success` is false or `request_token` is blank.
  Future<String> createRequestToken();

  /// `POST authentication/token/validate_with_login`.
  ///
  /// Sends [username], [password] and [requestToken]. Throws when
  /// the login is rejected or the returned token is blank.
  Future<String> validateWithLogin({
    required String username,
    required String password,
    required String requestToken,
  });

  /// `POST authentication/session/new`.
  ///
  /// Throws when the session is missing or `success` is false.
  Future<String> createSession({required String requestToken});

  /// `GET account` for this [sessionId], not a stored session.
  ///
  /// Throws when `id` is below 1.
  Future<TmdbAccount> getAccount({required String sessionId});
}
