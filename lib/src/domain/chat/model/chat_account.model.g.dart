// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_account.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatAccountModel _$ChatAccountModelFromJson(Map<String, dynamic> json) =>
    ChatAccountModel(
      rowNum: (json['rowNum'] as num?)?.toInt(),
      accountId: (json['accountId'] as num?)?.toInt(),
      accountName: json['accountName'] as String?,
      lastChatId: json['lastChatId'] as String?,
      lastMessageOn: json['lastMessageOn'] == null
          ? null
          : DateTime.parse(json['lastMessageOn'] as String),
      lastMessagePreview: json['lastMessagePreview'] as String?,
      totalMessageCount: (json['totalMessageCount'] as num?)?.toInt(),
      unreadMessageCount: (json['unreadMessageCount'] as num?)?.toInt(),
      unreadChatCount: (json['unreadChatCount'] as num?)?.toInt(),
      adminChatRole: (json['adminChatRole'] as num?)?.toInt(),
      chatStatus: (json['chatStatus'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ChatAccountModelToJson(ChatAccountModel instance) =>
    <String, dynamic>{
      'rowNum': instance.rowNum,
      'accountId': instance.accountId,
      'accountName': instance.accountName,
      'lastChatId': instance.lastChatId,
      'lastMessageOn': instance.lastMessageOn?.toIso8601String(),
      'lastMessagePreview': instance.lastMessagePreview,
      'totalMessageCount': instance.totalMessageCount,
      'unreadMessageCount': instance.unreadMessageCount,
      'unreadChatCount': instance.unreadChatCount,
      'adminChatRole': instance.adminChatRole,
      'chatStatus': instance.chatStatus,
    };
