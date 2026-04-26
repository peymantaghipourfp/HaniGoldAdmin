// To parse this JSON data, do
//
//     final listTransactionInfoItemModel = listTransactionInfoItemModelFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

import '../../remittance/model/balance.model.dart';

part 'list_transaction_info_item.model.g.dart';

ListTransactionInfoItemModel listTransactionInfoItemModelFromJson(String str) => ListTransactionInfoItemModel.fromJson(json.decode(str));

String listTransactionInfoItemModelToJson(ListTransactionInfoItemModel data) => json.encode(data.toJson());

@JsonSerializable()
class ListTransactionInfoItemModel {
  @JsonKey(name: "accountId")
  final int? accountId;
  @JsonKey(name: "accountName")
  final String? accountName;
  @JsonKey(name: "currencyValueBES")
  final double? currencyValueBes;
  @JsonKey(name: "currencyValueBED")
  final double? currencyValueBed;
  @JsonKey(name: "goldBalanceBES")
  final double? goldBalanceBes;
  @JsonKey(name: "goldBalanceBED")
  final double? goldBalanceBed;
  @JsonKey(name: "coinBalanceBES")
  final double? coinBalanceBes;
  @JsonKey(name: "coinBalanceBED")
  final double? coinBalanceBed;
  @JsonKey(name: "halfCoinBalanceBES")
  final double? halfCoinBalanceBes;
  @JsonKey(name: "halfCoinBalanceBED")
  final double? halfCoinBalanceBed;
  @JsonKey(name: "quarterCoinBalanceBES")
  final double? quarterCoinBalanceBes;
  @JsonKey(name: "quarterCoinBalanceBED")
  final double? quarterCoinBalanceBed;
  @JsonKey(name: "cashBalanceBES")
  final double? cashBalanceBes;
  @JsonKey(name: "cashBalanceBED")
  final double? cashBalanceBed;
  @JsonKey(name: "goldValue")
  final double? goldValue;
  @JsonKey(name: "coinValue")
  final double? coinValue;
  @JsonKey(name: "afterGoldBalance")
  final double? afterGoldBalance;
  @JsonKey(name: "afterCashBalance")
  final double? afterCashBalance;
  @JsonKey(name: "rowNum")
  final int? rowNum;
  @JsonKey(name: "balances")
  final List<BalanceModel>? balances;

  ListTransactionInfoItemModel({
    required this.accountId,
    required this.accountName,
    required this.currencyValueBes,
    required this.currencyValueBed,
    required this.goldBalanceBes,
    required this.goldBalanceBed,
    required this.coinBalanceBes,
    required this.coinBalanceBed,
    required this.halfCoinBalanceBes,
    required this.halfCoinBalanceBed,
    required this.quarterCoinBalanceBes,
    required this.quarterCoinBalanceBed,
    required this.cashBalanceBes,
    required this.cashBalanceBed,
    required this.goldValue,
    required this.coinValue,
    required this.afterGoldBalance,
    required this.afterCashBalance,
    required this.rowNum,
    required this.balances,
  });

  factory ListTransactionInfoItemModel.fromJson(Map<String, dynamic> json) => _$ListTransactionInfoItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$ListTransactionInfoItemModelToJson(this);
}
