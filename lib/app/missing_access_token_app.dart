import 'package:flutter/material.dart';
import 'package:tmdb_flutter/app/theme/tmdb_theme.dart';

/// Text shown when `TMDB_ACCESS_TOKEN` was not provided.
const String missingAccessTokenMessage = '''
Ключ доступа TMDB не задан.

Скопируйте config/dart_defines.json.example
в config/dart_defines.json, укажите ключ доступа API v4
и запустите:

flutter run --dart-define-from-file=config/dart_defines.json
''';

/// Full-screen explanation instead of a crash when the token is missing.
class MissingAccessTokenApp extends StatelessWidget {
  /// Creates the missing-token screen.
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TMDB',
      theme: tmdbDarkTheme,
      darkTheme: tmdbDarkTheme,
      themeMode: ThemeMode.dark,
      home: const TmdbBackground(
        child: Scaffold(
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Center(
                child: Text(
                  missingAccessTokenMessage,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
