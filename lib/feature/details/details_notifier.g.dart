// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'details_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Movie or TV card for one id.

@ProviderFor(DetailsNotifier)
final detailsProvider = DetailsNotifierFamily._();

/// Movie or TV card for one id.
final class DetailsNotifierProvider
    extends $NotifierProvider<DetailsNotifier, DetailsState> {
  /// Movie or TV card for one id.
  DetailsNotifierProvider._({
    required DetailsNotifierFamily super.from,
    required (DetailsMediaType, int) super.argument,
  }) : super(
         retry: null,
         name: r'detailsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$detailsNotifierHash();

  @override
  String toString() {
    return r'detailsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  DetailsNotifier create() => DetailsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DetailsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DetailsState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is DetailsNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$detailsNotifierHash() => r'a1982ac397390aa32be0f1fd45faced505cf2039';

/// Movie or TV card for one id.

final class DetailsNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          DetailsNotifier,
          DetailsState,
          DetailsState,
          DetailsState,
          (DetailsMediaType, int)
        > {
  DetailsNotifierFamily._()
    : super(
        retry: null,
        name: r'detailsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Movie or TV card for one id.

  DetailsNotifierProvider call(DetailsMediaType mediaType, int id) =>
      DetailsNotifierProvider._(argument: (mediaType, id), from: this);

  @override
  String toString() => r'detailsProvider';
}

/// Movie or TV card for one id.

abstract class _$DetailsNotifier extends $Notifier<DetailsState> {
  late final _$args = ref.$arg as (DetailsMediaType, int);
  DetailsMediaType get mediaType => _$args.$1;
  int get id => _$args.$2;

  DetailsState build(DetailsMediaType mediaType, int id);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<DetailsState, DetailsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DetailsState, DetailsState>,
              DetailsState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args.$1, _$args.$2));
  }
}
