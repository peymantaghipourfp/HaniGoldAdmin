// To parse this JSON data, do
//
//     final balanceItemModel = balanceItemModelFromJson(jsonString);

import 'package:hanigold_admin/src/domain/account/model/account.model.dart';
import 'package:hanigold_admin/src/domain/product/model/item.model.dart';
import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'balance_item.model.g.dart';

BalanceItemModel balanceItemModelFromJson(String str) => BalanceItemModel.fromJson(json.decode(str));

String balanceItemModelToJson(BalanceItemModel data) => json.encode(data.toJson());

@JsonSerializable()
class BalanceItemModel {
  @JsonKey(name: "type")
  final int? type;
  @JsonKey(name: "address")
  final String? address;
  @JsonKey(name: "account")
  final AccountModel? account;
  @JsonKey(name: "item")
  final ItemModel? item;
  @JsonKey(name: "balance")
  final double? balance;
  @JsonKey(name: "isMainCurrency")
  final bool? isMainCurrency;
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "infos")
  final List<dynamic>? infos;

  BalanceItemModel({
    required this.type,
    required this.address,
    required this.account,
    required this.item,
    required this.balance,
    required this.isMainCurrency,
    required this.id,
    required this.infos,
  });

  factory BalanceItemModel.fromJson(Map<String, dynamic> json) => _$BalanceItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$BalanceItemModelToJson(this);
}