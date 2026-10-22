import 'package:flutter/foundation.dart';

/// A movie or TV genre.
@immutable
final class Genre {
  /// Creates a genre.
  const new({required this.id, required this.name});

  /// TMDB genre id.
  final int id;

  /// Localized genre name.
  final String name;

  @override
  bool operator ==(Object other) {
    return other is Genre && id == other.id && name == other.name;
  }

  @override
  int get hashCode => Object.hash(id, name);
}
