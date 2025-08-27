// To parse this JSON data, do
//
//     final balanceTradingModel = balanceTradingModelFromJson(jsonString);

import 'package:hanigold_admin/src/domain/balance/model/balance_trading_item.model.dart';
import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'balance_trading.model.g.dart';

BalanceTradingModel balanceTradingModelFromJson(String str) => BalanceTradingModel.fromJson(json.decode(str));

String balanceTradingModelToJson(BalanceTradingModel data) => json.encode(data.toJson());

@JsonSerializable()
class BalanceTradingModel {
  @JsonKey(name: "itemGroup")
  final String? itemGroup;
  @JsonKey(name: "dateName")
  final String? dateName;
  @JsonKey(name: "startDate")
  final String? startDate;
  @JsonKey(name: "endDate")
  final String? endDate;
  @JsonKey(name: "balances")
  final List<BalanceTradingItemModel>? balances;

  BalanceTradingModel({
    required this.itemGroup,
    required this.dateName,
    required this.startDate,
    required this.endDate,
    required this.balances,
  });

  factory BalanceTradingModel.fromJson(Map<String, dynamic> json) => _$BalanceTradingModelFromJson(json);

  Map<String, dynamic> toJson() => _$BalanceTradingModelToJson(this);
}
