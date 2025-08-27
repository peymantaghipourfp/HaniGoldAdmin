import 'package:hanigold_admin/src/domain/product/model/item.model.dart';
import 'package:hanigold_admin/src/domain/product/model/item_unit.model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'product_inventory.model.g.dart';

List<ProductInventoryModel> productInventoryModelFromJson(String str) => List<ProductInventoryModel>.from(json.decode(str).map((x) => ProductInventoryModel.fromJson(x)));

String productInventoryModelToJson(List<ProductInventoryModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class ProductInventoryModel {
  @JsonKey(name: "item")
  final ItemModel? item;
  @JsonKey(name: "itemUnit")
  final ItemUnitModel? itemUnit;
  @JsonKey(name: "initBalance")
  final double? initBalance;
  @JsonKey(name: "quantity")
  final double? quantity;
  @JsonKey(name: "quantityIn")
  final double? quantityIn;
  @JsonKey(name: "quantityOut")
  final double? quantityOut;
  @JsonKey(name: "rowNum")
  final int? rowNum;

  ProductInventoryModel({
    required this.item,
    required this.itemUnit,
    required this.initBalance,
    required this.quantity,
    required this.quantityIn,
    required this.quantityOut,
    required this.rowNum,
  });

  factory ProductInventoryModel.fromJson(Map<String, dynamic> json) => _$ProductInventoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductInventoryModelToJson(this);
}