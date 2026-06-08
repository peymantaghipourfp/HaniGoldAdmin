import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'socket_chat_pick.model.g.dart';

SocketChatPickModel socketChatPickModelFromJson(String str) => SocketChatPickModel.fromJson(json.decode(str));

String socketChatPickModelToJson(SocketChatPickModel data) => json.encode(data.toJson());
/// "channel": "chat.pick",
@JsonSerializable()
class SocketChatPickModel {
  @JsonKey(name: "channel")
  final String? channel;
  @JsonKey(name: "reqId")
  final String? reqId;
  @JsonKey(name: "data")
  final Data? data;

  SocketChatPickModel({
    required this.channel,
    required this.reqId,
    required this.data,
  });

  factory SocketChatPickModel.fromJson(Map<String, dynamic> json) => _$SocketChatPickModelFromJson(json);

  Map<String, dynamic> toJson() => _$SocketChatPickModelToJson(this);
}

@JsonSerializable()
class Data {
  @JsonKey(name: "ChatId")
  final String? chatId;
  @JsonKey(name: "Note")
  final String? note;

  Data({
    required this.chatId,
    required this.note,
  });

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}