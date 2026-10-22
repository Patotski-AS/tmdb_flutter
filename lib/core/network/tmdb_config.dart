/// TMDB API v3 root. The trailing slash lets Dio join relative paths.
const String tmdbBaseUrl = 'https://api.themoviedb.org/3/';

/// Connect timeout for the TMDB client.
const Duration tmdbConnectTimeout = Duration(seconds: 15);

/// Receive timeout for the TMDB client.
const Duration tmdbReceiveTimeout = Duration(seconds: 15);

/// Token compiled with `--dart-define` or `--dart-define-from-file`.
const String tmdbAccessToken = String.fromEnvironment('TMDB_ACCESS_TOKEN');

/// Value that means the example file was not filled in.
const String tmdbAccessTokenPlaceholder = 'your_access_token_here';

/// Whether [tmdbAccessToken] is a real TMDB v4 access token.
bool get isTmdbAccessTokenConfigured {
  final token = tmdbAccessToken.trim();
  return token.isNotEmpty && token != tmdbAccessTokenPlaceholder;
}

/// Returns [tmdbAccessToken] or throws when it is missing.
String requireTmdbAccessToken() {
  if (!isTmdbAccessTokenConfigured) {
    throw StateError(
      'TMDB_ACCESS_TOKEN не задан. '
      'Запустите приложение с '
      '--dart-define-from-file=config/dart_defines.json',
    );
  }
  return tmdbAccessToken;
}
