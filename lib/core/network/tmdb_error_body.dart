import 'package:json_annotation/json_annotation.dart';

part 'tmdb_error_body.g.dart';

/// Error object returned by TMDB.
@JsonSerializable(checked: true, createToJson: false)
class TmdbErrorBody {
  /// Creates a decoded TMDB error body.
  const new({
    this.statusCode,
    this.statusMessage,
    this.success,
  });

  /// Parses a JSON object from a TMDB error response.
  factory fromJson(Map<String, dynamic> json) =>
      _$TmdbErrorBodyFromJson(json);

  /// TMDB `status_code`.
  @JsonKey(name: 'status_code')
  final int? statusCode;

  /// TMDB `status_message`.
  @JsonKey(name: 'status_message')
  final String? statusMessage;

  /// TMDB `success` flag, when the body includes one.
  final bool? success;
}
