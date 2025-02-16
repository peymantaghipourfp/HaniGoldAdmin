// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemModel _$ItemModelFromJson(Map<String, dynamic> json) => ItemModel(
      itemGroup: Group.fromJson(json['itemGroup'] as Map<String, dynamic>),
      itemPrice: ItemPrice.fromJson(json['itemPrice'] as Map<String, dynamic>),
      name: json['name'] as String,
      sellStatus: (json['sellStatus'] as num).toInt(),
      buyStatus: (json['buyStatus'] as num).toInt(),
      maxSell: (json['maxSell'] as num).toInt(),
      maxBuy: (json['maxBuy'] as num).toInt(),
      unit: (json['unit'] as num).toInt(),
      w750: (json['w750'] as num).toDouble(),
      initBalance: (json['initBalance'] as num).toInt(),
      rowNum: (json['rowNum'] as num).toInt(),
      id: (json['id'] as num).toInt(),
      attribute: $enumDecode(_$ItemModelAttributeEnumMap, json['attribute']),
      recId: json['recId'] as String,
      infos: json['infos'] as List<dynamic>,
    );

Map<String, dynamic> _$ItemModelToJson(ItemModel instance) => <String, dynamic>{
      'itemGroup': instance.itemGroup,
      'itemPrice': instance.itemPrice,
      'name': instance.name,
      'sellStatus': instance.sellStatus,
      'buyStatus': instance.buyStatus,
      'maxSell': instance.maxSell,
      'maxBuy': instance.maxBuy,
      'unit': instance.unit,
      'w750': instance.w750,
      'initBalance': instance.initBalance,
      'rowNum': instance.rowNum,
      'id': instance.id,
      'attribute': _$ItemModelAttributeEnumMap[instance.attribute]!,
      'recId': instance.recId,
      'infos': instance.infos,
    };

const _$ItemModelAttributeEnumMap = {
  ItemModelAttribute.SYS: 'sys',
};

ItemPrice _$ItemPriceFromJson(Map<String, dynamic> json) => ItemPrice(
      price: (json['price'] as num).toDouble(),
      differentPrice: (json['differentPrice'] as num).toDouble(),
      createdOn: DateTime.parse(json['createdOn'] as String),
      infos: json['infos'] as List<dynamic>,
    );

Map<String, dynamic> _$ItemPriceToJson(ItemPrice instance) => <String, dynamic>{
      'price': instance.price,
      'differentPrice': instance.differentPrice,
      'createdOn': instance.createdOn.toIso8601String(),
      'infos': instance.infos,
    };
