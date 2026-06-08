// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'socket_chat_pick_broadcast.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SocketChatPickBroadcastModel _$SocketChatPickBroadcastModelFromJson(
        Map<String, dynamic> json) =>
    SocketChatPickBroadcastModel(
      channel: json['channel'] as String?,
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SocketChatPickBroadcastModelToJson(
        SocketChatPickBroadcastModel instance) =>
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
      assignedAdminAccountId: (json['assignedAdminAccountId'] as num?)?.toInt(),
      assignedAdminUserId: (json['assignedAdminUserId'] as num?)?.toInt(),
      on: json['on'] == null ? null : DateTime.parse(json['on'] as String),
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'chatId': instance.chatId,
      'customerAccountId': instance.customerAccountId,
      'topicId': instance.topicId,
      'topicCode': instance.topicCode,
      'topicKey': instance.topicKey,
      'assignedAdminAccountId': instance.assignedAdminAccountId,
      'assignedAdminUserId': instance.assignedAdminUserId,
      'on': instance.on?.toIso8601String(),
    };
