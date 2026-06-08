// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'socket_chat_ack_unread.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SocketChatAckUnreadModel _$SocketChatAckUnreadModelFromJson(
        Map<String, dynamic> json) =>
    SocketChatAckUnreadModel(
      channel: json['channel'] as String?,
      reqId: json['reqId'] as String?,
      data: (json['data'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SocketChatAckUnreadModelToJson(
        SocketChatAckUnreadModel instance) =>
    <String, dynamic>{
      'channel': instance.channel,
      'reqId': instance.reqId,
      'data': instance.data,
    };
