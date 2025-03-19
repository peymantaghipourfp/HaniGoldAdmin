// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reason_rejection.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReasonRejectionModel _$ReasonRejectionModelFromJson(
        Map<String, dynamic> json) =>
    ReasonRejectionModel(
      name: json['name'] as String?,
      type: json['type'] as String?,
      rowNum: (json['rowNum'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      attribute: json['attribute'] as String?,
      infos: json['infos'] as List<dynamic>?,
    );

Map<String, dynamic> _$ReasonRejectionModelToJson(
        ReasonRejectionModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': instance.type,
      'rowNum': instance.rowNum,
      'id': instance.id,
      'attribute': instance.attribute,
      'infos': instance.infos,
    };
