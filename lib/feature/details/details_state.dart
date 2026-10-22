import 'package:flutter/foundation.dart';

/// Movie or TV card.
enum DetailsMediaType {
  /// A movie card.
  movie,

  /// A TV card.
  tv,
}

/// An actor shown on the card.
@immutable
final class DetailsCastMember {
  /// Creates a cast row.
  const new({
    required this.id,
    required this.name,
    required this.character,
    required this.profileUrl,
  });

  /// TMDB person id.
  final int id;

  /// Person name.
  final String name;

  /// Character name. Empty when TMDB omits it.
  final String character;

  /// Absolute profile URL, or null.
  final String? profileUrl;

  @override
  bool operator ==(Object other) {
    return other is DetailsCastMember &&
        id == other.id &&
        name == other.name &&
        character == other.character &&
        profileUrl == other.profileUrl;
  }

  @override
  int get hashCode => Object.hash(id, name, character, profileUrl);
}

/// One crew line, such as director or creator.
@immutable
final class DetailsCrewMember {
  /// Creates a crew line.
  const new({required this.name, required this.jobLabel});

  /// Names joined for this job.
  final String name;

  /// Russian job caption, for example `Режиссёр`.
  final String jobLabel;

  @override
  bool operator ==(Object other) {
    return other is DetailsCrewMember &&
        name == other.name &&
        jobLabel == other.jobLabel;
  }

  @override
  int get hashCode => Object.hash(name, jobLabel);
}

/// A YouTube video prepared for the card.
@immutable
final class DetailsVideo {
  /// Creates a video row.
  const new({required this.key, required this.name, required this.typeLabel});

  /// YouTube video id.
  final String key;

  /// Video title.
  final String name;

  /// Russian type caption, or the original type.
  final String typeLabel;

  @override
  bool operator ==(Object other) {
    return other is DetailsVideo &&
        key == other.key &&
        name == other.name &&
        typeLabel == other.typeLabel;
  }

  @override
  int get hashCode => Object.hash(key, name, typeLabel);
}

/// A still or poster URL.
@immutable
final class DetailsImage {
  /// Creates an image.
  const new({required this.url});

  /// Absolute image URL.
  final String url;

  @override
  bool operator ==(Object other) {
    return other is DetailsImage && url == other.url;
  }

  @override
  int get hashCode => url.hashCode;
}

/// A recommendation of the same media type as the open card.
@immutable
final class DetailsRecommendation {
  /// Creates a recommendation.
  const new({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.voteAverage,
  });

  /// TMDB id of the recommended title.
  final int id;

  /// Localized title.
  final String title;

  /// Absolute poster URL, or null.
  final String? posterUrl;

  /// Average vote from 0 to 10.
  final double voteAverage;

  @override
  bool operator ==(Object other) {
    return other is DetailsRecommendation &&
        id == other.id &&
        title == other.title &&
        posterUrl == other.posterUrl &&
        voteAverage == other.voteAverage;
  }

  @override
  int get hashCode => Object.hash(id, title, posterUrl, voteAverage);
}

/// Which image strip the gallery is showing.
enum DetailsGallerySection {
  /// Backdrop stills.
  backdrops,

  /// Posters.
  posters,
}

/// Local image gallery over the card.
@immutable
final class DetailsImageGallery {
  /// Creates a gallery position.
  const new({required this.section, required this.index});

  /// Strip that was opened.
  final DetailsGallerySection section;

  /// Index inside that strip.
  final int index;

  @override
  bool operator ==(Object other) {
    return other is DetailsImageGallery &&
        section == other.section &&
        index == other.index;
  }

  @override
  int get hashCode => Object.hash(section, index);
}

const _unchanged = Object();

/// Immutable card screen state, shaped like the KMP `DetailsModel`.
@immutable
final class DetailsState {
  /// Creates card state.
  const new({
    required this.mediaType,
    this.title,
    this.overview,
    this.posterUrl,
    this.backdropUrl,
    this.tagline,
    this.voteAverage,
    this.releaseDate,
    this.runtime,
    this.genres = const [],
    this.originalTitle,
    this.status,
    this.originalLanguage,
    this.budget,
    this.revenue,
    this.numberOfSeasons,
    this.numberOfEpisodes,
    this.cast = const [],
    this.showFullCast = false,
    this.crew = const [],
    this.videos = const [],
    this.backdrops = const [],
    this.posters = const [],
    this.recommendations = const [],
    this.imageGallery,
    this.isLoading = false,
    this.error,
    this.isFavorite,
    this.isFavoriteLoading = false,
    this.favoriteMessage,
  });

  /// Movie or TV. Recommendations stay on this type.
  final DetailsMediaType mediaType;

  /// Localized title, or null before the first success.
  final String? title;

  /// Description, or null before the card loads.
  final String? overview;

  /// Absolute poster URL, or null.
  final String? posterUrl;

  /// Absolute backdrop URL, or null.
  final String? backdropUrl;

  /// Tagline, or null.
  final String? tagline;

  /// Average vote from 0 to 10, or null before the card loads.
  final double? voteAverage;

  /// Release or first-air date, or null.
  final String? releaseDate;

  /// Runtime in minutes, or null.
  final int? runtime;

  /// Localized genre names.
  final List<String> genres;

  /// Original title, or null.
  final String? originalTitle;

  /// Localized status, or null.
  final String? status;

  /// Original language code, or null.
  final String? originalLanguage;

  /// Budget in dollars. Null for TV and when the figure is zero.
  final int? budget;

  /// Revenue in dollars. Null for TV and when the figure is zero.
  final int? revenue;

  /// Season count. Null for movies and when the figure is zero.
  final int? numberOfSeasons;

  /// Episode count. Null for movies and when the figure is zero.
  final int? numberOfEpisodes;

  /// Full cast. The screen shows the first 15 until [showFullCast].
  final List<DetailsCastMember> cast;

  /// Whether the cast list is expanded on this screen.
  final bool showFullCast;

  /// Key crew lines, creators first for a TV show.
  final List<DetailsCrewMember> crew;

  /// YouTube videos in display order.
  final List<DetailsVideo> videos;

  /// Backdrop stills.
  final List<DetailsImage> backdrops;

  /// Poster images.
  final List<DetailsImage> posters;

  /// Recommendations of [mediaType].
  final List<DetailsRecommendation> recommendations;

  /// Open gallery, or null when the card is showing.
  final DetailsImageGallery? imageGallery;

  /// Whether a details request is in flight.
  final bool isLoading;

  /// Last failure text, or null.
  final String? error;

  /// Whether this movie is on the account favorite list.
  ///
  /// Null until a signed-in read finishes, and for a TV card or a guest.
  final bool? isFavorite;

  /// Whether a favorite write is in flight.
  final bool isFavoriteLoading;

  /// Last favorite-write failure, or null.
  final String? favoriteMessage;

  /// Returns a copy with the given fields replaced.
  ///
  /// Pass [error], [imageGallery], [isFavorite] or [favoriteMessage]
  /// to replace them, including with null. Omit one to keep it.
  DetailsState copyWith({
    bool? showFullCast,
    Object? imageGallery = _unchanged,
    bool? isLoading,
    Object? error = _unchanged,
    Object? isFavorite = _unchanged,
    bool? isFavoriteLoading,
    Object? favoriteMessage = _unchanged,
  }) {
    return DetailsState(
      mediaType: mediaType,
      title: title,
      overview: overview,
      posterUrl: posterUrl,
      backdropUrl: backdropUrl,
      tagline: tagline,
      voteAverage: voteAverage,
      releaseDate: releaseDate,
      runtime: runtime,
      genres: genres,
      originalTitle: originalTitle,
      status: status,
      originalLanguage: originalLanguage,
      budget: budget,
      revenue: revenue,
      numberOfSeasons: numberOfSeasons,
      numberOfEpisodes: numberOfEpisodes,
      cast: cast,
      showFullCast: showFullCast ?? this.showFullCast,
      crew: crew,
      videos: videos,
      backdrops: backdrops,
      posters: posters,
      recommendations: recommendations,
      imageGallery: identical(imageGallery, _unchanged)
          ? this.imageGallery
          : imageGallery as DetailsImageGallery?,
      isLoading: isLoading ?? this.isLoading,
      error: identical(error, _unchanged) ? this.error : error as String?,
      isFavorite: identical(isFavorite, _unchanged)
          ? this.isFavorite
          : isFavorite as bool?,
      isFavoriteLoading: isFavoriteLoading ?? this.isFavoriteLoading,
      favoriteMessage: identical(favoriteMessage, _unchanged)
          ? this.favoriteMessage
          : favoriteMessage as String?,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is DetailsState &&
        mediaType == other.mediaType &&
        title == other.title &&
        overview == other.overview &&
        posterUrl == other.posterUrl &&
        backdropUrl == other.backdropUrl &&
        tagline == other.tagline &&
        voteAverage == other.voteAverage &&
        releaseDate == other.releaseDate &&
        runtime == other.runtime &&
        listEquals(genres, other.genres) &&
        originalTitle == other.originalTitle &&
        status == other.status &&
        originalLanguage == other.originalLanguage &&
        budget == other.budget &&
        revenue == other.revenue &&
        numberOfSeasons == other.numberOfSeasons &&
        numberOfEpisodes == other.numberOfEpisodes &&
        listEquals(cast, other.cast) &&
        showFullCast == other.showFullCast &&
        listEquals(crew, other.crew) &&
        listEquals(videos, other.videos) &&
        listEquals(backdrops, other.backdrops) &&
        listEquals(posters, other.posters) &&
        listEquals(recommendations, other.recommendations) &&
        imageGallery == other.imageGallery &&
        isLoading == other.isLoading &&
        error == other.error &&
        isFavorite == other.isFavorite &&
        isFavoriteLoading == other.isFavoriteLoading &&
        favoriteMessage == other.favoriteMessage;
  }

  @override
  int get hashCode => Object.hash(
    Object.hash(
      mediaType,
      title,
      overview,
      posterUrl,
      backdropUrl,
      tagline,
      voteAverage,
      releaseDate,
      runtime,
      Object.hashAll(genres),
    ),
    Object.hash(
      originalTitle,
      status,
      originalLanguage,
      budget,
      revenue,
      numberOfSeasons,
      numberOfEpisodes,
      Object.hashAll(cast),
      showFullCast,
      Object.hashAll(crew),
    ),
    Object.hash(
      Object.hashAll(videos),
      Object.hashAll(backdrops),
      Object.hashAll(posters),
      Object.hashAll(recommendations),
      imageGallery,
      isLoading,
      error,
      isFavorite,
      isFavoriteLoading,
      favoriteMessage,
    ),
  );
}
