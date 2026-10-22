import 'package:tmdb_flutter/data/tmdb/dto/tv_show_dto.dart';
import 'package:tmdb_flutter/data/tmdb/model/image_configuration.dart';
import 'package:tmdb_flutter/data/tmdb/model/paged.dart';
import 'package:tmdb_flutter/data/tmdb/model/tv_show.dart';

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
