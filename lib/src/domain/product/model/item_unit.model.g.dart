// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_unit.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemUnitModel _$ItemUnitModelFromJson(Map<String, dynamic> json) =>
    ItemUnitModel(
      name: json['name'] as String,
      rowNum: (json['rowNum'] as num).toInt(),
      id: (json['id'] as num).toInt(),
      attribute: json['attribute'] as String,
      recId: json['recId'] as String,
      infos: json['infos'] as List<dynamic>,
    );

Map<String, dynamic> _$ItemUnitModelToJson(ItemUnitModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'rowNum': instance.rowNum,
      'id': instance.id,
      'attribute': instance.attribute,
      'recId': instance.recId,
      'infos': instance.infos,
    };
