// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorites_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Favorite movies for the signed-in account.
///
/// A guest stays empty and does not call the account API.
/// Logout clears the list.

@ProviderFor(FavoritesNotifier)
final favoritesProvider = FavoritesNotifierProvider._();

/// Favorite movies for the signed-in account.
///
/// A guest stays empty and does not call the account API.
/// Logout clears the list.
final class FavoritesNotifierProvider
    extends $NotifierProvider<FavoritesNotifier, FavoritesState> {
  /// Favorite movies for the signed-in account.
  ///
  /// A guest stays empty and does not call the account API.
  /// Logout clears the list.
  FavoritesNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'favoritesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$favoritesNotifierHash();

  @$internal
  @override
  FavoritesNotifier create() => FavoritesNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FavoritesState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FavoritesState>(value),
    );
  }
}

String _$favoritesNotifierHash() => r'b6fbbc3b4050d1e4e1c67f35a48031c644b1c424';

/// Favorite movies for the signed-in account.
///
/// A guest stays empty and does not call the account API.
/// Logout clears the list.

abstract class _$FavoritesNotifier extends $Notifier<FavoritesState> {
  FavoritesState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<FavoritesState, FavoritesState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<FavoritesState, FavoritesState>,
              FavoritesState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
