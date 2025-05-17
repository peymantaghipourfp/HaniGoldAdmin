// To parse this JSON data, do
//
//     final balanceTradingModel = balanceTradingModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'balance_trading_item.model.g.dart';


@JsonSerializable()
class BalanceTradingItemModel {
  @JsonKey(name: "itemName")
  final String? itemName;
  @JsonKey(name: "unitName")
  final String? unitName;
  @JsonKey(name: "type")
  final String? type;
  @JsonKey(name: "w750")
  final int? w750;
  @JsonKey(name: "latestPrice")
  final int? latestPrice;
  @JsonKey(name: "netQuantity")
  final int? netQuantity;
  @JsonKey(name: "netTotalPrice")
  final int? netTotalPrice;
  @JsonKey(name: "avgPricePerUnit")
  final int? avgPricePerUnit;
  @JsonKey(name: "predicatePrice")
  final int? predicatePrice;
  @JsonKey(name: "profitAndLoss")
  final int? profitAndLoss;
  @JsonKey(name: "realProfitAndLoss")
  final int? realProfitAndLoss;

  BalanceTradingItemModel({
    required this.itemName,
    required this.unitName,
    required this.type,
    required this.w750,
    required this.latestPrice,
    required this.netQuantity,
    required this.netTotalPrice,
    required this.avgPricePerUnit,
    required this.predicatePrice,
    required this.profitAndLoss,
    required this.realProfitAndLoss,
  });

  factory BalanceTradingItemModel.fromJson(Map<String, dynamic> json) => _$BalanceTradingItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$BalanceTradingItemModelToJson(this);
}
