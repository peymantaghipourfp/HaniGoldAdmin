import 'package:hanigold_admin/src/domain/accountSalesGroup/model/account_sales_group_item.model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'account_sales_group_get_one_item.model.g.dart';

AccountSalesGroupGetOneItemModel accountSalesGroupGetOneItemModelFromJson(String str) => AccountSalesGroupGetOneItemModel.fromJson(json.decode(str));

String accountSalesGroupGetOneItemModelToJson(AccountSalesGroupGetOneItemModel data) => json.encode(data.toJson());

@JsonSerializable()
class AccountSalesGroupGetOneItemModel {
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "hasDeposit")
  final bool? hasDeposit;
  @JsonKey(name: "deposit")
  final double? deposit;
  @JsonKey(name: "hasBalance")
  final bool? hasBalance;
  @JsonKey(name: "balance")
  final double? balance;
  @JsonKey(name: "color")
  final String? color;
  @JsonKey(name: "chiledrenCount")
  final int? chiledrenCount;
  @JsonKey(name: "accountSalesGroupItems")
  final List<AccountSalesGroupItemModel>? accountSalesGroupItems;
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "infos")
  final List<dynamic>? infos;

  AccountSalesGroupGetOneItemModel({
    required this.name,
    required this.hasDeposit,
    required this.deposit,
    required this.hasBalance,
    required this.balance,
    required this.color,
    required this.chiledrenCount,
    required this.accountSalesGroupItems,
    required this.id,
    required this.infos,
  });

  factory AccountSalesGroupGetOneItemModel.fromJson(Map<String, dynamic> json) => _$AccountSalesGroupGetOneItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$AccountSalesGroupGetOneItemModelToJson(this);
}