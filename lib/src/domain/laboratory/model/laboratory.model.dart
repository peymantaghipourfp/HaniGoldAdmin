// To parse this JSON data, do
//
//     final laboratoryModel = laboratoryModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'laboratory.model.g.dart';

LaboratoryModel laboratoryModelFromJson(String str) => LaboratoryModel.fromJson(json.decode(str));

String laboratoryModelToJson(LaboratoryModel data) => json.encode(data.toJson());

@JsonSerializable()
class LaboratoryModel {
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "address")
  final String? address;
  @JsonKey(name: "phone")
  final String? phone;
  @JsonKey(name: "createdOn")
  final DateTime? createdOn;
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
    required this.address,
    required this.phone,
    required this.createdOn,
    required this.rowNum,
    required this.id,
    required this.attribute,
    required this.recId,
    required this.infos,
  });

  factory LaboratoryModel.fromJson(Map<String, dynamic> json) => _$LaboratoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$LaboratoryModelToJson(this);
}
