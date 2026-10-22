import 'package:flutter/foundation.dart';

/// A backdrop or poster from the TMDB images payload.
@immutable
final class MediaImage {
  /// Creates an image.
  const new({
    required this.url,
    required this.aspectRatio,
    required this.width,
  });

  /// Absolute image URL.
  final String url;

  /// Width divided by height.
  final double aspectRatio;

  /// Pixel width reported by TMDB.
  final int width;

  @override
  bool operator ==(Object other) {
    return other is MediaImage &&
        url == other.url &&
        aspectRatio == other.aspectRatio &&
        width == other.width;
  }

  @override
  int get hashCode => Object.hash(url, aspectRatio, width);
}
