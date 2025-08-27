import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'chat_user.model.g.dart';

List<ChatUserModel> chatUserModelFromJson(String str) => List<ChatUserModel>.from(json.decode(str).map((x) => ChatUserModel.fromJson(x)));

String chatUserModelToJson(List<ChatUserModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class ChatUserModel {
  @JsonKey(name: "lastMessageDate")
  final DateTime? lastMessageDate;
  @JsonKey(name: "chatUserId")
  final int? chatUserId;
  @JsonKey(name: "chatUserName")
  final String? chatUserName;
  @JsonKey(name: "unseenCount")
  final int? unseenCount;

  ChatUserModel({
    required this.lastMessageDate,
    required this.chatUserId,
    required this.chatUserName,
    required this.unseenCount,
  });

  factory ChatUserModel.fromJson(Map<String, dynamic> json) => _$ChatUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChatUserModelToJson(this);
}