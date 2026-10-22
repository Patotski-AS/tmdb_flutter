import 'package:flutter/foundation.dart';

/// Account returned by `GET account`.
@immutable
final class TmdbAccount {
  /// Creates an account.
  const new({required this.id, this.username});

  /// TMDB account id. Values below 1 are rejected by the client.
  final int id;

  /// TMDB username, or null when the account has none.
  final String? username;

  @override
  bool operator ==(Object other) {
    return other is TmdbAccount && id == other.id && username == other.username;
  }

  @override
  int get hashCode => Object.hash(id, username);
}
