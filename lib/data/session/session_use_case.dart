import 'package:tmdb_flutter/data/session/session_repository.dart';
import 'package:tmdb_flutter/data/session/tmdb_session_client.dart';

/// Token, session and account chain for TMDB login.
class SessionUseCase {
  /// Creates a use case that stores a session after TMDB accepts it.
  const new({required this.client, required this.sessions});

  /// Authentication calls.
  final TmdbSessionClient client;

  /// Repository that stores a successful login.
  final SessionRepository sessions;

  /// Creates a request token, checks [username] and [password],
  /// then stores the session and account.
  Future<void> signInWithPassword({
    required String username,
    required String password,
  }) async {
    final requestToken = await client.createRequestToken();
    final approved = await client.validateWithLogin(
      username: username,
      password: password,
      requestToken: requestToken,
    );
    await _saveSession(approved);
  }

  /// Returns a request token and writes nothing.
  Future<String> beginApproval() {
    return client.createRequestToken();
  }

  /// Creates a session for an approved [requestToken] and stores it.
  Future<void> completeApproval(String requestToken) {
    return _saveSession(requestToken);
  }

  Future<void> _saveSession(String requestToken) async {
    final sessionId = await client.createSession(requestToken: requestToken);
    final account = await client.getAccount(sessionId: sessionId);
    await sessions.saveSession(
      sessionId: sessionId,
      accountId: account.id,
      username: account.username,
    );
  }
}
