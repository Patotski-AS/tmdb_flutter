// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Account API backed by [dioProvider].

@ProviderFor(accountApi)
final accountApiProvider = AccountApiProvider._();

/// Account API backed by [dioProvider].

final class AccountApiProvider
    extends $FunctionalProvider<AccountApi, AccountApi, AccountApi>
    with $Provider<AccountApi> {
  /// Account API backed by [dioProvider].
  AccountApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accountApiProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accountApiHash();

  @$internal
  @override
  $ProviderElement<AccountApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AccountApi create(Ref ref) {
    return accountApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AccountApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AccountApi>(value),
    );
  }
}

String _$accountApiHash() => r'9d597c6dc7575c5556788e0c6e99100006e62e52';

/// Favorite movies for the signed-in account.

@ProviderFor(accountRepository)
final accountRepositoryProvider = AccountRepositoryProvider._();

/// Favorite movies for the signed-in account.

final class AccountRepositoryProvider
    extends
        $FunctionalProvider<
          AccountRepository,
          AccountRepository,
          AccountRepository
        >
    with $Provider<AccountRepository> {
  /// Favorite movies for the signed-in account.
  AccountRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accountRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accountRepositoryHash();

  @$internal
  @override
  $ProviderElement<AccountRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AccountRepository create(Ref ref) {
    return accountRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AccountRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AccountRepository>(value),
    );
  }
}

String _$accountRepositoryHash() => r'488d8ab71f622f06269ef86220258c30b3f9cbec';
