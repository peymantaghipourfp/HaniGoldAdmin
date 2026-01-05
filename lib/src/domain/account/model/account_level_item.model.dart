import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'account_level_item.model.g.dart';

List<AccountLevelItemModel> accountLevelItemModelFromJson(String str) => List<AccountLevelItemModel>.from(json.decode(str).map((x) => AccountLevelItemModel.fromJson(x)));

String accountLevelItemModelToJson(List<AccountLevelItemModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class AccountLevelItemModel {
  @JsonKey(name: "accountLevelId")
  final int? accountLevelId;
  @JsonKey(name: "itemId")
  final int? itemId;
  @JsonKey(name: "itemName")
  final String? itemName;
  @JsonKey(name: "itemIcon")
  final String? itemIcon;
  @JsonKey(name: "maxSell")
  final double? maxSell;
  @JsonKey(name: "maxBuy")
  final double? maxBuy;
  @JsonKey(name: "rowNum")
  final int? rowNum;
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "recId")
  final String? recId;
  @JsonKey(name: "infos")
  final List<dynamic>? infos;

  AccountLevelItemModel({
    required this.accountLevelId,
    required this.itemId,
    required this.itemName,
    required this.itemIcon,
    required this.maxSell,
    required this.maxBuy,
    required this.rowNum,
    required this.id,
    required this.recId,
    required this.infos,
  });

  factory AccountLevelItemModel.fromJson(Map<String, dynamic> json) => _$AccountLevelItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$AccountLevelItemModelToJson(this);
}