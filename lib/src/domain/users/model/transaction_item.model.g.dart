// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_item.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionItemModel _$TransactionItemModelFromJson(
        Map<String, dynamic> json) =>
    TransactionItemModel(
      itemName: json['itemName'] as String?,
      groupName: json['groupName'] as String?,
      type: json['type'] as String?,
      transactionCount: (json['transactionCount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TransactionItemModelToJson(
        TransactionItemModel instance) =>
    <String, dynamic>{
      'itemName': instance.itemName,
      'groupName': instance.groupName,
      'type': instance.type,
      'transactionCount': instance.transactionCount,
    };
