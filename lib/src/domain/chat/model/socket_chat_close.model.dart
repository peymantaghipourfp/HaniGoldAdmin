import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'socket_chat_close.model.g.dart';

SocketChatCloseModel socketChatCloseModelFromJson(String str) => SocketChatCloseModel.fromJson(json.decode(str));

String socketChatCloseModelToJson(SocketChatCloseModel data) => json.encode(data.toJson());
///  "channel": "chat.close",
@JsonSerializable()
class SocketChatCloseModel {
  @JsonKey(name: "channel")
  final String? channel;
  @JsonKey(name: "reqId")
  final String? reqId;
  @JsonKey(name: "data")
  final Data? data;

  SocketChatCloseModel({
    required this.channel,
    required this.reqId,
    required this.data,
  });

  factory SocketChatCloseModel.fromJson(Map<String, dynamic> json) => _$SocketChatCloseModelFromJson(json);

  Map<String, dynamic> toJson() => _$SocketChatCloseModelToJson(this);
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