// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_level_get_one_item.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountLevelGetOneItemModel _$AccountLevelGetOneItemModelFromJson(
        Map<String, dynamic> json) =>
    AccountLevelGetOneItemModel(
      name: json['name'] as String?,
      balance: (json['balance'] as num?)?.toDouble(),
      positiveGold: (json['positiveGold'] as num?)?.toDouble(),
      negativeGold: (json['negativeGold'] as num?)?.toDouble(),
      accountLevelItems: (json['accountLevelItems'] as List<dynamic>?)
          ?.map(
              (e) => AccountLevelItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      rowNum: (json['rowNum'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      attribute: json['attribute'] as String?,
      recId: json['recId'] as String?,
      infos: json['infos'] as List<dynamic>?,
    );

Map<String, dynamic> _$AccountLevelGetOneItemModelToJson(
        AccountLevelGetOneItemModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'balance': instance.balance,
      'positiveGold': instance.positiveGold,
      'negativeGold': instance.negativeGold,
      'accountLevelItems': instance.accountLevelItems,
      'rowNum': instance.rowNum,
      'id': instance.id,
      'attribute': instance.attribute,
      'recId': instance.recId,
      'infos': instance.infos,
    };
