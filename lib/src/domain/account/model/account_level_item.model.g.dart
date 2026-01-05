// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_level_item.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountLevelItemModel _$AccountLevelItemModelFromJson(
        Map<String, dynamic> json) =>
    AccountLevelItemModel(
      accountLevelId: (json['accountLevelId'] as num?)?.toInt(),
      itemId: (json['itemId'] as num?)?.toInt(),
      itemName: json['itemName'] as String?,
      itemIcon: json['itemIcon'] as String?,
      maxSell: (json['maxSell'] as num?)?.toDouble(),
      maxBuy: (json['maxBuy'] as num?)?.toDouble(),
      rowNum: (json['rowNum'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      recId: json['recId'] as String?,
      infos: json['infos'] as List<dynamic>?,
    );

Map<String, dynamic> _$AccountLevelItemModelToJson(
        AccountLevelItemModel instance) =>
    <String, dynamic>{
      'accountLevelId': instance.accountLevelId,
      'itemId': instance.itemId,
      'itemName': instance.itemName,
      'itemIcon': instance.itemIcon,
      'maxSell': instance.maxSell,
      'maxBuy': instance.maxBuy,
      'rowNum': instance.rowNum,
      'id': instance.id,
      'recId': instance.recId,
      'infos': instance.infos,
    };
