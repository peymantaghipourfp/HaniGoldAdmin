// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'socket_chat_seen_broadcast.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SocketChatSeenBroadcastModel _$SocketChatSeenBroadcastModelFromJson(
        Map<String, dynamic> json) =>
    SocketChatSeenBroadcastModel(
      channel: json['channel'] as String?,
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SocketChatSeenBroadcastModelToJson(
        SocketChatSeenBroadcastModel instance) =>
    <String, dynamic>{
      'channel': instance.channel,
      'data': instance.data,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      chatId: json['chatId'] as String?,
      customerAccountId: (json['customerAccountId'] as num?)?.toInt(),
      topicId: (json['topicId'] as num?)?.toInt(),
      topicKey: json['topicKey'] as String?,
      upToSeq: (json['upToSeq'] as num?)?.toInt(),
      changedCount: (json['changedCount'] as num?)?.toInt(),
      unreadMessageCount: (json['unreadMessageCount'] as num?)?.toInt(),
      totalUnreadMessageCount:
          (json['totalUnreadMessageCount'] as num?)?.toInt(),
      byAccountId: (json['byAccountId'] as num?)?.toInt(),
      byUserId: (json['byUserId'] as num?)?.toInt(),
      on: json['on'] == null ? null : DateTime.parse(json['on'] as String),
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'chatId': instance.chatId,
      'customerAccountId': instance.customerAccountId,
      'topicId': instance.topicId,
      'topicKey': instance.topicKey,
      'upToSeq': instance.upToSeq,
      'changedCount': instance.changedCount,
      'unreadMessageCount': instance.unreadMessageCount,
      'totalUnreadMessageCount': instance.totalUnreadMessageCount,
      'byAccountId': instance.byAccountId,
      'byUserId': instance.byUserId,
      'on': instance.on?.toIso8601String(),
    };
