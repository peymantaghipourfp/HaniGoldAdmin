// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatModel _$ChatModelFromJson(Map<String, dynamic> json) => ChatModel(
      rowNum: (json['rowNum'] as num?)?.toInt(),
      chatId: json['chatId'] as String?,
      accountId: (json['accountId'] as num?)?.toInt(),
      topicId: (json['topicId'] as num?)?.toInt(),
      topicCode: json['topicCode'] as String?,
      topicTitle: json['topicTitle'] as String?,
      status: (json['status'] as num?)?.toInt(),
      createdOn: json['createdOn'] == null
          ? null
          : DateTime.parse(json['createdOn'] as String),
      lastActivity: json['lastActivity'] == null
          ? null
          : DateTime.parse(json['lastActivity'] as String),
      accountName: json['accountName'] as String?,
      lastMessageSeq: (json['lastMessageSeq'] as num?)?.toInt(),
      lastMessagePreview: json['lastMessagePreview'] as String?,
      lastMessageOn: json['lastMessageOn'] == null
          ? null
          : DateTime.parse(json['lastMessageOn'] as String),
      totalMessageCount: (json['totalMessageCount'] as num?)?.toInt(),
      unreadMessageCount: (json['unreadMessageCount'] as num?)?.toInt(),
      topicKey: json['topicKey'] as String?,
      assignedAdminAccountId: (json['assignedAdminAccountId'] as num?)?.toInt(),
      assignedAdminUserId: (json['assignedAdminUserId'] as num?)?.toInt(),
      closedOn: json['closedOn'] == null
          ? null
          : DateTime.parse(json['closedOn'] as String),
      assignedAdminName: json['assignedAdminName'] as String?,
      userId: (json['userId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ChatModelToJson(ChatModel instance) => <String, dynamic>{
      'rowNum': instance.rowNum,
      'chatId': instance.chatId,
      'accountId': instance.accountId,
      'topicId': instance.topicId,
      'topicCode': instance.topicCode,
      'topicTitle': instance.topicTitle,
      'status': instance.status,
      'createdOn': instance.createdOn?.toIso8601String(),
      'lastActivity': instance.lastActivity?.toIso8601String(),
      'accountName': instance.accountName,
      'lastMessageSeq': instance.lastMessageSeq,
      'lastMessagePreview': instance.lastMessagePreview,
      'lastMessageOn': instance.lastMessageOn?.toIso8601String(),
      'totalMessageCount': instance.totalMessageCount,
      'unreadMessageCount': instance.unreadMessageCount,
      'topicKey': instance.topicKey,
      'assignedAdminAccountId': instance.assignedAdminAccountId,
      'assignedAdminUserId': instance.assignedAdminUserId,
      'closedOn': instance.closedOn?.toIso8601String(),
      'assignedAdminName': instance.assignedAdminName,
      'userId': instance.userId,
    };
