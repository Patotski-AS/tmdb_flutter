// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Authentication client using [dioProvider].

@ProviderFor(tmdbSessionClient)
final tmdbSessionClientProvider = TmdbSessionClientProvider._();

/// Authentication client using [dioProvider].

final class TmdbSessionClientProvider
    extends
        $FunctionalProvider<
          TmdbSessionClient,
          TmdbSessionClient,
          TmdbSessionClient
        >
    with $Provider<TmdbSessionClient> {
  /// Authentication client using [dioProvider].
  TmdbSessionClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tmdbSessionClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tmdbSessionClientHash();

  @$internal
  @override
  $ProviderElement<TmdbSessionClient> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TmdbSessionClient create(Ref ref) {
    return tmdbSessionClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TmdbSessionClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TmdbSessionClient>(value),
    );
  }
}

String _$tmdbSessionClientHash() => r'c7f000042942db2e3bcb3840238d29edb9ee7b04';

/// Password login and browser-approval chain.

@ProviderFor(sessionUseCase)
final sessionUseCaseProvider = SessionUseCaseProvider._();

/// Password login and browser-approval chain.

final class SessionUseCaseProvider
    extends $FunctionalProvider<SessionUseCase, SessionUseCase, SessionUseCase>
    with $Provider<SessionUseCase> {
  /// Password login and browser-approval chain.
  SessionUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sessionUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionUseCaseHash();

  @$internal
  @override
  $ProviderElement<SessionUseCase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SessionUseCase create(Ref ref) {
    return sessionUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SessionUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SessionUseCase>(value),
    );
  }
}

String _$sessionUseCaseHash() => r'9befd449a2e12b3c5bb0c869d09c28c5db79b49f';
