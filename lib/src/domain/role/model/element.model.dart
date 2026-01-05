import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'element.model.g.dart';

List<ElementModel> elementModelFromJson(String str) => List<ElementModel>.from(json.decode(str).map((x) => ElementModel.fromJson(x)));

String elementModelToJson(List<ElementModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class ElementModel {
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "type")
  final String? type;
  @JsonKey(name: "title")
  final String? title;
  @JsonKey(name: "rowNum")
  final int? rowNum;
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "attribute")
  final String? attribute;
  @JsonKey(name: "description")
  final String? description;
  @JsonKey(name: "infos")
  final List<dynamic>? infos;

  ElementModel({
    required this.name,
    required this.type,
    required this.title,
    required this.rowNum,
    required this.id,
    required this.attribute,
    required this.description,
    required this.infos,
  });

  factory ElementModel.fromJson(Map<String, dynamic> json) => _$ElementModelFromJson(json);

  Map<String, dynamic> toJson() => _$ElementModelToJson(this);
}