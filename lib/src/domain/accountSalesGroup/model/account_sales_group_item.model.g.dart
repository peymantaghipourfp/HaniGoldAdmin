// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_sales_group_item.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountSalesGroupItemModel _$AccountSalesGroupItemModelFromJson(
        Map<String, dynamic> json) =>
    AccountSalesGroupItemModel(
      itemId: (json['itemId'] as num?)?.toInt(),
      itemName: json['itemName'] as String?,
      itemIcon: json['itemIcon'] as String?,
      status: json['status'] as bool?,
      mesghalPrice: (json['mesghalPrice'] as num?)?.toDouble(),
      mesghalBuyPrice: (json['mesghalBuyPrice'] as num?)?.toDouble(),
      salesRange: (json['salesRange'] as num?)?.toDouble(),
      buyRange: (json['buyRange'] as num?)?.toDouble(),
      rowNum: (json['rowNum'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      recId: json['recId'] as String?,
      infos: json['infos'] as List<dynamic>?,
    );

Map<String, dynamic> _$AccountSalesGroupItemModelToJson(
        AccountSalesGroupItemModel instance) =>
    <String, dynamic>{
      'itemId': instance.itemId,
      'itemName': instance.itemName,
      'itemIcon': instance.itemIcon,
      'status': instance.status,
      'mesghalPrice': instance.mesghalPrice,
      'mesghalBuyPrice': instance.mesghalBuyPrice,
      'salesRange': instance.salesRange,
      'buyRange': instance.buyRange,
      'rowNum': instance.rowNum,
      'id': instance.id,
      'recId': instance.recId,
      'infos': instance.infos,
    };
