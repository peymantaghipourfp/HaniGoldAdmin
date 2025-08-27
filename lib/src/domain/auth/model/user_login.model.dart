// To parse this JSON data, do
//
//     final userLoginModel = userLoginModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'user_login.model.g.dart';

UserLoginModel userLoginModelFromJson(String str) => UserLoginModel.fromJson(json.decode(str));

String userLoginModelToJson(UserLoginModel data) => json.encode(data.toJson());

@JsonSerializable()
class UserLoginModel {
  @JsonKey(name: "user")
  final User user;
  @JsonKey(name: "languageCode")
  final String languageCode;
  @JsonKey(name: "themeName")
  final String themeName;
  @JsonKey(name: "rowNum")
  final int rowNum;
  @JsonKey(name: "id")
  final int id;
  @JsonKey(name: "token")
  String? token;
  @JsonKey(name: "infos")
  final List<dynamic> infos;

  UserLoginModel({
    required this.user,
    required this.languageCode,
    required this.themeName,
    required this.rowNum,
    required this.id,
    this.token,
    required this.infos,
  });

  UserLoginModel copyWith({
    User? user,
    String? languageCode,
    String? themeName,
    int? rowNum,
    int? id,
    String? token,
    List<dynamic>? infos,
  }) {
    return UserLoginModel(
      user: user ?? this.user,
      languageCode: languageCode ?? this.languageCode,
      themeName: themeName ?? this.themeName,
      rowNum: rowNum ?? this.rowNum,
      id: id ?? this.id,
      token: token ?? this.token,
      infos: infos ?? this.infos,
    );
  }

  factory UserLoginModel.fromJson(Map<String, dynamic> json) => _$UserLoginModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserLoginModelToJson(this);
}

@JsonSerializable()
class User {
  @JsonKey(name: "contact")
  final Contact contact;
  @JsonKey(name: "code")
  final String code;
  @JsonKey(name: "userName")
  final String userName;
  @JsonKey(name: "id")
  final int id;
  @JsonKey(name: "infos")
  final List<dynamic> infos;

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
  final Account account;
  @JsonKey(name: "name")
  final String name;
  @JsonKey(name: "id")
  final int id;
  @JsonKey(name: "infos")
  final List<dynamic> infos;

  Contact({
    required this.account,
    required this.name,
    required this.id,
    required this.infos,
  });

  factory Contact.fromJson(Map<String, dynamic> json) => _$ContactFromJson(json);

  Map<String, dynamic> toJson() => _$ContactToJson(this);
}

@JsonSerializable()
class Account {
  @JsonKey(name: "accountGroup")
  final AccountGroup accountGroup;
  @JsonKey(name: "infos")
  final List<dynamic> infos;

  Account({
    required this.accountGroup,
    required this.infos,
  });

  factory Account.fromJson(Map<String, dynamic> json) => _$AccountFromJson(json);

  Map<String, dynamic> toJson() => _$AccountToJson(this);
}

@JsonSerializable()
class AccountGroup {
  @JsonKey(name: "infos")
  final List<dynamic> infos;

  AccountGroup({
    required this.infos,
  });

  factory AccountGroup.fromJson(Map<String, dynamic> json) => _$AccountGroupFromJson(json);

  Map<String, dynamic> toJson() => _$AccountGroupToJson(this);
}
