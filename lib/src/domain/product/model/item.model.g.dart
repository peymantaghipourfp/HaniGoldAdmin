// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemModel _$ItemModelFromJson(Map<String, dynamic> json) => ItemModel(
      itemGroup: json['itemGroup'] == null
          ? null
          : ItemGroupModel.fromJson(json['itemGroup'] as Map<String, dynamic>),
      itemPrice: json['itemPrice'] == null
          ? null
          : ItemPriceModel.fromJson(json['itemPrice'] as Map<String, dynamic>),
      itemUnit: json['itemUnit'] == null
          ? null
          : ItemModel.fromJson(json['itemUnit'] as Map<String, dynamic>),
      name: json['name'] as String?,
      sellStatus: (json['sellStatus'] as num?)?.toInt(),
      buyStatus: (json['buyStatus'] as num?)?.toInt(),
      maxSell: (json['maxSell'] as num?)?.toInt(),
      maxBuy: (json['maxBuy'] as num?)?.toInt(),
      unit: (json['unit'] as num?)?.toInt(),
      w750: (json['w750'] as num?)?.toDouble(),
      initBalance: (json['initBalance'] as num?)?.toInt(),
      rowNum: (json['rowNum'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      attribute: json['attribute'] as String?,
      recId: json['recId'] as String?,
      infos: json['infos'] as List<dynamic>?,
    );

Map<String, dynamic> _$ItemModelToJson(ItemModel instance) => <String, dynamic>{
      'itemGroup': instance.itemGroup,
      'itemPrice': instance.itemPrice,
      'itemUnit': instance.itemUnit,
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
      'attribute': instance.attribute,
      'recId': instance.recId,
      'infos': instance.infos,
    };
