import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tmdb_flutter/core/network/dio_provider.dart';
import 'package:tmdb_flutter/data/session/dio_tmdb_session_client.dart';
import 'package:tmdb_flutter/data/session/session_repository.dart';
import 'package:tmdb_flutter/data/session/session_use_case.dart';
import 'package:tmdb_flutter/data/session/tmdb_session_client.dart';

part 'session_providers.g.dart';

/// Authentication client using [dioProvider].
@Riverpod(keepAlive: true)
TmdbSessionClient tmdbSessionClient(Ref ref) {
  return DioTmdbSessionClient(ref.watch(dioProvider));
}

/// Password login and browser-approval chain.
@Riverpod(keepAlive: true)
SessionUseCase sessionUseCase(Ref ref) {
  return SessionUseCase(
    client: ref.watch(tmdbSessionClientProvider),
    sessions: ref.watch(sessionRepositoryProvider.notifier),
  );
}
