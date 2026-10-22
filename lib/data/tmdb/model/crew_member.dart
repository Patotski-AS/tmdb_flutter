import 'package:flutter/foundation.dart';

/// A crew credit on a movie or a TV show.
@immutable
final class CrewMember {
  /// Creates a crew entry.
  const new({required this.id, required this.name, required this.job});

  /// TMDB person id.
  final int id;

  /// Person name.
  final String name;

  /// TMDB job, for example `Director`.
  final String job;

  @override
  bool operator ==(Object other) {
    return other is CrewMember &&
        id == other.id &&
        name == other.name &&
        job == other.job;
  }

  @override
  int get hashCode => Object.hash(id, name, job);
}
