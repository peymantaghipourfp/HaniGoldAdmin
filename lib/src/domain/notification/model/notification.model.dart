import 'package:hanigold_admin/src/domain/account/model/account.model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'notification.model.g.dart';

List<NotificationModel> notificationModelFromJson(String str) => List<NotificationModel>.from(json.decode(str).map((x) => NotificationModel.fromJson(x)));

String notificationModelToJson(List<NotificationModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class NotificationModel {
  @JsonKey(name: "account")
  final AccountModel? account;
  @JsonKey(name: "date")
  final DateTime? date;
  @JsonKey(name: "topic")
  final String? topic;
  @JsonKey(name: "title")
  final String? title;
  @JsonKey(name: "notifContent")
  final String? notifContent;
  @JsonKey(name: "hasReaction")
  final bool? hasReaction;
  @JsonKey(name: "isViewed")
  final bool? isViewed;
  @JsonKey(name: "type")
  final int? type;
  @JsonKey(name: "status")
  final int? status;
  @JsonKey(name: "recordStatus")
  final int? recordStatus;
  @JsonKey(name: "rowNum")
  final int? rowNum;
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "attribute")
  final String? attribute;
  @JsonKey(name: "infos")
  final List<dynamic>? infos;

  NotificationModel({
    required this.account,
    required this.date,
    required this.topic,
    required this.title,
    required this.notifContent,
    required this.hasReaction,
    required this.isViewed,
    required this.type,
    required this.status,
    required this.recordStatus,
    required this.rowNum,
    required this.id,
    required this.attribute,
    required this.infos,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) => _$NotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);
}