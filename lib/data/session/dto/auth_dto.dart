import 'package:json_annotation/json_annotation.dart';

part 'auth_dto.g.dart';

/// Response of `GET authentication/token/new` and login validation.
@JsonSerializable(
  fieldRename: FieldRename.snake,
  createToJson: false,
  checked: true,
)
final class RequestTokenResponseDto {
  /// Creates a request-token payload.
  const new({this.requestToken, this.success = false});

  /// Parses a request-token response.
  factory fromJson(Map<String, dynamic> json) =>
      _$RequestTokenResponseDtoFromJson(json);

  /// `request_token`, or null when TMDB omits it.
  final String? requestToken;

  /// TMDB `success`. Missing values count as false.
  final bool success;
}

/// JSON body for `POST authentication/token/validate_with_login`.
@JsonSerializable(fieldRename: FieldRename.snake, createFactory: false)
final class ValidateWithLoginRequestDto {
  /// Creates a login body.
  const new({
    required this.username,
    required this.password,
    required this.requestToken,
  });

  /// Serializes the login body.
  Map<String, dynamic> toJson() => _$ValidateWithLoginRequestDtoToJson(this);

  /// TMDB username.
  final String username;

  /// TMDB password.
  final String password;

  /// Request token being approved with the password.
  final String requestToken;
}

/// JSON body for `POST authentication/session/new`.
@JsonSerializable(fieldRename: FieldRename.snake, createFactory: false)
final class SessionRequestDto {
  /// Creates a session body.
  const new({required this.requestToken});

  /// Serializes the session body.
  Map<String, dynamic> toJson() => _$SessionRequestDtoToJson(this);

  /// Approved request token.
  final String requestToken;
}

/// Response of `POST authentication/session/new`.
@JsonSerializable(
  fieldRename: FieldRename.snake,
  createToJson: false,
  checked: true,
)
final class SessionResponseDto {
  /// Creates a session payload.
  const new({this.sessionId, this.success = false});

  /// Parses a session response.
  factory fromJson(Map<String, dynamic> json) =>
      _$SessionResponseDtoFromJson(json);

  /// `session_id`, or null when TMDB omits it.
  final String? sessionId;

  /// TMDB `success`. Missing values count as false.
  final bool success;
}

/// Response of `GET account`.
@JsonSerializable(
  fieldRename: FieldRename.snake,
  createToJson: false,
  checked: true,
)
final class AccountResponseDto {
  /// Creates an account payload.
  const new({this.id = 0, this.username});

  /// Parses an account response.
  factory fromJson(Map<String, dynamic> json) =>
      _$AccountResponseDtoFromJson(json);

  /// TMDB account id. Missing values count as 0.
  final int id;

  /// TMDB username, or null when it is missing.
  final String? username;
}
