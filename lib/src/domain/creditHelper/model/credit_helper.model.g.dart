// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_helper.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreditHelperModel _$CreditHelperModelFromJson(Map<String, dynamic> json) =>
    CreditHelperModel(
      account: json['account'] == null
          ? null
          : AccountModel.fromJson(json['account'] as Map<String, dynamic>),
      item: json['item'] == null
          ? null
          : ItemModel.fromJson(json['item'] as Map<String, dynamic>),
      type: (json['type'] as num?)?.toInt(),
      typeName: json['typeName'] as String?,
      amount: (json['amount'] as num?)?.toDouble(),
      isActive: json['isActive'] as bool?,
      rowNum: (json['rowNum'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      attribute: json['attribute'] as String?,
      recId: json['recId'] as String?,
      infos: json['infos'] as List<dynamic>?,
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      description: json['description'] as String?,
    );

Map<String, dynamic> _$CreditHelperModelToJson(CreditHelperModel instance) =>
    <String, dynamic>{
      'account': instance.account,
      'item': instance.item,
      'type': instance.type,
      'typeName': instance.typeName,
      'amount': instance.amount,
      'isActive': instance.isActive,
      'rowNum': instance.rowNum,
      'id': instance.id,
      'attribute': instance.attribute,
      'recId': instance.recId,
      'infos': instance.infos,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'description': instance.description,
    };
