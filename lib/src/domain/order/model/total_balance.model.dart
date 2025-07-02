import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'total_balance.model.g.dart';

List<TotalBalanceModel> totalBalanceModelFromJson(String str) => List<TotalBalanceModel>.from(json.decode(str).map((x) => TotalBalanceModel.fromJson(x)));

String totalBalanceModelToJson(List<TotalBalanceModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class TotalBalanceModel {
  @JsonKey(name: "itemName")
  final String? itemName;
  @JsonKey(name: "itemGroupName")
  final String? itemGroupName;
  @JsonKey(name: "unitName")
  final String? unitName;
  @JsonKey(name: "latestPrice")
  final double? latestPrice;
  @JsonKey(name: "sellQuantity")
  final double? sellQuantity;
  @JsonKey(name: "sellTotalPrice")
  final double? sellTotalPrice;
  @JsonKey(name: "sellAvgPricePerUnit")
  final double? sellAvgPricePerUnit;
  @JsonKey(name: "sellPercent")
  final double? sellPercent;
  @JsonKey(name: "buyQuantity")
  final double? buyQuantity;
  @JsonKey(name: "buyTotalPrice")
  final double? buyTotalPrice;
  @JsonKey(name: "buyAvgPricePerUnit")
  final double? buyAvgPricePerUnit;
  @JsonKey(name: "buyPercent")
  final double? buyPercent;
  @JsonKey(name: "totalBalanceQuantity")
  final double? totalBalanceQuantity;
  @JsonKey(name: "balanceQuantity")
  final double? balanceQuantity;
  @JsonKey(name: "avaragePridicate")
  final double? avaragePridicate;
  @JsonKey(name: "profit")
  final double? profit;

  TotalBalanceModel({
    required this.itemName,
    required this.itemGroupName,
    required this.unitName,
    required this.latestPrice,
    required this.sellQuantity,
    required this.sellTotalPrice,
    required this.sellAvgPricePerUnit,
    required this.sellPercent,
    required this.buyQuantity,
    required this.buyTotalPrice,
    required this.buyAvgPricePerUnit,
    required this.buyPercent,
    required this.totalBalanceQuantity,
    required this.balanceQuantity,
    required this.avaragePridicate,
    required this.profit,
  });

  factory TotalBalanceModel.fromJson(Map<String, dynamic> json) => _$TotalBalanceModelFromJson(json);

  Map<String, dynamic> toJson() => _$TotalBalanceModelToJson(this);
}
