import 'package:json_annotation/json_annotation.dart';

part 'person_details_dto.g.dart';

/// Person payload from `GET person/{id}`.
///
/// Unknown JSON keys are ignored.
@JsonSerializable(
  fieldRename: FieldRename.snake,
  createToJson: false,
  checked: true,
)
final class PersonDetailsDto {
  /// Creates a person details payload.
  const new({
    required this.id,
    required this.name,
    this.biography = '',
    this.profilePath,
    this.knownForDepartment,
    this.birthday,
    this.deathday,
    this.placeOfBirth,
    this.alsoKnownAs = const [],
    this.combinedCredits,
  });

  /// Parses a person details object.
  factory fromJson(Map<String, dynamic> json) =>
      _$PersonDetailsDtoFromJson(json);

  /// TMDB person id.
  final int id;

  /// Display name.
  final String name;

  /// Biography. Empty when the field is missing or null.
  final String biography;

  /// Profile path, including the leading slash, or null.
  final String? profilePath;

  /// Department such as Acting, or null.
  final String? knownForDepartment;

  /// Birthday `YYYY-MM-DD`, or null.
  final String? birthday;

  /// Day of death `YYYY-MM-DD`, or null.
  final String? deathday;

  /// Place of birth, or null.
  final String? placeOfBirth;

  /// Other names. Empty when the field is missing or null.
  final List<String> alsoKnownAs;

  /// Appended combined credits, or null when the field is missing.
  final CombinedCreditsDto? combinedCredits;
}

/// `combined_credits` object on a person details response.
///
/// Unknown JSON keys are ignored.
@JsonSerializable(
  fieldRename: FieldRename.snake,
  createToJson: false,
  checked: true,
)
final class CombinedCreditsDto {
  /// Creates a combined-credits payload.
  const new({this.cast = const [], this.crew = const []});

  /// Parses a combined-credits object.
  factory fromJson(Map<String, dynamic> json) =>
      _$CombinedCreditsDtoFromJson(json);

  /// Acting credits. Empty when the field is missing or null.
  final List<PersonCreditDto> cast;

  /// Crew credits. Empty when the field is missing or null.
  final List<PersonCreditDto> crew;
}

/// One movie or TV object inside `combined_credits`.
///
/// Unknown JSON keys are ignored.
@JsonSerializable(
  fieldRename: FieldRename.snake,
  createToJson: false,
  checked: true,
)
final class PersonCreditDto {
  /// Creates a combined-credit payload.
  const new({
    required this.id,
    this.mediaType = 'movie',
    this.title,
    this.name,
    this.posterPath,
    this.releaseDate,
    this.firstAirDate,
    this.voteAverage = 0,
    this.character,
    this.job,
  });

  /// Parses a combined-credit object.
  factory fromJson(Map<String, dynamic> json) =>
      _$PersonCreditDtoFromJson(json);

  /// TMDB movie or TV id.
  final int id;

  /// `movie`, `tv`, or another TMDB media type.
  ///
  /// Missing and null values are read as `movie`.
  final String mediaType;

  /// Movie title, or null.
  final String? title;

  /// TV name, or null.
  final String? name;

  /// Poster path, including the leading slash, or null.
  final String? posterPath;

  /// Movie release date, or null.
  final String? releaseDate;

  /// TV first air date, or null.
  final String? firstAirDate;

  /// Average vote from 0 to 10. Zero when the field is missing or null.
  final double voteAverage;

  /// Character name, or null.
  final String? character;

  /// Crew job, or null.
  final String? job;
}
