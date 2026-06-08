import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'socket_chat_close_broadcast.model.g.dart';

SocketChatCloseBroadcastModel socketChatCloseBroadcastModelFromJson(String str) => SocketChatCloseBroadcastModel.fromJson(json.decode(str));

String socketChatCloseBroadcastModelToJson(SocketChatCloseBroadcastModel data) => json.encode(data.toJson());
/// "channel": "chat.close",
@JsonSerializable()
class SocketChatCloseBroadcastModel {
  @JsonKey(name: "channel")
  final String? channel;
  @JsonKey(name: "data")
  final Data? data;

  SocketChatCloseBroadcastModel({
    required this.channel,
    required this.data,
  });

  factory SocketChatCloseBroadcastModel.fromJson(Map<String, dynamic> json) => _$SocketChatCloseBroadcastModelFromJson(json);

  Map<String, dynamic> toJson() => _$SocketChatCloseBroadcastModelToJson(this);
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
  @JsonKey(name: "closedOn")
  final DateTime? closedOn;
  @JsonKey(name: "closeStatus")
  final int? closeStatus;

  Data({
    required this.chatId,
    required this.customerAccountId,
    required this.topicId,
    required this.topicCode,
    required this.topicKey,
    required this.closedOn,
    required this.closeStatus,
  });

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}