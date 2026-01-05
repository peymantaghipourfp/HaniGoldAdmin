// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_price.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemPriceModel _$ItemPriceModelFromJson(Map<String, dynamic> json) =>
    ItemPriceModel(
      StateMode: (json['StateMode'] as num?)?.toInt(),
      itemId: (json['itemId'] as num?)?.toInt(),
      price: (json['price'] as num?)?.toDouble(),
      mesghalPrice: (json['mesghalPrice'] as num?)?.toDouble(),
      differentPrice: (json['differentPrice'] as num?)?.toDouble(),
      mesghalDifferentPrice:
          (json['mesghalDifferentPrice'] as num?)?.toDouble(),
      rowNum: (json['rowNum'] as num?)?.toInt(),
      itemName: json['itemName'] as String?,
      itemIcon: json['itemIcon'] as String?,
      salesRange: (json['salesRange'] as num?)?.toDouble(),
      buyRange: (json['buyRange'] as num?)?.toDouble(),
      maxBuy: (json['maxBuy'] as num?)?.toDouble(),
      maxSell: (json['maxSell'] as num?)?.toDouble(),
      id: (json['id'] as num?)?.toInt(),
      attribute: json['attribute'] as String?,
      recId: json['recId'] as String?,
      infos: json['infos'] as List<dynamic>?,
      itemUnitId: (json['itemUnitId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ItemPriceModelToJson(ItemPriceModel instance) =>
    <String, dynamic>{
      'StateMode': instance.StateMode,
      'itemId': instance.itemId,
      'price': instance.price,
      'mesghalPrice': instance.mesghalPrice,
      'differentPrice': instance.differentPrice,
      'mesghalDifferentPrice': instance.mesghalDifferentPrice,
      'itemName': instance.itemName,
      'itemIcon': instance.itemIcon,
      'salesRange': instance.salesRange,
      'buyRange': instance.buyRange,
      'maxBuy': instance.maxBuy,
      'maxSell': instance.maxSell,
      'rowNum': instance.rowNum,
      'id': instance.id,
      'attribute': instance.attribute,
      'recId': instance.recId,
      'infos': instance.infos,
      'itemUnitId': instance.itemUnitId,
    };
