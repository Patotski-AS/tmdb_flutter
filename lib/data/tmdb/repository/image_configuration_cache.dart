import 'package:tmdb_flutter/data/tmdb/mapper/configuration_mapper.dart';
import 'package:tmdb_flutter/data/tmdb/model/image_configuration.dart';
import 'package:tmdb_flutter/data/tmdb/source/tmdb_api.dart';

/// In-memory [ImageConfiguration] shared by the catalog repositories.
///
/// The value lives until the process exits. A failed load is not cached,
/// so the next call tries `GET configuration` again.
final class ImageConfigurationCache {
  /// Creates an empty cache.
  new();

  ImageConfiguration? _cached;
  Future<ImageConfiguration>? _loading;

  /// Returns the configuration, loading it from [api] at most once.
  Future<ImageConfiguration> require(TmdbApi api) {
    final cached = _cached;
    if (cached != null) {
      return Future<ImageConfiguration>.value(cached);
    }
    return _loading ??= _load(api);
  }

  Future<ImageConfiguration> _load(TmdbApi api) async {
    try {
      final dto = await api.getConfiguration();
      final configuration = mapImageConfiguration(dto);
      _cached = configuration;
      return configuration;
    } on Exception {
      _loading = null;
      rethrow;
    }
  }
}
