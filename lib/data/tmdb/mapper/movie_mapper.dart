import 'package:tmdb_flutter/data/tmdb/dto/movie_dto.dart';
import 'package:tmdb_flutter/data/tmdb/model/image_configuration.dart';
import 'package:tmdb_flutter/data/tmdb/model/movie.dart';
import 'package:tmdb_flutter/data/tmdb/model/paged.dart';

/// Maps [dto] to movies, building poster URLs from [images].
Paged<Movie> mapMoviePage(
  PopularMoviesResponseDto dto,
  ImageConfiguration images,
) {
  return Paged<Movie>(
    items: [for (final movie in dto.results) _mapMovie(movie, images)],
    page: dto.page,
    totalPages: dto.totalPages,
    totalResults: dto.totalResults,
  );
}

Movie _mapMovie(MovieDto dto, ImageConfiguration images) {
  return Movie(
    id: dto.id,
    title: dto.title,
    overview: dto.overview,
    posterUrl: images.posterUrlFor(dto.posterPath),
    voteAverage: dto.voteAverage,
    releaseDate: dto.releaseDate,
  );
}
