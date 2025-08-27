// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemModel _$ItemModelFromJson(Map<String, dynamic> json) => ItemModel(
      itemGroup: json['itemGroup'] == null
          ? null
          : ItemGroupModel.fromJson(json['itemGroup'] as Map<String, dynamic>),
      itemUnit: json['itemUnit'] == null
          ? null
          : ItemUnitModel.fromJson(json['itemUnit'] as Map<String, dynamic>),
      price: (json['price'] as num?)?.toDouble(),
      mesghalPrice: (json['mesghalPrice'] as num?)?.toDouble(),
      differentPrice: (json['differentPrice'] as num?)?.toDouble(),
      mesghalDifferentPrice:
          (json['mesghalDifferentPrice'] as num?)?.toDouble(),
      name: json['name'] as String?,
      isDefault: json['isDefault'] as bool?,
      isDecimal: json['isDecimal'] as bool?,
      status: json['status'] as bool?,
      showMarket: json['showMarket'] as bool?,
      sellStatus: json['sellStatus'] as bool?,
      buyStatus: json['buyStatus'] as bool?,
      hasWage: json['hasWage'] as bool?,
      wage: (json['wage'] as num?)?.toDouble(),
      hasCard: json['hasCard'] as bool?,
      cardPrice: (json['cardPrice'] as num?)?.toDouble(),
      maxSell: (json['maxSell'] as num?)?.toInt(),
      maxBuy: (json['maxBuy'] as num?)?.toInt(),
      w750: (json['w750'] as num?)?.toDouble(),
      initBalance: (json['initBalance'] as num?)?.toInt(),
      openPrice: (json['openPrice'] as num?)?.toDouble(),
      openPriceValue: (json['openPriceValue'] as num?)?.toDouble(),
      symbol: json['symbol'] as String?,
      icon: json['icon'] as String?,
      rowNum: (json['rowNum'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      attribute: json['attribute'] as String?,
      recId: json['recId'] as String?,
      infos: json['infos'] as List<dynamic>?,
      salesRange: (json['salesRange'] as num?)?.toDouble(),
      buyRange: (json['buyRange'] as num?)?.toDouble(),
      refrence: json['refrence'] == null
          ? null
          : Refrence.fromJson(json['refrence'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ItemModelToJson(ItemModel instance) => <String, dynamic>{
      'itemGroup': instance.itemGroup,
      'itemUnit': instance.itemUnit,
      'price': instance.price,
      'mesghalPrice': instance.mesghalPrice,
      'differentPrice': instance.differentPrice,
      'mesghalDifferentPrice': instance.mesghalDifferentPrice,
      'name': instance.name,
      'isDefault': instance.isDefault,
      'isDecimal': instance.isDecimal,
      'status': instance.status,
      'showMarket': instance.showMarket,
      'sellStatus': instance.sellStatus,
      'buyStatus': instance.buyStatus,
      'hasWage': instance.hasWage,
      'wage': instance.wage,
      'hasCard': instance.hasCard,
      'cardPrice': instance.cardPrice,
      'maxSell': instance.maxSell,
      'maxBuy': instance.maxBuy,
      'salesRange': instance.salesRange,
      'buyRange': instance.buyRange,
      'w750': instance.w750,
      'initBalance': instance.initBalance,
      'openPrice': instance.openPrice,
      'openPriceValue': instance.openPriceValue,
      'symbol': instance.symbol,
      'icon': instance.icon,
      'rowNum': instance.rowNum,
      'id': instance.id,
      'attribute': instance.attribute,
      'recId': instance.recId,
      'infos': instance.infos,
      'refrence': instance.refrence,
    };

Refrence _$RefrenceFromJson(Map<String, dynamic> json) => Refrence(
      itemGroup: json['itemGroup'] == null
          ? null
          : ItemGroupModel.fromJson(json['itemGroup'] as Map<String, dynamic>),
      itemUnit: json['itemUnit'] == null
          ? null
          : ItemUnitModel.fromJson(json['itemUnit'] as Map<String, dynamic>),
      name: json['name'] as String?,
      id: (json['id'] as num?)?.toInt(),
      infos: json['infos'] as List<dynamic>?,
    );

Map<String, dynamic> _$RefrenceToJson(Refrence instance) => <String, dynamic>{
      'itemGroup': instance.itemGroup,
      'itemUnit': instance.itemUnit,
      'name': instance.name,
      'id': instance.id,
      'infos': instance.infos,
    };
