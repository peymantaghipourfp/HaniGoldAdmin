
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'detail_gold.model.g.dart';

DetailGoldModel detailGoldModelFromJson(String str) => DetailGoldModel.fromJson(json.decode(str));

String detailGoldModelToJson(DetailGoldModel data) => json.encode(data.toJson());

@JsonSerializable()
class DetailGoldModel {
  @JsonKey(name: "quantity")
  final double? quantity;
  @JsonKey(name: "weight")
  final double? weight;
  @JsonKey(name: "carat")
  final int? carat;
  @JsonKey(name: "impurity")
  final int? impurity;
  @JsonKey(name: "receiptNumber")
  final String? receiptNumber;
  @JsonKey(name: "itemId")
  final int? itemId;
  @JsonKey(name: "itemName")
  final String? itemName;
  @JsonKey(name: "itemUnitId")
  final int? itemUnitId;
  @JsonKey(name: "itemUnitName")
  final String? itemUnitName;
  @JsonKey(name: "laboratoryId")
  final int? laboratoryId;
  @JsonKey(name: "name")
  final String? name;

  DetailGoldModel({
    required this.quantity,
    required this.weight,
    required this.carat,
    required this.impurity,
    required this.receiptNumber,
    required this.itemId,
    required this.itemName,
    required this.itemUnitId,
    required this.itemUnitName,
    required this.laboratoryId,
    required this.name,
  });

  factory DetailGoldModel.fromJson(Map<String, dynamic> json) => _$DetailGoldModelFromJson(json);

  Map<String, dynamic> toJson() => _$DetailGoldModelToJson(this);
}