// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_storage_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Secure storage for a future TMDB session.
///
/// Nothing reads this provider during startup.

@ProviderFor(sessionStorage)
final sessionStorageProvider = SessionStorageProvider._();

/// Secure storage for a future TMDB session.
///
/// Nothing reads this provider during startup.

final class SessionStorageProvider
    extends $FunctionalProvider<SessionStorage, SessionStorage, SessionStorage>
    with $Provider<SessionStorage> {
  /// Secure storage for a future TMDB session.
  ///
  /// Nothing reads this provider during startup.
  SessionStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sessionStorageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionStorageHash();

  @$internal
  @override
  $ProviderElement<SessionStorage> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SessionStorage create(Ref ref) {
    return sessionStorage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SessionStorage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SessionStorage>(value),
    );
  }
}

String _$sessionStorageHash() => r'8ec77290e4ae899e29fc2317318d5e9305844190';
