


import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

import 'item.model.dart';

part 'item_price.model.g.dart';

List<ItemPriceModel> itemPriceModelFromJson(String str) => List<ItemPriceModel>.from(json.decode(str).map((x) => ItemPriceModel.fromJson(x)));

String itemPriceModelToJson(List<ItemPriceModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class ItemPriceModel {
  @JsonKey(name: "itemId")
  final int itemId;
  @JsonKey(name: "price")
  final double price;
  @JsonKey(name: "differentPrice")
  final double differentPrice;
  @JsonKey(name: "rowNum")
  final int rowNum;
  @JsonKey(name: "id")
  final int id;
  @JsonKey(name: "attribute")
  final ItemModelAttribute attribute;
  @JsonKey(name: "recId")
  final String recId;
  @JsonKey(name: "infos")
  final List<dynamic> infos;

  ItemPriceModel({
    required this.itemId,
    required this.price,
    required this.differentPrice,
    required this.rowNum,
    required this.id,
    required this.attribute,
    required this.recId,
    required this.infos,
  });

  factory ItemPriceModel.fromJson(Map<String, dynamic> json) => _$ItemPriceModelFromJson(json);

  Map<String, dynamic> toJson() => _$ItemPriceModelToJson(this);
}
