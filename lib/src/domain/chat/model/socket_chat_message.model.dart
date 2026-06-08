import 'package:hanigold_admin/src/domain/chat/model/chat.model.dart';
import 'package:hanigold_admin/src/domain/chat/model/chat_message.model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'socket_chat_message.model.g.dart';

void _copyJsonKey(Map<String, dynamic> json, String camel, String pascal) {
  if (json[camel] != null) return;
  final value = json[pascal];
  if (value != null) json[camel] = value;
}

/// WebSocket payloads may use PascalCase (.NET) property names.
Map<String, dynamic> normalizeSocketChatMessagePayloadJson(
    Map<String, dynamic> json,
    ) {
  final m = Map<String, dynamic>.from(json);
  _copyJsonKey(m, 'chatId', 'ChatId');
  _copyJsonKey(m, 'messageGuid', 'MessageGuid');
  _copyJsonKey(m, 'seq', 'Seq');
  _copyJsonKey(m, 'senderType', 'SenderType');
  _copyJsonKey(m, 'senderAccountId', 'SenderAccountId');
  _copyJsonKey(m, 'senderUserId', 'SenderUserId');
  _copyJsonKey(m, 'messageType', 'MessageType');
  _copyJsonKey(m, 'text', 'Text');
  _copyJsonKey(m, 'dataJson', 'DataJson');
  _copyJsonKey(m, 'referenceType', 'ReferenceType');
  _copyJsonKey(m, 'referenceId', 'ReferenceId');
  _copyJsonKey(m, 'replyToMessageGuid', 'ReplyToMessageGuid');
  _copyJsonKey(m, 'replyMessage', 'ReplyMessage');
  _copyJsonKey(m, 'forwardFromMessageGuid', 'ForwardFromMessageGuid');
  _copyJsonKey(m, 'forwardFromSenderName', 'ForwardFromSenderName');
  _copyJsonKey(m, 'forwardMessage', 'ForwardMessage');
  _copyJsonKey(m, 'forwardFromSeq', 'ForwardFromSeq');
  _copyJsonKey(m, 'filesJson', 'FilesJson');
  _copyJsonKey(m, 'createdOnUtc', 'CreatedOnUtc');
  _copyJsonKey(m, 'isDeleted', 'IsDeleted');
  _copyJsonKey(m, 'editedOnUtc', 'EditedOnUtc');
  _copyJsonKey(m, 'deletedOnUtc', 'DeletedOnUtc');
  _copyJsonKey(m, 'deliveredOnUtc', 'DeliveredOnUtc');
  _copyJsonKey(m, 'seenOnUtc', 'SeenOnUtc');
  _copyJsonKey(m, 'senderAccountName', 'SenderAccountName');
  _copyJsonKey(m, 'topicCode', 'TopicCode');
  _copyJsonKey(m, 'topicKey', 'TopicKey');
  _copyJsonKey(m, 'customerAccountId', 'CustomerAccountId');
  _copyJsonKey(m, 'targetAdminAccountId', 'TargetAdminAccountId');
  _copyJsonKey(m, 'totalMessageCount', 'TotalMessageCount');
  _copyJsonKey(m, 'unreadMessageCount', 'UnreadMessageCount');
  _copyJsonKey(m, 'totalUnreadMessageCount', 'TotalUnreadMessageCount');
  _copyJsonKey(m, 'waitingChatCount', 'WaitingChatCount');
  return m;
}

Map<String, dynamic> normalizeSocketChatMessageChatJson(
    Map<String, dynamic> json,
    ) {
  final m = Map<String, dynamic>.from(json);
  _copyJsonKey(m, 'chatId', 'ChatId');
  _copyJsonKey(m, 'accountId', 'AccountId');
  _copyJsonKey(m, 'customerAccountId', 'CustomerAccountId');
  _copyJsonKey(m, 'accountName', 'AccountName');
  _copyJsonKey(m, 'customerAccountName', 'CustomerAccountName');
  _copyJsonKey(m, 'topicId', 'TopicId');
  _copyJsonKey(m, 'topicCode', 'TopicCode');
  _copyJsonKey(m, 'topicTitle', 'TopicTitle');
  _copyJsonKey(m, 'topicKey', 'TopicKey');
  _copyJsonKey(m, 'status', 'Status');
  _copyJsonKey(m, 'assignedAdminAccountId', 'AssignedAdminAccountId');
  _copyJsonKey(m, 'assignedAdminUserId', 'AssignedAdminUserId');
  _copyJsonKey(m, 'assignedAdminName', 'AssignedAdminName');
  _copyJsonKey(m, 'createdOn', 'CreatedOn');
  _copyJsonKey(m, 'lastActivity', 'LastActivity');
  _copyJsonKey(m, 'lastMessageSeq', 'LastMessageSeq');
  _copyJsonKey(m, 'lastSeenSeq', 'lastSeenSeq');
  _copyJsonKey(m, 'clientSeenSeq', 'clientSeenSeq');
  _copyJsonKey(m, 'lastMessagePreview', 'LastMessagePreview');
  _copyJsonKey(m, 'lastMessageOn', 'LastMessageOn');
  _copyJsonKey(m, 'totalMessageCount', 'TotalMessageCount');
  _copyJsonKey(m, 'unreadMessageCount', 'UnreadMessageCount');
  _copyJsonKey(m, 'messageSeq', 'MessageSeq');
  _copyJsonKey(m, 'routingSeq', 'RoutingSeq');
  _copyJsonKey(m, 'adminRole', 'AdminRole');
  _copyJsonKey(m, 'adminRoleTitle', 'AdminRoleTitle');
  return m;
}

Map<String, dynamic> normalizeSocketChatMessageDataJson(
    Map<String, dynamic> json,
    ) {
  final m = Map<String, dynamic>.from(json);
  _copyJsonKey(m, 'isNewChat', 'IsNewChat');
  _copyJsonKey(m, 'chat', 'Chat');
  _copyJsonKey(m, 'message', 'Message');
  final chat = m['chat'];
  if (chat is Map) {
    m['chat'] = normalizeSocketChatMessageChatJson(
      Map<String, dynamic>.from(chat),
    );
  }
  final message = m['message'];
  if (message is Map) {
    m['message'] = normalizeSocketChatMessagePayloadJson(
      Map<String, dynamic>.from(message),
    );
  }
  return m;
}

Map<String, dynamic> normalizeSocketReplyMessageJson(
    Map<String, dynamic> json,
    ) {
  final m = Map<String, dynamic>.from(json);
  _copyJsonKey(m, 'chatId', 'ChatId');
  _copyJsonKey(m, 'messageGuid', 'MessageGuid');
  _copyJsonKey(m, 'seq', 'Seq');
  _copyJsonKey(m, 'senderType', 'SenderType');
  _copyJsonKey(m, 'senderAccountId', 'SenderAccountId');
  _copyJsonKey(m, 'senderUserId', 'SenderUserId');
  _copyJsonKey(m, 'messageType', 'MessageType');
  _copyJsonKey(m, 'text', 'Text');
  _copyJsonKey(m, 'replyToMessageGuid', 'ReplyToMessageGuid');
  _copyJsonKey(m, 'filesJson', 'FilesJson');
  _copyJsonKey(m, 'createdOnUtc', 'CreatedOnUtc');
  _copyJsonKey(m, 'isDeleted', 'IsDeleted');
  _copyJsonKey(m, 'senderAccountName', 'SenderAccountName');
  final files = m['filesJson'];
  if (files != null) {
    m['filesJson'] = normalizeChatMessageFilesJson(files);
  }
  final created = m['createdOnUtc'];
  if (created is DateTime) {
    m['createdOnUtc'] = created.toUtc().toIso8601String();
  }
  return m;
}

SocketChatMessageModel socketChatMessageModelFromJson(String str) =>
    SocketChatMessageModel.fromJson(json.decode(str));

String socketChatMessageModelToJson(SocketChatMessageModel data) =>
    json.encode(data.toJson());

/// Inbound WebSocket envelope: `"channel": "chat.message"`.
@JsonSerializable()
class SocketChatMessageModel {
  @JsonKey(name: 'channel')
  final String? channel;
  @JsonKey(name: 'reqId')
  final String? reqId;
  @JsonKey(name: 'data')
  final SocketChatMessageData? data;

  SocketChatMessageModel({
    required this.channel,
    required this.reqId,
    required this.data,
  });

  factory SocketChatMessageModel.fromJson(Map<String, dynamic> json) =>
      _$SocketChatMessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$SocketChatMessageModelToJson(this);
}

@JsonSerializable()
class SocketChatMessageData {
  @JsonKey(name: 'isNewChat')
  final bool? isNewChat;
  @JsonKey(name: 'chat')
  final SocketChatMessageChat? chat;
  @JsonKey(name: 'message')
  final SocketChatMessagePayload? message;

  SocketChatMessageData({
    required this.isNewChat,
    required this.chat,
    required this.message,
  });

  factory SocketChatMessageData.fromJson(Map<String, dynamic> json) =>
      _$SocketChatMessageDataFromJson(normalizeSocketChatMessageDataJson(json));

  Map<String, dynamic> toJson() => _$SocketChatMessageDataToJson(this);
}

/// Thread metadata included when [SocketChatMessageData.isNewChat] is true.
@JsonSerializable()
class SocketChatMessageChat {
  @JsonKey(name: 'chatId')
  final String? chatId;
  @JsonKey(name: 'accountId')
  final int? accountId;
  @JsonKey(name: 'customerAccountId')
  final int? customerAccountId;
  @JsonKey(name: 'accountName')
  final String? accountName;
  @JsonKey(name: 'customerAccountName')
  final String? customerAccountName;
  @JsonKey(name: 'topicId')
  final int? topicId;
  @JsonKey(name: 'topicCode')
  final String? topicCode;
  @JsonKey(name: 'topicTitle')
  final String? topicTitle;
  @JsonKey(name: 'topicKey')
  final String? topicKey;
  @JsonKey(name: 'status')
  final int? status;
  @JsonKey(name: 'assignedAdminAccountId')
  final int? assignedAdminAccountId;
  @JsonKey(name: 'assignedAdminUserId')
  final int? assignedAdminUserId;
  @JsonKey(name: 'assignedAdminName')
  final String? assignedAdminName;
  @JsonKey(name: 'createdOn')
  final DateTime? createdOn;
  @JsonKey(name: 'lastActivity')
  final DateTime? lastActivity;
  @JsonKey(name: 'lastMessageSeq')
  final int? lastMessageSeq;
  @JsonKey(name: "lastSeenSeq")
  final int? lastSeenSeq;
  @JsonKey(name: "clientSeenSeq")
  final int? clientSeenSeq;
  @JsonKey(name: 'lastMessagePreview')
  final String? lastMessagePreview;
  @JsonKey(name: 'lastMessageOn')
  final DateTime? lastMessageOn;
  @JsonKey(name: 'totalMessageCount')
  final int? totalMessageCount;
  @JsonKey(name: 'unreadMessageCount')
  final int? unreadMessageCount;
  @JsonKey(name: 'messageSeq')
  final int? messageSeq;
  @JsonKey(name: 'routingSeq')
  final int? routingSeq;
  @JsonKey(name: 'adminRole')
  final int? adminRole;
  @JsonKey(name: 'adminRoleTitle')
  final String? adminRoleTitle;

  SocketChatMessageChat({
    required this.chatId,
    required this.accountId,
    required this.customerAccountId,
    required this.accountName,
    required this.customerAccountName,
    required this.topicId,
    required this.topicCode,
    required this.topicTitle,
    required this.topicKey,
    required this.status,
    required this.assignedAdminAccountId,
    required this.assignedAdminUserId,
    required this.assignedAdminName,
    required this.createdOn,
    required this.lastActivity,
    required this.lastMessageSeq,
    required this.lastSeenSeq,
    required this.clientSeenSeq,
    required this.lastMessagePreview,
    required this.lastMessageOn,
    required this.totalMessageCount,
    required this.unreadMessageCount,
    required this.messageSeq,
    required this.routingSeq,
    required this.adminRole,
    required this.adminRoleTitle,
  });

  factory SocketChatMessageChat.fromJson(Map<String, dynamic> json) =>
      _$SocketChatMessageChatFromJson(normalizeSocketChatMessageChatJson(json));

  Map<String, dynamic> toJson() => _$SocketChatMessageChatToJson(this);

  ChatModel toChatModel() {
    final customerAccountId = this.customerAccountId ?? accountId;
    return ChatModel(
      rowNum: null,
      chatId: chatId,
      accountId: customerAccountId,
      topicId: topicId,
      topicCode: topicCode,
      topicTitle: topicTitle,
      status: status ?? 0,
      createdOn: createdOn,
      lastActivity: lastActivity,
      accountName: customerAccountName ?? accountName,
      lastMessageSeq: lastMessageSeq,
      lastSeenSeq: lastSeenSeq,
      clientSeenSeq: clientSeenSeq,
      lastMessagePreview: lastMessagePreview,
      lastMessageOn: lastMessageOn,
      totalMessageCount: totalMessageCount,
      unreadMessageCount: unreadMessageCount,
      topicKey: topicKey,
      assignedAdminAccountId: assignedAdminAccountId,
      assignedAdminUserId: assignedAdminUserId,
      closedOn: null,
      assignedAdminName: assignedAdminName,
      userId: null,
      adminRole: adminRole,
      adminRoleTitle: adminRoleTitle,
    );
  }
}

/// Message body nested under [SocketChatMessageData.message].
@JsonSerializable()
class SocketChatMessagePayload {
  @JsonKey(name: 'chatId')
  final String? chatId;
  @JsonKey(name: 'messageGuid')
  final String? messageGuid;
  @JsonKey(name: 'seq')
  final int? seq;
  @JsonKey(name: 'senderType')
  final int? senderType;
  @JsonKey(name: 'senderAccountId')
  final int? senderAccountId;
  @JsonKey(name: 'senderUserId')
  final int? senderUserId;
  @JsonKey(name: 'messageType')
  final int? messageType;
  @JsonKey(name: 'text')
  final String? text;
  @JsonKey(name: 'dataJson')
  final String? dataJson;
  @JsonKey(name: 'referenceType')
  final String? referenceType;
  @JsonKey(name: 'referenceId')
  final String? referenceId;
  @JsonKey(name: 'replyToMessageGuid')
  final String? replyToMessageGuid;
  @JsonKey(name: 'replyMessage')
  final ReplyMessage? replyMessage;
  @JsonKey(name: 'forwardFromMessageGuid')
  final String? forwardFromMessageGuid;
  @JsonKey(name: 'forwardFromSenderName')
  final String? forwardFromSenderName;
  @JsonKey(name: 'forwardMessage')
  final ReplyMessage? forwardMessage;
  @JsonKey(name: 'forwardFromSeq')
  final int? forwardFromSeq;
  @JsonKey(name: 'filesJson')
  final dynamic filesJson;
  @JsonKey(name: 'createdOnUtc')
  final DateTime? createdOnUtc;
  @JsonKey(name: 'isDeleted')
  final bool? isDeleted;
  @JsonKey(name: 'editedOnUtc')
  final DateTime? editedOnUtc;
  @JsonKey(name: 'deletedOnUtc')
  final DateTime? deletedOnUtc;
  @JsonKey(name: 'deliveredOnUtc')
  final DateTime? deliveredOnUtc;
  @JsonKey(name: 'seenOnUtc')
  final DateTime? seenOnUtc;
  @JsonKey(name: 'senderAccountName')
  final String? senderAccountName;
  @JsonKey(name: 'topicCode')
  final String? topicCode;
  @JsonKey(name: 'topicKey')
  final String? topicKey;
  @JsonKey(name: 'customerAccountId')
  final int? customerAccountId;
  @JsonKey(name: 'targetAdminAccountId')
  final int? targetAdminAccountId;
  @JsonKey(name: 'totalMessageCount')
  final int? totalMessageCount;
  @JsonKey(name: 'unreadMessageCount')
  final int? unreadMessageCount;
  @JsonKey(name: 'totalUnreadMessageCount')
  final int? totalUnreadMessageCount;
  @JsonKey(name: 'waitingChatCount')
  final int? waitingChatCount;

  SocketChatMessagePayload({
    required this.chatId,
    required this.messageGuid,
    required this.seq,
    required this.senderType,
    required this.senderAccountId,
    required this.senderUserId,
    required this.messageType,
    required this.text,
    required this.dataJson,
    required this.referenceType,
    required this.referenceId,
    required this.replyToMessageGuid,
    required this.replyMessage,
    required this.forwardFromMessageGuid,
    required this.forwardFromSenderName,
    required this.forwardMessage,
    required this.forwardFromSeq,
    required this.filesJson,
    required this.createdOnUtc,
    required this.isDeleted,
    required this.editedOnUtc,
    required this.deletedOnUtc,
    required this.deliveredOnUtc,
    required this.seenOnUtc,
    required this.senderAccountName,
    required this.topicCode,
    required this.topicKey,
    required this.customerAccountId,
    required this.targetAdminAccountId,
    required this.totalMessageCount,
    required this.unreadMessageCount,
    required this.totalUnreadMessageCount,
    required this.waitingChatCount,
  });

  factory SocketChatMessagePayload.fromJson(Map<String, dynamic> json) {
    final normalized = normalizeSocketChatMessagePayloadJson(json);
    final embedded = normalized['replyMessage'];
    if (embedded is Map) {
      normalized['replyMessage'] = normalizeSocketReplyMessageJson(
        Map<String, dynamic>.from(embedded),
      );
    }
    final forwardEmbedded = normalized['forwardMessage'];
    if (forwardEmbedded is Map) {
      normalized['forwardMessage'] = normalizeSocketReplyMessageJson(
        Map<String, dynamic>.from(forwardEmbedded),
      );
    }
    return _$SocketChatMessagePayloadFromJson(normalized);
  }

  Map<String, dynamic> toJson() => _$SocketChatMessagePayloadToJson(this);

  ChatMessageModel toChatMessageModel({String? chatIdOverride}) {
    return ChatMessageModel(
      rowNum: null,
      chatId: chatId ?? chatIdOverride,
      messageGuid: messageGuid,
      replyToMessageGuid: replyToMessageGuid,
      replyMessage: replyMessage,
      forwardFromMessageGuid: forwardFromMessageGuid,
      forwardFromSenderName: forwardFromSenderName,
      forwardMessage: forwardMessage,
      seq: seq,
      senderType: senderType,
      senderAccountId: senderAccountId,
      senderUserId: senderUserId,
      messageType: messageType,
      text: text,
      createdOnUtc: createdOnUtc,
      isDeleted: isDeleted ?? false,
      deliveredOnUtc: deliveredOnUtc,
      seenOnUtc: seenOnUtc,
      seen: seenOnUtc != null,
      senderAccountName: senderAccountName,
      replyToSeq: null,
      forwardFromSeq: forwardFromSeq,
      filesJson: normalizeChatMessageFilesJson(filesJson),
    );
  }
}
