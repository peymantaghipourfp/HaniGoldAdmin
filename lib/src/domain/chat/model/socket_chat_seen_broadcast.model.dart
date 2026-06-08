import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'socket_chat_seen_broadcast.model.g.dart';

SocketChatSeenBroadcastModel socketChatSeenBroadcastModelFromJson(String str) => SocketChatSeenBroadcastModel.fromJson(json.decode(str));

String socketChatSeenBroadcastModelToJson(SocketChatSeenBroadcastModel data) => json.encode(data.toJson());
/// "channel": "chat.seen",
@JsonSerializable()
class SocketChatSeenBroadcastModel {
  @JsonKey(name: "channel")
  final String? channel;
  @JsonKey(name: "data")
  final Data? data;

  SocketChatSeenBroadcastModel({
    required this.channel,
    required this.data,
  });

  factory SocketChatSeenBroadcastModel.fromJson(Map<String, dynamic> json) => _$SocketChatSeenBroadcastModelFromJson(json);

  Map<String, dynamic> toJson() => _$SocketChatSeenBroadcastModelToJson(this);
}

@JsonSerializable()
class Data {
  @JsonKey(name: "chatId")
  final String? chatId;
  @JsonKey(name: "customerAccountId")
  final int? customerAccountId;
  @JsonKey(name: "topicId")
  final int? topicId;
  @JsonKey(name: "topicKey")
  final String? topicKey;
  @JsonKey(name: "upToSeq")
  final int? upToSeq;
  @JsonKey(name: "changedCount")
  final int? changedCount;
  @JsonKey(name: "unreadMessageCount")
  final int? unreadMessageCount;
  @JsonKey(name: "totalUnreadMessageCount")
  final int? totalUnreadMessageCount;
  @JsonKey(name: "byAccountId")
  final int? byAccountId;
  @JsonKey(name: "byUserId")
  final int? byUserId;
  @JsonKey(name: "on")
  final DateTime? on;

  Data({
    required this.chatId,
    required this.customerAccountId,
    required this.topicId,
    required this.topicKey,
    required this.upToSeq,
    required this.changedCount,
    required this.unreadMessageCount,
    required this.totalUnreadMessageCount,
    required this.byAccountId,
    required this.byUserId,
    required this.on,
  });

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}