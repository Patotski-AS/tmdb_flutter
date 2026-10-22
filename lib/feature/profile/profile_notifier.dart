import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tmdb_flutter/core/network/tmdb_exception.dart';
import 'package:tmdb_flutter/data/session/session_providers.dart';
import 'package:tmdb_flutter/data/session/session_repository.dart';
import 'package:tmdb_flutter/feature/profile/profile_state.dart';

part 'profile_notifier.g.dart';

/// Login form for the profile screen.
@riverpod
class ProfileNotifier extends _$ProfileNotifier {
  @override
  ProfileState build() => const ProfileState();

  /// Signs in with [username] and [password].
  ///
  /// Blank fields set an error and do not call the network.
  Future<void> signIn({
    required String username,
    required String password,
  }) async {
    if (!ref.mounted || state.isLoading || state.isAwaitingApproval) {
      return;
    }
    final login = username.trim();
    if (login.isEmpty || password.trim().isEmpty) {
      state = state.copyWith(error: 'Введите логин и пароль');
      return;
    }
    state = state.copyWith(isLoading: true, error: null);
    try {
      await ref
          .read(sessionUseCaseProvider)
          .signInWithPassword(username: login, password: password);
      if (!ref.mounted) {
        return;
      }
      state = const ProfileState();
    } on TmdbException catch (error) {
      if (!ref.mounted) {
        return;
      }
      state = state.copyWith(isLoading: false, error: error.message);
    }
  }

  /// Creates a request token and returns it.
  ///
  /// The caller opens the TMDB approval page. A failure returns null.
  Future<String?> beginWebsiteLogin() async {
    if (!ref.mounted || state.isLoading || state.isAwaitingApproval) {
      return null;
    }
    state = state.copyWith(isLoading: true, error: null);
    try {
      final token = await ref.read(sessionUseCaseProvider).beginApproval();
      if (!ref.mounted) {
        return null;
      }
      state = ProfileState(
        isAwaitingApproval: true,
        pendingRequestToken: token,
      );
      return token;
    } on TmdbException catch (error) {
      if (!ref.mounted) {
        return null;
      }
      state = state.copyWith(isLoading: false, error: error.message);
      return null;
    }
  }

  /// Finishes the website login with the pending request token.
  Future<void> confirmApproval() async {
    final token = state.pendingRequestToken;
    if (!ref.mounted || token == null || state.isLoading) {
      return;
    }
    state = state.copyWith(isLoading: true, error: null);
    try {
      await ref.read(sessionUseCaseProvider).completeApproval(token);
      if (!ref.mounted) {
        return;
      }
      state = const ProfileState();
    } on TmdbException catch (error) {
      if (!ref.mounted) {
        return;
      }
      state = state.copyWith(isLoading: false, error: error.message);
    }
  }

  /// Drops the pending approval without a network call.
  void cancelApproval() {
    if (!ref.mounted || state.isLoading) {
      return;
    }
    state = const ProfileState();
  }

  /// Clears the visible error.
  void dismissError() {
    if (!ref.mounted || state.error == null) {
      return;
    }
    state = state.copyWith(error: null);
  }

  /// Clears the stored session.
  Future<void> logout() async {
    if (!ref.mounted || state.isLoading) {
      return;
    }
    state = state.copyWith(isLoading: true, error: null);
    await ref.read(sessionRepositoryProvider.notifier).logout();
    if (!ref.mounted) {
      return;
    }
    state = const ProfileState();
  }
}
