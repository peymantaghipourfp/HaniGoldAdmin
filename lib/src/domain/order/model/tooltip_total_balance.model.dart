
import 'package:hanigold_admin/src/domain/account/model/account.model.dart';
import 'package:hanigold_admin/src/domain/remittance/model/balance.model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'tooltip_total_balance.model.g.dart';

List<TooltipTotalBalanceModel> tooltipTotalBalanceModelFromJson(String str) => List<TooltipTotalBalanceModel>.from(json.decode(str).map((x) => TooltipTotalBalanceModel.fromJson(x)));

String tooltipTotalBalanceModelToJson(List<TooltipTotalBalanceModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class TooltipTotalBalanceModel {
  @JsonKey(name: "account")
  final AccountModel? account;
  @JsonKey(name: "currencyValue")
  final double? currencyValue;
  @JsonKey(name: "goldValue")
  final double? goldValue;
  @JsonKey(name: "coinValue")
  final double? coinValue;
  @JsonKey(name: "balances")
  final List<BalanceModel>? balances;

  TooltipTotalBalanceModel({
    required this.account,
    required this.currencyValue,
    required this.goldValue,
    required this.coinValue,
    required this.balances,
  });

  factory TooltipTotalBalanceModel.fromJson(Map<String, dynamic> json) => _$TooltipTotalBalanceModelFromJson(json);

  Map<String, dynamic> toJson() => _$TooltipTotalBalanceModelToJson(this);
}