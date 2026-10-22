import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tmdb_flutter/core/network/dio_provider.dart';
import 'package:tmdb_flutter/data/tmdb/repository/image_configuration_cache.dart';
import 'package:tmdb_flutter/data/tmdb/repository/movie_repository.dart';
import 'package:tmdb_flutter/data/tmdb/repository/movie_repository_impl.dart';
import 'package:tmdb_flutter/data/tmdb/repository/person_repository.dart';
import 'package:tmdb_flutter/data/tmdb/repository/person_repository_impl.dart';
import 'package:tmdb_flutter/data/tmdb/repository/tv_repository.dart';
import 'package:tmdb_flutter/data/tmdb/repository/tv_repository_impl.dart';
import 'package:tmdb_flutter/data/tmdb/source/dio_tmdb_api.dart';
import 'package:tmdb_flutter/data/tmdb/source/tmdb_api.dart';

part 'tmdb_providers.g.dart';

/// TMDB catalog API backed by [dioProvider].
@Riverpod(keepAlive: true)
TmdbApi tmdbApi(Ref ref) {
  return DioTmdbApi(ref.watch(dioProvider));
}

/// Image configuration shared by the three catalog repositories.
@Riverpod(keepAlive: true)
ImageConfigurationCache imageConfigurationCache(Ref ref) {
  return ImageConfigurationCache();
}

/// Movies, movie genres, and image configuration.
@Riverpod(keepAlive: true)
MovieRepository movieRepository(Ref ref) {
  return MovieRepositoryImpl(
    api: ref.watch(tmdbApiProvider),
    images: ref.watch(imageConfigurationCacheProvider),
  );
}

/// TV shows and TV genres.
@Riverpod(keepAlive: true)
TvRepository tvRepository(Ref ref) {
  return TvRepositoryImpl(
    api: ref.watch(tmdbApiProvider),
    images: ref.watch(imageConfigurationCacheProvider),
  );
}

/// Popular people and person search.
@Riverpod(keepAlive: true)
PersonRepository personRepository(Ref ref) {
  return PersonRepositoryImpl(
    api: ref.watch(tmdbApiProvider),
    images: ref.watch(imageConfigurationCacheProvider),
  );
}
