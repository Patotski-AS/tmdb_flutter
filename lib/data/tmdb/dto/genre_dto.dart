import 'package:json_annotation/json_annotation.dart';

part 'genre_dto.g.dart';

/// One genre object from `genre/movie/list` or `genre/tv/list`.
@JsonSerializable(
  fieldRename: FieldRename.snake,
  createToJson: false,
  checked: true,
)
final class GenreDto {
  /// Creates a genre payload.
  const new({required this.id, required this.name});

  /// Parses a genre object.
  factory fromJson(Map<String, dynamic> json) => _$GenreDtoFromJson(json);

  /// TMDB genre id.
  final int id;

  /// Localized genre name.
  final String name;
}

/// Response of a genre list endpoint.
@JsonSerializable(
  fieldRename: FieldRename.snake,
  createToJson: false,
  checked: true,
)
final class GenreListResponseDto {
  /// Creates a genre list payload.
  const new({this.genres = const []});

  /// Parses a genre list response.
  factory fromJson(Map<String, dynamic> json) =>
      _$GenreListResponseDtoFromJson(json);

  /// Genres. Empty when TMDB omits the list.
  final List<GenreDto> genres;
}
