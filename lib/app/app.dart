import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmdb_flutter/app/router.dart';
import 'package:tmdb_flutter/app/theme/tmdb_theme.dart';

/// Root application once the TMDB access token is configured.
class TmdbApp extends ConsumerWidget {
  /// Creates the routed application.
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'TMDB',
      theme: tmdbDarkTheme,
      darkTheme: tmdbDarkTheme,
      themeMode: ThemeMode.dark,
      routerConfig: router,
      builder: (context, child) {
        return TmdbBackground(child: child ?? const SizedBox.shrink());
      },
    );
  }
}
