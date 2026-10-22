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
/// Logging is attached only in debug builds.

@ProviderFor(dio)
final dioProvider = DioProvider._();

/// Dio client for `https://api.themoviedb.org/3/`.
///
/// Sends `Authorization: Bearer <TMDB_ACCESS_TOKEN>`.
/// Logging is attached only in debug builds.

final class DioProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  /// Dio client for `https://api.themoviedb.org/3/`.
  ///
  /// Sends `Authorization: Bearer <TMDB_ACCESS_TOKEN>`.
  /// Logging is attached only in debug builds.
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

String _$dioHash() => r'b2dd7d76d7d23605c05217be92883e2f412c9ec1';
