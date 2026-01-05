// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'element.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ElementModel _$ElementModelFromJson(Map<String, dynamic> json) => ElementModel(
      name: json['name'] as String?,
      type: json['type'] as String?,
      title: json['title'] as String?,
      rowNum: (json['rowNum'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      attribute: json['attribute'] as String?,
      description: json['description'] as String?,
      infos: json['infos'] as List<dynamic>?,
    );

Map<String, dynamic> _$ElementModelToJson(ElementModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': instance.type,
      'title': instance.title,
      'rowNum': instance.rowNum,
      'id': instance.id,
      'attribute': instance.attribute,
      'description': instance.description,
      'infos': instance.infos,
    };
