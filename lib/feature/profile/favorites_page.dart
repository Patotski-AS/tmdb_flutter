import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmdb_flutter/app/router.dart';
import 'package:tmdb_flutter/app/theme/tmdb_colors.dart';
import 'package:tmdb_flutter/data/tmdb/model/movie.dart';
import 'package:tmdb_flutter/feature/profile/favorites_notifier.dart';

/// Favorite movies at `/profile/favorites`.
class FavoritesPage extends ConsumerWidget {
  /// Creates the favorites screen.
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(favoritesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Избранное')),
      body: _FavoritesBody(
        isLoading: state.isLoading,
        error: state.error,
        movies: state.movies,
        onRetry: () {
          unawaited(ref.read(favoritesProvider.notifier).refresh());
        },
        onMovieTap: (movieId) {
          unawaited(MovieRoute(id: '$movieId').push<void>(context));
        },
      ),
    );
  }
}

class _FavoritesBody extends StatelessWidget {
  const new({
    required this.isLoading,
    required this.error,
    required this.movies,
    required this.onRetry,
    required this.onMovieTap,
  });

  final bool isLoading;
  final String? error;
  final List<Movie> movies;
  final VoidCallback onRetry;
  final ValueChanged<int> onMovieTap;

  @override
  Widget build(BuildContext context) {
    final message = error;
    if (isLoading && movies.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (message != null && movies.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: onRetry,
                child: const Text('Повторить'),
              ),
            ],
          ),
        ),
      );
    }
    if (movies.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Вы пока не добавили фильмы в избранное',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.52,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return _FavoritePoster(
          movie: movie,
          onTap: () => onMovieTap(movie.id),
        );
      },
    );
  }
}

class _FavoritePoster extends StatelessWidget {
  const new({required this.movie, required this.onTap});

  final Movie movie;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cacheWidth = _cacheWidth(context, 160);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: _PosterImage(url: movie.posterUrl, cacheWidth: cacheWidth),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            movie.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall,
          ),
          if (movie.voteAverage > 0)
            Text(
              '★ ${movie.voteAverage.toStringAsFixed(1)}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
        ],
      ),
    );
  }
}

class _PosterImage extends StatelessWidget {
  const new({required this.url, required this.cacheWidth});

  final String? url;
  final int cacheWidth;

  @override
  Widget build(BuildContext context) {
    final imageUrl = url;
    const placeholder = ColoredBox(
      color: TmdbColors.surfaceVariant,
      child: Center(child: Icon(Icons.movie_outlined)),
    );
    if (imageUrl == null || imageUrl.isEmpty) {
      return placeholder;
    }
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      memCacheWidth: cacheWidth,
      placeholder: (_, _) => placeholder,
      errorWidget: (_, _, _) => placeholder,
    );
  }
}

int _cacheWidth(BuildContext context, double logicalWidth) {
  final pixels = logicalWidth * MediaQuery.devicePixelRatioOf(context);
  if (!pixels.isFinite || pixels < 1) {
    return 1;
  }
  return pixels.round();
}
