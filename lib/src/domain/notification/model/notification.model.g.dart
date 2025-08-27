// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    NotificationModel(
      account: json['account'] == null
          ? null
          : AccountModel.fromJson(json['account'] as Map<String, dynamic>),
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      topic: json['topic'] as String?,
      title: json['title'] as String?,
      notifContent: json['notifContent'] as String?,
      hasReaction: json['hasReaction'] as bool?,
      isViewed: json['isViewed'] as bool?,
      type: (json['type'] as num?)?.toInt(),
      status: (json['status'] as num?)?.toInt(),
      recordStatus: (json['recordStatus'] as num?)?.toInt(),
      rowNum: (json['rowNum'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      attribute: json['attribute'] as String?,
      infos: json['infos'] as List<dynamic>?,
    );

Map<String, dynamic> _$NotificationModelToJson(NotificationModel instance) =>
    <String, dynamic>{
      'account': instance.account,
      'date': instance.date?.toIso8601String(),
      'topic': instance.topic,
      'title': instance.title,
      'notifContent': instance.notifContent,
      'hasReaction': instance.hasReaction,
      'isViewed': instance.isViewed,
      'type': instance.type,
      'status': instance.status,
      'recordStatus': instance.recordStatus,
      'rowNum': instance.rowNum,
      'id': instance.id,
      'attribute': instance.attribute,
      'infos': instance.infos,
    };
