import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmdb_flutter/app/app.dart';
import 'package:tmdb_flutter/app/missing_access_token_app.dart';
import 'package:tmdb_flutter/core/network/tmdb_config.dart';

/// Starts the widget tree inside a [ProviderScope].
void bootstrap() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: AppBootstrap()));
}

/// Shows the app, or a setup screen when the TMDB token is missing.
class AppBootstrap extends StatelessWidget {
  /// Creates the root widget.
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    if (!isTmdbAccessTokenConfigured) {
      return const MissingAccessTokenApp();
    }
    return const TmdbApp();
  }
}
