
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'element_action.model.g.dart';

List<ElementActionModel> elementActionModelFromJson(String str) => List<ElementActionModel>.from(json.decode(str).map((x) => ElementActionModel.fromJson(x)));

String elementActionModelToJson(List<ElementActionModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class ElementActionModel {
  @JsonKey(name: "elementId")
  final int? elementId;
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "title")
  final String? title;
  @JsonKey(name: "rowNum")
  final int? rowNum;
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "attribute")
  final String? attribute;
  @JsonKey(name: "infos")
  final List<dynamic>? infos;

  ElementActionModel({
    required this.elementId,
    required this.name,
    required this.title,
    required this.rowNum,
    required this.id,
    required this.attribute,
    required this.infos,
  });

  factory ElementActionModel.fromJson(Map<String, dynamic> json) => _$ElementActionModelFromJson(json);

  Map<String, dynamic> toJson() => _$ElementActionModelToJson(this);
}