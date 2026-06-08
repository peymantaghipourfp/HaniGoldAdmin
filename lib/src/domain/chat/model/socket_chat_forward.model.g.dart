// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'socket_chat_forward.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SocketChatForwardModel _$SocketChatForwardModelFromJson(
        Map<String, dynamic> json) =>
    SocketChatForwardModel(
      channel: json['channel'] as String?,
      reqId: json['reqId'] as String?,
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SocketChatForwardModelToJson(
        SocketChatForwardModel instance) =>
    <String, dynamic>{
      'channel': instance.channel,
      'reqId': instance.reqId,
      'data': instance.data,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      chatId: json['ChatId'] as String?,
      toAdminAccountId: (json['ToAdminAccountId'] as num?)?.toInt(),
      forwardMessageSeq: (json['ForwardMessageSeq'] as num?)?.toInt(),
      note: json['Note'] as String?,
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'ChatId': instance.chatId,
      'ToAdminAccountId': instance.toAdminAccountId,
      'ForwardMessageSeq': instance.forwardMessageSeq,
      'Note': instance.note,
    };
