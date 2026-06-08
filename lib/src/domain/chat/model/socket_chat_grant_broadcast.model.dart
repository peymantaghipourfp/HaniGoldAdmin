import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'socket_chat_grant_broadcast.model.g.dart';

SocketChatGrantBroadcastModel socketChatGrantBroadcastModelFromJson(String str) => SocketChatGrantBroadcastModel.fromJson(json.decode(str));

String socketChatGrantBroadcastModelToJson(SocketChatGrantBroadcastModel data) => json.encode(data.toJson());
/// "channel": "chat.grant",
@JsonSerializable()
class SocketChatGrantBroadcastModel {
  @JsonKey(name: "channel")
  final String? channel;
  @JsonKey(name: "data")
  final Data? data;

  SocketChatGrantBroadcastModel({
    required this.channel,
    required this.data,
  });

  factory SocketChatGrantBroadcastModel.fromJson(Map<String, dynamic> json) => _$SocketChatGrantBroadcastModelFromJson(json);

  Map<String, dynamic> toJson() => _$SocketChatGrantBroadcastModelToJson(this);
}

@JsonSerializable()
class Data {
  @JsonKey(name: "chatId")
  final String? chatId;
  @JsonKey(name: "customerAccountId")
  final int? customerAccountId;
  @JsonKey(name: "topicId")
  final int? topicId;
  @JsonKey(name: "topicCode")
  final String? topicCode;
  @JsonKey(name: "topicKey")
  final String? topicKey;
  @JsonKey(name: "targetAdminAccountId")
  final int? targetAdminAccountId;
  @JsonKey(name: "targetAdminUserId")
  final int? targetAdminUserId;
  @JsonKey(name: "role")
  final int? role;
  @JsonKey(name: "on")
  final DateTime? on;

  Data({
    required this.chatId,
    required this.customerAccountId,
    required this.topicId,
    required this.topicCode,
    required this.topicKey,
    required this.targetAdminAccountId,
    required this.targetAdminUserId,
    required this.role,
    required this.on,
  });

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}