import 'package:hanigold_admin/src/domain/product/model/item_group.model.dart';
import 'package:hanigold_admin/src/domain/product/model/item_price.model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'item.model.g.dart';

List<ItemModel> itemModelFromJson(String str) => List<ItemModel>.from(json.decode(str).map((x) => ItemModel.fromJson(x)));

String itemModelToJson(List<ItemModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class ItemModel {
  @JsonKey(name: "itemGroup")
  final ItemGroupModel? itemGroup;
  @JsonKey(name: "itemPrice")
  final ItemPriceModel? itemPrice;
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "sellStatus")
  final int? sellStatus;
  @JsonKey(name: "buyStatus")
  final int? buyStatus;
  @JsonKey(name: "maxSell")
  final int? maxSell;
  @JsonKey(name: "maxBuy")
  final int? maxBuy;
  @JsonKey(name: "unit")
  final int? unit;
  @JsonKey(name: "w750")
  final double? w750;
  @JsonKey(name: "initBalance")
  final int? initBalance;
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
    required this.itemPrice,
    required this.name,
    required this.sellStatus,
    required this.buyStatus,
    required this.maxSell,
    required this.maxBuy,
    required this.unit,
    required this.w750,
    required this.initBalance,
    required this.rowNum,
    required this.id,
    required this.attribute,
    required this.recId,
    required this.infos,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) => _$ItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$ItemModelToJson(this);
}

