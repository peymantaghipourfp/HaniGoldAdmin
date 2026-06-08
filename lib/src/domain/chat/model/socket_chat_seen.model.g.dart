// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'socket_chat_seen.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SocketChatSeenModel _$SocketChatSeenModelFromJson(Map<String, dynamic> json) =>
    SocketChatSeenModel(
      channel: json['channel'] as String?,
      reqId: json['reqId'] as String?,
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SocketChatSeenModelToJson(
        SocketChatSeenModel instance) =>
    <String, dynamic>{
      'channel': instance.channel,
      'reqId': instance.reqId,
      'data': instance.data,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      chatId: json['ChatId'] as String?,
      upToSeq: (json['UpToSeq'] as num?)?.toInt(),
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'ChatId': instance.chatId,
      'UpToSeq': instance.upToSeq,
    };
