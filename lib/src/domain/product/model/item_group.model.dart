
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'item_group.model.g.dart';

List<ItemGroupModel> itemGroupModelFromJson(String str) => List<ItemGroupModel>.from(json.decode(str).map((x) => ItemGroupModel.fromJson(x)));

String itemGroupModelToJson(List<ItemGroupModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class ItemGroupModel {
  @JsonKey(name: "code")
  final String? code;
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "equivalent")
  final String? equivalent;
  @JsonKey(name: "rowNum")
  final int? rowNum;
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "attribute")
  final String? attribute;
  @JsonKey(name: "description")
  final String? description;
  @JsonKey(name: "recId")
  final String? recId;
  @JsonKey(name: "infos")
  final List<dynamic>? infos;

  ItemGroupModel({
    required this.code,
    required this.name,
    required this.equivalent,
    required this.rowNum,
    required this.id,
    required this.attribute,
    required this.description,
    required this.recId,
    required this.infos,
  });

  factory ItemGroupModel.fromJson(Map<String, dynamic> json) => _$ItemGroupModelFromJson(json);

  Map<String, dynamic> toJson() => _$ItemGroupModelToJson(this);
}
