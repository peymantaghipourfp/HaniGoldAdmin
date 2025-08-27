// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_info_footer.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionInfoFooterModel _$TransactionInfoFooterModelFromJson(
        Map<String, dynamic> json) =>
    TransactionInfoFooterModel(
      rowNum: (json['rowNum'] as num?)?.toInt(),
      itemId: (json['itemId'] as num?)?.toInt(),
      itemName: json['itemName'] as String?,
      unitName: json['unitName'] as String?,
      itemGroupName: json['itemGroupName'] as String?,
      totalPositiveBalance: (json['totalPositiveBalance'] as num?)?.toDouble(),
      totalPositiveValue: (json['totalPositiveValue'] as num?)?.toDouble(),
      totalNegativeBalance: (json['totalNegativeBalance'] as num?)?.toDouble(),
      totalNegativeValue: (json['totalNegativeValue'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$TransactionInfoFooterModelToJson(
        TransactionInfoFooterModel instance) =>
    <String, dynamic>{
      'rowNum': instance.rowNum,
      'itemId': instance.itemId,
      'itemName': instance.itemName,
      'unitName': instance.unitName,
      'itemGroupName': instance.itemGroupName,
      'totalPositiveBalance': instance.totalPositiveBalance,
      'totalPositiveValue': instance.totalPositiveValue,
      'totalNegativeBalance': instance.totalNegativeBalance,
      'totalNegativeValue': instance.totalNegativeValue,
    };
