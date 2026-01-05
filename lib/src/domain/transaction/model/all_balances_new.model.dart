import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'all_balances_new.model.g.dart';

AllBalancesNewModel allBalancesNewModelFromJson(String str) => AllBalancesNewModel.fromJson(json.decode(str));

String allBalancesNewModelToJson(AllBalancesNewModel data) => json.encode(data.toJson());

@JsonSerializable()
class AllBalancesNewModel {
  @JsonKey(name: "totalValue")
  final double? totalValue;
  @JsonKey(name: "balances")
  final List<BalanceModel>? balances;

  AllBalancesNewModel({
    required this.totalValue,
    required this.balances,
  });

  factory AllBalancesNewModel.fromJson(Map<String, dynamic> json) => _$AllBalancesNewModelFromJson(json);

  Map<String, dynamic> toJson() => _$AllBalancesNewModelToJson(this);
}

@JsonSerializable()
class BalanceModel {
  @JsonKey(name: "balance")
  final double? balance;
  @JsonKey(name: "itemName")
  final String? itemName;
  @JsonKey(name: "unitName")
  final String? unitName;

  BalanceModel({
    required this.balance,
    required this.itemName,
    required this.unitName,
  });

  factory BalanceModel.fromJson(Map<String, dynamic> json) => _$BalanceModelFromJson(json);

  Map<String, dynamic> toJson() => _$BalanceModelToJson(this);
}