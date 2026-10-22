// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestTokenResponseDto _$RequestTokenResponseDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('RequestTokenResponseDto', json, ($checkedConvert) {
  final val = RequestTokenResponseDto(
    requestToken: $checkedConvert('request_token', (v) => v as String?),
    success: $checkedConvert('success', (v) => v as bool? ?? false),
  );
  return val;
}, fieldKeyMap: const {'requestToken': 'request_token'});

Map<String, dynamic> _$ValidateWithLoginRequestDtoToJson(
  ValidateWithLoginRequestDto instance,
) => <String, dynamic>{
  'username': instance.username,
  'password': instance.password,
  'request_token': instance.requestToken,
};

Map<String, dynamic> _$SessionRequestDtoToJson(SessionRequestDto instance) =>
    <String, dynamic>{'request_token': instance.requestToken};

SessionResponseDto _$SessionResponseDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('SessionResponseDto', json, ($checkedConvert) {
      final val = SessionResponseDto(
        sessionId: $checkedConvert('session_id', (v) => v as String?),
        success: $checkedConvert('success', (v) => v as bool? ?? false),
      );
      return val;
    }, fieldKeyMap: const {'sessionId': 'session_id'});

AccountResponseDto _$AccountResponseDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AccountResponseDto', json, ($checkedConvert) {
      final val = AccountResponseDto(
        id: $checkedConvert('id', (v) => (v as num?)?.toInt() ?? 0),
        username: $checkedConvert('username', (v) => v as String?),
      );
      return val;
    });
