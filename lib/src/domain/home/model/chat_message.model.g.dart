// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessageModel _$ChatMessageModelFromJson(Map<String, dynamic> json) =>
    ChatMessageModel(
      replyMessage: json['replyMessage'] == null
          ? null
          : ReplyMessageModel.fromJson(
              json['replyMessage'] as Map<String, dynamic>),
      fromUser: json['fromUser'] == null
          ? null
          : UserModel.fromJson(json['fromUser'] as Map<String, dynamic>),
      toUser: json['toUser'] == null
          ? null
          : UserModel.fromJson(json['toUser'] as Map<String, dynamic>),
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      topic: json['topic'] as String?,
      messageContent: json['messageContent'] as String?,
      type: (json['type'] as num?)?.toInt(),
      seen: json['seen'] as bool?,
      delivered: json['delivered'] as bool?,
      rowNum: (json['rowNum'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      replyId: (json['replyId'] as num?)?.toInt(),
      infos: json['infos'] as List<dynamic>?,
      recordType: json['recordType'] as String?,
    );

Map<String, dynamic> _$ChatMessageModelToJson(ChatMessageModel instance) =>
    <String, dynamic>{
      'replyMessage': instance.replyMessage,
      'fromUser': instance.fromUser,
      'toUser': instance.toUser,
      'date': instance.date?.toIso8601String(),
      'topic': instance.topic,
      'messageContent': instance.messageContent,
      'type': instance.type,
      'seen': instance.seen,
      'delivered': instance.delivered,
      'rowNum': instance.rowNum,
      'id': instance.id,
      'replyId': instance.replyId,
      'infos': instance.infos,
      'recordType': instance.recordType,
    };
