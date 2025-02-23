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
      differentPrice: (json['differentPrice'] as num?)?.toDouble(),
      name: json['name'] as String?,
      isDefault: json['isDefault'] as bool?,
      status: json['status'] as bool?,
      sellStatus: json['sellStatus'] as bool?,
      buyStatus: json['buyStatus'] as bool?,
      maxSell: (json['maxSell'] as num?)?.toInt(),
      maxBuy: (json['maxBuy'] as num?)?.toInt(),
      w750: (json['w750'] as num?)?.toDouble(),
      initBalance: (json['initBalance'] as num?)?.toInt(),
      openPrice: (json['openPrice'] as num?)?.toDouble(),
      symbol: json['symbol'] as String?,
      icon: json['icon'] as String?,
      rowNum: (json['rowNum'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      attribute: json['attribute'] as String?,
      recId: json['recId'] as String?,
      infos: json['infos'] as List<dynamic>?,
    );

Map<String, dynamic> _$ItemModelToJson(ItemModel instance) => <String, dynamic>{
      'itemGroup': instance.itemGroup,
      'itemUnit': instance.itemUnit,
      'price': instance.price,
      'differentPrice': instance.differentPrice,
      'name': instance.name,
      'isDefault': instance.isDefault,
      'status': instance.status,
      'sellStatus': instance.sellStatus,
      'buyStatus': instance.buyStatus,
      'maxSell': instance.maxSell,
      'maxBuy': instance.maxBuy,
      'w750': instance.w750,
      'initBalance': instance.initBalance,
      'openPrice': instance.openPrice,
      'symbol': instance.symbol,
      'icon': instance.icon,
      'rowNum': instance.rowNum,
      'id': instance.id,
      'attribute': instance.attribute,
      'recId': instance.recId,
      'infos': instance.infos,
    };
