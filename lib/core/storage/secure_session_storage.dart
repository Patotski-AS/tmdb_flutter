import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tmdb_flutter/core/storage/session_storage.dart';

const String _sessionIdKey = 'session_id';
const String _accountIdKey = 'account_id';
const String _usernameKey = 'username';

/// [SessionStorage] backed by [FlutterSecureStorage].
class SecureSessionStorage implements SessionStorage {
  /// Creates a storage that writes only the TMDB session keys.
  const new(this._storage);

  final FlutterSecureStorage _storage;

  @override
  Future<StoredSession?> read() async {
    final results = await Future.wait<String?>([
      _storage.read(key: _sessionIdKey),
      _storage.read(key: _accountIdKey),
      _storage.read(key: _usernameKey),
    ]);
    final sessionId = results[0];
    if (sessionId == null || sessionId.isEmpty) {
      return null;
    }
    final accountId = int.tryParse(results[1] ?? '');
    if (accountId == null || accountId <= 0) {
      return null;
    }
    return StoredSession(
      sessionId: sessionId,
      accountId: accountId,
      username: results[2],
    );
  }

  @override
  Future<void> write(StoredSession session) async {
    await Future.wait<void>([
      _storage.write(key: _sessionIdKey, value: session.sessionId),
      _storage.write(key: _accountIdKey, value: '${session.accountId}'),
      _storage.write(key: _usernameKey, value: session.username),
    ]);
  }

  @override
  Future<void> clear() async {
    await Future.wait<void>([
      _storage.delete(key: _sessionIdKey),
      _storage.delete(key: _accountIdKey),
      _storage.delete(key: _usernameKey),
    ]);
  }
}
