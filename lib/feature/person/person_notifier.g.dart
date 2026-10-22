// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Person card for one id.

@ProviderFor(PersonNotifier)
final personProvider = PersonNotifierFamily._();

/// Person card for one id.
final class PersonNotifierProvider
    extends $NotifierProvider<PersonNotifier, PersonState> {
  /// Person card for one id.
  PersonNotifierProvider._({
    required PersonNotifierFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'personProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$personNotifierHash();

  @override
  String toString() {
    return r'personProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  PersonNotifier create() => PersonNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PersonState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PersonState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PersonNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$personNotifierHash() => r'49b64826d4fd095d8813b45684eec97fd905f90a';

/// Person card for one id.

final class PersonNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          PersonNotifier,
          PersonState,
          PersonState,
          PersonState,
          int
        > {
  PersonNotifierFamily._()
    : super(
        retry: null,
        name: r'personProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Person card for one id.

  PersonNotifierProvider call(int id) =>
      PersonNotifierProvider._(argument: id, from: this);

  @override
  String toString() => r'personProvider';
}

/// Person card for one id.

abstract class _$PersonNotifier extends $Notifier<PersonState> {
  late final _$args = ref.$arg as int;
  int get id => _$args;

  PersonState build(int id);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<PersonState, PersonState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PersonState, PersonState>,
              PersonState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
