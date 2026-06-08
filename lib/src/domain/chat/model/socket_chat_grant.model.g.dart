// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'socket_chat_grant.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SocketChatGrantModel _$SocketChatGrantModelFromJson(
        Map<String, dynamic> json) =>
    SocketChatGrantModel(
      channel: json['channel'] as String?,
      reqId: json['reqId'] as String?,
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SocketChatGrantModelToJson(
        SocketChatGrantModel instance) =>
    <String, dynamic>{
      'channel': instance.channel,
      'reqId': instance.reqId,
      'data': instance.data,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      chatId: json['ChatId'] as String?,
      targetAdminAccountId: (json['TargetAdminAccountId'] as num?)?.toInt(),
      note: json['Note'] as String?,
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'ChatId': instance.chatId,
      'TargetAdminAccountId': instance.targetAdminAccountId,
      'Note': instance.note,
    };
