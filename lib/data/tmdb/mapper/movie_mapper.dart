import 'package:tmdb_flutter/data/tmdb/dto/movie_details_dto.dart';
import 'package:tmdb_flutter/data/tmdb/dto/movie_dto.dart';
import 'package:tmdb_flutter/data/tmdb/mapper/details_mapper.dart';
import 'package:tmdb_flutter/data/tmdb/model/image_configuration.dart';
import 'package:tmdb_flutter/data/tmdb/model/movie.dart';
import 'package:tmdb_flutter/data/tmdb/model/movie_details.dart';
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

/// Maps a movie card and builds image URLs from [images].
///
/// Videos whose site is not YouTube are dropped. Blank text becomes null.
MovieDetails mapMovieDetails(
  MovieDetailsDto dto,
  ImageConfiguration images,
) {
  final credits = dto.credits;
  final videos = dto.videos;
  final pictures = dto.images;
  return MovieDetails(
    id: dto.id,
    title: dto.title,
    overview: dto.overview,
    posterUrl: images.posterUrlFor(dto.posterPath),
    voteAverage: dto.voteAverage,
    releaseDate: dto.releaseDate,
    runtime: dto.runtime,
    genres: [for (final genre in dto.genres) genre.name],
    tagline: _nonBlank(dto.tagline),
    backdropUrl: images.backdropUrlFor(dto.backdropPath),
    originalTitle: _nonBlank(dto.originalTitle),
    status: _nonBlank(dto.status),
    originalLanguage: _nonBlank(dto.originalLanguage),
    budget: dto.budget,
    revenue: dto.revenue,
    cast: mapCast(credits?.cast ?? const [], images),
    crew: mapCrew(credits?.crew ?? const []),
    videos: mapYoutubeVideos(videos?.results ?? const []),
    backdrops: mapMediaImages(
      pictures?.backdrops ?? const [],
      images,
      backdrop: true,
    ),
    posters: mapMediaImages(
      pictures?.posters ?? const [],
      images,
      backdrop: false,
    ),
    recommendations: [
      for (final movie in dto.recommendations?.results ?? const <MovieDto>[])
        _mapMovie(movie, images),
    ],
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

String? _nonBlank(String? value) {
  if (value == null || value.trim().isEmpty) {
    return null;
  }
  return value;
}
