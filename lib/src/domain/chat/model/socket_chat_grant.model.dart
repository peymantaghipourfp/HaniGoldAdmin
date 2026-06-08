import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'socket_chat_grant.model.g.dart';

SocketChatGrantModel socketChatGrantModelFromJson(String str) => SocketChatGrantModel.fromJson(json.decode(str));

String socketChatGrantModelToJson(SocketChatGrantModel data) => json.encode(data.toJson());
/// "channel": "chat.grant",
@JsonSerializable()
class SocketChatGrantModel {
  @JsonKey(name: "channel")
  final String? channel;
  @JsonKey(name: "reqId")
  final String? reqId;
  @JsonKey(name: "data")
  final Data? data;

  SocketChatGrantModel({
    required this.channel,
    required this.reqId,
    required this.data,
  });

  factory SocketChatGrantModel.fromJson(Map<String, dynamic> json) => _$SocketChatGrantModelFromJson(json);

  Map<String, dynamic> toJson() => _$SocketChatGrantModelToJson(this);
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