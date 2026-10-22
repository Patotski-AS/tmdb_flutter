import 'package:flutter/material.dart';

/// Official TMDB brand colors.
///
/// https://www.themoviedb.org/about/logos-attribution
abstract final class TmdbColors {
  /// Navy used at the top of the background gradient.
  static const Color darkBlue = Color(0xFF0D253F);

  /// Navy used at the bottom of the background gradient.
  static const Color darkBlueDeep = Color(0xFF081522);

  /// TMDB light blue.
  static const Color lightBlue = Color(0xFF01B4E4);

  /// TMDB light green.
  static const Color lightGreen = Color(0xFF90CEA1);

  /// Elevated surface.
  static const Color surface = Color(0xFF152B40);

  /// Alternate surface.
  static const Color surfaceVariant = Color(0xFF1C3448);

  /// Primary text on dark backgrounds.
  static const Color onDark = Color(0xFFE8EEF3);

  /// Secondary text on dark backgrounds.
  static const Color onDarkMuted = Color(0xFF9EACBA);

  /// Borders and dividers.
  static const Color outline = Color(0xFF2A4560);
}

/// Brand colors that widgets look up by name.
@immutable
class TmdbBrandColors extends ThemeExtension<TmdbBrandColors> {
  /// Creates the brand extension.
  const new({
    required this.lightGreen,
    required this.darkBlueDeep,
    required this.darkBlue,
  });

  /// Dark brand palette.
  static const TmdbBrandColors dark = TmdbBrandColors(
    lightGreen: TmdbColors.lightGreen,
    darkBlueDeep: TmdbColors.darkBlueDeep,
    darkBlue: TmdbColors.darkBlue,
  );

  /// TMDB light green.
  final Color lightGreen;

  /// Deep navy from the background gradient.
  final Color darkBlueDeep;

  /// Navy from the top of the background gradient.
  final Color darkBlue;

  /// Brand colors from [context], or a [StateError] when they are missing.
  static TmdbBrandColors of(BuildContext context) {
    final colors = Theme.of(context).extension<TmdbBrandColors>();
    if (colors == null) {
      throw StateError('TmdbBrandColors отсутствует в ThemeData.');
    }
    return colors;
  }

  @override
  TmdbBrandColors copyWith({
    Color? lightGreen,
    Color? darkBlueDeep,
    Color? darkBlue,
  }) {
    return TmdbBrandColors(
      lightGreen: lightGreen ?? this.lightGreen,
      darkBlueDeep: darkBlueDeep ?? this.darkBlueDeep,
      darkBlue: darkBlue ?? this.darkBlue,
    );
  }

  @override
  TmdbBrandColors lerp(ThemeExtension<TmdbBrandColors>? other, double t) {
    if (other is! TmdbBrandColors) {
      return this;
    }
    return TmdbBrandColors(
      lightGreen: Color.lerp(lightGreen, other.lightGreen, t) ?? lightGreen,
      darkBlueDeep:
          Color.lerp(darkBlueDeep, other.darkBlueDeep, t) ?? darkBlueDeep,
      darkBlue: Color.lerp(darkBlue, other.darkBlue, t) ?? darkBlue,
    );
  }
}
