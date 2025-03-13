import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'bank.model.g.dart';

List<BankModel> bankModelFromJson(String str) => List<BankModel>.from(json.decode(str).map((x) => BankModel.fromJson(x)));

String bankModelToJson(List<BankModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class BankModel {
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "icon")
  final String? icon;
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "recId")
  final String? recId;
  @JsonKey(name: "infos")
  final List<dynamic>? infos;

  BankModel({
    required this.name,
    required this.icon,
    required this.id,
    required this.recId,
    required this.infos,
  });

  factory BankModel.fromJson(Map<String, dynamic> json) => _$BankModelFromJson(json);

  Map<String, dynamic> toJson() => _$BankModelToJson(this);
}