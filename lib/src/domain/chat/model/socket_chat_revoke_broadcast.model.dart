import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'socket_chat_revoke_broadcast.model.g.dart';

SocketChatRevokeBroadcastModel socketChatRevokeBroadcastModelFromJson(String str) => SocketChatRevokeBroadcastModel.fromJson(json.decode(str));

String socketChatRevokeBroadcastModelToJson(SocketChatRevokeBroadcastModel data) => json.encode(data.toJson());
/// "channel": "chat.revoke",
@JsonSerializable()
class SocketChatRevokeBroadcastModel {
  @JsonKey(name: "channel")
  final String? channel;
  @JsonKey(name: "data")
  final Data? data;

  SocketChatRevokeBroadcastModel({
    required this.channel,
    required this.data,
  });

  factory SocketChatRevokeBroadcastModel.fromJson(Map<String, dynamic> json) => _$SocketChatRevokeBroadcastModelFromJson(json);

  Map<String, dynamic> toJson() => _$SocketChatRevokeBroadcastModelToJson(this);
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
    required this.on,
  });

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}