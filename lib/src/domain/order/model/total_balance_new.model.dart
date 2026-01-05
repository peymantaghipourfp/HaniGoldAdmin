
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'total_balance_new.model.g.dart';

List<TotalBalanceNewModel> totalBalanceNewModelFromJson(String str) => List<TotalBalanceNewModel>.from(json.decode(str).map((x) => TotalBalanceNewModel.fromJson(x)));

String totalBalanceNewModelToJson(List<TotalBalanceNewModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class TotalBalanceNewModel {
  @JsonKey(name: "tradeDate")
  final String? tradeDate;
  @JsonKey(name: "itemGroupName")
  final String? itemGroupName;
  @JsonKey(name: "itemName")
  final String? itemName;
  @JsonKey(name: "itemId")
  final int? itemId;
  @JsonKey(name: "unitName")
  final String? unitName;
  @JsonKey(name: "buyQty")
  final double? buyQty;
  @JsonKey(name: "buyAmount")
  final double? buyAmount;
  @JsonKey(name: "buyAvgPrice")
  final double? buyAvgPrice;
  @JsonKey(name: "salesQty")
  final double? salesQty;
  @JsonKey(name: "sellAmount")
  final double? sellAmount;
  @JsonKey(name: "salesAvgPrice")
  final double? salesAvgPrice;
  @JsonKey(name: "dailyBalanceQty")
  final double? dailyBalanceQty;
  @JsonKey(name: "totalBalanceQty")
  final double? totalBalanceQty;
  @JsonKey(name: "carryInBuyQty")
  final double? carryInBuyQty;
  @JsonKey(name: "carryInBuyPrice")
  final double? carryInBuyPrice;
  @JsonKey(name: "carryInSellQty")
  final double? carryInSellQty;
  @JsonKey(name: "carryInSellPrice")
  final double? carryInSellPrice;
  @JsonKey(name: "carryInQty")
  final double? carryInQty;
  @JsonKey(name: "carryInPrice")
  final double? carryInPrice;
  @JsonKey(name: "carryInBuyTotal")
  final double? carryInBuyTotal;
  @JsonKey(name: "carryInSellTotal")
  final double? carryInSellTotal;
  @JsonKey(name: "previousCarryPrice")
  final double? previousCarryPrice;
  @JsonKey(name: "adjustedBuyAvgPrice")
  final double? adjustedBuyAvgPrice;
  @JsonKey(name: "adjustedSalesAvgPrice")
  final double? adjustedSalesAvgPrice;
  @JsonKey(name: "qtyForProfit")
  final double? qtyForProfit;
  @JsonKey(name: "profit")
  final double? profit;

  TotalBalanceNewModel({
    required this.tradeDate,
    required this.itemGroupName,
    required this.itemName,
    required this.itemId,
    required this.unitName,
    required this.buyQty,
    required this.buyAmount,
    required this.buyAvgPrice,
    required this.salesQty,
    required this.sellAmount,
    required this.salesAvgPrice,
    required this.dailyBalanceQty,
    required this.totalBalanceQty,
    required this.carryInBuyQty,
    required this.carryInBuyPrice,
    required this.carryInSellQty,
    required this.carryInSellPrice,
    required this.carryInQty,
    required this.carryInPrice,
    required this.carryInBuyTotal,
    required this.carryInSellTotal,
    required this.previousCarryPrice,
    required this.adjustedBuyAvgPrice,
    required this.adjustedSalesAvgPrice,
    required this.qtyForProfit,
    required this.profit,
  });

  factory TotalBalanceNewModel.fromJson(Map<String, dynamic> json) => _$TotalBalanceNewModelFromJson(json);

  Map<String, dynamic> toJson() => _$TotalBalanceNewModelToJson(this);
}
