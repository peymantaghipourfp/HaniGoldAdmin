
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'chat_history.model.g.dart';

ChatHistoryModel chatHistoryModelFromJson(String str) => ChatHistoryModel.fromJson(json.decode(str));

String chatHistoryModelToJson(ChatHistoryModel data) => json.encode(data.toJson());

@JsonSerializable()
class ChatHistoryModel {
  @JsonKey(name: "chatId")
  final String? chatId;
  @JsonKey(name: "customerAccountId")
  final int? customerAccountId;
  @JsonKey(name: "customerAccountName")
  final String? customerAccountName;
  @JsonKey(name: "topicId")
  final int? topicId;
  @JsonKey(name: "topicCode")
  final String? topicCode;
  @JsonKey(name: "topicTitle")
  final String? topicTitle;
  @JsonKey(name: "topicKey")
  final String? topicKey;
  @JsonKey(name: "status")
  final int? status;
  @JsonKey(name: "currentOwnerAdminAccountId")
  final int? currentOwnerAdminAccountId;
  @JsonKey(name: "currentOwnerAdminUserId")
  final int? currentOwnerAdminUserId;
  @JsonKey(name: "currentOwnerAdminName")
  final String? currentOwnerAdminName;
  @JsonKey(name: "createdOn")
  final DateTime? createdOn;
  @JsonKey(name: "lastActivity")
  final DateTime? lastActivity;
  @JsonKey(name: "closedOn")
  final DateTime? closedOn;
  @JsonKey(name: "firstPicker")
  final ClosedBy? firstPicker;
  @JsonKey(name: "closedBy")
  final ClosedBy? closedBy;
  @JsonKey(name: "forwards")
  final List<Forward>? forwards;
  @JsonKey(name: "viewers")
  final List<Viewer>? viewers;

  ChatHistoryModel({
    required this.chatId,
    required this.customerAccountId,
    required this.customerAccountName,
    required this.topicId,
    required this.topicCode,
    required this.topicTitle,
    required this.topicKey,
    required this.status,
    required this.currentOwnerAdminAccountId,
    required this.currentOwnerAdminUserId,
    required this.currentOwnerAdminName,
    required this.createdOn,
    required this.lastActivity,
    required this.closedOn,
    required this.firstPicker,
    required this.closedBy,
    required this.forwards,
    required this.viewers,
  });

  factory ChatHistoryModel.fromJson(Map<String, dynamic> json) => _$ChatHistoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChatHistoryModelToJson(this);
}

@JsonSerializable()
class ClosedBy {
  @JsonKey(name: "adminAccountId")
  final int? adminAccountId;
  @JsonKey(name: "adminUserId")
  final int? adminUserId;
  @JsonKey(name: "adminName")
  final String? adminName;
  @JsonKey(name: "on")
  final DateTime? on;
  @JsonKey(name: "note")
  final String? note;

  ClosedBy({
    required this.adminAccountId,
    required this.adminUserId,
    required this.adminName,
    required this.on,
    required this.note,
  });

  factory ClosedBy.fromJson(Map<String, dynamic> json) => _$ClosedByFromJson(json);

  Map<String, dynamic> toJson() => _$ClosedByToJson(this);
}

@JsonSerializable()
class Forward {
  @JsonKey(name: "seq")
  final int? seq;
  @JsonKey(name: "fromAdminAccountId")
  final int? fromAdminAccountId;
  @JsonKey(name: "fromAdminUserId")
  final int? fromAdminUserId;
  @JsonKey(name: "fromAdminName")
  final String? fromAdminName;
  @JsonKey(name: "toAdminAccountId")
  final int? toAdminAccountId;
  @JsonKey(name: "toAdminUserId")
  final int? toAdminUserId;
  @JsonKey(name: "toAdminName")
  final String? toAdminName;
  @JsonKey(name: "messageSeq")
  final int? messageSeq;
  @JsonKey(name: "note")
  final String? note;
  @JsonKey(name: "on")
  final DateTime? on;

  Forward({
    required this.seq,
    required this.fromAdminAccountId,
    required this.fromAdminUserId,
    required this.fromAdminName,
    required this.toAdminAccountId,
    required this.toAdminUserId,
    required this.toAdminName,
    required this.messageSeq,
    required this.note,
    required this.on,
  });

  factory Forward.fromJson(Map<String, dynamic> json) => _$ForwardFromJson(json);

  Map<String, dynamic> toJson() => _$ForwardToJson(this);
}

@JsonSerializable()
class Viewer {
  @JsonKey(name: "adminAccountId")
  final int? adminAccountId;
  @JsonKey(name: "adminUserId")
  final int? adminUserId;
  @JsonKey(name: "adminName")
  final String? adminName;
  @JsonKey(name: "currentRole")
  final int? currentRole;
  @JsonKey(name: "currentRoleTitle")
  final String? currentRoleTitle;
  @JsonKey(name: "hasCurrentAccess")
  final bool? hasCurrentAccess;
  @JsonKey(name: "grantedOn")
  final String? grantedOn;
  @JsonKey(name: "grantedByAdminAccountId")
  final int? grantedByAdminAccountId;
  @JsonKey(name: "grantedByAdminUserId")
  final int? grantedByAdminUserId;
  @JsonKey(name: "grantedByAdminName")
  final String? grantedByAdminName;
  @JsonKey(name: "note")
  final String? note;

  Viewer({
    required this.adminAccountId,
    required this.adminUserId,
    required this.adminName,
    required this.currentRole,
    required this.currentRoleTitle,
    required this.hasCurrentAccess,
    required this.grantedOn,
    required this.grantedByAdminAccountId,
    required this.grantedByAdminUserId,
    required this.grantedByAdminName,
    required this.note,
  });

  factory Viewer.fromJson(Map<String, dynamic> json) => _$ViewerFromJson(json);

  Map<String, dynamic> toJson() => _$ViewerToJson(this);
}
