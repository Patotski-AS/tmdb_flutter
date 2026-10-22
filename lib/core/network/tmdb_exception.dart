/// Failure produced by the TMDB client.
sealed class TmdbException implements Exception {
  /// Creates an exception with a message safe to show in the UI.
  const new(this.message);

  /// Human-readable description of the failure.
  final String message;

  @override
  String toString() => message;
}

/// The request never received an HTTP response.
final class TmdbNetworkException extends TmdbException {
  /// Creates a transport failure.
  const new(super.message, {this.cause});

  /// Underlying error, when the client captured one.
  final Object? cause;
}

/// TMDB answered with an error payload.
final class TmdbHttpException extends TmdbException {
  /// Creates an HTTP failure from a TMDB error body.
  const new({
    required this.statusCode,
    required this.statusMessage,
    this.httpStatusCode,
  }) : super(statusMessage);

  /// `status_code` from the TMDB error body.
  ///
  /// Falls back to the HTTP status when the body omits the field.
  final int statusCode;

  /// `status_message` from the TMDB error body.
  final String statusMessage;

  /// HTTP status of the response, when the transport provided one.
  final int? httpStatusCode;
}

/// The response body could not be read as a TMDB payload.
final class TmdbResponseException extends TmdbException {
  /// Creates a response-parsing failure.
  const new(super.message, {this.cause});

  /// Underlying parse error, when one was thrown.
  final Object? cause;
}
