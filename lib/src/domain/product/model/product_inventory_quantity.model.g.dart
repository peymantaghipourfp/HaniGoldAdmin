// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_inventory_quantity.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductInventoryQuantityModel _$ProductInventoryQuantityModelFromJson(
        Map<String, dynamic> json) =>
    ProductInventoryQuantityModel(
      item: json['item'] == null
          ? null
          : ItemModel.fromJson(json['item'] as Map<String, dynamic>),
      itemUnit: json['itemUnit'] == null
          ? null
          : ItemUnitModel.fromJson(json['itemUnit'] as Map<String, dynamic>),
      quantity: (json['quantity'] as num?)?.toDouble(),
      quantity750: (json['quantity750'] as num?)?.toDouble(),
      quantityCount: (json['quantityCount'] as num?)?.toDouble(),
      rowNum: (json['rowNum'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ProductInventoryQuantityModelToJson(
        ProductInventoryQuantityModel instance) =>
    <String, dynamic>{
      'item': instance.item,
      'itemUnit': instance.itemUnit,
      'quantity': instance.quantity,
      'quantity750': instance.quantity750,
      'quantityCount': instance.quantityCount,
      'rowNum': instance.rowNum,
    };
