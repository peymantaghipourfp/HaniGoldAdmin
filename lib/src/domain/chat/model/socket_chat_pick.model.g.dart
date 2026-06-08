// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'socket_chat_pick.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SocketChatPickModel _$SocketChatPickModelFromJson(Map<String, dynamic> json) =>
    SocketChatPickModel(
      channel: json['channel'] as String?,
      reqId: json['reqId'] as String?,
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SocketChatPickModelToJson(
        SocketChatPickModel instance) =>
    <String, dynamic>{
      'channel': instance.channel,
      'reqId': instance.reqId,
      'data': instance.data,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      chatId: json['ChatId'] as String?,
      note: json['Note'] as String?,
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'ChatId': instance.chatId,
      'Note': instance.note,
    };
