// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersonDto _$PersonDtoFromJson(Map<String, dynamic> json) => $checkedCreate(
  'PersonDto',
  json,
  ($checkedConvert) {
    final val = PersonDto(
      id: $checkedConvert('id', (v) => (v as num).toInt()),
      name: $checkedConvert('name', (v) => v as String),
      profilePath: $checkedConvert('profile_path', (v) => v as String?),
      knownForDepartment: $checkedConvert(
        'known_for_department',
        (v) => v as String?,
      ),
    );
    return val;
  },
  fieldKeyMap: const {
    'profilePath': 'profile_path',
    'knownForDepartment': 'known_for_department',
  },
);

PopularPeopleResponseDto _$PopularPeopleResponseDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  'PopularPeopleResponseDto',
  json,
  ($checkedConvert) {
    final val = PopularPeopleResponseDto(
      page: $checkedConvert('page', (v) => (v as num).toInt()),
      totalPages: $checkedConvert('total_pages', (v) => (v as num).toInt()),
      totalResults: $checkedConvert('total_results', (v) => (v as num).toInt()),
      results: $checkedConvert(
        'results',
        (v) =>
            (v as List<dynamic>?)
                ?.map((e) => PersonDto.fromJson(e as Map<String, dynamic>))
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
