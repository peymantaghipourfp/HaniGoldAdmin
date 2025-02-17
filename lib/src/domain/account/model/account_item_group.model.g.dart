// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_item_group.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountItemGroupModel _$AccountItemGroupModelFromJson(
        Map<String, dynamic> json) =>
    AccountItemGroupModel(
      name: json['name'] as String?,
      rowNum: (json['rowNum'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      attribute: json['attribute'] as String?,
      recId: json['recId'] as String?,
      infos: json['infos'] as List<dynamic>?,
    );

Map<String, dynamic> _$AccountItemGroupModelToJson(
        AccountItemGroupModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'rowNum': instance.rowNum,
      'id': instance.id,
      'attribute': instance.attribute,
      'recId': instance.recId,
      'infos': instance.infos,
    };
