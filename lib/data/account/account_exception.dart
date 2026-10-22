/// Thrown before an account request when the user is signed out.
final class AccountAuthorizationException implements Exception {
  /// Creates the failure shown when a session is required.
  const new();

  /// Text safe to show in the UI.
  String get message => 'Необходима авторизация';

  @override
  String toString() => message;
}
