// To parse this JSON data, do
//
//     final citytemModel = citytemModelFromJson(jsonString);

import 'package:hanigold_admin/src/domain/users/model/state_item.model.dart';
import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'city_item.model.g.dart';


@JsonSerializable()
class CityItemModel {
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "state")
  final StateItemModel? state;
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

  CityItemModel({
    required this.name,
    required this.state,
    required this.rowNum,
    required this.id,
    required this.attribute,
    required this.recId,
    required this.infos,
  });

  factory CityItemModel.fromJson(Map<String, dynamic> json) => _$CityItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$CityItemModelToJson(this);
}
