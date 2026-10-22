// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieAccountStatesDto _$MovieAccountStatesDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('MovieAccountStatesDto', json, ($checkedConvert) {
  final val = MovieAccountStatesDto(
    favorite: $checkedConvert('favorite', (v) => v as bool? ?? false),
  );
  return val;
});

Map<String, dynamic> _$FavoriteRequestDtoToJson(FavoriteRequestDto instance) =>
    <String, dynamic>{
      'media_type': instance.mediaType,
      'media_id': instance.mediaId,
      'favorite': instance.favorite,
    };
