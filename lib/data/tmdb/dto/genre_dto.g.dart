// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'genre_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GenreDto _$GenreDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('GenreDto', json, ($checkedConvert) {
      final val = GenreDto(
        id: $checkedConvert('id', (v) => (v as num).toInt()),
        name: $checkedConvert('name', (v) => v as String),
      );
      return val;
    });

GenreListResponseDto _$GenreListResponseDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('GenreListResponseDto', json, ($checkedConvert) {
  final val = GenreListResponseDto(
    genres: $checkedConvert(
      'genres',
      (v) =>
          (v as List<dynamic>?)
              ?.map((e) => GenreDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    ),
  );
  return val;
});
