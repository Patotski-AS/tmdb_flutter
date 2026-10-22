// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tmdb_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// TMDB catalog API backed by [dioProvider].

@ProviderFor(tmdbApi)
final tmdbApiProvider = TmdbApiProvider._();

/// TMDB catalog API backed by [dioProvider].

final class TmdbApiProvider
    extends $FunctionalProvider<TmdbApi, TmdbApi, TmdbApi>
    with $Provider<TmdbApi> {
  /// TMDB catalog API backed by [dioProvider].
  TmdbApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tmdbApiProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tmdbApiHash();

  @$internal
  @override
  $ProviderElement<TmdbApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TmdbApi create(Ref ref) {
    return tmdbApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TmdbApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TmdbApi>(value),
    );
  }
}

String _$tmdbApiHash() => r'35551bf021d2b3ef6cb3ab7cb50beca835f790cc';

/// Image configuration shared by the three catalog repositories.

@ProviderFor(imageConfigurationCache)
final imageConfigurationCacheProvider = ImageConfigurationCacheProvider._();

/// Image configuration shared by the three catalog repositories.

final class ImageConfigurationCacheProvider
    extends
        $FunctionalProvider<
          ImageConfigurationCache,
          ImageConfigurationCache,
          ImageConfigurationCache
        >
    with $Provider<ImageConfigurationCache> {
  /// Image configuration shared by the three catalog repositories.
  ImageConfigurationCacheProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'imageConfigurationCacheProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$imageConfigurationCacheHash();

  @$internal
  @override
  $ProviderElement<ImageConfigurationCache> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ImageConfigurationCache create(Ref ref) {
    return imageConfigurationCache(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ImageConfigurationCache value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ImageConfigurationCache>(value),
    );
  }
}

String _$imageConfigurationCacheHash() =>
    r'b95cd506408878f881ef70a5efa82fe856a116b7';

/// Movies, movie genres, and image configuration.

@ProviderFor(movieRepository)
final movieRepositoryProvider = MovieRepositoryProvider._();

/// Movies, movie genres, and image configuration.

final class MovieRepositoryProvider
    extends
        $FunctionalProvider<MovieRepository, MovieRepository, MovieRepository>
    with $Provider<MovieRepository> {
  /// Movies, movie genres, and image configuration.
  MovieRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'movieRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$movieRepositoryHash();

  @$internal
  @override
  $ProviderElement<MovieRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MovieRepository create(Ref ref) {
    return movieRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MovieRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MovieRepository>(value),
    );
  }
}

String _$movieRepositoryHash() => r'142e00b9eb8d9651360e139da8d88fac3cb8c070';

/// TV shows and TV genres.

@ProviderFor(tvRepository)
final tvRepositoryProvider = TvRepositoryProvider._();

/// TV shows and TV genres.

final class TvRepositoryProvider
    extends $FunctionalProvider<TvRepository, TvRepository, TvRepository>
    with $Provider<TvRepository> {
  /// TV shows and TV genres.
  TvRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tvRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tvRepositoryHash();

  @$internal
  @override
  $ProviderElement<TvRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TvRepository create(Ref ref) {
    return tvRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TvRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TvRepository>(value),
    );
  }
}

String _$tvRepositoryHash() => r'e23454e1cc7b6846b18c2ae391a9c837ca5dcc7a';

/// Popular people, person search, and person details.

@ProviderFor(personRepository)
final personRepositoryProvider = PersonRepositoryProvider._();

/// Popular people, person search, and person details.

final class PersonRepositoryProvider
    extends
        $FunctionalProvider<
          PersonRepository,
          PersonRepository,
          PersonRepository
        >
    with $Provider<PersonRepository> {
  /// Popular people, person search, and person details.
  PersonRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'personRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$personRepositoryHash();

  @$internal
  @override
  $ProviderElement<PersonRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PersonRepository create(Ref ref) {
    return personRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PersonRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PersonRepository>(value),
    );
  }
}

String _$personRepositoryHash() => r'da99b9689509bcfc3b78ada0217620f75bde3954';
