part of 'details_page.dart';

const _castPreviewCount = 15;

typedef _ImageTap = void Function(DetailsGallerySection section, int index);

class _DetailsBody extends StatelessWidget {
  const new({
    required this.state,
    required this.showFavorite,
    required this.onShowFullCast,
    required this.onCastTap,
    required this.onVideoTap,
    required this.onImageTap,
    required this.onRecommendationTap,
  });

  final DetailsState state;
  final bool showFavorite;
  final VoidCallback onShowFullCast;
  final ValueChanged<int> onCastTap;
  final ValueChanged<String> onVideoTap;
  final _ImageTap onImageTap;
  final ValueChanged<int> onRecommendationTap;

  @override
  Widget build(BuildContext context) {
    final visibleCast = state.showFullCast
        ? state.cast
        : state.cast.take(_castPreviewCount).toList();
    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        _DetailsHero(
          state: state,
          showFavorite: showFavorite,
          cacheWidth: _cacheWidth(context, 100),
        ),
        const SizedBox(height: 16),
        _Overview(state: state),
        if (state.cast.isNotEmpty) ...[
          const _SectionTitle(title: 'В главных ролях'),
          _CastRow(
            cast: visibleCast,
            onCastTap: onCastTap,
          ),
          if (!state.showFullCast && state.cast.length > _castPreviewCount)
            Center(
              child: TextButton(
                onPressed: onShowFullCast,
                child: const Text('Смотреть ещё'),
              ),
            ),
        ],
        if (state.videos.isNotEmpty) ...[
          const _SectionTitle(title: 'Видео'),
          _VideoRow(videos: state.videos, onVideoTap: onVideoTap),
        ],
        if (state.backdrops.isNotEmpty) ...[
          const _SectionTitle(title: 'Кадры'),
          _ImageStrip(
            images: state.backdrops,
            width: 220,
            height: 124,
            cacheWidth: _cacheWidth(context, 220),
            onTap: (index) {
              onImageTap(DetailsGallerySection.backdrops, index);
            },
          ),
        ],
        if (state.posters.isNotEmpty) ...[
          const _SectionTitle(title: 'Постеры'),
          _ImageStrip(
            images: state.posters,
            width: 120,
            height: 180,
            cacheWidth: _cacheWidth(context, 120),
            onTap: (index) {
              onImageTap(DetailsGallerySection.posters, index);
            },
          ),
        ],
        if (_hasMetadata(state)) ...[
          const _SectionTitle(title: 'Метаданные'),
          _Metadata(state: state),
        ],
        if (state.recommendations.isNotEmpty) ...[
          const _SectionTitle(title: 'Рекомендации'),
          _RecommendationRow(
            items: state.recommendations,
            onTap: onRecommendationTap,
          ),
        ],
      ],
    );
  }
}

class _DetailsHero extends StatelessWidget {
  const new({
    required this.state,
    required this.showFavorite,
    required this.cacheWidth,
  });

  final DetailsState state;
  final bool showFavorite;
  final int cacheWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final vote = state.voteAverage;
    final tagline = state.tagline;
    return SizedBox(
      height: 260,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _NetworkImage(
            url: state.backdropUrl,
            cacheWidth: _cacheWidth(context, 780),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x00000000),
                  Color(0xD9152B40),
                  TmdbColors.surface,
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      width: 100,
                      height: 150,
                      child: _NetworkImage(
                        url: state.posterUrl,
                        cacheWidth: cacheWidth,
                        icon: Icons.movie_outlined,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.title ?? '',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: TmdbColors.onDark,
                          ),
                        ),
                        if (vote != null) ...[
                          const SizedBox(height: 6),
                          Text(
                            '★ ${vote.toStringAsFixed(1)}',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                        if (showFavorite) ...[
                          const SizedBox(height: 4),
                          TextButton(
                            onPressed: _ignoreFavorite,
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text('☆ В избранное'),
                          ),
                        ],
                        if (tagline != null) ...[
                          const SizedBox(height: 6),
                          Text(
                            tagline,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: TmdbColors.onDark.withValues(alpha: 0.85),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Overview extends StatelessWidget {
  const new({required this.state});

  final DetailsState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    final releaseDate = state.releaseDate;
    final runtime = state.runtime;
    final seasons = _formatSeasonsEpisodes(state);
    final overview = state.overview;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_hasDateOrRuntime(releaseDate, runtime))
            Row(
              children: [
                if (releaseDate != null && releaseDate.isNotEmpty)
                  Text(releaseDate, style: muted),
                if (releaseDate != null &&
                    releaseDate.isNotEmpty &&
                    runtime != null &&
                    runtime > 0)
                  const SizedBox(width: 16),
                if (runtime != null && runtime > 0)
                  Text(_runtimeLabel(state.mediaType, runtime), style: muted),
              ],
            ),
          if (seasons != null) ...[
            const SizedBox(height: 12),
            Text(seasons, style: muted),
          ],
          if (state.genres.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              state.genres.join(', '),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ],
          for (final member in state.crew) ...[
            const SizedBox(height: 12),
            Text('${member.jobLabel}: ${member.name}'),
          ],
          if (overview != null && overview.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(overview, style: theme.textTheme.bodyLarge),
          ],
        ],
      ),
    );
  }
}

class _CastRow extends StatelessWidget {
  const new({required this.cast, required this.onCastTap});

  final List<DetailsCastMember> cast;
  final ValueChanged<int> onCastTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 168,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: cast.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final member = cast[index];
          return _CastCell(
            member: member,
            cacheWidth: _cacheWidth(context, 80),
            onTap: () => onCastTap(member.id),
          );
        },
      ),
    );
  }
}

class _CastCell extends StatelessWidget {
  const new({
    required this.member,
    required this.cacheWidth,
    required this.onTap,
  });

  final DetailsCastMember member;
  final int cacheWidth;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 96,
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            ClipOval(
              child: SizedBox.square(
                dimension: 80,
                child: _NetworkImage(
                  url: member.profileUrl,
                  cacheWidth: cacheWidth,
                  icon: Icons.person_outline,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              member.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: theme.textTheme.labelMedium,
            ),
            Text(
              member.character,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VideoRow extends StatelessWidget {
  const new({required this.videos, required this.onVideoTap});

  final List<DetailsVideo> videos;
  final ValueChanged<String> onVideoTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 176,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: videos.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final video = videos[index];
          return _VideoCell(
            video: video,
            cacheWidth: _cacheWidth(context, 180),
            onTap: () => onVideoTap(video.key),
          );
        },
      ),
    );
  }
}

class _VideoCell extends StatelessWidget {
  const new({
    required this.video,
    required this.cacheWidth,
    required this.onTap,
  });

  final DetailsVideo video;
  final int cacheWidth;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final thumbnail = 'https://img.youtube.com/vi/${video.key}/hqdefault.jpg';
    return SizedBox(
      width: 180,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                height: 101,
                width: 180,
                child: _NetworkImage(url: thumbnail, cacheWidth: cacheWidth),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              video.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelMedium,
            ),
            Text(
              video.typeLabel,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImageStrip extends StatelessWidget {
  const new({
    required this.images,
    required this.width,
    required this.height,
    required this.cacheWidth,
    required this.onTap,
  });

  final List<DetailsImage> images;
  final double width;
  final double height;
  final int cacheWidth;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: images.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () => onTap(index),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: width,
                height: height,
                child: _NetworkImage(
                  url: images[index].url,
                  cacheWidth: cacheWidth,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _RecommendationRow extends StatelessWidget {
  const new({required this.items, required this.onTap});

  final List<DetailsRecommendation> items;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = items[index];
          return _RecommendationCell(
            item: item,
            cacheWidth: _cacheWidth(context, 120),
            onTap: () => onTap(item.id),
          );
        },
      ),
    );
  }
}

class _RecommendationCell extends StatelessWidget {
  const new({
    required this.item,
    required this.cacheWidth,
    required this.onTap,
  });

  final DetailsRecommendation item;
  final int cacheWidth;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 120,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 120,
                height: 180,
                child: _NetworkImage(
                  url: item.posterUrl,
                  cacheWidth: cacheWidth,
                  icon: Icons.movie_outlined,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              item.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelMedium,
            ),
            Text(
              '★ ${item.voteAverage.toStringAsFixed(1)}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Metadata extends StatelessWidget {
  const new({required this.state});

  final DetailsState state;

  @override
  Widget build(BuildContext context) {
    final originalTitle = state.originalTitle;
    final status = state.status;
    final seasons = state.numberOfSeasons;
    final episodes = state.numberOfEpisodes;
    final language = state.originalLanguage;
    final budget = state.budget;
    final revenue = state.revenue;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          if (originalTitle != null)
            _MetadataRow(label: 'Исходное название', value: originalTitle),
          if (status != null) _MetadataRow(label: 'Статус', value: status),
          if (seasons != null)
            _MetadataRow(label: 'Сезоны', value: '$seasons'),
          if (episodes != null)
            _MetadataRow(label: 'Эпизоды', value: '$episodes'),
          if (language != null)
            _MetadataRow(label: 'Язык', value: language.toUpperCase()),
          if (budget != null)
            _MetadataRow(label: 'Бюджет', value: _formatCurrency(budget)),
          if (revenue != null)
            _MetadataRow(label: 'Сборы', value: _formatCurrency(revenue)),
        ],
      ),
    );
  }
}

class _MetadataRow extends StatelessWidget {
  const new({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            '$label:',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(value, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const new({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}

class _NetworkImage extends StatelessWidget {
  const new({
    required this.url,
    required this.cacheWidth,
    this.icon = Icons.image_outlined,
    this.fit = BoxFit.cover,
  });

  final String? url;
  final int cacheWidth;
  final IconData icon;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final imageUrl = url;
    final placeholder = ColoredBox(
      color: TmdbColors.surfaceVariant,
      child: Center(child: Icon(icon)),
    );
    if (imageUrl == null || imageUrl.isEmpty) {
      return placeholder;
    }
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
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

bool _hasDateOrRuntime(String? releaseDate, int? runtime) {
  return (releaseDate != null && releaseDate.isNotEmpty) ||
      (runtime != null && runtime > 0);
}

bool _hasMetadata(DetailsState state) {
  return state.originalTitle != null ||
      state.status != null ||
      state.originalLanguage != null ||
      state.numberOfSeasons != null ||
      state.numberOfEpisodes != null ||
      state.budget != null ||
      state.revenue != null;
}

String? _formatSeasonsEpisodes(DetailsState state) {
  final seasons = state.numberOfSeasons;
  final episodes = state.numberOfEpisodes;
  if (seasons != null && episodes != null) {
    return '${_formatSeasons(seasons)} · ${_formatEpisodes(episodes)}';
  }
  if (seasons != null) {
    return _formatSeasons(seasons);
  }
  if (episodes != null) {
    return _formatEpisodes(episodes);
  }
  return null;
}

String _formatSeasons(int count) {
  return _plural(count, 'сезон', 'сезона', 'сезонов');
}

String _formatEpisodes(int count) {
  return _plural(count, 'эпизод', 'эпизода', 'эпизодов');
}

String _plural(int count, String one, String few, String many) {
  final mod10 = count % 10;
  final mod100 = count % 100;
  if (mod10 == 1 && mod100 != 11) {
    return '$count $one';
  }
  if (mod10 >= 2 && mod10 <= 4 && (mod100 < 12 || mod100 > 14)) {
    return '$count $few';
  }
  return '$count $many';
}

String _runtimeLabel(DetailsMediaType mediaType, int minutes) {
  final label = _formatRuntime(minutes);
  if (mediaType == DetailsMediaType.tv) {
    return '~$label';
  }
  return label;
}

String _formatRuntime(int minutes) {
  final hours = minutes ~/ 60;
  final mins = minutes % 60;
  if (hours > 0 && mins > 0) {
    return '$hours ч $mins мин';
  }
  if (hours > 0) {
    return '$hours ч';
  }
  return '$mins мин';
}

String _formatCurrency(int amount) {
  if (amount >= 1000000000) {
    return '\$${_formatAmount(amount / 1000000000)} млрд';
  }
  if (amount >= 1000000) {
    return '\$${_formatAmount(amount / 1000000)} млн';
  }
  return '\$$amount';
}

String _formatAmount(double value) {
  final rounded = (value * 10).truncate() / 10;
  if (rounded % 1 == 0) {
    return rounded.toInt().toString();
  }
  return rounded.toString();
}
