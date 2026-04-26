import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'chat.model.g.dart';

List<ChatModel> chatModelFromJson(String str) => List<ChatModel>.from(json.decode(str).map((x) => ChatModel.fromJson(x)));

String chatModelToJson(List<ChatModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class ChatModel {
  @JsonKey(name: "rowNum")
  final int? rowNum;
  @JsonKey(name: "chatId")
  final String? chatId;
  @JsonKey(name: "accountId")
  final int? accountId;
  @JsonKey(name: "topicId")
  final int? topicId;
  @JsonKey(name: "topicCode")
  final String? topicCode;
  @JsonKey(name: "topicTitle")
  final String? topicTitle;
  @JsonKey(name: "status")
  final int? status;
  @JsonKey(name: "createdOn")
  final DateTime? createdOn;
  @JsonKey(name: "lastActivity")
  final DateTime? lastActivity;
  @JsonKey(name: "accountName")
  final String? accountName;
  @JsonKey(name: "lastMessageSeq")
  final int? lastMessageSeq;
  @JsonKey(name: "lastMessagePreview")
  final String? lastMessagePreview;
  @JsonKey(name: "lastMessageOn")
  final DateTime? lastMessageOn;
  @JsonKey(name: "totalMessageCount")
  final int? totalMessageCount;
  @JsonKey(name: "unreadMessageCount")
  final int? unreadMessageCount;
  @JsonKey(name: "topicKey")
  final String? topicKey;
  @JsonKey(name: "assignedAdminAccountId")
  final int? assignedAdminAccountId;
  @JsonKey(name: "assignedAdminUserId")
  final int? assignedAdminUserId;
  @JsonKey(name: "closedOn")
  final DateTime? closedOn;
  @JsonKey(name: "assignedAdminName")
  final String? assignedAdminName;
  @JsonKey(name: "userId")
  final int? userId;

  ChatModel({
    required this.rowNum,
    required this.chatId,
    required this.accountId,
    required this.topicId,
    required this.topicCode,
    required this.topicTitle,
    required this.status,
    required this.createdOn,
    required this.lastActivity,
    required this.accountName,
    required this.lastMessageSeq,
    required this.lastMessagePreview,
    required this.lastMessageOn,
    required this.totalMessageCount,
    required this.unreadMessageCount,
    required this.topicKey,
    required this.assignedAdminAccountId,
    required this.assignedAdminUserId,
    required this.closedOn,
    required this.assignedAdminName,
    required this.userId,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) => _$ChatModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChatModelToJson(this);
}