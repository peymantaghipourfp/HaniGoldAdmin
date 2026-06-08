// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'socket_chat_forward_broadcast.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SocketChatForwardBroadcastModel _$SocketChatForwardBroadcastModelFromJson(
        Map<String, dynamic> json) =>
    SocketChatForwardBroadcastModel(
      channel: json['channel'] as String?,
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SocketChatForwardBroadcastModelToJson(
        SocketChatForwardBroadcastModel instance) =>
    <String, dynamic>{
      'channel': instance.channel,
      'data': instance.data,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      chatId: json['chatId'] as String?,
      customerAccountId: (json['customerAccountId'] as num?)?.toInt(),
      topicId: (json['topicId'] as num?)?.toInt(),
      topicCode: json['topicCode'] as String?,
      topicKey: json['topicKey'] as String?,
      fromAdminAccountId: (json['fromAdminAccountId'] as num?)?.toInt(),
      toAdminAccountId: (json['toAdminAccountId'] as num?)?.toInt(),
      forwardMessageSeq: (json['forwardMessageSeq'] as num?)?.toInt(),
      on: json['on'] == null ? null : DateTime.parse(json['on'] as String),
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'chatId': instance.chatId,
      'customerAccountId': instance.customerAccountId,
      'topicId': instance.topicId,
      'topicCode': instance.topicCode,
      'topicKey': instance.topicKey,
      'fromAdminAccountId': instance.fromAdminAccountId,
      'toAdminAccountId': instance.toAdminAccountId,
      'forwardMessageSeq': instance.forwardMessageSeq,
      'on': instance.on?.toIso8601String(),
    };
