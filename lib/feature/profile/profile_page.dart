import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmdb_flutter/app/router.dart';
import 'package:tmdb_flutter/data/session/session_repository.dart';
import 'package:tmdb_flutter/data/session/session_state.dart';
import 'package:tmdb_flutter/feature/media/tmdb_attribution.dart';
import 'package:tmdb_flutter/feature/profile/profile_notifier.dart';
import 'package:tmdb_flutter/feature/profile/profile_state.dart';
import 'package:url_launcher/url_launcher.dart';

/// Profile at `/profile`.
class ProfilePage extends ConsumerWidget {
  /// Creates the profile screen.
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionRepositoryProvider);
    if (session.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    final account = session.asData?.value;
    if (account is Authenticated) {
      return _SignedInProfile(account: account);
    }
    return const _GuestProfile();
  }
}

class _GuestProfile extends ConsumerStatefulWidget {
  const new();

  @override
  ConsumerState<_GuestProfile> createState() => _GuestProfileState();
}

class _GuestProfileState extends ConsumerState<_GuestProfile> {
  final _username = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final form = ref.watch(profileProvider);
    final notifier = ref.read(profileProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: const Text('Профиль')),
      body: _GuestForm(
        form: form,
        username: _username,
        password: _password,
        onWebsite: _loginOnWebsite,
        onPassword: _submitPassword,
        onConfirm: () => unawaited(notifier.confirmApproval()),
        onCancel: notifier.cancelApproval,
        onDismissError: notifier.dismissError,
      ),
    );
  }

  void _submitPassword() {
    final password = _password.text;
    _password.clear();
    unawaited(
      ref
          .read(profileProvider.notifier)
          .signIn(username: _username.text, password: password),
    );
  }

  Future<void> _loginOnWebsite() async {
    final token = await ref
        .read(profileProvider.notifier)
        .beginWebsiteLogin();
    if (!mounted || token == null) {
      return;
    }
    final uri = Uri.https('www.themoviedb.org', '/authenticate/$token');
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } on Exception {
      // Approval can still be confirmed or cancelled.
    }
  }
}

class _GuestForm extends StatelessWidget {
  const new({
    required this.form,
    required this.username,
    required this.password,
    required this.onWebsite,
    required this.onPassword,
    required this.onConfirm,
    required this.onCancel,
    required this.onDismissError,
  });

  final ProfileState form;
  final TextEditingController username;
  final TextEditingController password;
  final VoidCallback onWebsite;
  final VoidCallback onPassword;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final VoidCallback onDismissError;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final error = form.error;
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text('Профиль', style: theme.textTheme.headlineMedium),
        const SizedBox(height: 16),
        Text(
          'Войдите в аккаунт TMDB, чтобы добавлять фильмы в избранное',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        if (error != null) ...[
          const SizedBox(height: 16),
          Text(
            error,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: onDismissError,
            child: const Text('Закрыть'),
          ),
        ],
        const SizedBox(height: 16),
        if (form.isAwaitingApproval) ...[
          const Text(
            'Подтвердите вход на themoviedb.org, '
            'затем нажмите «Подтвердить»',
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: form.isLoading ? null : onConfirm,
            child: form.isLoading
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Подтвердить'),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: form.isLoading ? null : onCancel,
            child: const Text('Отмена'),
          ),
        ] else if (form.isLoading)
          const Center(child: CircularProgressIndicator())
        else ...[
          FilledButton(
            onPressed: onWebsite,
            child: const Text('Войти через сайт TMDB'),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(),
          ),
          Text(
            'или логин и пароль',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: username,
            decoration: const InputDecoration(labelText: 'Логин TMDB'),
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.username],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: password,
            decoration: const InputDecoration(labelText: 'Пароль'),
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            autofillHints: const [AutofillHints.password],
            onSubmitted: (_) => onPassword(),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: onPassword,
            child: const Text('Войти'),
          ),
        ],
        const SizedBox(height: 24),
        const TmdbAttribution(),
      ],
    );
  }
}

class _SignedInProfile extends ConsumerWidget {
  const new({required this.account});

  final Authenticated account;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loggingOut = ref.watch(profileProvider).isLoading;
    final username = account.username;
    return Scaffold(
      appBar: AppBar(title: const Text('Профиль')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _ProfileHeader(
            displayName: _displayName(account),
            onOpen: () => unawaited(_openTmdbProfile(username, '')),
          ),
          const Divider(),
          for (final item in _activityItems)
            _MenuRow(
              label: item.title,
              onTap: () => _onMenu(context, item, username),
            ),
          const Divider(),
          for (final item in _accountItems)
            _MenuRow(
              label: item.title,
              onTap: () => _onMenu(context, item, username),
            ),
          const Divider(),
          _MenuRow(
            label: 'Выйти',
            onTap: loggingOut
                ? null
                : () {
                    unawaited(ref.read(profileProvider.notifier).logout());
                  },
            trailing: loggingOut
                ? const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : null,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 24, bottom: 16),
            child: TmdbAttribution(),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const new({required this.displayName, required this.onOpen});

  final String displayName;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onOpen,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 32,
              child: Text(_initial(displayName)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Открыть профиль',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  const new({required this.label, required this.onTap, this.trailing});

  final String label;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final icon = trailing;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Expanded(child: Text(label, style: theme.textTheme.bodyLarge)),
            icon ??
                Text(
                  '›',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

enum _ProfileMenuItem {
  discussions,
  lists,
  reviews,
  ratings,
  watchlist,
  favorites,
  apiSubscription,
  editProfile,
  settings,
}

const List<_ProfileMenuItem> _activityItems = [
  _ProfileMenuItem.discussions,
  _ProfileMenuItem.lists,
  _ProfileMenuItem.reviews,
  _ProfileMenuItem.ratings,
  _ProfileMenuItem.watchlist,
  _ProfileMenuItem.favorites,
];

const List<_ProfileMenuItem> _accountItems = [
  _ProfileMenuItem.apiSubscription,
  _ProfileMenuItem.editProfile,
  _ProfileMenuItem.settings,
];

extension on _ProfileMenuItem {
  String get title {
    return switch (this) {
      _ProfileMenuItem.discussions => 'Обсуждения',
      _ProfileMenuItem.lists => 'Списки',
      _ProfileMenuItem.reviews => 'Обзоры',
      _ProfileMenuItem.ratings => 'Рейтинги',
      _ProfileMenuItem.watchlist => 'Список отслеживания',
      _ProfileMenuItem.favorites => 'Избранное',
      _ProfileMenuItem.apiSubscription => 'API Subscription',
      _ProfileMenuItem.editProfile => 'Править профиль',
      _ProfileMenuItem.settings => 'Параметры',
    };
  }

  String get pathSuffix {
    return switch (this) {
      _ProfileMenuItem.discussions => '/discussions',
      _ProfileMenuItem.lists => '/lists',
      _ProfileMenuItem.reviews => '/reviews',
      _ProfileMenuItem.ratings => '/ratings',
      _ProfileMenuItem.watchlist => '/watchlist',
      _ProfileMenuItem.favorites => '/favorites',
      _ProfileMenuItem.apiSubscription => '/settings/api',
      _ProfileMenuItem.editProfile => '/edit',
      _ProfileMenuItem.settings => '/settings',
    };
  }
}

String _displayName(Authenticated account) {
  final username = account.username?.trim();
  if (username != null && username.isNotEmpty) {
    return username;
  }
  return 'Аккаунт #${account.accountId}';
}

String _initial(String name) {
  final trimmed = name.trim();
  if (trimmed.isEmpty) {
    return '?';
  }
  return trimmed.substring(0, 1).toUpperCase();
}

void _onMenu(BuildContext context, _ProfileMenuItem item, String? username) {
  if (item == _ProfileMenuItem.favorites) {
    unawaited(const FavoritesRoute().push<void>(context));
    return;
  }
  unawaited(_openTmdbProfile(username, item.pathSuffix));
}

Future<void> _openTmdbProfile(String? username, String suffix) async {
  final name = username?.trim();
  if (name == null || name.isEmpty) {
    return;
  }
  final uri = Uri.https('www.themoviedb.org', '/u/$name$suffix');
  try {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } on Exception {
    // The platform can refuse to open the page.
  }
}
