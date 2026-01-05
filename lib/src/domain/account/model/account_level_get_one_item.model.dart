import 'package:hanigold_admin/src/domain/account/model/account_level_item.model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'account_level_get_one_item.model.g.dart';

AccountLevelGetOneItemModel accountLevelGetOneItemModelFromJson(String str) => AccountLevelGetOneItemModel.fromJson(json.decode(str));

String accountLevelGetOneItemModelToJson(AccountLevelGetOneItemModel data) => json.encode(data.toJson());

@JsonSerializable()
class AccountLevelGetOneItemModel {
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "balance")
  final double? balance;
  @JsonKey(name: "positiveGold")
  final double? positiveGold;
  @JsonKey(name: "negativeGold")
  final double? negativeGold;
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

  AccountLevelGetOneItemModel({
    required this.name,
    required this.balance,
    required this.positiveGold,
    required this.negativeGold,
    required this.accountLevelItems,
    required this.rowNum,
    required this.id,
    required this.attribute,
    required this.recId,
    required this.infos,
  });

  factory AccountLevelGetOneItemModel.fromJson(Map<String, dynamic> json) => _$AccountLevelGetOneItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$AccountLevelGetOneItemModelToJson(this);
}