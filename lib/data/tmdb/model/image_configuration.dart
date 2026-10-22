import 'package:flutter/foundation.dart';

/// Base URL and size tokens used to build TMDB image links.
@immutable
final class ImageConfiguration {
  /// Creates an image configuration.
  const new({
    required this.posterBaseUrl,
    this.posterSize = defaultPosterSize,
    this.backdropSize = defaultBackdropSize,
    this.profileSize = defaultProfileSize,
  });

  /// Poster width requested from TMDB, `w500`.
  static const String defaultPosterSize = 'w500';

  /// Backdrop width requested from TMDB, `w780`.
  static const String defaultBackdropSize = 'w780';

  /// Profile width requested from TMDB, `w185`.
  static const String defaultProfileSize = 'w185';

  /// Secure CDN root, including the trailing slash.
  final String posterBaseUrl;

  /// Poster size token appended after [posterBaseUrl].
  final String posterSize;

  /// Backdrop size token appended after [posterBaseUrl].
  final String backdropSize;

  /// Profile size token appended after [posterBaseUrl].
  final String profileSize;

  /// Poster URL for [path], or null when [path] is null.
  ///
  /// [path] is the TMDB path, including its leading slash.
  String? posterUrlFor(String? path) => _url(path, posterSize);

  /// Backdrop URL for [path], or null when [path] is null.
  ///
  /// [path] is the TMDB path, including its leading slash.
  String? backdropUrlFor(String? path) => _url(path, backdropSize);

  /// Profile URL for [path], or null when [path] is null.
  ///
  /// [path] is the TMDB path, including its leading slash.
  String? profileUrlFor(String? path) => _url(path, profileSize);

  /// Absolute URL for a TMDB image [path] using [size].
  ///
  /// [path] is the TMDB path, including its leading slash.
  String urlFor(String path, String size) => '$posterBaseUrl$size$path';

  String? _url(String? path, String size) {
    if (path == null) {
      return null;
    }
    return urlFor(path, size);
  }

  @override
  bool operator ==(Object other) {
    return other is ImageConfiguration &&
        posterBaseUrl == other.posterBaseUrl &&
        posterSize == other.posterSize &&
        backdropSize == other.backdropSize &&
        profileSize == other.profileSize;
  }

  @override
  int get hashCode =>
      Object.hash(posterBaseUrl, posterSize, backdropSize, profileSize);
}
