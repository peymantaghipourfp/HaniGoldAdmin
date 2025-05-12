// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_info_detail_item.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionInfoDetailItemModel _$TransactionInfoDetailItemModelFromJson(
        Map<String, dynamic> json) =>
    TransactionInfoDetailItemModel(
      id: (json['id'] as num?)?.toInt(),
      quantity: (json['quantity'] as num?)?.toDouble(),
      weight: (json['weight'] as num?)?.toDouble(),
      carat: (json['carat'] as num?)?.toInt(),
      impurity: (json['impurity'] as num?)?.toInt(),
      receiptNumber: json['receiptNumber'] as String?,
      itemId: (json['itemId'] as num?)?.toInt(),
      itemName: json['itemName'] as String?,
      itemUnitId: (json['itemUnitId'] as num?)?.toInt(),
      itemUnitName: json['itemUnitName'] as String?,
      walletId: (json['walletId'] as num?)?.toInt(),
      walletAddress: json['walletAddress'] as String?,
      description: json['description'] as String?,
      laboratoryId: (json['laboratoryId'] as num?)?.toInt(),
      laboratoryName: json['name'] as String?,
    );

Map<String, dynamic> _$TransactionInfoDetailItemModelToJson(
        TransactionInfoDetailItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quantity': instance.quantity,
      'weight': instance.weight,
      'carat': instance.carat,
      'impurity': instance.impurity,
      'receiptNumber': instance.receiptNumber,
      'itemId': instance.itemId,
      'itemName': instance.itemName,
      'itemUnitId': instance.itemUnitId,
      'itemUnitName': instance.itemUnitName,
      'walletId': instance.walletId,
      'walletAddress': instance.walletAddress,
      'description': instance.description,
      'laboratoryId': instance.laboratoryId,
      'name': instance.laboratoryName,
    };
