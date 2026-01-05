// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_type.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreditTypeModel _$CreditTypeModelFromJson(Map<String, dynamic> json) =>
    CreditTypeModel(
      name: json['name'] as String?,
      leverage: (json['leverage'] as num?)?.toInt(),
      rowNum: (json['rowNum'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      infos: json['infos'] as List<dynamic>?,
    );

Map<String, dynamic> _$CreditTypeModelToJson(CreditTypeModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'leverage': instance.leverage,
      'rowNum': instance.rowNum,
      'id': instance.id,
      'infos': instance.infos,
    };
