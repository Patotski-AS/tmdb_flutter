import 'package:tmdb_flutter/data/tmdb/dto/tv_show_dto.dart';
import 'package:tmdb_flutter/data/tmdb/mapper/genre_mapper.dart';
import 'package:tmdb_flutter/data/tmdb/mapper/tv_mapper.dart';
import 'package:tmdb_flutter/data/tmdb/model/genre.dart';
import 'package:tmdb_flutter/data/tmdb/model/paged.dart';
import 'package:tmdb_flutter/data/tmdb/model/tv_show.dart';
import 'package:tmdb_flutter/data/tmdb/model/tv_show_details.dart';
import 'package:tmdb_flutter/data/tmdb/repository/image_configuration_cache.dart';
import 'package:tmdb_flutter/data/tmdb/repository/tv_repository.dart';
import 'package:tmdb_flutter/data/tmdb/source/tmdb_api.dart';

/// [TvRepository] that maps TMDB list payloads.
final class TvRepositoryImpl implements TvRepository {
  /// Creates a repository that reads TV shows through [api].
  ///
  /// Poster URLs use the shared [images] cache.
  const new({required this.api, required this.images});

  /// Remote catalog API.
  final TmdbApi api;

  /// Process-wide image configuration.
  final ImageConfigurationCache images;

  @override
  Future<List<Genre>> getTvGenres() async {
    return mapGenres(await api.getTvGenres());
  }

  @override
  Future<Paged<TvShow>> getPopularTvShows([int page = 1]) {
    return _load(() => api.getPopularTvShows(page: page));
  }

  @override
  Future<Paged<TvShow>> searchTvShows(String query, [int page = 1]) {
    return _load(() => api.searchTvShows(query: query, page: page));
  }

  @override
  Future<Paged<TvShow>> discoverTvShows({
    int? genreId,
    String? sortBy,
    int page = 1,
  }) {
    return _load(
      () => api.discoverTvShows(page: page, genreId: genreId, sortBy: sortBy),
    );
  }

  @override
  Future<TvShowDetails> getTvShowDetails(int tvId) async {
    final configuration = await images.require(api);
    final dto = await api.getTvShowDetails(id: tvId);
    return mapTvDetails(dto, configuration);
  }

  Future<Paged<TvShow>> _load(
    Future<PopularTvResponseDto> Function() load,
  ) async {
    final configuration = await images.require(api);
    return mapTvPage(await load(), configuration);
  }
}
