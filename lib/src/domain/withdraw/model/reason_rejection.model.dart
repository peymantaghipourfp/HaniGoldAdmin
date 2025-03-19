import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'reason_rejection.model.g.dart';

List<ReasonRejectionModel> reasonRejectionModelFromJson(String str) => List<ReasonRejectionModel>.from(json.decode(str).map((x) => ReasonRejectionModel.fromJson(x)));

String reasonRejectionModelToJson(List<ReasonRejectionModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class ReasonRejectionModel {
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "type")
  final String? type;
  @JsonKey(name: "rowNum")
  final int? rowNum;
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "attribute")
  final String? attribute;
  @JsonKey(name: "infos")
  final List<dynamic>? infos;

  ReasonRejectionModel({
    required this.name,
    required this.type,
    required this.rowNum,
    required this.id,
    required this.attribute,
    required this.infos,
  });

  factory ReasonRejectionModel.fromJson(Map<String, dynamic> json) => _$ReasonRejectionModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReasonRejectionModelToJson(this);
}