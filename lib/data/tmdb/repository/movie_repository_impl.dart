import 'package:tmdb_flutter/data/tmdb/dto/movie_dto.dart';
import 'package:tmdb_flutter/data/tmdb/mapper/genre_mapper.dart';
import 'package:tmdb_flutter/data/tmdb/mapper/movie_mapper.dart';
import 'package:tmdb_flutter/data/tmdb/model/genre.dart';
import 'package:tmdb_flutter/data/tmdb/model/image_configuration.dart';
import 'package:tmdb_flutter/data/tmdb/model/movie.dart';
import 'package:tmdb_flutter/data/tmdb/model/paged.dart';
import 'package:tmdb_flutter/data/tmdb/repository/image_configuration_cache.dart';
import 'package:tmdb_flutter/data/tmdb/repository/movie_repository.dart';
import 'package:tmdb_flutter/data/tmdb/source/tmdb_api.dart';

/// [MovieRepository] that maps TMDB list payloads.
final class MovieRepositoryImpl implements MovieRepository {
  /// Creates a repository that reads movies through [api].
  ///
  /// Poster URLs use the shared [images] cache.
  const new({required this.api, required this.images});

  /// Remote catalog API.
  final TmdbApi api;

  /// Process-wide image configuration.
  final ImageConfigurationCache images;

  @override
  Future<List<Genre>> getMovieGenres() async {
    return mapGenres(await api.getMovieGenres());
  }

  @override
  Future<Paged<Movie>> getPopularMovies([int page = 1]) {
    return _load(() => api.getPopularMovies(page: page));
  }

  @override
  Future<Paged<Movie>> searchMovies(String query, [int page = 1]) {
    return _load(() => api.searchMovies(query: query, page: page));
  }

  @override
  Future<Paged<Movie>> discoverMovies({
    int? genreId,
    String? sortBy,
    int page = 1,
  }) {
    return _load(
      () => api.discoverMovies(page: page, genreId: genreId, sortBy: sortBy),
    );
  }

  @override
  Future<ImageConfiguration> getImageConfiguration() {
    return images.require(api);
  }

  Future<Paged<Movie>> _load(
    Future<PopularMoviesResponseDto> Function() load,
  ) async {
    final configuration = await images.require(api);
    return mapMoviePage(await load(), configuration);
  }
}
