// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoleModel _$RoleModelFromJson(Map<String, dynamic> json) => RoleModel(
      name: json['name'] as String?,
      rowNum: (json['rowNum'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      attribute: json['attribute'] as String?,
      infos: json['infos'] as List<dynamic>?,
    );

Map<String, dynamic> _$RoleModelToJson(RoleModel instance) => <String, dynamic>{
      'name': instance.name,
      'rowNum': instance.rowNum,
      'id': instance.id,
      'attribute': instance.attribute,
      'infos': instance.infos,
    };
