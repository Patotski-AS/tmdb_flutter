import 'package:flutter/foundation.dart';

/// Whether a TMDB session is stored on the device.
@immutable
sealed class SessionState {
  const new();
}

/// No usable `session_id` or account id.
final class Guest extends SessionState {
  /// Creates the signed-out state.
  const new();

  @override
  bool operator ==(Object other) => other is Guest;

  @override
  int get hashCode => runtimeType.hashCode;
}

/// A stored session whose account id is at least 1.
final class Authenticated extends SessionState {
  /// Creates a signed-in state.
  const new({required this.accountId, this.username});

  /// TMDB account id.
  final int accountId;

  /// TMDB username, or null when the account has none.
  final String? username;

  @override
  bool operator ==(Object other) {
    return other is Authenticated &&
        accountId == other.accountId &&
        username == other.username;
  }

  @override
  int get hashCode => Object.hash(accountId, username);
}
