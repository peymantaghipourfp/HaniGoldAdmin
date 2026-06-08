import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'socket_chat_seen.model.g.dart';

SocketChatSeenModel socketChatSeenModelFromJson(String str) => SocketChatSeenModel.fromJson(json.decode(str));

String socketChatSeenModelToJson(SocketChatSeenModel data) => json.encode(data.toJson());
/// "channel": "chat.admin.seen",
@JsonSerializable()
class SocketChatSeenModel {
  @JsonKey(name: "channel")
  final String? channel;
  @JsonKey(name: "reqId")
  final String? reqId;
  @JsonKey(name: "data")
  final Data? data;

  SocketChatSeenModel({
    required this.channel,
    required this.reqId,
    required this.data,
  });

  factory SocketChatSeenModel.fromJson(Map<String, dynamic> json) => _$SocketChatSeenModelFromJson(json);

  Map<String, dynamic> toJson() => _$SocketChatSeenModelToJson(this);
}

@JsonSerializable()
class Data {
  @JsonKey(name: "ChatId")
  final String? chatId;
  @JsonKey(name: "UpToSeq")
  final int? upToSeq;

  Data({
    required this.chatId,
    required this.upToSeq,
  });

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}