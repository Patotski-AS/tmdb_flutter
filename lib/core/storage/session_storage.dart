/// TMDB session persisted on the device.
class StoredSession {
  /// Creates a stored session.
  const new({
    required this.sessionId,
    required this.accountId,
    this.username,
  });

  /// TMDB `session_id`.
  final String sessionId;

  /// TMDB account id. Values below 1 are not stored as a valid session.
  final int accountId;

  /// TMDB username, when the account has one.
  final String? username;
}

/// Reads and writes the TMDB session outside the widget tree.
abstract interface class SessionStorage {
  /// Returns the saved session, or null when it is missing or incomplete.
  Future<StoredSession?> read();

  /// Replaces `session_id`, `account_id` and `username`.
  ///
  /// A null [StoredSession.username] removes the stored username.
  Future<void> write(StoredSession session);

  /// Removes `session_id`, `account_id` and `username`.
  Future<void> clear();
}
