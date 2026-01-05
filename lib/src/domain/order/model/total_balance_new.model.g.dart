// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'total_balance_new.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TotalBalanceNewModel _$TotalBalanceNewModelFromJson(
        Map<String, dynamic> json) =>
    TotalBalanceNewModel(
      tradeDate: json['tradeDate'] as String?,
      itemGroupName: json['itemGroupName'] as String?,
      itemName: json['itemName'] as String?,
      itemId: (json['itemId'] as num?)?.toInt(),
      unitName: json['unitName'] as String?,
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
      carryInQty: (json['carryInQty'] as num?)?.toDouble(),
      carryInPrice: (json['carryInPrice'] as num?)?.toDouble(),
      carryInBuyTotal: (json['carryInBuyTotal'] as num?)?.toDouble(),
      carryInSellTotal: (json['carryInSellTotal'] as num?)?.toDouble(),
      previousCarryPrice: (json['previousCarryPrice'] as num?)?.toDouble(),
      adjustedBuyAvgPrice: (json['adjustedBuyAvgPrice'] as num?)?.toDouble(),
      adjustedSalesAvgPrice:
          (json['adjustedSalesAvgPrice'] as num?)?.toDouble(),
      qtyForProfit: (json['qtyForProfit'] as num?)?.toDouble(),
      profit: (json['profit'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$TotalBalanceNewModelToJson(
        TotalBalanceNewModel instance) =>
    <String, dynamic>{
      'tradeDate': instance.tradeDate,
      'itemGroupName': instance.itemGroupName,
      'itemName': instance.itemName,
      'itemId': instance.itemId,
      'unitName': instance.unitName,
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
      'carryInQty': instance.carryInQty,
      'carryInPrice': instance.carryInPrice,
      'carryInBuyTotal': instance.carryInBuyTotal,
      'carryInSellTotal': instance.carryInSellTotal,
      'previousCarryPrice': instance.previousCarryPrice,
      'adjustedBuyAvgPrice': instance.adjustedBuyAvgPrice,
      'adjustedSalesAvgPrice': instance.adjustedSalesAvgPrice,
      'qtyForProfit': instance.qtyForProfit,
      'profit': instance.profit,
    };
