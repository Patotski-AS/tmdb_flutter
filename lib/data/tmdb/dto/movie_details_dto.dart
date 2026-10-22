import 'package:json_annotation/json_annotation.dart';
import 'package:tmdb_flutter/data/tmdb/dto/details_dto.dart';
import 'package:tmdb_flutter/data/tmdb/dto/genre_dto.dart';
import 'package:tmdb_flutter/data/tmdb/dto/movie_dto.dart';

part 'movie_details_dto.g.dart';

/// Movie payload from `GET movie/{id}`.
///
/// Unknown JSON keys are ignored.
@JsonSerializable(
  fieldRename: FieldRename.snake,
  createToJson: false,
  checked: true,
)
final class MovieDetailsDto {
  /// Creates a movie details payload.
  const new({
    required this.id,
    required this.title,
    this.overview = '',
    this.posterPath,
    this.backdropPath,
    this.tagline,
    this.voteAverage = 0,
    this.releaseDate,
    this.runtime,
    this.genres = const [],
    this.originalTitle,
    this.status,
    this.originalLanguage,
    this.budget = 0,
    this.revenue = 0,
    this.credits,
    this.videos,
    this.images,
    this.recommendations,
  });

  /// Parses a movie details object.
  factory fromJson(Map<String, dynamic> json) =>
      _$MovieDetailsDtoFromJson(json);

  /// TMDB movie id.
  final int id;

  /// Localized title.
  final String title;

  /// Description. Empty when the field is missing or null.
  final String overview;

  /// Poster path, including the leading slash, or null.
  final String? posterPath;

  /// Backdrop path, including the leading slash, or null.
  final String? backdropPath;

  /// Tagline, or null.
  final String? tagline;

  /// Average vote from 0 to 10.
  final double voteAverage;

  /// Release date `YYYY-MM-DD`, or null.
  final String? releaseDate;

  /// Runtime in minutes, or null.
  final int? runtime;

  /// Genres. Empty when the field is missing or null.
  final List<GenreDto> genres;

  /// Original title, or null.
  final String? originalTitle;

  /// Status, or null.
  final String? status;

  /// Original language code, or null.
  final String? originalLanguage;

  /// Budget in dollars. Zero when the field is missing or null.
  final int budget;

  /// Revenue in dollars. Zero when the field is missing or null.
  final int revenue;

  /// Appended credits, or null when the field is missing.
  final CreditsDto? credits;

  /// Appended videos, or null when the field is missing.
  final VideosResponseDto? videos;

  /// Appended images, or null when the field is missing.
  final ImagesResponseDto? images;

  /// Appended recommendations, or null when the field is missing.
  final MovieRecommendationsDto? recommendations;
}

/// `recommendations` object on a movie details response.
///
/// Unknown JSON keys are ignored.
@JsonSerializable(
  fieldRename: FieldRename.snake,
  createToJson: false,
  checked: true,
)
final class MovieRecommendationsDto {
  /// Creates a movie recommendations payload.
  const new({this.results = const []});

  /// Parses a movie recommendations object.
  factory fromJson(Map<String, dynamic> json) =>
      _$MovieRecommendationsDtoFromJson(json);

  /// Recommended movies. Empty when the field is missing or null.
  final List<MovieDto> results;
}
