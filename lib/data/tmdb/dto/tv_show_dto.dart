import 'package:json_annotation/json_annotation.dart';

part 'tv_show_dto.g.dart';

/// One TV object from a list, search, or discover response.
@JsonSerializable(
  fieldRename: FieldRename.snake,
  createToJson: false,
  checked: true,
)
final class TvShowDto {
  /// Creates a TV payload.
  const new({
    required this.id,
    required this.name,
    this.overview = '',
    this.posterPath,
    this.voteAverage = 0,
    this.firstAirDate,
  });

  /// Parses a TV object.
  factory fromJson(Map<String, dynamic> json) => _$TvShowDtoFromJson(json);

  /// TMDB TV id.
  final int id;

  /// Localized name. The domain model stores this as its title.
  final String name;

  /// Short description. Empty when the field is missing or null.
  final String overview;

  /// Poster path, including the leading slash, or null.
  final String? posterPath;

  /// Average vote from 0 to 10.
  final double voteAverage;

  /// First air date `YYYY-MM-DD`, or null.
  final String? firstAirDate;
}

/// Page of TV shows from popular, search, or discover.
@JsonSerializable(
  fieldRename: FieldRename.snake,
  createToJson: false,
  checked: true,
)
final class PopularTvResponseDto {
  /// Creates a TV page payload.
  const new({
    required this.page,
    required this.totalPages,
    required this.totalResults,
    this.results = const [],
  });

  /// Parses a TV page.
  factory fromJson(Map<String, dynamic> json) =>
      _$PopularTvResponseDtoFromJson(json);

  /// Page number reported by TMDB.
  final int page;

  /// Shows on this page. Empty when the field is missing or null.
  final List<TvShowDto> results;

  /// Total number of pages.
  final int totalPages;

  /// Total number of matches.
  final int totalResults;
}
