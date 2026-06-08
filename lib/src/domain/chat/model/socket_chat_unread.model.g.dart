// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'socket_chat_unread.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SocketChatUnreadModel _$SocketChatUnreadModelFromJson(
        Map<String, dynamic> json) =>
    SocketChatUnreadModel(
      channel: json['channel'] as String?,
      reqId: json['reqId'] as String?,
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SocketChatUnreadModelToJson(
        SocketChatUnreadModel instance) =>
    <String, dynamic>{
      'channel': instance.channel,
      'reqId': instance.reqId,
      'data': instance.data,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      customerAccountId: (json['CustomerAccountId'] as num?)?.toInt(),
      topicCode: json['TopicCode'] as String?,
      topicKey: json['TopicKey'] as String?,
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'CustomerAccountId': instance.customerAccountId,
      'TopicCode': instance.topicCode,
      'TopicKey': instance.topicKey,
    };
