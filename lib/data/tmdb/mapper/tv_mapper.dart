import 'package:tmdb_flutter/data/tmdb/dto/details_dto.dart';
import 'package:tmdb_flutter/data/tmdb/dto/tv_show_details_dto.dart';
import 'package:tmdb_flutter/data/tmdb/dto/tv_show_dto.dart';
import 'package:tmdb_flutter/data/tmdb/mapper/details_mapper.dart';
import 'package:tmdb_flutter/data/tmdb/model/image_configuration.dart';
import 'package:tmdb_flutter/data/tmdb/model/paged.dart';
import 'package:tmdb_flutter/data/tmdb/model/tv_show.dart';
import 'package:tmdb_flutter/data/tmdb/model/tv_show_details.dart';

/// Maps [dto] to shows, building poster URLs from [images].
///
/// TMDB `name` becomes [TvShow.title].
Paged<TvShow> mapTvPage(PopularTvResponseDto dto, ImageConfiguration images) {
  return Paged<TvShow>(
    items: [for (final show in dto.results) _mapTvShow(show, images)],
    page: dto.page,
    totalPages: dto.totalPages,
    totalResults: dto.totalResults,
  );
}

/// Maps a TV card and builds image URLs from [images].
///
/// Episode runtime is the first positive `episode_run_time` value.
/// Videos whose site is not YouTube are dropped.
TvShowDetails mapTvDetails(TvShowDetailsDto dto, ImageConfiguration images) {
  final credits = dto.credits;
  final videos = dto.videos;
  final pictures = dto.images;
  return TvShowDetails(
    id: dto.id,
    title: dto.name,
    overview: dto.overview,
    posterUrl: images.posterUrlFor(dto.posterPath),
    voteAverage: dto.voteAverage,
    firstAirDate: dto.firstAirDate,
    episodeRuntimeMinutes: _episodeRuntime(dto.episodeRunTime),
    genres: [for (final genre in dto.genres) genre.name],
    tagline: _nonBlank(dto.tagline),
    backdropUrl: images.backdropUrlFor(dto.backdropPath),
    originalName: _nonBlank(dto.originalName),
    status: _nonBlank(dto.status),
    originalLanguage: _nonBlank(dto.originalLanguage),
    numberOfSeasons: _positive(dto.numberOfSeasons),
    numberOfEpisodes: _positive(dto.numberOfEpisodes),
    cast: mapCast(credits?.cast ?? const [], images),
    crew: mapCrew(credits?.crew ?? const []),
    createdBy: _creatorNames(dto.createdBy),
    videos: mapYoutubeVideos(videos?.results ?? const []),
    backdrops: mapMediaImages(
      pictures?.backdrops ?? const [],
      images,
      backdrop: true,
    ),
    posters: mapMediaImages(
      pictures?.posters ?? const [],
      images,
      backdrop: false,
    ),
    recommendations: [
      for (final show in dto.recommendations?.results ?? const <TvShowDto>[])
        _mapTvShow(show, images),
    ],
  );
}

TvShow _mapTvShow(TvShowDto dto, ImageConfiguration images) {
  return TvShow(
    id: dto.id,
    title: dto.name,
    overview: dto.overview,
    posterUrl: images.posterUrlFor(dto.posterPath),
    voteAverage: dto.voteAverage,
    firstAirDate: dto.firstAirDate,
  );
}

int? _episodeRuntime(List<int> runtimes) {
  if (runtimes.isEmpty) {
    return null;
  }
  final minutes = runtimes.first;
  if (minutes <= 0) {
    return null;
  }
  return minutes;
}

int? _positive(int? value) {
  if (value == null || value <= 0) {
    return null;
  }
  return value;
}

List<String> _creatorNames(List<CreatedByDto> createdBy) {
  final names = <String>[];
  final seen = <String>{};
  for (final creator in createdBy) {
    final name = creator.name;
    if (name.trim().isEmpty || !seen.add(name)) {
      continue;
    }
    names.add(name);
  }
  return names;
}

String? _nonBlank(String? value) {
  if (value == null || value.trim().isEmpty) {
    return null;
  }
  return value;
}
