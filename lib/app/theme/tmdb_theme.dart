import 'package:flutter/material.dart';
import 'package:tmdb_flutter/app/theme/tmdb_colors.dart';

/// Dark Material 3 palette mapped from the KMP `TmdbDarkColorScheme`.
const ColorScheme tmdbDarkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: TmdbColors.lightBlue,
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFF015A73),
  onPrimaryContainer: Color(0xFFFFFFFF),
  secondary: TmdbColors.lightGreen,
  onSecondary: TmdbColors.darkBlue,
  secondaryContainer: Color(0xFF3D6B52),
  onSecondaryContainer: TmdbColors.onDark,
  tertiary: TmdbColors.lightGreen,
  onTertiary: TmdbColors.darkBlue,
  tertiaryContainer: Color(0xFF3D6B52),
  onTertiaryContainer: TmdbColors.onDark,
  error: Color(0xFFFF8A80),
  onError: Color(0xFF4A0000),
  surface: TmdbColors.surface,
  onSurface: TmdbColors.onDark,
  surfaceContainer: TmdbColors.surface,
  surfaceContainerLow: Color(0xFF122A3D),
  surfaceContainerHigh: Color(0xFF1F3A50),
  surfaceContainerHighest: Color(0xFF25455C),
  onSurfaceVariant: TmdbColors.onDarkMuted,
  outline: TmdbColors.outline,
  outlineVariant: Color(0xFF223A4F),
);

/// Dark Material 3 theme. Page background stays transparent for the gradient.
final ThemeData tmdbDarkTheme = ThemeData(
  colorScheme: tmdbDarkColorScheme,
  scaffoldBackgroundColor: Colors.transparent,
  extensions: const [TmdbBrandColors.dark],
);

/// Vertical gradient from [TmdbColors.darkBlue] to [TmdbColors.darkBlueDeep].
class TmdbBackground extends StatelessWidget {
  /// Paints [child] on the TMDB background gradient.
  const new({required this.child, super.key});

  /// Widget drawn above the gradient.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final brand = TmdbBrandColors.of(context);
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [brand.darkBlue, brand.darkBlueDeep],
          ),
        ),
        child: child,
      ),
    );
  }
}
