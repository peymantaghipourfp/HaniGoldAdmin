import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'chat_account.model.g.dart';

List<ChatAccountModel> chatAccountModelFromJson(String str) => List<ChatAccountModel>.from(json.decode(str).map((x) => ChatAccountModel.fromJson(x)));

String chatAccountModelToJson(List<ChatAccountModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class ChatAccountModel {
  @JsonKey(name: "rowNum")
  final int? rowNum;
  @JsonKey(name: "accountId")
  final int? accountId;
  @JsonKey(name: "accountName")
  final String? accountName;
  @JsonKey(name: "lastChatId")
  final String? lastChatId;
  @JsonKey(name: "lastMessageOn")
  final DateTime? lastMessageOn;
  @JsonKey(name: "lastMessagePreview")
  final String? lastMessagePreview;
  @JsonKey(name: "totalMessageCount")
  final int? totalMessageCount;
  @JsonKey(name: "unreadMessageCount")
  final int? unreadMessageCount;
  @JsonKey(name: "unreadChatCount")
  final int? unreadChatCount;
  @JsonKey(name: "adminChatRole")
  final int? adminChatRole;
  @JsonKey(name: "chatStatus")
  final int? chatStatus;

  ChatAccountModel({
    required this.rowNum,
    required this.accountId,
    required this.accountName,
    required this.lastChatId,
    required this.lastMessageOn,
    required this.lastMessagePreview,
    required this.totalMessageCount,
    required this.unreadMessageCount,
    required this.unreadChatCount,
    required this.adminChatRole,
    required this.chatStatus,
  });

  factory ChatAccountModel.fromJson(Map<String, dynamic> json) => _$ChatAccountModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChatAccountModelToJson(this);
}