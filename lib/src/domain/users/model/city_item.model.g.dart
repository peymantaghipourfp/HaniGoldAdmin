// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'city_item.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CityItemModel _$CityItemModelFromJson(Map<String, dynamic> json) =>
    CityItemModel(
      name: json['name'] as String?,
      state: json['state'] == null
          ? null
          : StateItemModel.fromJson(json['state'] as Map<String, dynamic>),
      rowNum: (json['rowNum'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      attribute: json['attribute'] as String?,
      recId: json['recId'] as String?,
      infos: json['infos'] as List<dynamic>?,
    );

Map<String, dynamic> _$CityItemModelToJson(CityItemModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'state': instance.state,
      'rowNum': instance.rowNum,
      'id': instance.id,
      'attribute': instance.attribute,
      'recId': instance.recId,
      'infos': instance.infos,
    };
