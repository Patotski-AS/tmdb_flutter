// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tv_show_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TvShowDto _$TvShowDtoFromJson(Map<String, dynamic> json) => $checkedCreate(
  'TvShowDto',
  json,
  ($checkedConvert) {
    final val = TvShowDto(
      id: $checkedConvert('id', (v) => (v as num).toInt()),
      name: $checkedConvert('name', (v) => v as String),
      overview: $checkedConvert('overview', (v) => v as String? ?? ''),
      posterPath: $checkedConvert('poster_path', (v) => v as String?),
      voteAverage: $checkedConvert(
        'vote_average',
        (v) => (v as num?)?.toDouble() ?? 0,
      ),
      firstAirDate: $checkedConvert('first_air_date', (v) => v as String?),
    );
    return val;
  },
  fieldKeyMap: const {
    'posterPath': 'poster_path',
    'voteAverage': 'vote_average',
    'firstAirDate': 'first_air_date',
  },
);

PopularTvResponseDto _$PopularTvResponseDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  'PopularTvResponseDto',
  json,
  ($checkedConvert) {
    final val = PopularTvResponseDto(
      page: $checkedConvert('page', (v) => (v as num).toInt()),
      totalPages: $checkedConvert('total_pages', (v) => (v as num).toInt()),
      totalResults: $checkedConvert('total_results', (v) => (v as num).toInt()),
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
  },
  fieldKeyMap: const {
    'totalPages': 'total_pages',
    'totalResults': 'total_results',
  },
);
