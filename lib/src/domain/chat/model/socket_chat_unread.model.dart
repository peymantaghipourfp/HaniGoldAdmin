import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'socket_chat_unread.model.g.dart';

SocketChatUnreadModel socketChatUnreadModelFromJson(String str) => SocketChatUnreadModel.fromJson(json.decode(str));

String socketChatUnreadModelToJson(SocketChatUnreadModel data) => json.encode(data.toJson());
///  "channel": "chat.unread",
@JsonSerializable()
class SocketChatUnreadModel {
  @JsonKey(name: "channel")
  final String? channel;
  @JsonKey(name: "reqId")
  final String? reqId;
  @JsonKey(name: "data")
  final Data? data;

  SocketChatUnreadModel({
    required this.channel,
    required this.reqId,
    required this.data,
  });

  factory SocketChatUnreadModel.fromJson(Map<String, dynamic> json) => _$SocketChatUnreadModelFromJson(json);

  Map<String, dynamic> toJson() => _$SocketChatUnreadModelToJson(this);
}

@JsonSerializable()
class Data {
  @JsonKey(name: "CustomerAccountId")
  final int? customerAccountId;
  @JsonKey(name: "TopicCode")
  final String? topicCode;
  @JsonKey(name: "TopicKey")
  final String? topicKey;

  Data({
    required this.customerAccountId,
    required this.topicCode,
    required this.topicKey,
  });

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}