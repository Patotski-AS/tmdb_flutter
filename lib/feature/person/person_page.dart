import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tmdb_flutter/app/router.dart';
import 'package:tmdb_flutter/app/theme/tmdb_colors.dart';
import 'package:tmdb_flutter/data/tmdb/model/person_credit.dart';
import 'package:tmdb_flutter/feature/person/person_notifier.dart';
import 'package:tmdb_flutter/feature/person/person_state.dart';

const _creditsPreviewCount = 12;

/// Person card.
class PersonPage extends ConsumerWidget {
  /// Creates the person screen for [id].
  const new({required this.id, super.key});

  /// TMDB person id.
  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(personProvider(id));
    final notifier = ref.read(personProvider(id).notifier);
    return _PersonScaffold(
      title: state.name ?? 'Персона',
      body: _personBody(
        context: context,
        state: state,
        onRetry: () => unawaited(notifier.load()),
        onShowFullCast: notifier.showFullCastCredits,
        onShowFullCrew: notifier.showFullCrewCredits,
      ),
    );
  }
}

Widget _personBody({
  required BuildContext context,
  required PersonState state,
  required VoidCallback onRetry,
  required VoidCallback onShowFullCast,
  required VoidCallback onShowFullCrew,
}) {
  if (state.isLoading && state.name == null) {
    return const _PersonLoading();
  }
  final error = state.error;
  if (error != null && state.name == null) {
    return _PersonMessage(message: error, onRetry: onRetry);
  }
  return _PersonBody(
    state: state,
    onShowFullCast: onShowFullCast,
    onShowFullCrew: onShowFullCrew,
  );
}

class _PersonScaffold extends StatelessWidget {
  const new({required this.title, required this.body});

  final String title;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
        leading: IconButton(
          tooltip: 'Назад',
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: body,
    );
  }
}

class _PersonBody extends StatelessWidget {
  const new({
    required this.state,
    required this.onShowFullCast,
    required this.onShowFullCrew,
  });

  final PersonState state;
  final VoidCallback onShowFullCast;
  final VoidCallback onShowFullCrew;

  @override
  Widget build(BuildContext context) {
    final biography = state.biography;
    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        _PersonHeader(state: state),
        if (biography != null) ...[
          const _SectionTitle(title: 'Биография'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              biography,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
        if (state.knownFor.isNotEmpty) ...[
          const _SectionTitle(title: 'Известен по'),
          _CreditStrip(
            credits: state.knownFor,
            onCreditTap: (credit) => _openCredit(context, credit),
          ),
        ],
        if (state.castCredits.isNotEmpty)
          _ExpandableCredits(
            title: 'Роли',
            credits: state.castCredits,
            showFull: state.showFullCastCredits,
            onShowFull: onShowFullCast,
            onCreditTap: (credit) => _openCredit(context, credit),
          ),
        if (state.crewCredits.isNotEmpty)
          _ExpandableCredits(
            title: 'Команда',
            credits: state.crewCredits,
            showFull: state.showFullCrewCredits,
            onShowFull: onShowFullCrew,
            onCreditTap: (credit) => _openCredit(context, credit),
          ),
      ],
    );
  }
}

class _PersonHeader extends StatelessWidget {
  const new({required this.state});

  final PersonState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    final lines = <Widget>[
      Text(state.name ?? '', style: theme.textTheme.headlineSmall),
      if (state.knownForDepartment case final department?)
        Text(
          department,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
      if (_lifeDates(state) case final dates?) Text(dates, style: muted),
      if (state.placeOfBirth case final place?) Text(place, style: muted),
      if (_aliases(state) case final aliases?)
        Text(
          aliases,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipOval(
            child: SizedBox(
              width: 120,
              height: 120,
              child: _PersonImage(
                url: state.profileUrl,
                cacheWidth: _memCacheWidth(context, 120),
                icon: Icons.person_outline,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var index = 0; index < lines.length; index++) ...[
                  if (index > 0) const SizedBox(height: 8),
                  lines[index],
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpandableCredits extends StatelessWidget {
  const new({
    required this.title,
    required this.credits,
    required this.showFull,
    required this.onShowFull,
    required this.onCreditTap,
  });

  final String title;
  final List<PersonCredit> credits;
  final bool showFull;
  final VoidCallback onShowFull;
  final ValueChanged<PersonCredit> onCreditTap;

  @override
  Widget build(BuildContext context) {
    final visible = showFull
        ? credits
        : credits.take(_creditsPreviewCount).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionTitle(title: title),
        _CreditStrip(credits: visible, onCreditTap: onCreditTap),
        if (!showFull && credits.length > _creditsPreviewCount)
          Center(
            child: TextButton(
              onPressed: onShowFull,
              child: const Text('Смотреть ещё'),
            ),
          ),
      ],
    );
  }
}

class _CreditStrip extends StatelessWidget {
  const new({required this.credits, required this.onCreditTap});

  final List<PersonCredit> credits;
  final ValueChanged<PersonCredit> onCreditTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: credits.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final credit = credits[index];
          return _CreditCell(
            credit: credit,
            cacheWidth: _memCacheWidth(context, 120),
            onTap: () => onCreditTap(credit),
          );
        },
      ),
    );
  }
}

class _CreditCell extends StatelessWidget {
  const new({
    required this.credit,
    required this.cacheWidth,
    required this.onTap,
  });

  final PersonCredit credit;
  final int cacheWidth;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subtitle = credit.characterOrJob;
    final vote = credit.voteAverage;
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
                child: _PersonImage(
                  url: credit.posterUrl,
                  cacheWidth: cacheWidth,
                  icon: Icons.movie_outlined,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              credit.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelMedium,
            ),
            if (subtitle != null)
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            if (vote > 0)
              Text(
                '★ ${vote.toStringAsFixed(1)}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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

class _PersonImage extends StatelessWidget {
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
    if (imageUrl == null || imageUrl.isEmpty) {
      return placeholder;
    }
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      memCacheWidth: cacheWidth,
      placeholder: (_, _) => placeholder,
      errorWidget: (_, _, _) => placeholder,
    );
  }
}

class _PersonLoading extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: const [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Bone.circle(size: 120),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Bone.text(words: 2),
                    SizedBox(height: 8),
                    Bone.text(words: 2),
                    SizedBox(height: 8),
                    Bone.text(words: 3),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          Bone.multiText(lines: 4),
        ],
      ),
    );
  }
}

class _PersonMessage extends StatelessWidget {
  const new({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
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
            FilledButton(onPressed: onRetry, child: const Text('Повторить')),
          ],
        ),
      ),
    );
  }
}

void _openCredit(BuildContext context, PersonCredit credit) {
  final routeId = '${credit.id}';
  switch (credit.mediaType) {
    case PersonCreditMediaType.movie:
      unawaited(MovieRoute(id: routeId).push<void>(context));
    case PersonCreditMediaType.tv:
      unawaited(TvRoute(id: routeId).push<void>(context));
  }
}

String? _lifeDates(PersonState state) {
  final birthday = state.birthday;
  if (birthday == null) {
    return null;
  }
  final deathday = state.deathday;
  if (deathday == null) {
    return 'Дата рождения: $birthday';
  }
  return '$birthday — $deathday';
}

String? _aliases(PersonState state) {
  if (state.alsoKnownAs.isEmpty) {
    return null;
  }
  return state.alsoKnownAs.take(3).join(', ');
}

int _memCacheWidth(BuildContext context, double logicalWidth) {
  final pixels = logicalWidth * MediaQuery.devicePixelRatioOf(context);
  if (!pixels.isFinite || pixels < 1) {
    return 1;
  }
  return pixels.round();
}
