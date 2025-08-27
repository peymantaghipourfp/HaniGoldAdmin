// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TopicModel _$TopicModelFromJson(Map<String, dynamic> json) => TopicModel(
      user: json['user'] == null
          ? null
          : UserModel.fromJson(json['user'] as Map<String, dynamic>),
      code: json['code'] as String?,
      topic: json['topic'] as String?,
      id: (json['id'] as num?)?.toInt(),
      infos: json['infos'] as List<dynamic>?,
    );

Map<String, dynamic> _$TopicModelToJson(TopicModel instance) =>
    <String, dynamic>{
      'user': instance.user,
      'code': instance.code,
      'topic': instance.topic,
      'id': instance.id,
      'infos': instance.infos,
    };
