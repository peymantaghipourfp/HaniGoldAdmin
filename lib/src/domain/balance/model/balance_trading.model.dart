import 'package:hanigold_admin/src/domain/balance/model/order_result_day.model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'balance_trading.model.g.dart';

List<BalanceTradingModel> balanceTradingModelFromJson(String str) => List<BalanceTradingModel>.from(json.decode(str).map((x) => BalanceTradingModel.fromJson(x)));

String balanceTradingModelToJson(List<BalanceTradingModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class BalanceTradingModel {
  @JsonKey(name: "itemName")
  final String? itemName;
  @JsonKey(name: "itemId")
  final int? itemId;
  @JsonKey(name: "unitName")
  final String? unitName;
  @JsonKey(name: "sumBuyQty")
  final double? sumBuyQty;
  @JsonKey(name: "sumBuyAmount")
  final double? sumBuyAmount;
  @JsonKey(name: "sumSalesQty")
  final double? sumSalesQty;
  @JsonKey(name: "sumSellAmount")
  final double? sumSellAmount;
  @JsonKey(name: "sumProfit")
  final double? sumProfit;
  @JsonKey(name: "totalBalanceQty")
  final double? totalBalanceQty;
  @JsonKey(name: "lastSellPrice")
  final double? lastSellPrice;
  @JsonKey(name: "lastBuyPrice")
  final double? lastBuyPrice;
  @JsonKey(name: "orderBalanceResultDays")
  final List<OrderResultDayModel>? orderBalanceResultDays;

  BalanceTradingModel({
    required this.itemName,
    required this.itemId,
    required this.unitName,
    required this.sumBuyQty,
    required this.sumBuyAmount,
    required this.sumSalesQty,
    required this.sumSellAmount,
    required this.sumProfit,
    required this.totalBalanceQty,
    required this.lastSellPrice,
    required this.lastBuyPrice,
    required this.orderBalanceResultDays,
  });

  factory BalanceTradingModel.fromJson(Map<String, dynamic> json) => _$BalanceTradingModelFromJson(json);

  Map<String, dynamic> toJson() => _$BalanceTradingModelToJson(this);
}
