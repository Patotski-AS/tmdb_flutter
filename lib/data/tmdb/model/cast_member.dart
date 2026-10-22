import 'package:flutter/foundation.dart';

/// An actor credited on a movie or a TV show.
@immutable
final class CastMember {
  /// Creates a cast entry.
  const new({
    required this.id,
    required this.name,
    required this.character,
    required this.profileUrl,
    required this.order,
  });

  /// TMDB person id.
  final int id;

  /// Person name.
  final String name;

  /// Character name. Empty when TMDB omits it.
  final String character;

  /// Absolute profile URL, or null when TMDB has no photo.
  final String? profileUrl;

  /// Billing order from TMDB. Lower comes first.
  final int order;

  @override
  bool operator ==(Object other) {
    return other is CastMember &&
        id == other.id &&
        name == other.name &&
        character == other.character &&
        profileUrl == other.profileUrl &&
        order == other.order;
  }

  @override
  int get hashCode => Object.hash(id, name, character, profileUrl, order);
}
