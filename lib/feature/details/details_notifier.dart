import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tmdb_flutter/core/network/tmdb_exception.dart';
import 'package:tmdb_flutter/data/account/account_exception.dart';
import 'package:tmdb_flutter/data/account/account_providers.dart';
import 'package:tmdb_flutter/data/session/session_repository.dart';
import 'package:tmdb_flutter/data/session/session_state.dart';
import 'package:tmdb_flutter/data/tmdb/model/cast_member.dart';
import 'package:tmdb_flutter/data/tmdb/model/crew_member.dart';
import 'package:tmdb_flutter/data/tmdb/model/media_image.dart';
import 'package:tmdb_flutter/data/tmdb/model/movie.dart';
import 'package:tmdb_flutter/data/tmdb/model/movie_details.dart';
import 'package:tmdb_flutter/data/tmdb/model/tv_show.dart';
import 'package:tmdb_flutter/data/tmdb/model/tv_show_details.dart';
import 'package:tmdb_flutter/data/tmdb/model/video.dart';
import 'package:tmdb_flutter/data/tmdb/tmdb_providers.dart';
import 'package:tmdb_flutter/feature/details/details_state.dart';

part 'details_notifier.g.dart';

const _writerJobs = {'Screenplay', 'Writer', 'Story'};
const _videoPriority = ['Trailer', 'Teaser', 'Clip'];

/// Movie or TV card for one id.
@riverpod
class DetailsNotifier extends _$DetailsNotifier {
  bool _inFlight = false;
  var _favoriteEpoch = 0;

  @override
  DetailsState build(DetailsMediaType mediaType, int id) {
    ref.listen(sessionRepositoryProvider, (previous, next) {
      _onSession(next);
    });
    unawaited(
      Future<void>.microtask(() {
        if (!ref.mounted) {
          return;
        }
        unawaited(load());
      }),
    );
    return DetailsState(mediaType: mediaType, isLoading: true);
  }

  /// Loads the card.
  ///
  /// A call while a request is already running does nothing.
  Future<void> load() async {
    if (!ref.mounted || _inFlight) {
      return;
    }
    _inFlight = true;
    final media = mediaType;
    final mediaId = id;
    final favorite = state.isFavorite;
    state = state.copyWith(isLoading: true, error: null);
    try {
      final loaded = await _fetch(media, mediaId);
      if (!ref.mounted) {
        return;
      }
      state = loaded.copyWith(isFavorite: favorite);
      if (media == DetailsMediaType.movie && _isAuthenticated()) {
        unawaited(_loadFavorite());
      }
    } on TmdbException catch (error) {
      if (!ref.mounted) {
        return;
      }
      state = state.copyWith(isLoading: false, error: error.message);
    } finally {
      _inFlight = false;
    }
  }

  /// Switches the movie favorite flag.
  ///
  /// Guests return without an account request. A second call while
  /// the request is running does nothing. On failure the previous
  /// flag stays and [DetailsState.favoriteMessage] is set.
  Future<void> toggleFavorite() async {
    if (!ref.mounted || mediaType != DetailsMediaType.movie) {
      return;
    }
    if (state.isFavoriteLoading || !_isAuthenticated()) {
      return;
    }
    final next = !(state.isFavorite ?? false);
    _favoriteEpoch += 1;
    state = state.copyWith(isFavoriteLoading: true, favoriteMessage: null);
    try {
      await ref
          .read(accountRepositoryProvider)
          .setFavorite(movieId: id, favorite: next);
      if (!ref.mounted) {
        return;
      }
      if (!_isAuthenticated()) {
        state = state.copyWith(isFavorite: null, isFavoriteLoading: false);
        return;
      }
      state = state.copyWith(isFavorite: next, isFavoriteLoading: false);
    } on Exception catch (error) {
      if (!ref.mounted) {
        return;
      }
      state = state.copyWith(
        isFavoriteLoading: false,
        favoriteMessage: _favoriteError(error),
      );
    }
  }

  void _onSession(AsyncValue<SessionState> next) {
    if (!ref.mounted || mediaType != DetailsMediaType.movie) {
      return;
    }
    final value = next.asData?.value;
    if (value is Authenticated) {
      if (state.title != null && !state.isFavoriteLoading) {
        unawaited(_loadFavorite());
      }
      return;
    }
    if (next.hasValue) {
      _favoriteEpoch += 1;
      state = state.copyWith(isFavorite: null, isFavoriteLoading: false);
    }
  }

  bool _isAuthenticated() {
    final value = ref.read(sessionRepositoryProvider).asData?.value;
    return value is Authenticated;
  }

  Future<void> _loadFavorite() async {
    if (!ref.mounted || mediaType != DetailsMediaType.movie) {
      return;
    }
    if (!_isAuthenticated() || state.isFavoriteLoading) {
      return;
    }
    final epoch = _favoriteEpoch;
    try {
      final favorite = await ref.read(accountRepositoryProvider).isFavorite(id);
      if (!ref.mounted || epoch != _favoriteEpoch || !_isAuthenticated()) {
        return;
      }
      if (state.isFavoriteLoading) {
        return;
      }
      state = state.copyWith(isFavorite: favorite);
    } on Exception {
      // A failed read keeps the previous star.
    }
  }

  /// Reveals every cast member on this screen.
  void showFullCast() {
    if (!ref.mounted || state.showFullCast) {
      return;
    }
    state = state.copyWith(showFullCast: true);
  }

  /// Opens the local gallery at [index] of [section].
  void openGallery(DetailsGallerySection section, int index) {
    if (!ref.mounted) {
      return;
    }
    state = state.copyWith(
      imageGallery: DetailsImageGallery(section: section, index: index),
    );
  }

  /// Closes the local gallery without leaving the card.
  void dismissGallery() {
    if (!ref.mounted || state.imageGallery == null) {
      return;
    }
    state = state.copyWith(imageGallery: null);
  }

  Future<DetailsState> _fetch(DetailsMediaType media, int mediaId) {
    return switch (media) {
      DetailsMediaType.movie => _fetchMovie(mediaId),
      DetailsMediaType.tv => _fetchTv(mediaId),
    };
  }

  Future<DetailsState> _fetchMovie(int mediaId) async {
    final details = await ref
        .read(movieRepositoryProvider)
        .getMovieDetails(mediaId);
    return _movieState(details);
  }

  Future<DetailsState> _fetchTv(int mediaId) async {
    final details = await ref
        .read(tvRepositoryProvider)
        .getTvShowDetails(mediaId);
    return _tvState(details);
  }
}

String _favoriteError(Exception error) {
  if (error is TmdbException) {
    return error.message;
  }
  if (error is AccountAuthorizationException) {
    return error.message;
  }
  return 'Не удалось обновить избранное';
}

DetailsState _movieState(MovieDetails details) {
  return DetailsState(
    mediaType: DetailsMediaType.movie,
    title: details.title,
    overview: details.overview,
    posterUrl: details.posterUrl,
    backdropUrl: details.backdropUrl,
    tagline: details.tagline,
    voteAverage: details.voteAverage,
    releaseDate: details.releaseDate,
    runtime: details.runtime,
    genres: details.genres,
    originalTitle: details.originalTitle,
    status: details.status,
    originalLanguage: details.originalLanguage,
    budget: _shownMoney(details.budget),
    revenue: _shownMoney(details.revenue),
    cast: [for (final member in details.cast) _castMember(member)],
    crew: _keyCrew(details.crew),
    videos: _displayVideos(details.videos),
    backdrops: _images(details.backdrops),
    posters: _images(details.posters),
    recommendations: [
      for (final movie in details.recommendations) _movieRecommendation(movie),
    ],
  );
}

DetailsState _tvState(TvShowDetails details) {
  return DetailsState(
    mediaType: DetailsMediaType.tv,
    title: details.title,
    overview: details.overview,
    posterUrl: details.posterUrl,
    backdropUrl: details.backdropUrl,
    tagline: details.tagline,
    voteAverage: details.voteAverage,
    releaseDate: details.firstAirDate,
    runtime: details.episodeRuntimeMinutes,
    genres: details.genres,
    originalTitle: details.originalName,
    status: details.status,
    originalLanguage: details.originalLanguage,
    numberOfSeasons: details.numberOfSeasons,
    numberOfEpisodes: details.numberOfEpisodes,
    cast: [for (final member in details.cast) _castMember(member)],
    crew: [..._creators(details.createdBy), ..._keyCrew(details.crew)],
    videos: _displayVideos(details.videos),
    backdrops: _images(details.backdrops),
    posters: _images(details.posters),
    recommendations: [
      for (final show in details.recommendations) _tvRecommendation(show),
    ],
  );
}

int? _shownMoney(int amount) => amount > 0 ? amount : null;

DetailsCastMember _castMember(CastMember member) {
  return DetailsCastMember(
    id: member.id,
    name: member.name,
    character: member.character,
    profileUrl: member.profileUrl,
  );
}

List<DetailsCrewMember> _creators(List<String> names) {
  if (names.isEmpty) {
    return const [];
  }
  return [DetailsCrewMember(name: names.join(', '), jobLabel: 'Создатель')];
}

List<DetailsCrewMember> _keyCrew(List<CrewMember> crew) {
  final directors = _distinctNames([
    for (final member in crew)
      if (member.job == 'Director') member,
  ]);
  final writers = _distinctNames([
    for (final member in crew)
      if (_writerJobs.contains(member.job)) member,
  ]);
  return [
    if (directors.isNotEmpty)
      DetailsCrewMember(name: directors.join(', '), jobLabel: 'Режиссёр'),
    if (writers.isNotEmpty)
      DetailsCrewMember(name: writers.join(', '), jobLabel: 'Сценарий'),
  ];
}

List<String> _distinctNames(Iterable<CrewMember> members) {
  final names = <String>[];
  final seen = <String>{};
  for (final member in members) {
    if (seen.add(member.name)) {
      names.add(member.name);
    }
  }
  return names;
}

List<DetailsVideo> _displayVideos(List<Video> videos) {
  final ordered = <({Video video, int index})>[
    for (var index = 0; index < videos.length; index++)
      (video: videos[index], index: index),
  ]..sort(_compareVideos);
  return [
    for (final entry in ordered)
      DetailsVideo(
        key: entry.video.key,
        name: entry.video.name,
        typeLabel: _videoTypeLabel(entry.video.type),
      ),
  ];
}

int _compareVideos(
  ({Video video, int index}) a,
  ({Video video, int index}) b,
) {
  final byType = _videoRank(a.video.type).compareTo(_videoRank(b.video.type));
  if (byType != 0) {
    return byType;
  }
  if (a.video.official != b.video.official) {
    return a.video.official ? -1 : 1;
  }
  return a.index.compareTo(b.index);
}

int _videoRank(String type) {
  final index = _videoPriority.indexOf(type);
  if (index == -1) {
    return _videoPriority.length;
  }
  return index;
}

String _videoTypeLabel(String type) {
  return switch (type) {
    'Trailer' => 'Трейлер',
    'Teaser' => 'Тизер',
    'Clip' => 'Клип',
    _ => type,
  };
}

List<DetailsImage> _images(List<MediaImage> images) {
  return [for (final image in images) DetailsImage(url: image.url)];
}

DetailsRecommendation _movieRecommendation(Movie movie) {
  return DetailsRecommendation(
    id: movie.id,
    title: movie.title,
    posterUrl: movie.posterUrl,
    voteAverage: movie.voteAverage,
  );
}

DetailsRecommendation _tvRecommendation(TvShow show) {
  return DetailsRecommendation(
    id: show.id,
    title: show.title,
    posterUrl: show.posterUrl,
    voteAverage: show.voteAverage,
  );
}
