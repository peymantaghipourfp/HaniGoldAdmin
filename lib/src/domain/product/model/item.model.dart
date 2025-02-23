


import 'package:hanigold_admin/src/domain/product/model/item_group.model.dart';
import 'package:hanigold_admin/src/domain/product/model/item_unit.model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'item.model.g.dart';

List<ItemModel> itemModelFromJson(String str) => List<ItemModel>.from(json.decode(str).map((x) => ItemModel.fromJson(x)));

String itemModelToJson(List<ItemModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class ItemModel {
  @JsonKey(name: "itemGroup")
  final ItemGroupModel? itemGroup;
  @JsonKey(name: "itemUnit")
  final ItemUnitModel? itemUnit;
  @JsonKey(name: "price")
  final double? price;
  @JsonKey(name: "differentPrice")
  final double? differentPrice;
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "isDefault")
  final bool? isDefault;
  @JsonKey(name: "status")
  final bool? status;
  @JsonKey(name: "sellStatus")
  final bool? sellStatus;
  @JsonKey(name: "buyStatus")
  final bool? buyStatus;
  @JsonKey(name: "maxSell")
  final int? maxSell;
  @JsonKey(name: "maxBuy")
  final int? maxBuy;
  @JsonKey(name: "w750")
  final double? w750;
  @JsonKey(name: "initBalance")
  final int? initBalance;
  @JsonKey(name: "openPrice")
  final double? openPrice;
  @JsonKey(name: "symbol")
  final String? symbol;
  @JsonKey(name: "icon")
  final String? icon;
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

  ItemModel({
    required this.itemGroup,
    required this.itemUnit,
    required this.price,
    required this.differentPrice,
    required this.name,
    required this.isDefault,
    required this.status,
    required this.sellStatus,
    required this.buyStatus,
    required this.maxSell,
    required this.maxBuy,
    required this.w750,
    required this.initBalance,
    required this.openPrice,
    required this.symbol,
    required this.icon,
    required this.rowNum,
    required this.id,
    required this.attribute,
    required this.recId,
    required this.infos,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) => _$ItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$ItemModelToJson(this);
}