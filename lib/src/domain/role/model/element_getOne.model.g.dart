// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'element_getOne.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ElementGetOneModel _$ElementGetOneModelFromJson(Map<String, dynamic> json) =>
    ElementGetOneModel(
      name: json['name'] as String?,
      type: json['type'] as String?,
      title: json['title'] as String?,
      elementActions: (json['elementActions'] as List<dynamic>?)
          ?.map((e) => ElementActionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      rowNum: (json['rowNum'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      attribute: json['attribute'] as String?,
      description: json['description'] as String?,
      infos: json['infos'] as List<dynamic>?,
    );

Map<String, dynamic> _$ElementGetOneModelToJson(ElementGetOneModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': instance.type,
      'title': instance.title,
      'elementActions': instance.elementActions,
      'rowNum': instance.rowNum,
      'id': instance.id,
      'attribute': instance.attribute,
      'description': instance.description,
      'infos': instance.infos,
    };
