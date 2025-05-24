

import 'package:hanigold_admin/src/domain/account/model/account.model.dart';
import 'package:hanigold_admin/src/domain/inventory/model/inventory_detail.model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'inventory.model.g.dart';

InventoryModel inventoryModelFromJson(String str) => InventoryModel.fromJson(json.decode(str));

String inventoryModelToJson(InventoryModel data) => json.encode(data.toJson());

@JsonSerializable()
class InventoryModel {
  @JsonKey(name: "date")
  final DateTime? date;
  @JsonKey(name: "account")
  final AccountModel? account;
  @JsonKey(name: "type")
  final int? type;
  @JsonKey(name: "isDeleted")
  final bool? isDeleted;
  @JsonKey(name: "inventoryDetails")
  final List<InventoryDetailModel>? inventoryDetails;
  @JsonKey(name: "rowNum")
  final int? rowNum;
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "attribute")
  final String? attribute;
  @JsonKey(name: "createdOn")
  final DateTime? createdOn;
  @JsonKey(name: "modifiedOn")
  final DateTime? modifiedOn;
  @JsonKey(name: "recId")
  final String? recId;
  @JsonKey(name: "infos")
  final List<dynamic>? infos;
  @JsonKey(name: "description")
  final String? description;
  @JsonKey(name: "inventoryDetailsCount")
  final int? inventoryDetailsCount;
  @JsonKey(name: "balances")
  final List<Balance>? balances;
  @JsonKey(name: "registered")
  final bool? registered;

  InventoryModel({
    required this.date,
    required this.account,
    required this.type,
    required this.isDeleted,
    required this.inventoryDetails,
    required this.rowNum,
    required this.id,
    required this.attribute,
    required this.createdOn,
    required this.modifiedOn,
    required this.recId,
    required this.infos,
    required this.description,
    required this.inventoryDetailsCount,
    required this.balances,
    required this.registered
  });

  factory InventoryModel.fromJson(Map<String, dynamic> json) => _$InventoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$InventoryModelToJson(this);
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
