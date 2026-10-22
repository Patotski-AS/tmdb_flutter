// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dio_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Dio client for `https://api.themoviedb.org/3/`.
///
/// Sends `Authorization: Bearer <TMDB_ACCESS_TOKEN>`.
/// Adds `session_id` only when [attachTmdbSessionKey] is true
/// and a session is stored. Logging runs only in debug builds.

@ProviderFor(dio)
final dioProvider = DioProvider._();

/// Dio client for `https://api.themoviedb.org/3/`.
///
/// Sends `Authorization: Bearer <TMDB_ACCESS_TOKEN>`.
/// Adds `session_id` only when [attachTmdbSessionKey] is true
/// and a session is stored. Logging runs only in debug builds.

final class DioProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  /// Dio client for `https://api.themoviedb.org/3/`.
  ///
  /// Sends `Authorization: Bearer <TMDB_ACCESS_TOKEN>`.
  /// Adds `session_id` only when [attachTmdbSessionKey] is true
  /// and a session is stored. Logging runs only in debug builds.
  DioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dioProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dioHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return dio(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$dioHash() => r'40b10050716e9a59ae515fc8eac665e9fd941d9c';
