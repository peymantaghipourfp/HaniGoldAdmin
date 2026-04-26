// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TopicModel _$TopicModelFromJson(Map<String, dynamic> json) => TopicModel(
      topicId: (json['topicId'] as num?)?.toInt(),
      code: json['code'] as String?,
      title: json['title'] as String?,
      sortOrder: (json['sortOrder'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TopicModelToJson(TopicModel instance) =>
    <String, dynamic>{
      'topicId': instance.topicId,
      'code': instance.code,
      'title': instance.title,
      'sortOrder': instance.sortOrder,
    };
