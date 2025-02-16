// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) => OrderModel(
      date: DateTime.parse(json['date'] as String),
      account: Parent.fromJson(json['account'] as Map<String, dynamic>),
      registered: (json['registered'] as num).toInt(),
      checked: (json['checked'] as num).toInt(),
      isDeleted: json['isDeleted'] as bool,
      rowNum: (json['rowNum'] as num).toInt(),
      id: (json['id'] as num).toInt(),
      attribute: $enumDecode(_$AccountModelAttributeEnumMap, json['attribute']),
      recId: json['recId'] as String,
      infos: json['infos'] as List<dynamic>,
    );

Map<String, dynamic> _$OrderModelToJson(OrderModel instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'account': instance.account,
      'registered': instance.registered,
      'checked': instance.checked,
      'isDeleted': instance.isDeleted,
      'rowNum': instance.rowNum,
      'id': instance.id,
      'attribute': _$AccountModelAttributeEnumMap[instance.attribute]!,
      'recId': instance.recId,
      'infos': instance.infos,
    };

const _$AccountModelAttributeEnumMap = {
  AccountModelAttribute.CUS: 'cus',
};
