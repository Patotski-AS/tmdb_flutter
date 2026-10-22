import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

final Uri _attributionUri = Uri.parse(
  'https://www.themoviedb.org/about/logos-attribution',
);

/// TMDB attribution required by the logo terms.
class TmdbAttribution extends StatelessWidget {
  /// Creates the attribution footer.
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => unawaited(_openAttribution()),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          'This product uses the TMDB API but is not '
          'endorsed or certified by TMDB.',
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

Future<void> _openAttribution() async {
  try {
    await launchUrl(_attributionUri, mode: LaunchMode.externalApplication);
  } on Exception {
    // The platform can refuse to open the page. The catalog stays usable.
  }
}
