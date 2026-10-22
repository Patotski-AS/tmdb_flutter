// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_details_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieDetailsDto _$MovieDetailsDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'MovieDetailsDto',
      json,
      ($checkedConvert) {
        final val = MovieDetailsDto(
          id: $checkedConvert('id', (v) => (v as num).toInt()),
          title: $checkedConvert('title', (v) => v as String),
          overview: $checkedConvert('overview', (v) => v as String? ?? ''),
          posterPath: $checkedConvert('poster_path', (v) => v as String?),
          backdropPath: $checkedConvert('backdrop_path', (v) => v as String?),
          tagline: $checkedConvert('tagline', (v) => v as String?),
          voteAverage: $checkedConvert(
            'vote_average',
            (v) => (v as num?)?.toDouble() ?? 0,
          ),
          releaseDate: $checkedConvert('release_date', (v) => v as String?),
          runtime: $checkedConvert('runtime', (v) => (v as num?)?.toInt()),
          genres: $checkedConvert(
            'genres',
            (v) =>
                (v as List<dynamic>?)
                    ?.map((e) => GenreDto.fromJson(e as Map<String, dynamic>))
                    .toList() ??
                const [],
          ),
          originalTitle: $checkedConvert('original_title', (v) => v as String?),
          status: $checkedConvert('status', (v) => v as String?),
          originalLanguage: $checkedConvert(
            'original_language',
            (v) => v as String?,
          ),
          budget: $checkedConvert('budget', (v) => (v as num?)?.toInt() ?? 0),
          revenue: $checkedConvert('revenue', (v) => (v as num?)?.toInt() ?? 0),
          credits: $checkedConvert(
            'credits',
            (v) => v == null
                ? null
                : CreditsDto.fromJson(v as Map<String, dynamic>),
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
                : MovieRecommendationsDto.fromJson(v as Map<String, dynamic>),
          ),
        );
        return val;
      },
      fieldKeyMap: const {
        'posterPath': 'poster_path',
        'backdropPath': 'backdrop_path',
        'voteAverage': 'vote_average',
        'releaseDate': 'release_date',
        'originalTitle': 'original_title',
        'originalLanguage': 'original_language',
      },
    );

MovieRecommendationsDto _$MovieRecommendationsDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('MovieRecommendationsDto', json, ($checkedConvert) {
  final val = MovieRecommendationsDto(
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
});
