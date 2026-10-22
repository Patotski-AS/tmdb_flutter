import 'package:json_annotation/json_annotation.dart';

part 'configuration_dto.g.dart';

/// `images` object from `GET configuration`.
@JsonSerializable(
  fieldRename: FieldRename.snake,
  createToJson: false,
  checked: true,
)
final class ImagesDto {
  /// Creates an images payload.
  const new({
    required this.secureBaseUrl,
    this.posterSizes = const [],
    this.backdropSizes = const [],
    this.profileSizes = const [],
  });

  /// Parses an images object.
  factory fromJson(Map<String, dynamic> json) => _$ImagesDtoFromJson(json);

  /// Secure CDN root, including the trailing slash.
  final String secureBaseUrl;

  /// Poster size tokens, for example `w500`.
  final List<String> posterSizes;

  /// Backdrop size tokens, for example `w780`.
  final List<String> backdropSizes;

  /// Profile size tokens, for example `w185`.
  final List<String> profileSizes;
}

/// Response of `GET configuration`.
@JsonSerializable(
  fieldRename: FieldRename.snake,
  createToJson: false,
  checked: true,
)
final class ConfigurationResponseDto {
  /// Creates a configuration payload.
  const new({required this.images});

  /// Parses a configuration response.
  factory fromJson(Map<String, dynamic> json) =>
      _$ConfigurationResponseDtoFromJson(json);

  /// Image base URL and size tables.
  final ImagesDto images;
}
