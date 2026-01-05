// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_level.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountLevelModel _$AccountLevelModelFromJson(Map<String, dynamic> json) =>
    AccountLevelModel(
      name: json['name'] as String?,
      balance: (json['balance'] as num?)?.toDouble(),
      positiveGold: (json['positiveGold'] as num?)?.toDouble(),
      negativeGold: (json['negativeGold'] as num?)?.toDouble(),
      levelCredit: (json['levelCredit'] as num?)?.toDouble(),
      accountLevelItems: (json['accountLevelItems'] as List<dynamic>?)
          ?.map(
              (e) => AccountLevelItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      rowNum: (json['rowNum'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      attribute: json['attribute'] as String?,
      recId: json['recId'] as String?,
      infos: json['infos'] as List<dynamic>?,
      accountCount: (json['accountCount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$AccountLevelModelToJson(AccountLevelModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'balance': instance.balance,
      'positiveGold': instance.positiveGold,
      'negativeGold': instance.negativeGold,
      'levelCredit': instance.levelCredit,
      'accountLevelItems': instance.accountLevelItems,
      'rowNum': instance.rowNum,
      'id': instance.id,
      'attribute': instance.attribute,
      'recId': instance.recId,
      'infos': instance.infos,
      'accountCount': instance.accountCount,
    };
