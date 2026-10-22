import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tmdb_flutter/core/storage/session_storage.dart';
import 'package:tmdb_flutter/core/storage/session_storage_provider.dart';
import 'package:tmdb_flutter/data/session/session_state.dart';

part 'session_repository.g.dart';

/// Guest or authenticated TMDB session, restored from storage.
///
/// A missing session id, or an account id below 1, is [Guest].
/// Logout clears storage. This repository does not use Dio.
@Riverpod(keepAlive: true)
class SessionRepository extends _$SessionRepository {
  int _generation = 0;
  String? _sessionId;
  SessionState _applied = const Guest();

  @override
  Future<SessionState> build() async {
    final generation = ++_generation;
    final storage = ref.watch(sessionStorageProvider);
    final stored = await storage.read();
    if (!ref.mounted || generation != _generation) {
      return _applied;
    }
    return _remember(stored);
  }

  /// Stored `session_id`, or null when the state is [Guest].
  Future<String?> getSessionId() async {
    await future;
    if (_applied is! Authenticated) {
      return null;
    }
    final sessionId = _sessionId;
    if (sessionId == null || sessionId.trim().isEmpty) {
      return null;
    }
    return sessionId;
  }

  /// Signed-in account, or null when the state is [Guest].
  ///
  /// A blank session id is [Guest] even when an account id is stored.
  Future<Authenticated?> readAuthenticated() async {
    final current = await future;
    if (current is! Authenticated) {
      return null;
    }
    final sessionId = _sessionId;
    if (sessionId == null || sessionId.trim().isEmpty) {
      return null;
    }
    return current;
  }

  /// Clears storage and becomes [Guest].
  Future<void> logout() async {
    final generation = ++_generation;
    await ref.read(sessionStorageProvider).clear();
    if (!ref.mounted || generation != _generation) {
      return;
    }
    _sessionId = null;
    _applied = const Guest();
    state = const AsyncData(Guest());
  }

  /// Saves [sessionId], [accountId] and [username].
  ///
  /// The published state is [Authenticated] only when [sessionId]
  /// is not blank and [accountId] is at least 1.
  Future<void> saveSession({
    required String sessionId,
    required int accountId,
    String? username,
  }) async {
    final generation = ++_generation;
    final stored = StoredSession(
      sessionId: sessionId,
      accountId: accountId,
      username: username,
    );
    await ref.read(sessionStorageProvider).write(stored);
    if (!ref.mounted || generation != _generation) {
      return;
    }
    state = AsyncData(_remember(stored));
  }

  SessionState _remember(StoredSession? stored) {
    if (stored == null ||
        stored.sessionId.trim().isEmpty ||
        stored.accountId < 1) {
      _sessionId = null;
      return _applied = const Guest();
    }
    _sessionId = stored.sessionId;
    return _applied = Authenticated(
      accountId: stored.accountId,
      username: stored.username,
    );
  }
}
