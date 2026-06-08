import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'socket_chat_typing.model.g.dart';

SocketChatTypingModel socketChatTypingModelFromJson(String str) => SocketChatTypingModel.fromJson(json.decode(str));

String socketChatTypingModelToJson(SocketChatTypingModel data) => json.encode(data.toJson());
/// "channel": "chat.typing",
@JsonSerializable()
class SocketChatTypingModel {
  @JsonKey(name: "channel")
  final String? channel;
  @JsonKey(name: "reqId")
  final String? reqId;
  @JsonKey(name: "data")
  final Data? data;

  SocketChatTypingModel({
    required this.channel,
    required this.reqId,
    required this.data,
  });

  factory SocketChatTypingModel.fromJson(Map<String, dynamic> json) => _$SocketChatTypingModelFromJson(json);

  Map<String, dynamic> toJson() => _$SocketChatTypingModelToJson(this);
}

@JsonSerializable()
class Data {
  @JsonKey(name: "CustomerAccountId")
  final int? customerAccountId;
  @JsonKey(name: "TopicCode")
  final String? topicCode;
  @JsonKey(name: "TopicKey")
  final String? topicKey;
  @JsonKey(name: "IsTyping")
  final bool? isTyping;

  Data({
    required this.customerAccountId,
    required this.topicCode,
    required this.topicKey,
    required this.isTyping,
  });

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}