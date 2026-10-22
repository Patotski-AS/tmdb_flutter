// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Catalog list: popular, search, and discover.

@ProviderFor(MediaNotifier)
final mediaProvider = MediaNotifierProvider._();

/// Catalog list: popular, search, and discover.
final class MediaNotifierProvider
    extends $NotifierProvider<MediaNotifier, MediaState> {
  /// Catalog list: popular, search, and discover.
  MediaNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mediaProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mediaNotifierHash();

  @$internal
  @override
  MediaNotifier create() => MediaNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MediaState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MediaState>(value),
    );
  }
}

String _$mediaNotifierHash() => r'f5c712edaddb286132a7c12599b37730b00392eb';

/// Catalog list: popular, search, and discover.

abstract class _$MediaNotifier extends $Notifier<MediaState> {
  MediaState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<MediaState, MediaState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MediaState, MediaState>,
              MediaState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
