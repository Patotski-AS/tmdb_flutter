import 'package:tmdb_flutter/data/tmdb/dto/configuration_dto.dart';
import 'package:tmdb_flutter/data/tmdb/model/image_configuration.dart';

/// Maps [dto] the same way as the KMP `ConfigurationResponseDto.toDomain`.
///
/// Poster and profile sizes use the exact default token when TMDB lists it,
/// and that same token when it does not. Backdrop uses `w780` when listed,
/// otherwise the last size other than `original`, otherwise `w780`.
ImageConfiguration mapImageConfiguration(ConfigurationResponseDto dto) {
  final images = dto.images;
  return ImageConfiguration(
    posterBaseUrl: images.secureBaseUrl,
    posterSize: _listedOrDefault(
      images.posterSizes,
      ImageConfiguration.defaultPosterSize,
    ),
    backdropSize: _backdropSize(images.backdropSizes),
    profileSize: _listedOrDefault(
      images.profileSizes,
      ImageConfiguration.defaultProfileSize,
    ),
  );
}

String _listedOrDefault(List<String> sizes, String preferred) {
  for (final size in sizes) {
    if (size == preferred) {
      return size;
    }
  }
  return preferred;
}

String _backdropSize(List<String> sizes) {
  const preferred = ImageConfiguration.defaultBackdropSize;
  for (final size in sizes) {
    if (size == preferred) {
      return size;
    }
  }
  for (var index = sizes.length - 1; index >= 0; index -= 1) {
    final size = sizes[index];
    if (size != 'original') {
      return size;
    }
  }
  return preferred;
}
