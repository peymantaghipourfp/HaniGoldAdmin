import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'laboratory.model.g.dart';

List<LaboratoryModel> laboratoryModelFromJson(String str) => List<LaboratoryModel>.from(json.decode(str).map((x) => LaboratoryModel.fromJson(x)));

String laboratoryModelToJson(List<LaboratoryModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class LaboratoryModel {
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

  LaboratoryModel({
    required this.name,
    required this.rowNum,
    required this.id,
    required this.attribute,
    required this.recId,
    required this.infos,
  });

  factory LaboratoryModel.fromJson(Map<String, dynamic> json) => _$LaboratoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$LaboratoryModelToJson(this);
}