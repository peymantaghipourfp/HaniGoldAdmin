// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'socket_chat_unread_total.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SocketChatUnreadTotalRequest _$SocketChatUnreadTotalRequestFromJson(
        Map<String, dynamic> json) =>
    SocketChatUnreadTotalRequest(
      channel: json['channel'] as String? ?? 'chat.admin.unread.total',
      reqId: json['reqId'] as String,
    );

Map<String, dynamic> _$SocketChatUnreadTotalRequestToJson(
        SocketChatUnreadTotalRequest instance) =>
    <String, dynamic>{
      'channel': instance.channel,
      'reqId': instance.reqId,
    };

SocketChatUnreadTotalModel _$SocketChatUnreadTotalModelFromJson(
        Map<String, dynamic> json) =>
    SocketChatUnreadTotalModel(
      channel: json['channel'] as String?,
      reqId: json['reqId'] as String?,
      data: json['data'] == null
          ? null
          : UnreadTotalData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SocketChatUnreadTotalModelToJson(
        SocketChatUnreadTotalModel instance) =>
    <String, dynamic>{
      'channel': instance.channel,
      'reqId': instance.reqId,
      'data': instance.data,
    };

UnreadTotalData _$UnreadTotalDataFromJson(Map<String, dynamic> json) =>
    UnreadTotalData(
      totalUnreadMessageCount:
          (json['totalUnreadMessageCount'] as num?)?.toInt(),
      on: json['on'] == null ? null : DateTime.parse(json['on'] as String),
    );

Map<String, dynamic> _$UnreadTotalDataToJson(UnreadTotalData instance) =>
    <String, dynamic>{
      'totalUnreadMessageCount': instance.totalUnreadMessageCount,
      'on': instance.on?.toIso8601String(),
    };
