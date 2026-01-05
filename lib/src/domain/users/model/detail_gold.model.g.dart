// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detail_gold.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DetailGoldModel _$DetailGoldModelFromJson(Map<String, dynamic> json) =>
    DetailGoldModel(
      quantity: (json['quantity'] as num?)?.toDouble(),
      weight: (json['weight'] as num?)?.toDouble(),
      carat: (json['carat'] as num?)?.toInt(),
      impurity: (json['impurity'] as num?)?.toInt(),
      receiptNumber: json['receiptNumber'] as String?,
      itemId: (json['itemId'] as num?)?.toInt(),
      itemName: json['itemName'] as String?,
      itemUnitId: (json['itemUnitId'] as num?)?.toInt(),
      itemUnitName: json['itemUnitName'] as String?,
      laboratoryId: (json['laboratoryId'] as num?)?.toInt(),
      name: json['name'] as String?,
    );

Map<String, dynamic> _$DetailGoldModelToJson(DetailGoldModel instance) =>
    <String, dynamic>{
      'quantity': instance.quantity,
      'weight': instance.weight,
      'carat': instance.carat,
      'impurity': instance.impurity,
      'receiptNumber': instance.receiptNumber,
      'itemId': instance.itemId,
      'itemName': instance.itemName,
      'itemUnitId': instance.itemUnitId,
      'itemUnitName': instance.itemUnitName,
      'laboratoryId': instance.laboratoryId,
      'name': instance.name,
    };
