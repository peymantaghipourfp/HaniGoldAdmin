// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reply_message.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReplyMessageModel _$ReplyMessageModelFromJson(Map<String, dynamic> json) =>
    ReplyMessageModel(
      fromUser: json['fromUser'] == null
          ? null
          : UserModel.fromJson(json['fromUser'] as Map<String, dynamic>),
      toUser: json['toUser'] == null
          ? null
          : UserModel.fromJson(json['toUser'] as Map<String, dynamic>),
      infos: json['infos'] as List<dynamic>?,
      messageContent: json['messageContent'] as String?,
      id: (json['id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ReplyMessageModelToJson(ReplyMessageModel instance) =>
    <String, dynamic>{
      'fromUser': instance.fromUser,
      'toUser': instance.toUser,
      'infos': instance.infos,
      'messageContent': instance.messageContent,
      'id': instance.id,
    };
