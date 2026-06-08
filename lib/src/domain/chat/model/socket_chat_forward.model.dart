import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'socket_chat_forward.model.g.dart';

SocketChatForwardModel socketChatForwardModelFromJson(String str) => SocketChatForwardModel.fromJson(json.decode(str));

String socketChatForwardModelToJson(SocketChatForwardModel data) => json.encode(data.toJson());
/// "channel": "chat.forward",
@JsonSerializable()
class SocketChatForwardModel {
  @JsonKey(name: "channel")
  final String? channel;
  @JsonKey(name: "reqId")
  final String? reqId;
  @JsonKey(name: "data")
  final Data? data;

  SocketChatForwardModel({
    required this.channel,
    required this.reqId,
    required this.data,
  });

  factory SocketChatForwardModel.fromJson(Map<String, dynamic> json) => _$SocketChatForwardModelFromJson(json);

  Map<String, dynamic> toJson() => _$SocketChatForwardModelToJson(this);
}

@JsonSerializable()
class Data {
  @JsonKey(name: "ChatId")
  final String? chatId;
  @JsonKey(name: "ToAdminAccountId")
  final int? toAdminAccountId;
  @JsonKey(name: "ForwardMessageSeq")
  final int? forwardMessageSeq;
  @JsonKey(name: "Note")
  final String? note;

  Data({
    required this.chatId,
    required this.toAdminAccountId,
    required this.forwardMessageSeq,
    required this.note,
  });

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}