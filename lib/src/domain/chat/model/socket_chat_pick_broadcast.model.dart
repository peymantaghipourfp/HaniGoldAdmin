import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'socket_chat_pick_broadcast.model.g.dart';

SocketChatPickBroadcastModel socketChatPickBroadcastModelFromJson(String str) => SocketChatPickBroadcastModel.fromJson(json.decode(str));

String socketChatPickBroadcastModelToJson(SocketChatPickBroadcastModel data) => json.encode(data.toJson());
///  "channel": "chat.pick",
@JsonSerializable()
class SocketChatPickBroadcastModel {
  @JsonKey(name: "channel")
  final String? channel;
  @JsonKey(name: "data")
  final Data? data;

  SocketChatPickBroadcastModel({
    required this.channel,
    required this.data,
  });

  factory SocketChatPickBroadcastModel.fromJson(Map<String, dynamic> json) => _$SocketChatPickBroadcastModelFromJson(json);

  Map<String, dynamic> toJson() => _$SocketChatPickBroadcastModelToJson(this);
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
  @JsonKey(name: "assignedAdminAccountId")
  final int? assignedAdminAccountId;
  @JsonKey(name: "assignedAdminUserId")
  final int? assignedAdminUserId;
  @JsonKey(name: "on")
  final DateTime? on;

  Data({
    required this.chatId,
    required this.customerAccountId,
    required this.topicId,
    required this.topicCode,
    required this.topicKey,
    required this.assignedAdminAccountId,
    required this.assignedAdminUserId,
    required this.on,
  });

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}