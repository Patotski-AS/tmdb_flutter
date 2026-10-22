import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmdb_flutter/app/router.dart';
import 'package:tmdb_flutter/data/tmdb/model/media_sort_option.dart';
import 'package:tmdb_flutter/feature/media/media_filter_sheet.dart';
import 'package:tmdb_flutter/feature/media/media_grid.dart';
import 'package:tmdb_flutter/feature/media/media_notifier.dart';
import 'package:tmdb_flutter/feature/media/tmdb_attribution.dart';

/// Catalog at `/`: movies, TV shows, and people.
class MediaPage extends ConsumerWidget {
  /// Creates the catalog screen.
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mediaProvider);
    final showFilters = state.contentType != MediaContentType.people;
    return Scaffold(
      floatingActionButton: showFilters
          ? FloatingActionButton(
              tooltip: 'Фильтры',
              onPressed: () => unawaited(_openFilters(context, ref)),
              child: const Icon(Icons.tune),
            )
          : null,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _SearchRow(
              query: state.searchQuery,
              hint: _searchHint(state.contentType),
              onQueryChanged: (query) {
                ref.read(mediaProvider.notifier).onQueryChanged(query);
              },
              onClear: () => ref.read(mediaProvider.notifier).clearQuery(),
              onProfile: () {
                unawaited(const ProfileRoute().push<void>(context));
              },
            ),
            Expanded(
              child: _MediaBody(
                onRetry: () {
                  ref.read(mediaProvider.notifier).load();
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const TmdbAttribution(),
          NavigationBar(
            selectedIndex: _sectionIndex(state.contentType),
            onDestinationSelected: (index) {
              ref
                  .read(mediaProvider.notifier)
                  .selectContentType(_sectionAt(index));
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.movie_outlined),
                label: 'Фильмы',
              ),
              NavigationDestination(
                icon: Icon(Icons.live_tv_outlined),
                label: 'Сериалы',
              ),
              NavigationDestination(
                icon: Icon(Icons.people_outline),
                label: 'Люди',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Future<void> _openFilters(BuildContext context, WidgetRef ref) async {
  final state = ref.read(mediaProvider);
  final notifier = ref.read(mediaProvider.notifier);
  await showMediaFilterSheet(
    context: context,
    contentType: state.contentType,
    genres: state.genres,
    filters: state.filters,
    onApply: notifier.applyFilters,
    onReset: notifier.resetFilters,
  );
}

class _SearchRow extends StatelessWidget {
  const new({
    required this.query,
    required this.hint,
    required this.onQueryChanged,
    required this.onClear,
    required this.onProfile,
  });

  final String query;
  final String hint;
  final ValueChanged<String> onQueryChanged;
  final VoidCallback onClear;
  final VoidCallback onProfile;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 4, 8),
      child: Row(
        children: [
          Expanded(
            child: _SearchField(
              query: query,
              hint: hint,
              onQueryChanged: onQueryChanged,
              onClear: onClear,
            ),
          ),
          IconButton(
            tooltip: 'Профиль',
            onPressed: onProfile,
            icon: const Icon(Icons.account_circle_outlined),
          ),
        ],
      ),
    );
  }
}

class _SearchField extends StatefulWidget {
  const new({
    required this.query,
    required this.hint,
    required this.onQueryChanged,
    required this.onClear,
  });

  final String query;
  final String hint;
  final ValueChanged<String> onQueryChanged;
  final VoidCallback onClear;

  @override
  State<_SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<_SearchField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.query);
  }

  @override
  void didUpdateWidget(covariant _SearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.query == _controller.text) return;
    _controller.value = TextEditingValue(
      text: widget.query,
      selection: TextSelection.collapsed(offset: widget.query.length),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
      controller: _controller,
      onChanged: widget.onQueryChanged,
      textInputAction: TextInputAction.search,
      autocorrect: false,
      decoration: InputDecoration(
        hintText: widget.hint,
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerHighest,
        suffixIcon: widget.query.isEmpty
            ? null
            : IconButton(
                tooltip: 'Очистить',
                onPressed: widget.onClear,
                icon: const Icon(Icons.close),
              ),
        border: const OutlineInputBorder(),
      ),
    );
  }
}

class _MediaBody extends ConsumerWidget {
  const new({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mediaProvider);
    final people = state.contentType == MediaContentType.people;
    if (state.isLoading && state.items.isEmpty) {
      return CatalogLoadingGrid(people: people);
    }
    if (state.error != null && state.items.isEmpty) {
      return _ErrorState(message: state.error!, onRetry: onRetry);
    }
    if (state.items.isEmpty) {
      return _EmptyState(message: _emptyMessage(state.contentType));
    }
    final footerError = state.error;
    void openItem(int id) => _openItem(context, state.contentType, id);
    void loadMore() => ref.read(mediaProvider.notifier).loadMore();
    if (people) {
      return PersonGrid(
        items: state.items,
        isLoading: state.isLoading,
        isLoadingMore: state.isLoadingMore,
        endReached: state.endReached,
        footerError: footerError,
        onLoadMore: loadMore,
        onItemTap: openItem,
      );
    }
    return MediaPosterGrid(
      items: state.items,
      favoriteIds: state.contentType == MediaContentType.movies
          ? state.favoriteIds
          : const <int>{},
      isLoading: state.isLoading,
      isLoadingMore: state.isLoadingMore,
      endReached: state.endReached,
      footerError: footerError,
      onLoadMore: loadMore,
      onItemTap: openItem,
    );
  }
}

class _EmptyState extends StatelessWidget {
  const new({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(message, textAlign: TextAlign.center),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const new({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: theme.colorScheme.error),
            ),
            const SizedBox(height: 16),
            FilledButton(onPressed: onRetry, child: const Text('Повторить')),
          ],
        ),
      ),
    );
  }
}

void _openItem(BuildContext context, MediaContentType type, int id) {
  final routeId = id.toString();
  switch (type) {
    case MediaContentType.movies:
      unawaited(MovieRoute(id: routeId).push<void>(context));
    case MediaContentType.tv:
      unawaited(TvRoute(id: routeId).push<void>(context));
    case MediaContentType.people:
      unawaited(PersonRoute(id: routeId).push<void>(context));
  }
}

String _searchHint(MediaContentType type) {
  return switch (type) {
    MediaContentType.movies => 'Поиск фильмов',
    MediaContentType.tv => 'Поиск сериалов',
    MediaContentType.people => 'Поиск людей',
  };
}

String _emptyMessage(MediaContentType type) {
  return switch (type) {
    MediaContentType.movies => 'Фильмы не найдены',
    MediaContentType.tv => 'Сериалы не найдены',
    MediaContentType.people => 'Люди не найдены',
  };
}

int _sectionIndex(MediaContentType type) {
  return switch (type) {
    MediaContentType.movies => 0,
    MediaContentType.tv => 1,
    MediaContentType.people => 2,
  };
}

MediaContentType _sectionAt(int index) {
  return switch (index) {
    0 => MediaContentType.movies,
    1 => MediaContentType.tv,
    _ => MediaContentType.people,
  };
}
