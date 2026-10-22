import 'package:json_annotation/json_annotation.dart';

part 'person_dto.g.dart';

/// One person object from a list or search response.
@JsonSerializable(
  fieldRename: FieldRename.snake,
  createToJson: false,
  checked: true,
)
final class PersonDto {
  /// Creates a person payload.
  const new({
    required this.id,
    required this.name,
    this.profilePath,
    this.knownForDepartment,
  });

  /// Parses a person object.
  factory fromJson(Map<String, dynamic> json) => _$PersonDtoFromJson(json);

  /// TMDB person id.
  final int id;

  /// Display name.
  final String name;

  /// Profile path, including the leading slash, or null.
  final String? profilePath;

  /// Department such as Acting. Blank values become null in the model.
  final String? knownForDepartment;
}

/// Page of people from popular or search.
@JsonSerializable(
  fieldRename: FieldRename.snake,
  createToJson: false,
  checked: true,
)
final class PopularPeopleResponseDto {
  /// Creates a people page payload.
  const new({
    required this.page,
    required this.totalPages,
    required this.totalResults,
    this.results = const [],
  });

  /// Parses a people page.
  factory fromJson(Map<String, dynamic> json) =>
      _$PopularPeopleResponseDtoFromJson(json);

  /// Page number reported by TMDB.
  final int page;

  /// People on this page. Empty when the field is missing or null.
  final List<PersonDto> results;

  /// Total number of pages.
  final int totalPages;

  /// Total number of matches.
  final int totalResults;
}
