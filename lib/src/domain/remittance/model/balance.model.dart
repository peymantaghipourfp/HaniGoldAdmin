// To parse this JSON data, do
//
//     final balanceModel = balanceModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

BalanceModel balanceModelFromJson(String str) => BalanceModel.fromJson(json.decode(str));

String balanceModelToJson(BalanceModel data) => json.encode(data.toJson());

class BalanceModel {
  final double? balance;
  final String? itemName;
  final String? unitName;

  BalanceModel({
    required this.balance,
    required this.itemName,
    required this.unitName,
  });

  factory BalanceModel.fromJson(Map<String, dynamic> json) => BalanceModel(
    balance: json["balance"],
    itemName: json["itemName"],
    unitName: json["unitName"],
  );

  Map<String, dynamic> toJson() => {
    "balance": balance,
    "itemName": itemName,
    "unitName": unitName,
  };
}
