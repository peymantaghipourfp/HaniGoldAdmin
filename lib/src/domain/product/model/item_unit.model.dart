import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'item_unit.model.g.dart';

List<ItemUnitModel> itemUnitModelFromJson(String str) => List<ItemUnitModel>.from(json.decode(str).map((x) => ItemUnitModel.fromJson(x)));

String itemUnitModelToJson(List<ItemUnitModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class ItemUnitModel {
  @JsonKey(name: "name")
  final String? name;
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

  ItemUnitModel({
    required this.name,
    required this.rowNum,
    required this.id,
    required this.attribute,
    required this.recId,
    required this.infos,
  });

  factory ItemUnitModel.fromJson(Map<String, dynamic> json) => _$ItemUnitModelFromJson(json);

  Map<String, dynamic> toJson() => _$ItemUnitModelToJson(this);
}