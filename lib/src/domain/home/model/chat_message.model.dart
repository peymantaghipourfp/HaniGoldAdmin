import 'package:hanigold_admin/src/domain/home/model/reply_message.model.dart';
import 'package:hanigold_admin/src/domain/home/model/user.model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'chat_message.model.g.dart';

List<ChatMessageModel> chatMessageModelFromJson(String str) => List<ChatMessageModel>.from(json.decode(str).map((x) => ChatMessageModel.fromJson(x)));

String chatMessageModelToJson(List<ChatMessageModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class ChatMessageModel {
  @JsonKey(name: "replyMessage")
  final ReplyMessageModel? replyMessage;
  @JsonKey(name: "fromUser")
  final UserModel? fromUser;
  @JsonKey(name: "toUser")
  final UserModel? toUser;
  @JsonKey(name: "date")
  final DateTime? date;
  @JsonKey(name: "topic")
  final String? topic;
  @JsonKey(name: "messageContent")
  final String? messageContent;
  @JsonKey(name: "type")
  final int? type;
  @JsonKey(name: "seen")
  final bool? seen;
  @JsonKey(name: "delivered")
  final bool? delivered;
  @JsonKey(name: "rowNum")
  final int? rowNum;
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "replyId")
  final int? replyId;
  @JsonKey(name: "infos")
  final List<dynamic>? infos;
  @JsonKey(name: "recordType")
  final String? recordType;

  ChatMessageModel({
    required this.replyMessage,
    required this.fromUser,
    required this.toUser,
    required this.date,
    required this.topic,
    required this.messageContent,
    required this.type,
    required this.seen,
    required this.delivered,
    required this.rowNum,
    required this.id,
    required this.replyId,
    required this.infos,
    required this.recordType,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) => _$ChatMessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMessageModelToJson(this);
}