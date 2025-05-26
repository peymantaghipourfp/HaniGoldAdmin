// To parse this JSON data, do
//
//     final listTransactionInfoItemModel = listTransactionInfoItemModelFromJson(jsonString);

import 'package:hanigold_admin/src/domain/users/model/balance_item.model.dart';
import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

import '../../remittance/model/balance.model.dart';

part 'list_transaction_info_item.model.g.dart';

ListTransactionInfoItemModel listTransactionInfoItemModelFromJson(String str) => ListTransactionInfoItemModel.fromJson(json.decode(str));

String listTransactionInfoItemModelToJson(ListTransactionInfoItemModel data) => json.encode(data.toJson());

@JsonSerializable()
class ListTransactionInfoItemModel {
  @JsonKey(name: "accountId")
  final int accountId;
  @JsonKey(name: "accountName")
  final String accountName;
  @JsonKey(name: "currencyValue")
  final double currencyValue;
  @JsonKey(name: "goldValue")
  final double goldValue;
  @JsonKey(name: "coinValue")
  final double coinValue;
  @JsonKey(name: "rowNum")
  final int rowNum;
  @JsonKey(name: "balances")
  final List<BalanceModel> balances;

  ListTransactionInfoItemModel({
    required this.accountId,
    required this.accountName,
    required this.currencyValue,
    required this.rowNum,
    required this.goldValue,
    required this.coinValue,
    required this.balances,
  });

  factory ListTransactionInfoItemModel.fromJson(Map<String, dynamic> json) => _$ListTransactionInfoItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$ListTransactionInfoItemModelToJson(this);
}
