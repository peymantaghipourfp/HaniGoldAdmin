
import 'package:hanigold_admin/src/domain/home/model/contact.model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'createdBy.model.g.dart';

List<CreatedByModel> createdByModelFromJson(String str) => List<CreatedByModel>.from(json.decode(str).map((x) => CreatedByModel.fromJson(x)));

String createdByModelToJson(List<CreatedByModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class CreatedByModel {
  @JsonKey(name: "contact")
  final ContactModel? contact;
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "infos")
  final List<dynamic>? infos;

  CreatedByModel({
    required this.contact,
    required this.name,
    required this.id,
    required this.infos,
  });

  factory CreatedByModel.fromJson(Map<String, dynamic> json) => _$CreatedByModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreatedByModelToJson(this);
}