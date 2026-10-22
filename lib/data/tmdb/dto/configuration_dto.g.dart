// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'configuration_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImagesDto _$ImagesDtoFromJson(Map<String, dynamic> json) => $checkedCreate(
  'ImagesDto',
  json,
  ($checkedConvert) {
    final val = ImagesDto(
      secureBaseUrl: $checkedConvert('secure_base_url', (v) => v as String),
      posterSizes: $checkedConvert(
        'poster_sizes',
        (v) =>
            (v as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      ),
      backdropSizes: $checkedConvert(
        'backdrop_sizes',
        (v) =>
            (v as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      ),
      profileSizes: $checkedConvert(
        'profile_sizes',
        (v) =>
            (v as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      ),
    );
    return val;
  },
  fieldKeyMap: const {
    'secureBaseUrl': 'secure_base_url',
    'posterSizes': 'poster_sizes',
    'backdropSizes': 'backdrop_sizes',
    'profileSizes': 'profile_sizes',
  },
);

ConfigurationResponseDto _$ConfigurationResponseDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('ConfigurationResponseDto', json, ($checkedConvert) {
  final val = ConfigurationResponseDto(
    images: $checkedConvert(
      'images',
      (v) => ImagesDto.fromJson(v as Map<String, dynamic>),
    ),
  );
  return val;
});
