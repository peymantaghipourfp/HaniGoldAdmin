
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'order_result_day.model.g.dart';

List<OrderResultDayModel> orderResultDayModelFromJson(String str) => List<OrderResultDayModel>.from(json.decode(str).map((x) => OrderResultDayModel.fromJson(x)));

String orderResultDayModelToJson(List<OrderResultDayModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class OrderResultDayModel {
  @JsonKey(name: "tradeDate")
  final String? tradeDate;
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
  @JsonKey(name: "adjustedBuyAvgPrice")
  final double? adjustedBuyAvgPrice;
  @JsonKey(name: "adjustedSalesAvgPrice")
  final double? adjustedSalesAvgPrice;
  @JsonKey(name: "qtyForProfit")
  final double? qtyForProfit;
  @JsonKey(name: "profit")
  final double? profit;

  OrderResultDayModel({
    required this.tradeDate,
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
    required this.adjustedBuyAvgPrice,
    required this.adjustedSalesAvgPrice,
    required this.qtyForProfit,
    required this.profit,
  });

  factory OrderResultDayModel.fromJson(Map<String, dynamic> json) => _$OrderResultDayModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderResultDayModelToJson(this);
}