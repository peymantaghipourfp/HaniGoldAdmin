// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'socket_chat_waiting_total.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SocketChatWaitingTotalRequest _$SocketChatWaitingTotalRequestFromJson(
        Map<String, dynamic> json) =>
    SocketChatWaitingTotalRequest(
      channel: json['channel'] as String? ?? 'chat.admin.waiting.total',
      reqId: json['reqId'] as String,
    );

Map<String, dynamic> _$SocketChatWaitingTotalRequestToJson(
        SocketChatWaitingTotalRequest instance) =>
    <String, dynamic>{
      'channel': instance.channel,
      'reqId': instance.reqId,
    };

SocketChatWaitingTotalModel _$SocketChatWaitingTotalModelFromJson(
        Map<String, dynamic> json) =>
    SocketChatWaitingTotalModel(
      channel: json['channel'] as String?,
      reqId: json['reqId'] as String?,
      data: json['data'] == null
          ? null
          : WaitingTotalData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SocketChatWaitingTotalModelToJson(
        SocketChatWaitingTotalModel instance) =>
    <String, dynamic>{
      'channel': instance.channel,
      'reqId': instance.reqId,
      'data': instance.data,
    };

WaitingTotalData _$WaitingTotalDataFromJson(Map<String, dynamic> json) =>
    WaitingTotalData(
      waitingChatCount: (json['waitingChatCount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$WaitingTotalDataToJson(WaitingTotalData instance) =>
    <String, dynamic>{
      'waitingChatCount': instance.waitingChatCount,
    };
