

import 'package:hanigold_admin/src/domain/remittance/model/balance.model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'transactions_wallet_receivables_item.model.g.dart';

TransactionsWalletReceivablesItemModel transactionsWalletReceivablesItemModelFromJson(String str) => TransactionsWalletReceivablesItemModel.fromJson(json.decode(str));

String transactionsWalletReceivablesItemModelToJson(TransactionsWalletReceivablesItemModel data) => json.encode(data.toJson());

@JsonSerializable()
class TransactionsWalletReceivablesItemModel {
  @JsonKey(name: "rowNum")
  final int? rowNum;
  @JsonKey(name: "accountId")
  final int? accountId;
  @JsonKey(name: "accountName")
  final String? accountName;
  @JsonKey(name: "goldInCurrency")
  final double? goldInCurrency;
  @JsonKey(name: "coinInCurrency")
  final double? coinInCurrency;
  @JsonKey(name: "currencyValue")
  final double? currencyValue;
  @JsonKey(name: "goldBalance")
  final double? goldBalance;
  @JsonKey(name: "halfCoinBalance")
  final double? halfCoinBalance;
  @JsonKey(name: "quarterCoinBalance")
  final double? quarterCoinBalance;
  @JsonKey(name: "goldValue")
  final double? goldValue;
  @JsonKey(name: "coinValue")
  final double? coinValue;
  @JsonKey(name: "afterGoldBalance")
  final double? afterGoldBalance;
  @JsonKey(name: "afterCashBalance")
  final double? afterCashBalance;
  @JsonKey(name: "balances")
  final List<BalanceModel>? balances;

  TransactionsWalletReceivablesItemModel({
    required this.rowNum,
    required this.accountId,
    required this.accountName,
    required this.goldInCurrency,
    required this.coinInCurrency,
    required this.currencyValue,
    required this.goldBalance,
    required this.halfCoinBalance,
    required this.quarterCoinBalance,
    required this.goldValue,
    required this.coinValue,
    required this.afterGoldBalance,
    required this.afterCashBalance,
    required this.balances,
  });

  factory TransactionsWalletReceivablesItemModel.fromJson(Map<String, dynamic> json) => _$TransactionsWalletReceivablesItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionsWalletReceivablesItemModelToJson(this);
}