// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SocialModel _$SocialModelFromJson(Map<String, dynamic> json) => SocialModel(
      accountId: (json['accountId'] as num?)?.toInt(),
      telegramStatus: json['telegramStatus'] as bool?,
      whatsappStatus: json['whatsappStatus'] as bool?,
      infos: json['infos'] as List<dynamic>?,
    );

Map<String, dynamic> _$SocialModelToJson(SocialModel instance) =>
    <String, dynamic>{
      'accountId': instance.accountId,
      'telegramStatus': instance.telegramStatus,
      'whatsappStatus': instance.whatsappStatus,
      'infos': instance.infos,
    };
