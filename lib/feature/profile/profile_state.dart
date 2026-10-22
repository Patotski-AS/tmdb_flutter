import 'package:flutter/foundation.dart';

const _keep = Object();

/// Guest form state on the profile screen.
@immutable
final class ProfileState {
  /// Creates profile form state.
  const new({
    this.isLoading = false,
    this.isAwaitingApproval = false,
    this.pendingRequestToken,
    this.error,
  });

  /// Whether a login or logout request is in flight.
  final bool isLoading;

  /// Whether the user must approve a token on themoviedb.org.
  final bool isAwaitingApproval;

  /// Request token waiting for approval, or null.
  final String? pendingRequestToken;

  /// Last failure text, or null.
  final String? error;

  /// Returns a copy with the given fields replaced.
  ///
  /// Pass [pendingRequestToken] or [error] to replace them, including
  /// with null. Omit either one to keep the current value.
  ProfileState copyWith({
    bool? isLoading,
    bool? isAwaitingApproval,
    Object? pendingRequestToken = _keep,
    Object? error = _keep,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      isAwaitingApproval: isAwaitingApproval ?? this.isAwaitingApproval,
      pendingRequestToken: identical(pendingRequestToken, _keep)
          ? this.pendingRequestToken
          : pendingRequestToken as String?,
      error: identical(error, _keep) ? this.error : error as String?,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ProfileState &&
        isLoading == other.isLoading &&
        isAwaitingApproval == other.isAwaitingApproval &&
        pendingRequestToken == other.pendingRequestToken &&
        error == other.error;
  }

  @override
  int get hashCode => Object.hash(
    isLoading,
    isAwaitingApproval,
    pendingRequestToken,
    error,
  );
}
