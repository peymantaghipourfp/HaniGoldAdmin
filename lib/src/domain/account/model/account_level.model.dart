
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

import 'account_level_item.model.dart';

part 'account_level.model.g.dart';

List<AccountLevelModel> accountLevelModelFromJson(String str) => List<AccountLevelModel>.from(json.decode(str).map((x) => AccountLevelModel.fromJson(x)));

String accountLevelModelToJson(List<AccountLevelModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class AccountLevelModel {
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "balance")
  final double? balance;
  @JsonKey(name: "positiveGold")
  final double? positiveGold;
  @JsonKey(name: "negativeGold")
  final double? negativeGold;
  @JsonKey(name: "levelCredit")
  final double? levelCredit;
  @JsonKey(name: "accountLevelItems")
  final List<AccountLevelItemModel>? accountLevelItems;
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

  AccountLevelModel({
    required this.name,
    required this.balance,
    required this.positiveGold,
    required this.negativeGold,
    required this.levelCredit,
    required this.accountLevelItems,
    required this.rowNum,
    required this.id,
    required this.attribute,
    required this.recId,
    required this.infos,
    required this.accountCount,
  });

  factory AccountLevelModel.fromJson(Map<String, dynamic> json) => _$AccountLevelModelFromJson(json);

  Map<String, dynamic> toJson() => _$AccountLevelModelToJson(this);
}