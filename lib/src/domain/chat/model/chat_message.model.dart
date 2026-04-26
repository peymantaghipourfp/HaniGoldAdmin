import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'chat_message.model.g.dart';

List<ChatMessageModel> chatMessageModelFromJson(String str) => List<ChatMessageModel>.from(json.decode(str).map((x) => ChatMessageModel.fromJson(x)));

String chatMessageModelToJson(List<ChatMessageModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class ChatMessageModel {
  @JsonKey(name: "rowNum")
  final int? rowNum;
  @JsonKey(name: "chatId")
  final String? chatId;
  @JsonKey(name: "messageGuid")
  final String? messageGuid;
  @JsonKey(name: "seq")
  final int? seq;
  @JsonKey(name: "senderType")
  final int? senderType;
  @JsonKey(name: "senderAccountId")
  final int? senderAccountId;
  @JsonKey(name: "senderUserId")
  final int? senderUserId;
  @JsonKey(name: "messageType")
  final int? messageType;
  @JsonKey(name: "text")
  final String? text;
  @JsonKey(name: "createdOnUtc")
  final DateTime? createdOnUtc;
  @JsonKey(name: "isDeleted")
  final bool? isDeleted;
  @JsonKey(name: "deliveredOnUtc")
  final DateTime? deliveredOnUtc;
  @JsonKey(name: "senderAccountName")
  final String? senderAccountName;
  @JsonKey(name: "replyToSeq")
  final int? replyToSeq;
  @JsonKey(name: "forwardFromSeq")
  final int? forwardFromSeq;

  ChatMessageModel({
    required this.rowNum,
    required this.chatId,
    required this.messageGuid,
    required this.seq,
    required this.senderType,
    required this.senderAccountId,
    required this.senderUserId,
    required this.messageType,
    required this.text,
    required this.createdOnUtc,
    required this.isDeleted,
    required this.deliveredOnUtc,
    required this.senderAccountName,
    required this.replyToSeq,
    required this.forwardFromSeq,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) => _$ChatMessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMessageModelToJson(this);
}