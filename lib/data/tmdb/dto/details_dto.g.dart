// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'details_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CastMemberDto _$CastMemberDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('CastMemberDto', json, ($checkedConvert) {
      final val = CastMemberDto(
        id: $checkedConvert('id', (v) => (v as num).toInt()),
        name: $checkedConvert('name', (v) => v as String),
        character: $checkedConvert('character', (v) => v as String? ?? ''),
        order: $checkedConvert('order', (v) => (v as num?)?.toInt() ?? 0),
        profilePath: $checkedConvert('profile_path', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {'profilePath': 'profile_path'});

CrewMemberDto _$CrewMemberDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('CrewMemberDto', json, ($checkedConvert) {
      final val = CrewMemberDto(
        id: $checkedConvert('id', (v) => (v as num).toInt()),
        name: $checkedConvert('name', (v) => v as String),
        job: $checkedConvert('job', (v) => v as String? ?? ''),
      );
      return val;
    });

CreditsDto _$CreditsDtoFromJson(Map<String, dynamic> json) => $checkedCreate(
  'CreditsDto',
  json,
  ($checkedConvert) {
    final val = CreditsDto(
      cast: $checkedConvert(
        'cast',
        (v) =>
            (v as List<dynamic>?)
                ?.map((e) => CastMemberDto.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
      ),
      crew: $checkedConvert(
        'crew',
        (v) =>
            (v as List<dynamic>?)
                ?.map((e) => CrewMemberDto.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
      ),
    );
    return val;
  },
);

VideoDto _$VideoDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('VideoDto', json, ($checkedConvert) {
      final val = VideoDto(
        id: $checkedConvert('id', (v) => v as String),
        key: $checkedConvert('key', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
        site: $checkedConvert('site', (v) => v as String),
        type: $checkedConvert('type', (v) => v as String),
        official: $checkedConvert('official', (v) => v as bool? ?? false),
      );
      return val;
    });

VideosResponseDto _$VideosResponseDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('VideosResponseDto', json, ($checkedConvert) {
      final val = VideosResponseDto(
        results: $checkedConvert(
          'results',
          (v) =>
              (v as List<dynamic>?)
                  ?.map((e) => VideoDto.fromJson(e as Map<String, dynamic>))
                  .toList() ??
              const [],
        ),
      );
      return val;
    });

ImageDto _$ImageDtoFromJson(Map<String, dynamic> json) => $checkedCreate(
  'ImageDto',
  json,
  ($checkedConvert) {
    final val = ImageDto(
      filePath: $checkedConvert('file_path', (v) => v as String),
      aspectRatio: $checkedConvert(
        'aspect_ratio',
        (v) => (v as num?)?.toDouble() ?? 1,
      ),
      width: $checkedConvert('width', (v) => (v as num?)?.toInt() ?? 0),
    );
    return val;
  },
  fieldKeyMap: const {'filePath': 'file_path', 'aspectRatio': 'aspect_ratio'},
);

ImagesResponseDto _$ImagesResponseDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ImagesResponseDto', json, ($checkedConvert) {
      final val = ImagesResponseDto(
        backdrops: $checkedConvert(
          'backdrops',
          (v) =>
              (v as List<dynamic>?)
                  ?.map((e) => ImageDto.fromJson(e as Map<String, dynamic>))
                  .toList() ??
              const [],
        ),
        posters: $checkedConvert(
          'posters',
          (v) =>
              (v as List<dynamic>?)
                  ?.map((e) => ImageDto.fromJson(e as Map<String, dynamic>))
                  .toList() ??
              const [],
        ),
      );
      return val;
    });

CreatedByDto _$CreatedByDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('CreatedByDto', json, ($checkedConvert) {
      final val = CreatedByDto(
        id: $checkedConvert('id', (v) => (v as num).toInt()),
        name: $checkedConvert('name', (v) => v as String),
      );
      return val;
    });
