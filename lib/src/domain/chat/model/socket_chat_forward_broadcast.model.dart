import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'socket_chat_forward_broadcast.model.g.dart';

SocketChatForwardBroadcastModel socketChatForwardBroadcastModelFromJson(String str) => SocketChatForwardBroadcastModel.fromJson(json.decode(str));

String socketChatForwardBroadcastModelToJson(SocketChatForwardBroadcastModel data) => json.encode(data.toJson());
/// "channel": "chat.forward",
@JsonSerializable()
class SocketChatForwardBroadcastModel {
  @JsonKey(name: "channel")
  final String? channel;
  @JsonKey(name: "data")
  final Data? data;

  SocketChatForwardBroadcastModel({
    required this.channel,
    required this.data,
  });

  factory SocketChatForwardBroadcastModel.fromJson(Map<String, dynamic> json) => _$SocketChatForwardBroadcastModelFromJson(json);

  Map<String, dynamic> toJson() => _$SocketChatForwardBroadcastModelToJson(this);
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
  @JsonKey(name: "fromAdminAccountId")
  final int? fromAdminAccountId;
  @JsonKey(name: "toAdminAccountId")
  final int? toAdminAccountId;
  @JsonKey(name: "forwardMessageSeq")
  final int? forwardMessageSeq;
  @JsonKey(name: "on")
  final DateTime? on;

  Data({
    required this.chatId,
    required this.customerAccountId,
    required this.topicId,
    required this.topicCode,
    required this.topicKey,
    required this.fromAdminAccountId,
    required this.toAdminAccountId,
    required this.forwardMessageSeq,
    required this.on,
  });

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}