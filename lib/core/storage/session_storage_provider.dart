import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tmdb_flutter/core/storage/secure_session_storage.dart';
import 'package:tmdb_flutter/core/storage/session_storage.dart';

part 'session_storage_provider.g.dart';

/// Secure storage for a future TMDB session.
///
/// Nothing reads this provider during startup.
@Riverpod(keepAlive: true)
SessionStorage sessionStorage(Ref ref) {
  return const SecureSessionStorage(FlutterSecureStorage());
}
