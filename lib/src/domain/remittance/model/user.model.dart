// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'user.model.g.dart';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

@JsonSerializable()
class UserModel {
  @JsonKey(name: "contact")
  final dynamic contact;
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "infos")
  final List<dynamic>? infos;

  UserModel({
    required this.contact,
    required this.name,
    required this.id,
    required this.infos,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
