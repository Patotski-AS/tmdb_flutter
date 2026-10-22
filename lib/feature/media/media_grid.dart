import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tmdb_flutter/app/theme/tmdb_colors.dart';
import 'package:tmdb_flutter/feature/media/media_state.dart';

const _posterAspect = 0.52;
const _personAspect = 0.72;
const _gridPadding = 16.0;
const _gridSpacing = 12.0;

/// Two-column poster grid with ratings.
class MediaPosterGrid extends StatelessWidget {
  /// Creates a poster grid.
  const new({
    required this.items,
    required this.favoriteIds,
    required this.isLoading,
    required this.isLoadingMore,
    required this.endReached,
    required this.onLoadMore,
    required this.onItemTap,
    this.footerError,
    super.key,
  });

  /// Posters to show.
  final List<MediaItem> items;

  /// Movie ids marked as favorites.
  final Set<int> favoriteIds;

  /// Whether a first-page request is still running.
  final bool isLoading;

  /// Whether the next page is being appended.
  final bool isLoadingMore;

  /// Whether there is no next page.
  final bool endReached;

  /// Requests the next page.
  final VoidCallback onLoadMore;

  /// Opens the item with this id.
  final ValueChanged<int> onItemTap;

  /// Load-more failure shown under the list.
  final String? footerError;

  @override
  Widget build(BuildContext context) {
    return _CatalogGrid(
      items: items,
      isLoading: isLoading,
      isLoadingMore: isLoadingMore,
      endReached: endReached,
      onLoadMore: onLoadMore,
      footerError: footerError,
      childAspectRatio: _posterAspect,
      cacheWidthFactor: 1,
      itemBuilder: (context, item, cacheWidth) {
        return _PosterCell(
          item: item,
          cacheWidth: cacheWidth,
          isFavorite: favoriteIds.contains(item.id),
          onTap: () => onItemTap(item.id),
        );
      },
    );
  }
}

/// Two-column grid of people photos.
class PersonGrid extends StatelessWidget {
  /// Creates a people grid.
  const new({
    required this.items,
    required this.isLoading,
    required this.isLoadingMore,
    required this.endReached,
    required this.onLoadMore,
    required this.onItemTap,
    this.footerError,
    super.key,
  });

  /// People to show.
  final List<MediaItem> items;

  /// Whether a first-page request is still running.
  final bool isLoading;

  /// Whether the next page is being appended.
  final bool isLoadingMore;

  /// Whether there is no next page.
  final bool endReached;

  /// Requests the next page.
  final VoidCallback onLoadMore;

  /// Opens the person with this id.
  final ValueChanged<int> onItemTap;

  /// Load-more failure shown under the list.
  final String? footerError;

  @override
  Widget build(BuildContext context) {
    return _CatalogGrid(
      items: items,
      isLoading: isLoading,
      isLoadingMore: isLoadingMore,
      endReached: endReached,
      onLoadMore: onLoadMore,
      footerError: footerError,
      childAspectRatio: _personAspect,
      cacheWidthFactor: 0.72,
      itemBuilder: (context, item, cacheWidth) {
        return _PersonCell(
          item: item,
          cacheWidth: cacheWidth,
          onTap: () => onItemTap(item.id),
        );
      },
    );
  }
}

/// Placeholder grid shown while the first page is loading.
class CatalogLoadingGrid extends StatelessWidget {
  /// Creates a loading grid.
  ///
  /// [people] uses round photo placeholders. Otherwise the cells are posters.
  const new({required this.people, super.key});

  /// Whether the placeholders are people instead of posters.
  final bool people;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(_gridPadding),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: _gridSpacing,
          crossAxisSpacing: _gridSpacing,
          childAspectRatio: people ? _personAspect : _posterAspect,
        ),
        itemCount: 12,
        itemBuilder: (context, index) {
          if (people) {
            return const Column(
              children: [
                Expanded(child: Center(child: Bone.circle(size: 96))),
                Bone.text(words: 2),
                SizedBox(height: 4),
                Bone.text(),
              ],
            );
          }
          return const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Bone()),
              SizedBox(height: 8),
              Bone.text(words: 2),
            ],
          );
        },
      ),
    );
  }
}

typedef _CellBuilder = Widget Function(
  BuildContext context,
  MediaItem item,
  int cacheWidth,
);

class _CatalogGrid extends StatefulWidget {
  const new({
    required this.items,
    required this.isLoading,
    required this.isLoadingMore,
    required this.endReached,
    required this.onLoadMore,
    required this.footerError,
    required this.childAspectRatio,
    required this.cacheWidthFactor,
    required this.itemBuilder,
  });

  final List<MediaItem> items;
  final bool isLoading;
  final bool isLoadingMore;
  final bool endReached;
  final VoidCallback onLoadMore;
  final String? footerError;
  final double childAspectRatio;
  final double cacheWidthFactor;
  final _CellBuilder itemBuilder;

  @override
  State<_CatalogGrid> createState() => _CatalogGridState();
}

class _CatalogGridState extends State<_CatalogGrid> {
  int _requestedForCount = -1;

  @override
  void didUpdateWidget(covariant _CatalogGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items.length != widget.items.length) {
      _requestedForCount = -1;
    }
  }

  void _considerLoadMore(int index) {
    final count = widget.items.length;
    if (index < count - 4) return;
    if (widget.endReached || widget.isLoadingMore || widget.isLoading) return;
    if (widget.footerError != null) return;
    if (_requestedForCount == count) return;
    _requestedForCount = count;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      widget.onLoadMore();
    });
  }

  @override
  Widget build(BuildContext context) {
    final error = widget.footerError;
    return LayoutBuilder(
      builder: (context, constraints) {
        final cellWidth =
            (constraints.maxWidth - _gridPadding * 2 - _gridSpacing) / 2;
        final imageWidth = cellWidth * widget.cacheWidthFactor;
        final cacheWidth = _memCacheWidth(context, imageWidth);
        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(_gridPadding),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: _gridSpacing,
                  crossAxisSpacing: _gridSpacing,
                  childAspectRatio: widget.childAspectRatio,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  _considerLoadMore(index);
                  return widget.itemBuilder(
                    context,
                    widget.items[index],
                    cacheWidth,
                  );
                }, childCount: widget.items.length),
              ),
            ),
            if (widget.isLoadingMore)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Center(
                    child: SizedBox.square(
                      dimension: 32,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
              ),
            if (error != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Text(
                    error,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

int _memCacheWidth(BuildContext context, double logicalWidth) {
  final pixels = logicalWidth * MediaQuery.devicePixelRatioOf(context);
  if (!pixels.isFinite || pixels < 1) return 1;
  return pixels.round();
}

class _PosterCell extends StatelessWidget {
  const new({
    required this.item,
    required this.cacheWidth,
    required this.isFavorite,
    required this.onTap,
  });

  final MediaItem item;
  final int cacheWidth;
  final bool isFavorite;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor = isFavorite ? const Color(0xFFFF6B00) : Colors.black;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: TmdbColors.surfaceVariant,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor, width: 2),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _CatalogImage(
                        url: item.posterUrl,
                        cacheWidth: cacheWidth,
                        icon: Icons.movie_outlined,
                      ),
                      if (isFavorite)
                        const Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: EdgeInsets.all(6),
                            child: Icon(Icons.star, color: Color(0xFFFFC107)),
                          ),
                        ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: theme.colorScheme.scrim.withValues(
                                alpha: 0.72,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              child: Text(
                                '★ ${item.voteAverage.toStringAsFixed(1)}',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PersonCell extends StatelessWidget {
  const new({
    required this.item,
    required this.cacheWidth,
    required this.onTap,
  });

  final MediaItem item;
  final int cacheWidth;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final department = item.subtitle;
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Expanded(
            child: Align(
              child: AspectRatio(
                aspectRatio: 1,
                child: FractionallySizedBox(
                  widthFactor: 0.72,
                  child: ClipOval(
                    child: _CatalogImage(
                      url: item.posterUrl,
                      cacheWidth: cacheWidth,
                      icon: Icons.person_outline,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
          if (department != null && department.isNotEmpty)
            Text(
              department,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }
}

class _CatalogImage extends StatelessWidget {
  const new({
    required this.url,
    required this.cacheWidth,
    required this.icon,
  });

  final String? url;
  final int cacheWidth;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final imageUrl = url;
    final placeholder = ColoredBox(
      color: TmdbColors.surfaceVariant,
      child: Center(child: Icon(icon)),
    );
    if (imageUrl == null || imageUrl.isEmpty) return placeholder;
    return CachedNetworkImage(
      imageUrl: imageUrl,
      memCacheWidth: cacheWidth,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      placeholder: (_, _) => placeholder,
      errorWidget: (_, _, _) => placeholder,
    );
  }
}
