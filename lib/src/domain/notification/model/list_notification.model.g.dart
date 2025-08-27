// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_notification.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListNotificationModel _$ListNotificationModelFromJson(
        Map<String, dynamic> json) =>
    ListNotificationModel(
      notifications: (json['notifications'] as List<dynamic>?)
          ?.map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      paginated: json['paginated'] == null
          ? null
          : PaginatedModel.fromJson(json['paginated'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ListNotificationModelToJson(
        ListNotificationModel instance) =>
    <String, dynamic>{
      'notifications': instance.notifications,
      'paginated': instance.paginated,
    };
