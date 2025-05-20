// To parse this JSON data, do
//
//     final stateItemModel = stateItemModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'state_item.model.g.dart';

StateItemModel stateItemModelFromJson(String str) => StateItemModel.fromJson(json.decode(str));

String stateItemModelToJson(StateItemModel data) => json.encode(data.toJson());

@JsonSerializable()
class StateItemModel {
  @JsonKey(name: "country")
  final Country? country;
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "preTell")
  final String? preTell;
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

  StateItemModel({
    required this.country,
    required this.name,
    required this.preTell,
    required this.rowNum,
    required this.id,
    required this.attribute,
    required this.recId,
    required this.infos,
  });

  factory StateItemModel.fromJson(Map<String, dynamic> json) => _$StateItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$StateItemModelToJson(this);
}

@JsonSerializable()
class Country {
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "infos")
  final List<dynamic>? infos;

  Country({
    required this.name,
    required this.id,
    required this.infos,
  });

  factory Country.fromJson(Map<String, dynamic> json) => _$CountryFromJson(json);

  Map<String, dynamic> toJson() => _$CountryToJson(this);
}
