import 'package:hanigold_admin/src/domain/role/model/element_action.model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'element_getOne.model.g.dart';

ElementGetOneModel elementGetOneModelFromJson(String str) => ElementGetOneModel.fromJson(json.decode(str));

String elementGetOneModelToJson(ElementGetOneModel data) => json.encode(data.toJson());

@JsonSerializable()
class ElementGetOneModel {
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "type")
  final String? type;
  @JsonKey(name: "title")
  final String? title;
  @JsonKey(name: "elementActions")
  final List<ElementActionModel>? elementActions;
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

  ElementGetOneModel({
    required this.name,
    required this.type,
    required this.title,
    required this.elementActions,
    required this.rowNum,
    required this.id,
    required this.attribute,
    required this.description,
    required this.infos,
  });

  factory ElementGetOneModel.fromJson(Map<String, dynamic> json) => _$ElementGetOneModelFromJson(json);

  Map<String, dynamic> toJson() => _$ElementGetOneModelToJson(this);
}