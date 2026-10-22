import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tmdb_flutter/core/network/dio_provider.dart';
import 'package:tmdb_flutter/data/account/account_api.dart';
import 'package:tmdb_flutter/data/account/account_repository.dart';
import 'package:tmdb_flutter/data/account/account_repository_impl.dart';
import 'package:tmdb_flutter/data/account/dio_account_api.dart';
import 'package:tmdb_flutter/data/session/session_repository.dart';
import 'package:tmdb_flutter/data/tmdb/tmdb_providers.dart';

part 'account_providers.g.dart';

/// Account API backed by [dioProvider].
@Riverpod(keepAlive: true)
AccountApi accountApi(Ref ref) {
  return DioAccountApi(ref.watch(dioProvider));
}

/// Favorite movies for the signed-in account.
@Riverpod(keepAlive: true)
AccountRepository accountRepository(Ref ref) {
  return AccountRepositoryImpl(
    api: ref.watch(accountApiProvider),
    sessions: ref.watch(sessionRepositoryProvider.notifier),
    images: ref.watch(imageConfigurationCacheProvider),
    catalog: ref.watch(tmdbApiProvider),
  );
}
