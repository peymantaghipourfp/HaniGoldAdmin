// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'total_balance.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TotalBalanceModel _$TotalBalanceModelFromJson(Map<String, dynamic> json) =>
    TotalBalanceModel(
      itemName: json['itemName'] as String?,
      itemGroupName: json['itemGroupName'] as String?,
      unitName: json['unitName'] as String?,
      latestPrice: (json['latestPrice'] as num?)?.toDouble(),
      sellQuantity: (json['sellQuantity'] as num?)?.toDouble(),
      sellTotalPrice: (json['sellTotalPrice'] as num?)?.toDouble(),
      sellAvgPricePerUnit: (json['sellAvgPricePerUnit'] as num?)?.toDouble(),
      sellPercent: (json['sellPercent'] as num?)?.toDouble(),
      buyQuantity: (json['buyQuantity'] as num?)?.toDouble(),
      buyTotalPrice: (json['buyTotalPrice'] as num?)?.toDouble(),
      buyAvgPricePerUnit: (json['buyAvgPricePerUnit'] as num?)?.toDouble(),
      buyPercent: (json['buyPercent'] as num?)?.toDouble(),
      totalBalanceQuantity: (json['totalBalanceQuantity'] as num?)?.toDouble(),
      balanceQuantity: (json['balanceQuantity'] as num?)?.toDouble(),
      avaragePridicate: (json['avaragePridicate'] as num?)?.toDouble(),
      profit: (json['profit'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$TotalBalanceModelToJson(TotalBalanceModel instance) =>
    <String, dynamic>{
      'itemName': instance.itemName,
      'itemGroupName': instance.itemGroupName,
      'unitName': instance.unitName,
      'latestPrice': instance.latestPrice,
      'sellQuantity': instance.sellQuantity,
      'sellTotalPrice': instance.sellTotalPrice,
      'sellAvgPricePerUnit': instance.sellAvgPricePerUnit,
      'sellPercent': instance.sellPercent,
      'buyQuantity': instance.buyQuantity,
      'buyTotalPrice': instance.buyTotalPrice,
      'buyAvgPricePerUnit': instance.buyAvgPricePerUnit,
      'buyPercent': instance.buyPercent,
      'totalBalanceQuantity': instance.totalBalanceQuantity,
      'balanceQuantity': instance.balanceQuantity,
      'avaragePridicate': instance.avaragePridicate,
      'profit': instance.profit,
    };
