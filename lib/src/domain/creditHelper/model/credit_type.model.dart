import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'credit_type.model.g.dart';

List<CreditTypeModel> creditTypeModelFromJson(String str) => List<CreditTypeModel>.from(json.decode(str).map((x) => CreditTypeModel.fromJson(x)));

String creditTypeModelToJson(List<CreditTypeModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class CreditTypeModel {
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "leverage")
  final int? leverage;
  @JsonKey(name: "rowNum")
  final int? rowNum;
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "infos")
  final List<dynamic>? infos;

  CreditTypeModel({
    required this.name,
    required this.leverage,
    required this.rowNum,
    required this.id,
    required this.infos,
  });

  factory CreditTypeModel.fromJson(Map<String, dynamic> json) => _$CreditTypeModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreditTypeModelToJson(this);
}