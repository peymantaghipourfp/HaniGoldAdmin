
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'item_price.model.g.dart';

List<ItemPriceModel> itemPriceModelFromJson(String str) => List<ItemPriceModel>.from(json.decode(str).map((x) => ItemPriceModel.fromJson(x)));

String itemPriceModelToJson(List<ItemPriceModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class ItemPriceModel {
  @JsonKey(name: "itemId")
  final int? itemId;
  @JsonKey(name: "price")
  final double? price;
  @JsonKey(name: "differentPrice")
  final double? differentPrice;
  @JsonKey(name: "itemName")
  final String? itemName;
  @JsonKey(name: "salesRange")
  final double? salesRange;
  @JsonKey(name: "buyRange")
  final double? buyRange;
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
  @JsonKey(name: "itemUnitId")
  final int? itemUnitId;

  ItemPriceModel({
    required this.itemId,
    required this.price,
    required this.differentPrice,
    required this.rowNum,
    required this.itemName,
    required this.salesRange,
    required this.buyRange,
    required this.id,
    required this.attribute,
    required this.recId,
    required this.infos,
    required this.itemUnitId,
  });

  factory ItemPriceModel.fromJson(Map<String, dynamic> json) => _$ItemPriceModelFromJson(json);

  Map<String, dynamic> toJson() => _$ItemPriceModelToJson(this);
}