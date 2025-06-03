// To parse this JSON data, do
//
//     final itemUserModel = itemUserModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'item_user.model.g.dart';

ItemUserModel itemUserModelFromJson(String str) => ItemUserModel.fromJson(json.decode(str));

String itemUserModelToJson(ItemUserModel data) => json.encode(data.toJson());

@JsonSerializable()
class ItemUserModel {
  @JsonKey(name: "contact")
  final Contact? contact;
  @JsonKey(name: "code")
  final String? code;
  @JsonKey(name: "status")
  final int? status;
  @JsonKey(name: "userName")
  final String? userName;
  @JsonKey(name: "mobileNumber")
  final String? mobileNumber;
  @JsonKey(name: "email")
  final String? email;
  @JsonKey(name: "rowNum")
  final int? rowNum;
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "attribute")
  final String? attribute;
  @JsonKey(name: "description")
  final String? description;
  @JsonKey(name: "recId")
  final String? recId;
  @JsonKey(name: "infos")
  final List<dynamic>? infos;

  ItemUserModel({
    required this.contact,
    required this.code,
    required this.status,
    required this.userName,
    required this.mobileNumber,
    required this.email,
    required this.rowNum,
    required this.id,
    required this.attribute,
    required this.description,
    required this.recId,
    required this.infos,
  });

  factory ItemUserModel.fromJson(Map<String, dynamic> json) => _$ItemUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$ItemUserModelToJson(this);
}

@JsonSerializable()
class Contact {
  @JsonKey(name: "account")
  final Account? account;
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

@JsonSerializable()
class Account {
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "accountGroup")
  final AccountGroup? accountGroup;
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "infos")
  final List<dynamic>? infos;

  Account({
    required this.name,
    required this.accountGroup,
    required this.id,
    required this.infos,
  });

  factory Account.fromJson(Map<String, dynamic> json) => _$AccountFromJson(json);

  Map<String, dynamic> toJson() => _$AccountToJson(this);
}

@JsonSerializable()
class AccountGroup {
  @JsonKey(name: "infos")
  final List<dynamic> ?infos;

  AccountGroup({
    required this.infos,
  });

  factory AccountGroup.fromJson(Map<String, dynamic> json) => _$AccountGroupFromJson(json);

  Map<String, dynamic> toJson() => _$AccountGroupToJson(this);
}
