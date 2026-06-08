import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'socket_chat_revoke.model.g.dart';

SocketChatRevokeModel socketChatRevokeModelFromJson(String str) => SocketChatRevokeModel.fromJson(json.decode(str));

String socketChatRevokeModelToJson(SocketChatRevokeModel data) => json.encode(data.toJson());
/// "channel": "chat.revoke",
@JsonSerializable()
class SocketChatRevokeModel {
  @JsonKey(name: "channel")
  final String? channel;
  @JsonKey(name: "reqId")
  final String? reqId;
  @JsonKey(name: "data")
  final Data? data;

  SocketChatRevokeModel({
    required this.channel,
    required this.reqId,
    required this.data,
  });

  factory SocketChatRevokeModel.fromJson(Map<String, dynamic> json) => _$SocketChatRevokeModelFromJson(json);

  Map<String, dynamic> toJson() => _$SocketChatRevokeModelToJson(this);
}

@JsonSerializable()
class Data {
  @JsonKey(name: "ChatId")
  final String? chatId;
  @JsonKey(name: "TargetAdminAccountId")
  final int? targetAdminAccountId;
  @JsonKey(name: "Note")
  final String? note;

  Data({
    required this.chatId,
    required this.targetAdminAccountId,
    required this.note,
  });

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}