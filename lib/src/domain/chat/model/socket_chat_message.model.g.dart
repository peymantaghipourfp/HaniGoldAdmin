// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'socket_chat_message.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SocketChatMessageModel _$SocketChatMessageModelFromJson(
        Map<String, dynamic> json) =>
    SocketChatMessageModel(
      channel: json['channel'] as String?,
      reqId: json['reqId'] as String?,
      data: json['data'] == null
          ? null
          : SocketChatMessageData.fromJson(
              json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SocketChatMessageModelToJson(
        SocketChatMessageModel instance) =>
    <String, dynamic>{
      'channel': instance.channel,
      'reqId': instance.reqId,
      'data': instance.data,
    };

SocketChatMessageData _$SocketChatMessageDataFromJson(
        Map<String, dynamic> json) =>
    SocketChatMessageData(
      isNewChat: json['isNewChat'] as bool?,
      chat: json['chat'] == null
          ? null
          : SocketChatMessageChat.fromJson(
              json['chat'] as Map<String, dynamic>),
      message: json['message'] == null
          ? null
          : SocketChatMessagePayload.fromJson(
              json['message'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SocketChatMessageDataToJson(
        SocketChatMessageData instance) =>
    <String, dynamic>{
      'isNewChat': instance.isNewChat,
      'chat': instance.chat,
      'message': instance.message,
    };

SocketChatMessageChat _$SocketChatMessageChatFromJson(
        Map<String, dynamic> json) =>
    SocketChatMessageChat(
      chatId: json['chatId'] as String?,
      accountId: (json['accountId'] as num?)?.toInt(),
      customerAccountId: (json['customerAccountId'] as num?)?.toInt(),
      accountName: json['accountName'] as String?,
      customerAccountName: json['customerAccountName'] as String?,
      topicId: (json['topicId'] as num?)?.toInt(),
      topicCode: json['topicCode'] as String?,
      topicTitle: json['topicTitle'] as String?,
      topicKey: json['topicKey'] as String?,
      status: (json['status'] as num?)?.toInt(),
      assignedAdminAccountId: (json['assignedAdminAccountId'] as num?)?.toInt(),
      assignedAdminUserId: (json['assignedAdminUserId'] as num?)?.toInt(),
      assignedAdminName: json['assignedAdminName'] as String?,
      createdOn: json['createdOn'] == null
          ? null
          : DateTime.parse(json['createdOn'] as String),
      lastActivity: json['lastActivity'] == null
          ? null
          : DateTime.parse(json['lastActivity'] as String),
      lastMessageSeq: (json['lastMessageSeq'] as num?)?.toInt(),
      lastSeenSeq: (json['lastSeenSeq'] as num?)?.toInt(),
      clientSeenSeq: (json['clientSeenSeq'] as num?)?.toInt(),
      lastMessagePreview: json['lastMessagePreview'] as String?,
      lastMessageOn: json['lastMessageOn'] == null
          ? null
          : DateTime.parse(json['lastMessageOn'] as String),
      totalMessageCount: (json['totalMessageCount'] as num?)?.toInt(),
      unreadMessageCount: (json['unreadMessageCount'] as num?)?.toInt(),
      messageSeq: (json['messageSeq'] as num?)?.toInt(),
      routingSeq: (json['routingSeq'] as num?)?.toInt(),
      adminRole: (json['adminRole'] as num?)?.toInt(),
      adminRoleTitle: json['adminRoleTitle'] as String?,
    );

Map<String, dynamic> _$SocketChatMessageChatToJson(
        SocketChatMessageChat instance) =>
    <String, dynamic>{
      'chatId': instance.chatId,
      'accountId': instance.accountId,
      'customerAccountId': instance.customerAccountId,
      'accountName': instance.accountName,
      'customerAccountName': instance.customerAccountName,
      'topicId': instance.topicId,
      'topicCode': instance.topicCode,
      'topicTitle': instance.topicTitle,
      'topicKey': instance.topicKey,
      'status': instance.status,
      'assignedAdminAccountId': instance.assignedAdminAccountId,
      'assignedAdminUserId': instance.assignedAdminUserId,
      'assignedAdminName': instance.assignedAdminName,
      'createdOn': instance.createdOn?.toIso8601String(),
      'lastActivity': instance.lastActivity?.toIso8601String(),
      'lastMessageSeq': instance.lastMessageSeq,
      'lastSeenSeq': instance.lastSeenSeq,
      'clientSeenSeq': instance.clientSeenSeq,
      'lastMessagePreview': instance.lastMessagePreview,
      'lastMessageOn': instance.lastMessageOn?.toIso8601String(),
      'totalMessageCount': instance.totalMessageCount,
      'unreadMessageCount': instance.unreadMessageCount,
      'messageSeq': instance.messageSeq,
      'routingSeq': instance.routingSeq,
      'adminRole': instance.adminRole,
      'adminRoleTitle': instance.adminRoleTitle,
    };

SocketChatMessagePayload _$SocketChatMessagePayloadFromJson(
        Map<String, dynamic> json) =>
    SocketChatMessagePayload(
      chatId: json['chatId'] as String?,
      messageGuid: json['messageGuid'] as String?,
      seq: (json['seq'] as num?)?.toInt(),
      senderType: (json['senderType'] as num?)?.toInt(),
      senderAccountId: (json['senderAccountId'] as num?)?.toInt(),
      senderUserId: (json['senderUserId'] as num?)?.toInt(),
      messageType: (json['messageType'] as num?)?.toInt(),
      text: json['text'] as String?,
      dataJson: json['dataJson'] as String?,
      referenceType: json['referenceType'] as String?,
      referenceId: json['referenceId'] as String?,
      replyToMessageGuid: json['replyToMessageGuid'] as String?,
      replyMessage: json['replyMessage'] == null
          ? null
          : ReplyMessage.fromJson(json['replyMessage'] as Map<String, dynamic>),
      forwardFromMessageGuid: json['forwardFromMessageGuid'] as String?,
      forwardFromSenderName: json['forwardFromSenderName'] as String?,
      forwardMessage: json['forwardMessage'] == null
          ? null
          : ReplyMessage.fromJson(
              json['forwardMessage'] as Map<String, dynamic>),
      forwardFromSeq: (json['forwardFromSeq'] as num?)?.toInt(),
      filesJson: json['filesJson'],
      createdOnUtc: json['createdOnUtc'] == null
          ? null
          : DateTime.parse(json['createdOnUtc'] as String),
      isDeleted: json['isDeleted'] as bool?,
      editedOnUtc: json['editedOnUtc'] == null
          ? null
          : DateTime.parse(json['editedOnUtc'] as String),
      deletedOnUtc: json['deletedOnUtc'] == null
          ? null
          : DateTime.parse(json['deletedOnUtc'] as String),
      deliveredOnUtc: json['deliveredOnUtc'] == null
          ? null
          : DateTime.parse(json['deliveredOnUtc'] as String),
      seenOnUtc: json['seenOnUtc'] == null
          ? null
          : DateTime.parse(json['seenOnUtc'] as String),
      senderAccountName: json['senderAccountName'] as String?,
      topicCode: json['topicCode'] as String?,
      topicKey: json['topicKey'] as String?,
      customerAccountId: (json['customerAccountId'] as num?)?.toInt(),
      targetAdminAccountId: (json['targetAdminAccountId'] as num?)?.toInt(),
      totalMessageCount: (json['totalMessageCount'] as num?)?.toInt(),
      unreadMessageCount: (json['unreadMessageCount'] as num?)?.toInt(),
      totalUnreadMessageCount:
          (json['totalUnreadMessageCount'] as num?)?.toInt(),
      waitingChatCount: (json['waitingChatCount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SocketChatMessagePayloadToJson(
        SocketChatMessagePayload instance) =>
    <String, dynamic>{
      'chatId': instance.chatId,
      'messageGuid': instance.messageGuid,
      'seq': instance.seq,
      'senderType': instance.senderType,
      'senderAccountId': instance.senderAccountId,
      'senderUserId': instance.senderUserId,
      'messageType': instance.messageType,
      'text': instance.text,
      'dataJson': instance.dataJson,
      'referenceType': instance.referenceType,
      'referenceId': instance.referenceId,
      'replyToMessageGuid': instance.replyToMessageGuid,
      'replyMessage': instance.replyMessage,
      'forwardFromMessageGuid': instance.forwardFromMessageGuid,
      'forwardFromSenderName': instance.forwardFromSenderName,
      'forwardMessage': instance.forwardMessage,
      'forwardFromSeq': instance.forwardFromSeq,
      'filesJson': instance.filesJson,
      'createdOnUtc': instance.createdOnUtc?.toIso8601String(),
      'isDeleted': instance.isDeleted,
      'editedOnUtc': instance.editedOnUtc?.toIso8601String(),
      'deletedOnUtc': instance.deletedOnUtc?.toIso8601String(),
      'deliveredOnUtc': instance.deliveredOnUtc?.toIso8601String(),
      'seenOnUtc': instance.seenOnUtc?.toIso8601String(),
      'senderAccountName': instance.senderAccountName,
      'topicCode': instance.topicCode,
      'topicKey': instance.topicKey,
      'customerAccountId': instance.customerAccountId,
      'targetAdminAccountId': instance.targetAdminAccountId,
      'totalMessageCount': instance.totalMessageCount,
      'unreadMessageCount': instance.unreadMessageCount,
      'totalUnreadMessageCount': instance.totalUnreadMessageCount,
      'waitingChatCount': instance.waitingChatCount,
    };
