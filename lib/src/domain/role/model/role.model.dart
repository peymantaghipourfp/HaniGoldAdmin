import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'role.model.g.dart';

List<RoleModel> roleModelFromJson(String str) => List<RoleModel>.from(json.decode(str).map((x) => RoleModel.fromJson(x)));

String roleModelToJson(List<RoleModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class RoleModel {
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "rowNum")
  final int? rowNum;
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "attribute")
  final String? attribute;
  @JsonKey(name: "infos")
  final List<dynamic>? infos;

  RoleModel({
    required this.name,
    required this.rowNum,
    required this.id,
    required this.attribute,
    required this.infos,
  });

  factory RoleModel.fromJson(Map<String, dynamic> json) => _$RoleModelFromJson(json);

  Map<String, dynamic> toJson() => _$RoleModelToJson(this);
}