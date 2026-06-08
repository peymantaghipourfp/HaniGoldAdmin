import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'socket_chat_admin_send.model.g.dart';

SocketChatAdminSendModel socketChatAdminSendModelFromJson(String str) => SocketChatAdminSendModel.fromJson(json.decode(str));

String socketChatAdminSendModelToJson(SocketChatAdminSendModel data) => json.encode(data.toJson());
/// "channel": "chat.admin.send",
@JsonSerializable()
class SocketChatAdminSendModel {
  @JsonKey(name: "channel")
  final String? channel;
  @JsonKey(name: "reqId")
  final String? reqId;
  @JsonKey(name: "data")
  final Data? data;

  SocketChatAdminSendModel({
    required this.channel,
    required this.reqId,
    required this.data,
  });

  factory SocketChatAdminSendModel.fromJson(Map<String, dynamic> json) => _$SocketChatAdminSendModelFromJson(json);

  Map<String, dynamic> toJson() => _$SocketChatAdminSendModelToJson(this);
}

@JsonSerializable()
class Data {
  @JsonKey(name: "CustomerAccountId")
  final int? customerAccountId;
  @JsonKey(name: "TopicCode")
  final String? topicCode;
  @JsonKey(name: "TopicKey")
  final String? topicKey;
  @JsonKey(name: "Text")
  final String? text;
  @JsonKey(name: "DataJson")
  final String? dataJson;
  @JsonKey(name: "FilesJson")
  final String? filesJson;
  @JsonKey(name: "ReplyToMessageGuid")
  final String? replyToMessageGuid;
  @JsonKey(name: "ForwardFromMessageGuid")
  final String? forwardFromMessageGuid;
  @JsonKey(name: "ForwardFromSenderName")
  final String? forwardFromSenderName;
  @JsonKey(name: "ReferenceType")
  final String? referenceType;
  @JsonKey(name: "ReferenceId")
  final int? referenceId;

  Data({
    required this.customerAccountId,
    required this.topicCode,
    required this.topicKey,
    required this.text,
    required this.dataJson,
    required this.filesJson,
    required this.replyToMessageGuid,
    required this.forwardFromMessageGuid,
    required this.forwardFromSenderName,
    required this.referenceType,
    required this.referenceId,
  });

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}

@JsonSerializable()
class FilesJson {
  @JsonKey(name: "recordId")
  final String? recordId;

  @JsonKey(name: "fileType")
  final String? fileType;

  FilesJson({
    required this.recordId,
    required this.fileType,
  });

  factory FilesJson.fromJson(Map<String, dynamic> json) =>
      _$FilesJsonFromJson(json);

  Map<String, dynamic> toJson() => _$FilesJsonToJson(this);
}