// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_result_day.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderResultDayModel _$OrderResultDayModelFromJson(Map<String, dynamic> json) =>
    OrderResultDayModel(
      tradeDate: json['tradeDate'] as String?,
      buyQty: (json['buyQty'] as num?)?.toDouble(),
      buyAmount: (json['buyAmount'] as num?)?.toDouble(),
      buyAvgPrice: (json['buyAvgPrice'] as num?)?.toDouble(),
      salesQty: (json['salesQty'] as num?)?.toDouble(),
      sellAmount: (json['sellAmount'] as num?)?.toDouble(),
      salesAvgPrice: (json['salesAvgPrice'] as num?)?.toDouble(),
      dailyBalanceQty: (json['dailyBalanceQty'] as num?)?.toDouble(),
      totalBalanceQty: (json['totalBalanceQty'] as num?)?.toDouble(),
      carryInBuyQty: (json['carryInBuyQty'] as num?)?.toDouble(),
      carryInBuyPrice: (json['carryInBuyPrice'] as num?)?.toDouble(),
      carryInSellQty: (json['carryInSellQty'] as num?)?.toDouble(),
      carryInSellPrice: (json['carryInSellPrice'] as num?)?.toDouble(),
      adjustedBuyAvgPrice: (json['adjustedBuyAvgPrice'] as num?)?.toDouble(),
      adjustedSalesAvgPrice:
          (json['adjustedSalesAvgPrice'] as num?)?.toDouble(),
      qtyForProfit: (json['qtyForProfit'] as num?)?.toDouble(),
      profit: (json['profit'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$OrderResultDayModelToJson(
        OrderResultDayModel instance) =>
    <String, dynamic>{
      'tradeDate': instance.tradeDate,
      'buyQty': instance.buyQty,
      'buyAmount': instance.buyAmount,
      'buyAvgPrice': instance.buyAvgPrice,
      'salesQty': instance.salesQty,
      'sellAmount': instance.sellAmount,
      'salesAvgPrice': instance.salesAvgPrice,
      'dailyBalanceQty': instance.dailyBalanceQty,
      'totalBalanceQty': instance.totalBalanceQty,
      'carryInBuyQty': instance.carryInBuyQty,
      'carryInBuyPrice': instance.carryInBuyPrice,
      'carryInSellQty': instance.carryInSellQty,
      'carryInSellPrice': instance.carryInSellPrice,
      'adjustedBuyAvgPrice': instance.adjustedBuyAvgPrice,
      'adjustedSalesAvgPrice': instance.adjustedSalesAvgPrice,
      'qtyForProfit': instance.qtyForProfit,
      'profit': instance.profit,
    };
