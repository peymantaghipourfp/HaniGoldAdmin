// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'balance_trading_item.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BalanceTradingItemModel _$BalanceTradingItemModelFromJson(
        Map<String, dynamic> json) =>
    BalanceTradingItemModel(
      itemName: json['itemName'] as String?,
      unitName: json['unitName'] as String?,
      type: json['type'] as String?,
      w750: (json['w750'] as num?)?.toInt(),
      latestPrice: (json['latestPrice'] as num?)?.toInt(),
      netQuantity: (json['netQuantity'] as num?)?.toInt(),
      netTotalPrice: (json['netTotalPrice'] as num?)?.toInt(),
      avgPricePerUnit: (json['avgPricePerUnit'] as num?)?.toInt(),
      predicatePrice: (json['predicatePrice'] as num?)?.toInt(),
      profitAndLoss: (json['profitAndLoss'] as num?)?.toInt(),
      realProfitAndLoss: (json['realProfitAndLoss'] as num?)?.toInt(),
    );

Map<String, dynamic> _$BalanceTradingItemModelToJson(
        BalanceTradingItemModel instance) =>
    <String, dynamic>{
      'itemName': instance.itemName,
      'unitName': instance.unitName,
      'type': instance.type,
      'w750': instance.w750,
      'latestPrice': instance.latestPrice,
      'netQuantity': instance.netQuantity,
      'netTotalPrice': instance.netTotalPrice,
      'avgPricePerUnit': instance.avgPricePerUnit,
      'predicatePrice': instance.predicatePrice,
      'profitAndLoss': instance.profitAndLoss,
      'realProfitAndLoss': instance.realProfitAndLoss,
    };
