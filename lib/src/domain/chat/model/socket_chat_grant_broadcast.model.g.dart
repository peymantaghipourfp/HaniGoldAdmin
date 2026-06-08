// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'socket_chat_grant_broadcast.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SocketChatGrantBroadcastModel _$SocketChatGrantBroadcastModelFromJson(
        Map<String, dynamic> json) =>
    SocketChatGrantBroadcastModel(
      channel: json['channel'] as String?,
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SocketChatGrantBroadcastModelToJson(
        SocketChatGrantBroadcastModel instance) =>
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
      targetAdminAccountId: (json['targetAdminAccountId'] as num?)?.toInt(),
      targetAdminUserId: (json['targetAdminUserId'] as num?)?.toInt(),
      role: (json['role'] as num?)?.toInt(),
      on: json['on'] == null ? null : DateTime.parse(json['on'] as String),
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'chatId': instance.chatId,
      'customerAccountId': instance.customerAccountId,
      'topicId': instance.topicId,
      'topicCode': instance.topicCode,
      'topicKey': instance.topicKey,
      'targetAdminAccountId': instance.targetAdminAccountId,
      'targetAdminUserId': instance.targetAdminUserId,
      'role': instance.role,
      'on': instance.on?.toIso8601String(),
    };
