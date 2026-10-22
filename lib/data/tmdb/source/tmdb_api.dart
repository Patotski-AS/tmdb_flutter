import 'package:tmdb_flutter/data/tmdb/dto/configuration_dto.dart';
import 'package:tmdb_flutter/data/tmdb/dto/genre_dto.dart';
import 'package:tmdb_flutter/data/tmdb/dto/movie_details_dto.dart';
import 'package:tmdb_flutter/data/tmdb/dto/movie_dto.dart';
import 'package:tmdb_flutter/data/tmdb/dto/person_dto.dart';
import 'package:tmdb_flutter/data/tmdb/dto/tv_show_details_dto.dart';
import 'package:tmdb_flutter/data/tmdb/dto/tv_show_dto.dart';

/// Catalog and details endpoints of TMDB API v3.
///
/// Every request sends `language=ru-RU`. Search also sends
/// `include_adult=false`. Details also send `append_to_response`.
/// Null discover filters are omitted.
abstract interface class TmdbApi {
  /// `GET genre/movie/list`.
  Future<GenreListResponseDto> getMovieGenres();

  /// `GET genre/tv/list`.
  Future<GenreListResponseDto> getTvGenres();

  /// `GET movie/popular`.
  Future<PopularMoviesResponseDto> getPopularMovies({required int page});

  /// `GET movie/{id}` with credits, videos, images, recommendations.
  Future<MovieDetailsDto> getMovieDetails({required int id});

  /// `GET tv/popular`.
  Future<PopularTvResponseDto> getPopularTvShows({required int page});

  /// `GET tv/{id}` with credits, videos, images, recommendations.
  Future<TvShowDetailsDto> getTvShowDetails({required int id});

  /// `GET person/popular`.
  Future<PopularPeopleResponseDto> getPopularPeople({required int page});

  /// `GET search/movie`.
  Future<PopularMoviesResponseDto> searchMovies({
    required String query,
    required int page,
  });

  /// `GET search/tv`.
  Future<PopularTvResponseDto> searchTvShows({
    required String query,
    required int page,
  });

  /// `GET search/person`.
  Future<PopularPeopleResponseDto> searchPeople({
    required String query,
    required int page,
  });

  /// `GET discover/movie`.
  ///
  /// [genreId] is sent as `with_genres` and [sortBy] as `sort_by`.
  /// A null value is left out of the query.
  Future<PopularMoviesResponseDto> discoverMovies({
    required int page,
    int? genreId,
    String? sortBy,
  });

  /// `GET discover/tv`.
  ///
  /// [genreId] is sent as `with_genres` and [sortBy] as `sort_by`.
  /// A null value is left out of the query.
  Future<PopularTvResponseDto> discoverTvShows({
    required int page,
    int? genreId,
    String? sortBy,
  });

  /// `GET configuration`.
  Future<ConfigurationResponseDto> getConfiguration();
}
