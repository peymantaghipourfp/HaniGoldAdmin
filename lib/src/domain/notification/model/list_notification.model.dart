
import 'package:hanigold_admin/src/domain/notification/model/notification.model.dart';
import 'package:hanigold_admin/src/domain/users/model/paginated.model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'list_notification.model.g.dart';

ListNotificationModel listNotificationFromJson(String str) => ListNotificationModel.fromJson(json.decode(str));

String listNotificationToJson(ListNotificationModel data) => json.encode(data.toJson());

@JsonSerializable()
class ListNotificationModel {
  @JsonKey(name: "notifications")
  final List<NotificationModel>? notifications;
  @JsonKey(name: "paginated")
  final PaginatedModel? paginated;

  ListNotificationModel({
    required this.notifications,
    required this.paginated,
  });

  factory ListNotificationModel.fromJson(Map<String, dynamic> json) => _$ListNotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$ListNotificationModelToJson(this);
}