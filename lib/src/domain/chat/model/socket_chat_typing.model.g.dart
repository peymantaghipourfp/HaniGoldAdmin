// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'socket_chat_typing.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SocketChatTypingModel _$SocketChatTypingModelFromJson(
        Map<String, dynamic> json) =>
    SocketChatTypingModel(
      channel: json['channel'] as String?,
      reqId: json['reqId'] as String?,
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SocketChatTypingModelToJson(
        SocketChatTypingModel instance) =>
    <String, dynamic>{
      'channel': instance.channel,
      'reqId': instance.reqId,
      'data': instance.data,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      customerAccountId: (json['CustomerAccountId'] as num?)?.toInt(),
      topicCode: json['TopicCode'] as String?,
      topicKey: json['TopicKey'] as String?,
      isTyping: json['IsTyping'] as bool?,
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'CustomerAccountId': instance.customerAccountId,
      'TopicCode': instance.topicCode,
      'TopicKey': instance.topicKey,
      'IsTyping': instance.isTyping,
    };
