import 'package:json_annotation/json_annotation.dart';

part 'details_dto.g.dart';

/// One cast object inside `credits`.
///
/// Unknown JSON keys are ignored.
@JsonSerializable(
  fieldRename: FieldRename.snake,
  createToJson: false,
  checked: true,
)
final class CastMemberDto {
  /// Creates a cast payload.
  const new({
    required this.id,
    required this.name,
    this.character = '',
    this.order = 0,
    this.profilePath,
  });

  /// Parses a cast object.
  factory fromJson(Map<String, dynamic> json) => _$CastMemberDtoFromJson(json);

  /// TMDB person id.
  final int id;

  /// Person name.
  final String name;

  /// Character name. Empty when the field is missing or null.
  final String character;

  /// Billing order. Zero when the field is missing or null.
  final int order;

  /// Profile path, including the leading slash, or null.
  final String? profilePath;
}

/// One crew object inside `credits`.
///
/// Unknown JSON keys are ignored.
@JsonSerializable(
  fieldRename: FieldRename.snake,
  createToJson: false,
  checked: true,
)
final class CrewMemberDto {
  /// Creates a crew payload.
  const new({required this.id, required this.name, this.job = ''});

  /// Parses a crew object.
  factory fromJson(Map<String, dynamic> json) => _$CrewMemberDtoFromJson(json);

  /// TMDB person id.
  final int id;

  /// Person name.
  final String name;

  /// Job title. Empty when the field is missing or null.
  final String job;
}

/// `credits` object appended to a movie or TV details response.
///
/// Unknown JSON keys are ignored.
@JsonSerializable(
  fieldRename: FieldRename.snake,
  createToJson: false,
  checked: true,
)
final class CreditsDto {
  /// Creates a credits payload.
  const new({this.cast = const [], this.crew = const []});

  /// Parses a credits object.
  factory fromJson(Map<String, dynamic> json) => _$CreditsDtoFromJson(json);

  /// Cast. Empty when the field is missing or null.
  final List<CastMemberDto> cast;

  /// Crew. Empty when the field is missing or null.
  final List<CrewMemberDto> crew;
}

/// One video object inside `videos.results`.
///
/// Unknown JSON keys are ignored.
@JsonSerializable(
  fieldRename: FieldRename.snake,
  createToJson: false,
  checked: true,
)
final class VideoDto {
  /// Creates a video payload.
  const new({
    required this.id,
    required this.key,
    required this.name,
    required this.site,
    required this.type,
    this.official = false,
  });

  /// Parses a video object.
  factory fromJson(Map<String, dynamic> json) => _$VideoDtoFromJson(json);

  /// TMDB video id.
  final String id;

  /// Site-specific key.
  final String key;

  /// Video title.
  final String name;

  /// Hosting site.
  final String site;

  /// Video type, for example `Trailer`.
  final String type;

  /// Whether TMDB marks the video as official.
  final bool official;
}

/// `videos` object appended to a details response.
///
/// Unknown JSON keys are ignored.
@JsonSerializable(
  fieldRename: FieldRename.snake,
  createToJson: false,
  checked: true,
)
final class VideosResponseDto {
  /// Creates a videos payload.
  const new({this.results = const []});

  /// Parses a videos object.
  factory fromJson(Map<String, dynamic> json) =>
      _$VideosResponseDtoFromJson(json);

  /// Videos. Empty when the field is missing or null.
  final List<VideoDto> results;
}

/// One image object inside `images.backdrops` or `images.posters`.
///
/// Unknown JSON keys are ignored.
@JsonSerializable(
  fieldRename: FieldRename.snake,
  createToJson: false,
  checked: true,
)
final class ImageDto {
  /// Creates an image payload.
  const new({required this.filePath, this.aspectRatio = 1, this.width = 0});

  /// Parses an image object.
  factory fromJson(Map<String, dynamic> json) => _$ImageDtoFromJson(json);

  /// Image path, including the leading slash.
  final String filePath;

  /// Width divided by height. `1` when the field is missing or null.
  final double aspectRatio;

  /// Pixel width. Zero when the field is missing or null.
  final int width;
}

/// `images` object appended to a details response.
///
/// Unknown JSON keys are ignored.
@JsonSerializable(
  fieldRename: FieldRename.snake,
  createToJson: false,
  checked: true,
)
final class ImagesResponseDto {
  /// Creates an images payload.
  const new({this.backdrops = const [], this.posters = const []});

  /// Parses an images object.
  factory fromJson(Map<String, dynamic> json) =>
      _$ImagesResponseDtoFromJson(json);

  /// Backdrop stills. Empty when the field is missing or null.
  final List<ImageDto> backdrops;

  /// Posters. Empty when the field is missing or null.
  final List<ImageDto> posters;
}

/// One person inside `created_by`.
///
/// Unknown JSON keys are ignored.
@JsonSerializable(
  fieldRename: FieldRename.snake,
  createToJson: false,
  checked: true,
)
final class CreatedByDto {
  /// Creates a creator payload.
  const new({required this.id, required this.name});

  /// Parses a creator object.
  factory fromJson(Map<String, dynamic> json) => _$CreatedByDtoFromJson(json);

  /// TMDB person id.
  final int id;

  /// Creator name.
  final String name;
}
