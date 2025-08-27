// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_inventory.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductInventoryModel _$ProductInventoryModelFromJson(
        Map<String, dynamic> json) =>
    ProductInventoryModel(
      item: json['item'] == null
          ? null
          : ItemModel.fromJson(json['item'] as Map<String, dynamic>),
      itemUnit: json['itemUnit'] == null
          ? null
          : ItemUnitModel.fromJson(json['itemUnit'] as Map<String, dynamic>),
      initBalance: (json['initBalance'] as num?)?.toDouble(),
      quantity: (json['quantity'] as num?)?.toDouble(),
      quantityIn: (json['quantityIn'] as num?)?.toDouble(),
      quantityOut: (json['quantityOut'] as num?)?.toDouble(),
      rowNum: (json['rowNum'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ProductInventoryModelToJson(
        ProductInventoryModel instance) =>
    <String, dynamic>{
      'item': instance.item,
      'itemUnit': instance.itemUnit,
      'initBalance': instance.initBalance,
      'quantity': instance.quantity,
      'quantityIn': instance.quantityIn,
      'quantityOut': instance.quantityOut,
      'rowNum': instance.rowNum,
    };
