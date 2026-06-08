// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'socket_chat_admin_send.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SocketChatAdminSendModel _$SocketChatAdminSendModelFromJson(
        Map<String, dynamic> json) =>
    SocketChatAdminSendModel(
      channel: json['channel'] as String?,
      reqId: json['reqId'] as String?,
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SocketChatAdminSendModelToJson(
        SocketChatAdminSendModel instance) =>
    <String, dynamic>{
      'channel': instance.channel,
      'reqId': instance.reqId,
      'data': instance.data,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      customerAccountId: (json['CustomerAccountId'] as num?)?.toInt(),
      topicCode: json['TopicCode'] as String?,
      topicKey: json['TopicKey'] as String?,
      text: json['Text'] as String?,
      dataJson: json['DataJson'] as String?,
      filesJson: json['FilesJson'] as String?,
      replyToMessageGuid: json['ReplyToMessageGuid'] as String?,
      forwardFromMessageGuid: json['ForwardFromMessageGuid'] as String?,
      forwardFromSenderName: json['ForwardFromSenderName'] as String?,
      referenceType: json['ReferenceType'] as String?,
      referenceId: (json['ReferenceId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'CustomerAccountId': instance.customerAccountId,
      'TopicCode': instance.topicCode,
      'TopicKey': instance.topicKey,
      'Text': instance.text,
      'DataJson': instance.dataJson,
      'FilesJson': instance.filesJson,
      'ReplyToMessageGuid': instance.replyToMessageGuid,
      'ForwardFromMessageGuid': instance.forwardFromMessageGuid,
      'ForwardFromSenderName': instance.forwardFromSenderName,
      'ReferenceType': instance.referenceType,
      'ReferenceId': instance.referenceId,
    };

FilesJson _$FilesJsonFromJson(Map<String, dynamic> json) => FilesJson(
      recordId: json['recordId'] as String?,
      fileType: json['fileType'] as String?,
    );

Map<String, dynamic> _$FilesJsonToJson(FilesJson instance) => <String, dynamic>{
      'recordId': instance.recordId,
      'fileType': instance.fileType,
    };
