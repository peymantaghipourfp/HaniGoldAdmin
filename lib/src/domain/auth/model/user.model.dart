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
  @JsonKey(name: "user")
  final User? user;
  @JsonKey(name: "languageCode")
  final String? languageCode;
  @JsonKey(name: "themeName")
  final String? themeName;
  @JsonKey(name: "rowNum")
  final int? rowNum;
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "infos")
  final List<dynamic>? infos;

  UserModel({
    required this.user,
    required this.languageCode,
    required this.themeName,
    required this.rowNum,
    required this.id,
    required this.infos,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

@JsonSerializable()
class User {
  @JsonKey(name: "contact")
  final Contact? contact;
  @JsonKey(name: "code")
  final String? code;
  @JsonKey(name: "userName")
  final String? userName;
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "infos")
  final List<dynamic>? infos;

  User({
    required this.contact,
    required this.code,
    required this.userName,
    required this.id,
    required this.infos,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable()
class Contact {
  @JsonKey(name: "account")
  final dynamic account;
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "infos")
  final List<dynamic>? infos;

  Contact({
    required this.account,
    required this.name,
    required this.id,
    required this.infos,
  });

  factory Contact.fromJson(Map<String, dynamic> json) => _$ContactFromJson(json);

  Map<String, dynamic> toJson() => _$ContactToJson(this);
}

