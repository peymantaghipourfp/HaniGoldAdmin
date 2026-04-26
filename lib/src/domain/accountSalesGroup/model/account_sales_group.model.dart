
import 'package:hanigold_admin/src/domain/accountSalesGroup/model/account_sales_group_item.model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'account_sales_group.model.g.dart';

List<AccountSalesGroupModel> accountSalesGroupModelFromJson(String str) => List<AccountSalesGroupModel>.from(json.decode(str).map((x) => AccountSalesGroupModel.fromJson(x)));

String accountSalesGroupModelToJson(List<AccountSalesGroupModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class AccountSalesGroupModel {
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "isDefault")
  final bool? isDefault;
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
  @JsonKey(name: "accountSalesGroupItems")
  final List<AccountSalesGroupItemModel>? accountSalesGroupItems;
  @JsonKey(name: "rowNum")
  final int? rowNum;
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "attribute")
  final String? attribute;
  @JsonKey(name: "recId")
  final String? recId;
  @JsonKey(name: "infos")
  final List<dynamic>? infos;
  @JsonKey(name: "accountCount")
  final int? accountCount;

  AccountSalesGroupModel({
    required this.name,
    required this.isDefault,
    required this.hasDeposit,
    required this.deposit,
    required this.hasBalance,
    required this.balance,
    required this.color,
    required this.accountSalesGroupItems,
    required this.rowNum,
    required this.id,
    required this.attribute,
    required this.recId,
    required this.infos,
    required this.accountCount,
  });

  factory AccountSalesGroupModel.fromJson(Map<String, dynamic> json) => _$AccountSalesGroupModelFromJson(json);

  Map<String, dynamic> toJson() => _$AccountSalesGroupModelToJson(this);
}