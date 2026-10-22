// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tv_show_details_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TvShowDetailsDto _$TvShowDetailsDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  'TvShowDetailsDto',
  json,
  ($checkedConvert) {
    final val = TvShowDetailsDto(
      id: $checkedConvert('id', (v) => (v as num).toInt()),
      name: $checkedConvert('name', (v) => v as String),
      overview: $checkedConvert('overview', (v) => v as String? ?? ''),
      posterPath: $checkedConvert('poster_path', (v) => v as String?),
      backdropPath: $checkedConvert('backdrop_path', (v) => v as String?),
      tagline: $checkedConvert('tagline', (v) => v as String?),
      voteAverage: $checkedConvert(
        'vote_average',
        (v) => (v as num?)?.toDouble() ?? 0,
      ),
      firstAirDate: $checkedConvert('first_air_date', (v) => v as String?),
      episodeRunTime: $checkedConvert(
        'episode_run_time',
        (v) =>
            (v as List<dynamic>?)?.map((e) => (e as num).toInt()).toList() ??
            const [],
      ),
      genres: $checkedConvert(
        'genres',
        (v) =>
            (v as List<dynamic>?)
                ?.map((e) => GenreDto.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
      ),
      originalName: $checkedConvert('original_name', (v) => v as String?),
      status: $checkedConvert('status', (v) => v as String?),
      originalLanguage: $checkedConvert(
        'original_language',
        (v) => v as String?,
      ),
      numberOfSeasons: $checkedConvert(
        'number_of_seasons',
        (v) => (v as num?)?.toInt(),
      ),
      numberOfEpisodes: $checkedConvert(
        'number_of_episodes',
        (v) => (v as num?)?.toInt(),
      ),
      createdBy: $checkedConvert(
        'created_by',
        (v) =>
            (v as List<dynamic>?)
                ?.map((e) => CreatedByDto.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
      ),
      credits: $checkedConvert(
        'credits',
        (v) =>
            v == null ? null : CreditsDto.fromJson(v as Map<String, dynamic>),
      ),
      videos: $checkedConvert(
        'videos',
        (v) => v == null
            ? null
            : VideosResponseDto.fromJson(v as Map<String, dynamic>),
      ),
      images: $checkedConvert(
        'images',
        (v) => v == null
            ? null
            : ImagesResponseDto.fromJson(v as Map<String, dynamic>),
      ),
      recommendations: $checkedConvert(
        'recommendations',
        (v) => v == null
            ? null
            : TvRecommendationsDto.fromJson(v as Map<String, dynamic>),
      ),
    );
    return val;
  },
  fieldKeyMap: const {
    'posterPath': 'poster_path',
    'backdropPath': 'backdrop_path',
    'voteAverage': 'vote_average',
    'firstAirDate': 'first_air_date',
    'episodeRunTime': 'episode_run_time',
    'originalName': 'original_name',
    'originalLanguage': 'original_language',
    'numberOfSeasons': 'number_of_seasons',
    'numberOfEpisodes': 'number_of_episodes',
    'createdBy': 'created_by',
  },
);

TvRecommendationsDto _$TvRecommendationsDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('TvRecommendationsDto', json, ($checkedConvert) {
  final val = TvRecommendationsDto(
    results: $checkedConvert(
      'results',
      (v) =>
          (v as List<dynamic>?)
              ?.map((e) => TvShowDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    ),
  );
  return val;
});
