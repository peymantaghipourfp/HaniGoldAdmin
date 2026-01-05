import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'account_sales_group_item.model.g.dart';

List<AccountSalesGroupItemModel> accountSalesGroupItemModelFromJson(String str) => List<AccountSalesGroupItemModel>.from(json.decode(str).map((x) => AccountSalesGroupItemModel.fromJson(x)));

String accountSalesGroupItemModelToJson(List<AccountSalesGroupItemModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class AccountSalesGroupItemModel {
  @JsonKey(name: "itemId")
  final int? itemId;
  @JsonKey(name: "itemName")
  final String? itemName;
  @JsonKey(name: "itemIcon")
  final String? itemIcon;
  @JsonKey(name: "status")
  final bool? status;
  @JsonKey(name: "mesghalPrice")
  final double? mesghalPrice;
  @JsonKey(name: "mesghalBuyPrice")
  final double? mesghalBuyPrice;
  @JsonKey(name: "salesRange")
  final double? salesRange;
  @JsonKey(name: "buyRange")
  final double? buyRange;
  @JsonKey(name: "rowNum")
  final int? rowNum;
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "recId")
  final String? recId;
  @JsonKey(name: "infos")
  final List<dynamic>? infos;

  AccountSalesGroupItemModel({
    required this.itemId,
    required this.itemName,
    required this.itemIcon,
    required this.status,
    required this.mesghalPrice,
    required this.mesghalBuyPrice,
    required this.salesRange,
    required this.buyRange,
    required this.rowNum,
    required this.id,
    required this.recId,
    required this.infos,
  });

  factory AccountSalesGroupItemModel.fromJson(Map<String, dynamic> json) => _$AccountSalesGroupItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$AccountSalesGroupItemModelToJson(this);
}