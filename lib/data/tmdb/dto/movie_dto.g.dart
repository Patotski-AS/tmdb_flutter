// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieDto _$MovieDtoFromJson(Map<String, dynamic> json) => $checkedCreate(
  'MovieDto',
  json,
  ($checkedConvert) {
    final val = MovieDto(
      id: $checkedConvert('id', (v) => (v as num).toInt()),
      title: $checkedConvert('title', (v) => v as String),
      overview: $checkedConvert('overview', (v) => v as String? ?? ''),
      posterPath: $checkedConvert('poster_path', (v) => v as String?),
      voteAverage: $checkedConvert(
        'vote_average',
        (v) => (v as num?)?.toDouble() ?? 0,
      ),
      releaseDate: $checkedConvert('release_date', (v) => v as String?),
    );
    return val;
  },
  fieldKeyMap: const {
    'posterPath': 'poster_path',
    'voteAverage': 'vote_average',
    'releaseDate': 'release_date',
  },
);

PopularMoviesResponseDto _$PopularMoviesResponseDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  'PopularMoviesResponseDto',
  json,
  ($checkedConvert) {
    final val = PopularMoviesResponseDto(
      page: $checkedConvert('page', (v) => (v as num).toInt()),
      totalPages: $checkedConvert('total_pages', (v) => (v as num).toInt()),
      totalResults: $checkedConvert('total_results', (v) => (v as num).toInt()),
      results: $checkedConvert(
        'results',
        (v) =>
            (v as List<dynamic>?)
                ?.map((e) => MovieDto.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
      ),
    );
    return val;
  },
  fieldKeyMap: const {
    'totalPages': 'total_pages',
    'totalResults': 'total_results',
  },
);
