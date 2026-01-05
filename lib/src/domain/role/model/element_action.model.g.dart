// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'element_action.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ElementActionModel _$ElementActionModelFromJson(Map<String, dynamic> json) =>
    ElementActionModel(
      elementId: (json['elementId'] as num?)?.toInt(),
      name: json['name'] as String?,
      title: json['title'] as String?,
      rowNum: (json['rowNum'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      attribute: json['attribute'] as String?,
      infos: json['infos'] as List<dynamic>?,
    );

Map<String, dynamic> _$ElementActionModelToJson(ElementActionModel instance) =>
    <String, dynamic>{
      'elementId': instance.elementId,
      'name': instance.name,
      'title': instance.title,
      'rowNum': instance.rowNum,
      'id': instance.id,
      'attribute': instance.attribute,
      'infos': instance.infos,
    };
