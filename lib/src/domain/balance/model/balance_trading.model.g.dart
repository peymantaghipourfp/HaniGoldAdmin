// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'balance_trading.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BalanceTradingModel _$BalanceTradingModelFromJson(Map<String, dynamic> json) =>
    BalanceTradingModel(
      itemName: json['itemName'] as String?,
      itemId: (json['itemId'] as num?)?.toInt(),
      unitName: json['unitName'] as String?,
      sumBuyQty: (json['sumBuyQty'] as num?)?.toDouble(),
      sumBuyAmount: (json['sumBuyAmount'] as num?)?.toDouble(),
      sumSalesQty: (json['sumSalesQty'] as num?)?.toDouble(),
      sumSellAmount: (json['sumSellAmount'] as num?)?.toDouble(),
      sumProfit: (json['sumProfit'] as num?)?.toDouble(),
      totalBalanceQty: (json['totalBalanceQty'] as num?)?.toDouble(),
      lastSellPrice: (json['lastSellPrice'] as num?)?.toDouble(),
      lastBuyPrice: (json['lastBuyPrice'] as num?)?.toDouble(),
      orderBalanceResultDays: (json['orderBalanceResultDays'] as List<dynamic>?)
          ?.map((e) => OrderResultDayModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BalanceTradingModelToJson(
        BalanceTradingModel instance) =>
    <String, dynamic>{
      'itemName': instance.itemName,
      'itemId': instance.itemId,
      'unitName': instance.unitName,
      'sumBuyQty': instance.sumBuyQty,
      'sumBuyAmount': instance.sumBuyAmount,
      'sumSalesQty': instance.sumSalesQty,
      'sumSellAmount': instance.sumSellAmount,
      'sumProfit': instance.sumProfit,
      'totalBalanceQty': instance.totalBalanceQty,
      'lastSellPrice': instance.lastSellPrice,
      'lastBuyPrice': instance.lastBuyPrice,
      'orderBalanceResultDays': instance.orderBalanceResultDays,
    };
