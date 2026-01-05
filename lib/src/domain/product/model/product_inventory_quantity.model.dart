import 'package:hanigold_admin/src/domain/product/model/item.model.dart';
import 'package:hanigold_admin/src/domain/product/model/item_unit.model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'product_inventory_quantity.model.g.dart';

List<ProductInventoryQuantityModel> productInventoryQuantityModelFromJson(String str) => List<ProductInventoryQuantityModel>.from(json.decode(str).map((x) => ProductInventoryQuantityModel.fromJson(x)));

String productInventoryQuantityModelToJson(List<ProductInventoryQuantityModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class ProductInventoryQuantityModel {
  @JsonKey(name: "item")
  final ItemModel? item;
  @JsonKey(name: "itemUnit")
  final ItemUnitModel? itemUnit;
  @JsonKey(name: "quantity")
  final double? quantity;
  @JsonKey(name: "quantity750")
  final double? quantity750;
  @JsonKey(name: "quantityCount")
  final double? quantityCount;
  @JsonKey(name: "rowNum")
  final int? rowNum;

  ProductInventoryQuantityModel({
    required this.item,
    required this.itemUnit,
    required this.quantity,
    required this.quantity750,
    required this.quantityCount,
    required this.rowNum,
  });

  factory ProductInventoryQuantityModel.fromJson(Map<String, dynamic> json) => _$ProductInventoryQuantityModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductInventoryQuantityModelToJson(this);
}