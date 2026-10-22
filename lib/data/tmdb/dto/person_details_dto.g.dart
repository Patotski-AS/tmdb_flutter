// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person_details_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersonDetailsDto _$PersonDetailsDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'PersonDetailsDto',
      json,
      ($checkedConvert) {
        final val = PersonDetailsDto(
          id: $checkedConvert('id', (v) => (v as num).toInt()),
          name: $checkedConvert('name', (v) => v as String),
          biography: $checkedConvert('biography', (v) => v as String? ?? ''),
          profilePath: $checkedConvert('profile_path', (v) => v as String?),
          knownForDepartment: $checkedConvert(
            'known_for_department',
            (v) => v as String?,
          ),
          birthday: $checkedConvert('birthday', (v) => v as String?),
          deathday: $checkedConvert('deathday', (v) => v as String?),
          placeOfBirth: $checkedConvert('place_of_birth', (v) => v as String?),
          alsoKnownAs: $checkedConvert(
            'also_known_as',
            (v) =>
                (v as List<dynamic>?)?.map((e) => e as String).toList() ??
                const [],
          ),
          combinedCredits: $checkedConvert(
            'combined_credits',
            (v) => v == null
                ? null
                : CombinedCreditsDto.fromJson(v as Map<String, dynamic>),
          ),
        );
        return val;
      },
      fieldKeyMap: const {
        'profilePath': 'profile_path',
        'knownForDepartment': 'known_for_department',
        'placeOfBirth': 'place_of_birth',
        'alsoKnownAs': 'also_known_as',
        'combinedCredits': 'combined_credits',
      },
    );

CombinedCreditsDto _$CombinedCreditsDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('CombinedCreditsDto', json, ($checkedConvert) {
  final val = CombinedCreditsDto(
    cast: $checkedConvert(
      'cast',
      (v) =>
          (v as List<dynamic>?)
              ?.map((e) => PersonCreditDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    ),
    crew: $checkedConvert(
      'crew',
      (v) =>
          (v as List<dynamic>?)
              ?.map((e) => PersonCreditDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    ),
  );
  return val;
});

PersonCreditDto _$PersonCreditDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'PersonCreditDto',
      json,
      ($checkedConvert) {
        final val = PersonCreditDto(
          id: $checkedConvert('id', (v) => (v as num).toInt()),
          mediaType: $checkedConvert(
            'media_type',
            (v) => v as String? ?? 'movie',
          ),
          title: $checkedConvert('title', (v) => v as String?),
          name: $checkedConvert('name', (v) => v as String?),
          posterPath: $checkedConvert('poster_path', (v) => v as String?),
          releaseDate: $checkedConvert('release_date', (v) => v as String?),
          firstAirDate: $checkedConvert('first_air_date', (v) => v as String?),
          voteAverage: $checkedConvert(
            'vote_average',
            (v) => (v as num?)?.toDouble() ?? 0,
          ),
          character: $checkedConvert('character', (v) => v as String?),
          job: $checkedConvert('job', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'mediaType': 'media_type',
        'posterPath': 'poster_path',
        'releaseDate': 'release_date',
        'firstAirDate': 'first_air_date',
        'voteAverage': 'vote_average',
      },
    );
