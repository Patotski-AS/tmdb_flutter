import 'package:flutter/foundation.dart';

/// A video attached to a movie or a TV show.
@immutable
final class Video {
  /// Creates a video.
  const new({
    required this.id,
    required this.key,
    required this.name,
    required this.site,
    required this.type,
    required this.official,
  });

  /// TMDB video id.
  final String id;

  /// Site-specific key, for example a YouTube id.
  final String key;

  /// Video title.
  final String name;

  /// Hosting site, for example `YouTube`.
  final String site;

  /// TMDB type, for example `Trailer`.
  final String type;

  /// Whether TMDB marks the video as official.
  final bool official;

  @override
  bool operator ==(Object other) {
    return other is Video &&
        id == other.id &&
        key == other.key &&
        name == other.name &&
        site == other.site &&
        type == other.type &&
        official == other.official;
  }

  @override
  int get hashCode => Object.hash(id, key, name, site, type, official);
}
