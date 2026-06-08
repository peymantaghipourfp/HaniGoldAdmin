import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'socket_chat_waiting_total.model.g.dart';

SocketChatWaitingTotalModel socketChatWaitingTotalModelFromJson(String str) =>
    SocketChatWaitingTotalModel.fromJson(json.decode(str));

String socketChatWaitingTotalModelToJson(SocketChatWaitingTotalModel data) =>
    json.encode(data.toJson());

/// Outbound request: `{ "channel": "chat.admin.waiting.total", "reqId": "..." }` (no `data`).
@JsonSerializable(includeIfNull: false)
class SocketChatWaitingTotalRequest {
  @JsonKey(name: 'channel')
  final String channel;
  @JsonKey(name: 'reqId')
  final String reqId;

  const SocketChatWaitingTotalRequest({
    this.channel = 'chat.admin.waiting.total',
    required this.reqId,
  });

  factory SocketChatWaitingTotalRequest.fromJson(Map<String, dynamic> json) =>
      _$SocketChatWaitingTotalRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SocketChatWaitingTotalRequestToJson(this);
}

/// Inbound ack response to [SocketChatWaitingTotalRequest]:
/// `{ "channel": "ack", "reqId": "...", "data": { "waitingChatCount" } }`
@JsonSerializable()
class SocketChatWaitingTotalModel {
  @JsonKey(name: 'channel')
  final String? channel;
  @JsonKey(name: 'reqId')
  final String? reqId;
  @JsonKey(name: 'data')
  final WaitingTotalData? data;

  SocketChatWaitingTotalModel({
    required this.channel,
    required this.reqId,
    required this.data,
  });

  factory SocketChatWaitingTotalModel.fromJson(Map<String, dynamic> json) =>
      _$SocketChatWaitingTotalModelFromJson(json);

  Map<String, dynamic> toJson() => _$SocketChatWaitingTotalModelToJson(this);
}

@JsonSerializable()
class WaitingTotalData {
  @JsonKey(name: 'waitingChatCount')
  final int? waitingChatCount;

  WaitingTotalData({
    required this.waitingChatCount,
  });

  factory WaitingTotalData.fromJson(Map<String, dynamic> json) =>
      _$WaitingTotalDataFromJson(json);

  Map<String, dynamic> toJson() => _$WaitingTotalDataToJson(this);
}
