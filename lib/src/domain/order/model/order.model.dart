

import 'package:hanigold_admin/src/domain/account/model/account.model.dart';
import 'package:hanigold_admin/src/domain/account/model/account_group.model.dart';
import 'package:hanigold_admin/src/domain/product/model/item.model.dart';
import 'package:hanigold_admin/src/domain/users/model/account_sub_group.model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'order.model.g.dart';

List<OrderModel> orderModelFromJson(String str) => List<OrderModel>.from(json.decode(str).map((x) => OrderModel.fromJson(x)));

String orderModelToJson(List<OrderModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class OrderModel {
  @JsonKey(name: "date")
  final DateTime? date;
  @JsonKey(name: "limitDate")
  final DateTime? limitDate;
  @JsonKey(name: "account")
  final AccountModel? account;
  @JsonKey(name: "type")
  final int? type;
  @JsonKey(name: "mode")
  final int? mode;
  @JsonKey(name: "item")
  final ItemModel? item;
  @JsonKey(name: "quantity")
  final double? quantity;
  @JsonKey(name: "price")
  final double? price;
  @JsonKey(name: "differentPrice")
  final double? differentPrice;
  @JsonKey(name: "totalPrice")
  final double? totalPrice;
  @JsonKey(name: "status")
  final int? status;
  @JsonKey(name: "balances")
  final List<Balance>? balances;
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
  @JsonKey(name: "limitPrice")
  final double? limitPrice;
  @JsonKey(name: "description")
  final String? description;
  @JsonKey(name: "registered")
  final bool? registered;
  @JsonKey(name: "notLimit")
  final bool? notLimit;
  @JsonKey(name: "manualPrice")
  final bool? manualPrice;
  @JsonKey(name: "accountParent")
  AccountParent? accountParent;
  @JsonKey(name: "extraAmount")
  final double? extraAmount;

  OrderModel({
    required this.date,
    required this.limitDate,
    required this.account,
    required this.type,
    required this.mode,
    required this.item,
    required this.quantity,
    required this.price,
    required this.differentPrice,
    required this.totalPrice,
    required this.status,
    required this.balances,
    required this.rowNum,
    required this.id,
    required this.attribute,
    required this.recId,
    required this.infos,
    required this.limitPrice,
    required this.description,
    required this.registered,
    required this.notLimit,
    required this.manualPrice,
    required this.accountParent,
    required this.extraAmount,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => _$OrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderModelToJson(this);
}

@JsonSerializable()
class Balance {
  @JsonKey(name: "balance")
  final double? balance;
  @JsonKey(name: "itemName")
  final String? itemName;
  @JsonKey(name: "unitName")
  final String? unitName;

  Balance({
    required this.balance,
    required this.itemName,
    required this.unitName,
  });

  factory Balance.fromJson(Map<String, dynamic> json) => _$BalanceFromJson(json);

  Map<String, dynamic> toJson() => _$BalanceToJson(this);
}

@JsonSerializable()
class AccountParent {
  @JsonKey(name: "code")
  final String? code;
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "contactInfo")
  final String? contactInfo;
  @JsonKey(name: "accountGroup")
  final AccountGroupModel? accountGroup;
  @JsonKey(name: "accountSubGroup")
  final AccountSubGroupModel? accountSubGroup;
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "infos")
  final List<dynamic>? infos;

  AccountParent({
    required this.code,
    required this.name,
    required this.contactInfo,
    required this.accountGroup,
    required this.accountSubGroup,
    required this.id,
    required this.infos,
  });

  factory AccountParent.fromJson(Map<String, dynamic> json) => _$AccountParentFromJson(json);

  Map<String, dynamic> toJson() => _$AccountParentToJson(this);
}