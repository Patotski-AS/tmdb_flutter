// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Guest or authenticated TMDB session, restored from storage.
///
/// A missing session id, or an account id below 1, is [Guest].
/// Logout clears storage. This repository does not use Dio.

@ProviderFor(SessionRepository)
final sessionRepositoryProvider = SessionRepositoryProvider._();

/// Guest or authenticated TMDB session, restored from storage.
///
/// A missing session id, or an account id below 1, is [Guest].
/// Logout clears storage. This repository does not use Dio.
final class SessionRepositoryProvider
    extends $AsyncNotifierProvider<SessionRepository, SessionState> {
  /// Guest or authenticated TMDB session, restored from storage.
  ///
  /// A missing session id, or an account id below 1, is [Guest].
  /// Logout clears storage. This repository does not use Dio.
  SessionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sessionRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionRepositoryHash();

  @$internal
  @override
  SessionRepository create() => SessionRepository();
}

String _$sessionRepositoryHash() => r'ad1b6055d516848eb8ee62098997226862f42b46';

/// Guest or authenticated TMDB session, restored from storage.
///
/// A missing session id, or an account id below 1, is [Guest].
/// Logout clears storage. This repository does not use Dio.

abstract class _$SessionRepository extends $AsyncNotifier<SessionState> {
  FutureOr<SessionState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<SessionState>, SessionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SessionState>, SessionState>,
              AsyncValue<SessionState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
