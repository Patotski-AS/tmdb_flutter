// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tmdb_error_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TmdbErrorBody _$TmdbErrorBodyFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'TmdbErrorBody',
      json,
      ($checkedConvert) {
        final val = TmdbErrorBody(
          statusCode: $checkedConvert(
            'status_code',
            (v) => (v as num?)?.toInt(),
          ),
          statusMessage: $checkedConvert('status_message', (v) => v as String?),
          success: $checkedConvert('success', (v) => v as bool?),
        );
        return val;
      },
      fieldKeyMap: const {
        'statusCode': 'status_code',
        'statusMessage': 'status_message',
      },
    );
