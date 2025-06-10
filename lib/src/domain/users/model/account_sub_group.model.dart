// To parse this JSON data, do
//
//     final accountSubGroupModel = accountSubGroupModelFromJson(jsonString);

import 'package:hanigold_admin/src/domain/account/model/account.model.dart';
import 'package:hanigold_admin/src/domain/product/model/item_price.model.dart';
import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'account_sub_group.model.g.dart';

AccountSubGroupModel accountSubGroupModelFromJson(String str) => AccountSubGroupModel.fromJson(json.decode(str));

String accountSubGroupModelToJson(AccountSubGroupModel data) => json.encode(data.toJson());

@JsonSerializable()
class AccountSubGroupModel {
  @JsonKey(name: "account")
  final AccountModel? account;
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "deposit")
  final double? deposit;
  @JsonKey(name: "balance")
  final double? balance;
  @JsonKey(name: "chiledrenCount")
  final int? chiledrenCount;
  @JsonKey(name: "color")
  final String? color;
  @JsonKey(name: "itemPrices")
  final List<ItemPriceModel>? itemPrices;
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "infos")
  final List<dynamic>? infos;

  AccountSubGroupModel({
    required this.account,
    required this.name,
    required this.deposit,
    required this.balance,
    required this.chiledrenCount,
    required this.color,
    required this.itemPrices,
    required this.id,
    required this.infos,
  });

  factory AccountSubGroupModel.fromJson(Map<String, dynamic> json) => _$AccountSubGroupModelFromJson(json);

  Map<String, dynamic> toJson() => _$AccountSubGroupModelToJson(this);
}