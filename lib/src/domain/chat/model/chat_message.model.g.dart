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
      replyToMessageGuid: json['replyToMessageGuid'] as String?,
      replyMessage: json['replyMessage'] == null
          ? null
          : ReplyMessage.fromJson(json['replyMessage'] as Map<String, dynamic>),
      forwardFromMessageGuid: json['forwardFromMessageGuid'] as String?,
      forwardFromSenderName: json['forwardFromSenderName'] as String?,
      forwardMessage: _forwardMessageFromJson(json['forwardMessage']),
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
      seenOnUtc: json['seenOnUtc'] == null
          ? null
          : DateTime.parse(json['seenOnUtc'] as String),
      seen: json['seen'] as bool?,
      senderAccountName: json['senderAccountName'] as String?,
      replyToSeq: (json['replyToSeq'] as num?)?.toInt(),
      forwardFromSeq: (json['forwardFromSeq'] as num?)?.toInt(),
      filesJson: _filesJsonFromJson(json['filesJson']),
    );

Map<String, dynamic> _$ChatMessageModelToJson(ChatMessageModel instance) =>
    <String, dynamic>{
      'rowNum': instance.rowNum,
      'chatId': instance.chatId,
      'messageGuid': instance.messageGuid,
      'replyToMessageGuid': instance.replyToMessageGuid,
      'replyMessage': instance.replyMessage,
      'forwardFromMessageGuid': instance.forwardFromMessageGuid,
      'forwardFromSenderName': instance.forwardFromSenderName,
      'forwardMessage': _forwardMessageToJson(instance.forwardMessage),
      'seq': instance.seq,
      'senderType': instance.senderType,
      'senderAccountId': instance.senderAccountId,
      'senderUserId': instance.senderUserId,
      'messageType': instance.messageType,
      'text': instance.text,
      'createdOnUtc': instance.createdOnUtc?.toIso8601String(),
      'isDeleted': instance.isDeleted,
      'deliveredOnUtc': instance.deliveredOnUtc?.toIso8601String(),
      'seenOnUtc': instance.seenOnUtc?.toIso8601String(),
      'seen': instance.seen,
      'senderAccountName': instance.senderAccountName,
      'replyToSeq': instance.replyToSeq,
      'forwardFromSeq': instance.forwardFromSeq,
      'filesJson': _filesJsonToJson(instance.filesJson),
    };

ReplyMessage _$ReplyMessageFromJson(Map<String, dynamic> json) => ReplyMessage(
      chatId: json['chatId'] as String?,
      messageGuid: json['messageGuid'] as String?,
      seq: (json['seq'] as num?)?.toInt(),
      senderType: (json['senderType'] as num?)?.toInt(),
      senderAccountId: (json['senderAccountId'] as num?)?.toInt(),
      senderUserId: (json['senderUserId'] as num?)?.toInt(),
      messageType: (json['messageType'] as num?)?.toInt(),
      text: json['text'] as String?,
      replyToMessageGuid: json['replyToMessageGuid'] as String?,
      filesJson: _filesJsonFromJson(json['filesJson']),
      createdOnUtc: json['createdOnUtc'] as String?,
      isDeleted: json['isDeleted'] as bool?,
      senderAccountName: json['senderAccountName'] as String?,
    );

Map<String, dynamic> _$ReplyMessageToJson(ReplyMessage instance) =>
    <String, dynamic>{
      'chatId': instance.chatId,
      'messageGuid': instance.messageGuid,
      'seq': instance.seq,
      'senderType': instance.senderType,
      'senderAccountId': instance.senderAccountId,
      'senderUserId': instance.senderUserId,
      'messageType': instance.messageType,
      'text': instance.text,
      'replyToMessageGuid': instance.replyToMessageGuid,
      'filesJson': _filesJsonToJson(instance.filesJson),
      'createdOnUtc': instance.createdOnUtc,
      'isDeleted': instance.isDeleted,
      'senderAccountName': instance.senderAccountName,
    };
