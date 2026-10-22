import 'package:json_annotation/json_annotation.dart';

part 'movie_dto.g.dart';

/// One movie object from a list, search, or discover response.
@JsonSerializable(
  fieldRename: FieldRename.snake,
  createToJson: false,
  checked: true,
)
final class MovieDto {
  /// Creates a movie payload.
  const new({
    required this.id,
    required this.title,
    this.overview = '',
    this.posterPath,
    this.voteAverage = 0,
    this.releaseDate,
  });

  /// Parses a movie object.
  factory fromJson(Map<String, dynamic> json) => _$MovieDtoFromJson(json);

  /// TMDB movie id.
  final int id;

  /// Localized title.
  final String title;

  /// Short description. Empty when the field is missing or null.
  final String overview;

  /// Poster path, including the leading slash, or null.
  final String? posterPath;

  /// Average vote from 0 to 10.
  final double voteAverage;

  /// Release date `YYYY-MM-DD`, or null.
  final String? releaseDate;
}

/// Page of movies from popular, search, or discover.
@JsonSerializable(
  fieldRename: FieldRename.snake,
  createToJson: false,
  checked: true,
)
final class PopularMoviesResponseDto {
  /// Creates a movie page payload.
  const new({
    required this.page,
    required this.totalPages,
    required this.totalResults,
    this.results = const [],
  });

  /// Parses a movie page.
  factory fromJson(Map<String, dynamic> json) =>
      _$PopularMoviesResponseDtoFromJson(json);

  /// Page number reported by TMDB.
  final int page;

  /// Movies on this page. Empty when the field is missing or null.
  final List<MovieDto> results;

  /// Total number of pages.
  final int totalPages;

  /// Total number of matches.
  final int totalResults;
}
