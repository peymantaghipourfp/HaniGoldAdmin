// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessageModel _$ChatMessageModelFromJson(Map<String, dynamic> json) =>
    ChatMessageModel(
      rowNum: (json['rowNum'] as num?)?.toInt(),
      chatId: json['chatId'] as String?,
      messageGuid: json['messageGuid'] as String?,
      seq: (json['seq'] as num?)?.toInt(),
      senderType: (json['senderType'] as num?)?.toInt(),
      senderAccountId: (json['senderAccountId'] as num?)?.toInt(),
      senderUserId: (json['senderUserId'] as num?)?.toInt(),
      messageType: (json['messageType'] as num?)?.toInt(),
      text: json['text'] as String?,
      createdOnUtc: json['createdOnUtc'] == null
          ? null
          : DateTime.parse(json['createdOnUtc'] as String),
      isDeleted: json['isDeleted'] as bool?,
      deliveredOnUtc: json['deliveredOnUtc'] == null
          ? null
          : DateTime.parse(json['deliveredOnUtc'] as String),
      senderAccountName: json['senderAccountName'] as String?,
      replyToSeq: (json['replyToSeq'] as num?)?.toInt(),
      forwardFromSeq: (json['forwardFromSeq'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ChatMessageModelToJson(ChatMessageModel instance) =>
    <String, dynamic>{
      'rowNum': instance.rowNum,
      'chatId': instance.chatId,
      'messageGuid': instance.messageGuid,
      'seq': instance.seq,
      'senderType': instance.senderType,
      'senderAccountId': instance.senderAccountId,
      'senderUserId': instance.senderUserId,
      'messageType': instance.messageType,
      'text': instance.text,
      'createdOnUtc': instance.createdOnUtc?.toIso8601String(),
      'isDeleted': instance.isDeleted,
      'deliveredOnUtc': instance.deliveredOnUtc?.toIso8601String(),
      'senderAccountName': instance.senderAccountName,
      'replyToSeq': instance.replyToSeq,
      'forwardFromSeq': instance.forwardFromSeq,
    };
