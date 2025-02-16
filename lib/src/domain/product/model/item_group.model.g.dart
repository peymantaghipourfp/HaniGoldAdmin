// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_group.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemGroupModel _$ItemGroupModelFromJson(Map<String, dynamic> json) =>
    ItemGroupModel(
      code: json['code'] as String,
      name: json['name'] as String,
      equivalent: json['equivalent'] as String,
      rowNum: (json['rowNum'] as num).toInt(),
      id: (json['id'] as num).toInt(),
      attribute: json['attribute'] as String,
      description: json['description'] as String,
      recId: json['recId'] as String,
      infos: json['infos'] as List<dynamic>,
    );

Map<String, dynamic> _$ItemGroupModelToJson(ItemGroupModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'name': instance.name,
      'equivalent': instance.equivalent,
      'rowNum': instance.rowNum,
      'id': instance.id,
      'attribute': instance.attribute,
      'description': instance.description,
      'recId': instance.recId,
      'infos': instance.infos,
    };
