import 'dart:convert';

SocketChatModel socketChatModelFromJson(String str) => SocketChatModel.fromJson(json.decode(str));

String socketChatModelToJson(SocketChatModel data) => json.encode(data.toJson());

class SocketChatModel {
  final String? channel;
  final int? id;
  final int? reply;
  final int? replyFromUser;
  final int? replyToUser;
  final DateTime? replyDate;
  final String? replyContent;
  final String? topic;
  final String? userName;
  final String? content;
  final DateTime? date;

  SocketChatModel({
    required this.channel,
    required this.id,
    required this.reply,
    required this.replyFromUser,
    required this.replyToUser,
    required this.replyDate,
    required this.replyContent,
    required this.topic,
    required this.userName,
    required this.content,
    required this.date,
  });

  factory SocketChatModel.fromJson(Map<String, dynamic> json) => SocketChatModel(
    channel: json["channel"],
    id: json["id"],
    reply: json["reply"],
    replyFromUser: json["replyFromUser"],
    replyToUser: json["replyToUser"],
    replyDate: DateTime.parse(json['replyDate'] as String),
    replyContent: json["replyContent"],
    topic: json["topic"],
    userName: json["userName"],
    content: json["content"],
    date: DateTime.parse(json['date'] as String),
  );

  Map<String, dynamic> toJson() => {
    "channel": channel,
    "id": id,
    "reply": reply,
    "replyFromUser": replyFromUser,
    "replyToUser": replyToUser,
    "replyDate": replyDate?.toIso8601String(),
    "replyContent": replyContent,
    "topic": topic,
    "userName": userName,
    "content": content,
    "date": date?.toIso8601String(),
  };
}