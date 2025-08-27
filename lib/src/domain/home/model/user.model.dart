
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

import 'contact.model.dart';

part 'user.model.g.dart';

List<UserModel> userModelFromJson(String str) => List<UserModel>.from(json.decode(str).map((x) => UserModel.fromJson(x)));

String userModelToJson(List<UserModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class UserModel {
  @JsonKey(name: "contact")
  final ContactModel? contact;
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