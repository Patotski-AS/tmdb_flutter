import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tmdb_flutter/app/router.dart';
import 'package:tmdb_flutter/app/theme/tmdb_colors.dart';
import 'package:tmdb_flutter/data/session/session_repository.dart';
import 'package:tmdb_flutter/data/session/session_state.dart';
import 'package:tmdb_flutter/feature/details/details_notifier.dart';
import 'package:tmdb_flutter/feature/details/details_state.dart';
import 'package:url_launcher/url_launcher.dart';

part 'details_body.dart';
part 'details_gallery.dart';

/// Details route that keeps [mediaType] of the open card.
GoRouteData recommendationRoute({
  required DetailsMediaType mediaType,
  required int id,
}) {
  final routeId = '$id';
  return switch (mediaType) {
    DetailsMediaType.movie => MovieRoute(id: routeId),
    DetailsMediaType.tv => TvRoute(id: routeId),
  };
}

/// Movie or TV card.
class DetailsPage extends ConsumerWidget {
  /// Creates a card for [mediaType] and [id].
  const new({required this.mediaType, required this.id, super.key});

  /// Movie or TV.
  final DetailsMediaType mediaType;

  /// TMDB id.
  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(detailsProvider(mediaType, id));
    final notifier = ref.read(detailsProvider(mediaType, id).notifier);
    final session = ref.watch(sessionRepositoryProvider);
    final signedIn = session.asData?.value is Authenticated;
    final favoriteEnabled = session.hasValue && !state.isFavoriteLoading;
    final gallery = state.imageGallery;
    final galleryImages = gallery == null
        ? const <String>[]
        : _galleryUrls(state, gallery.section);
    final showGallery = gallery != null && galleryImages.isNotEmpty;
    final galleryIndex = gallery?.index ?? 0;
    return PopScope(
      canPop: !showGallery,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          return;
        }
        notifier.dismissGallery();
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          _DetailsScaffold(
            body: _detailsBody(
              context: context,
              state: state,
              mediaType: mediaType,
              onRetry: () => unawaited(notifier.load()),
              onShowFullCast: notifier.showFullCast,
              onCastTap: (personId) {
                unawaited(PersonRoute(id: '$personId').push<void>(context));
              },
              onVideoTap: (key) => unawaited(_openYoutube(key)),
              onImageTap: notifier.openGallery,
              onRecommendationTap: (recommendationId) {
                unawaited(
                  recommendationRoute(
                    mediaType: mediaType,
                    id: recommendationId,
                  ).push<void>(context),
                );
              },
              favoriteLabel: _favoriteLabel(signedIn: signedIn, state: state),
              onFavorite: favoriteEnabled
                  ? () => _onFavorite(
                      context,
                      ref,
                      mediaType: mediaType,
                      id: id,
                      signedIn: signedIn,
                    )
                  : null,
            ),
          ),
          if (showGallery)
            _DetailsGallery(
              images: galleryImages,
              initialIndex: galleryIndex,
              onDismiss: notifier.dismissGallery,
            ),
        ],
      ),
    );
  }
}

/// Error screen for a details path whose id is not an integer.
class DetailsInvalidIdPage extends StatelessWidget {
  /// Creates the invalid-id screen.
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return const _DetailsScaffold(
      body: _DetailsMessage(message: 'Некорректный идентификатор'),
    );
  }
}

Widget _detailsBody({
  required BuildContext context,
  required DetailsState state,
  required DetailsMediaType mediaType,
  required VoidCallback onRetry,
  required VoidCallback onShowFullCast,
  required ValueChanged<int> onCastTap,
  required ValueChanged<String> onVideoTap,
  required _ImageTap onImageTap,
  required ValueChanged<int> onRecommendationTap,
  required String favoriteLabel,
  required VoidCallback? onFavorite,
}) {
  if (state.isLoading && state.title == null) {
    return const _DetailsLoading();
  }
  final error = state.error;
  if (error != null && state.title == null) {
    return _DetailsMessage(message: error, onRetry: onRetry);
  }
  return _DetailsBody(
    state: state,
    showFavorite: mediaType == DetailsMediaType.movie,
    favoriteLabel: favoriteLabel,
    onFavorite: onFavorite,
    onShowFullCast: onShowFullCast,
    onCastTap: onCastTap,
    onVideoTap: onVideoTap,
    onImageTap: onImageTap,
    onRecommendationTap: onRecommendationTap,
  );
}

List<String> _galleryUrls(DetailsState state, DetailsGallerySection section) {
  final images = switch (section) {
    DetailsGallerySection.backdrops => state.backdrops,
    DetailsGallerySection.posters => state.posters,
  };
  return [for (final image in images) image.url];
}

Future<void> _openYoutube(String key) {
  final uri = Uri.https('www.youtube.com', '/watch', {'v': key});
  return launchUrl(uri, mode: LaunchMode.externalApplication);
}

void _onFavorite(
  BuildContext context,
  WidgetRef ref, {
  required DetailsMediaType mediaType,
  required int id,
  required bool signedIn,
}) {
  if (!signedIn) {
    unawaited(const ProfileRoute().push<void>(context));
    return;
  }
  if (mediaType != DetailsMediaType.movie) {
    return;
  }
  unawaited(
    ref.read(detailsProvider(mediaType, id).notifier).toggleFavorite(),
  );
}

String _favoriteLabel({
  required bool signedIn,
  required DetailsState state,
}) {
  if (!signedIn || state.isFavorite != true) {
    if (signedIn && state.isFavoriteLoading && state.isFavorite == null) {
      return '…';
    }
    return '☆ В избранное';
  }
  return '★ В избранном';
}

class _DetailsScaffold extends StatelessWidget {
  const new({required this.body});

  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
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

class _DetailsLoading extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          SizedBox(height: 260, width: double.infinity, child: Bone()),
          SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Bone.text(words: 3),
                SizedBox(height: 12),
                Bone.multiText(lines: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailsMessage extends StatelessWidget {
  const new({required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final retry = onRetry;
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
            if (retry != null) ...[
              const SizedBox(height: 16),
              FilledButton(onPressed: retry, child: const Text('Повторить')),
            ],
          ],
        ),
      ),
    );
  }
}
