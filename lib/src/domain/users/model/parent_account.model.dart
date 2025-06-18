// To parse this JSON data, do
//
//     final parentAccountModel = parentAccountModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'parent_account.model.g.dart';

ParentAccountModel parentAccountModelFromJson(String str) => ParentAccountModel.fromJson(json.decode(str));

String parentAccountModelToJson(ParentAccountModel data) => json.encode(data.toJson());

@JsonSerializable()
class ParentAccountModel {
  @JsonKey(name: "type")
  final int? type;
  @JsonKey(name: "code")
  final String? code;
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "accountGroup")
  final AccountGroup? accountGroup;
  @JsonKey(name: "accountSubGroup")
  final AccountGroup? accountSubGroup;
  @JsonKey(name: "id")
  late  int? id;
  @JsonKey(name: "infos")
  final List<dynamic>? infos;

  ParentAccountModel({
    required this.type,
    required this.code,
    required this.name,
    required this.accountGroup,
    required this.accountSubGroup,
    required this.id,
    required this.infos,
  });

  factory ParentAccountModel.fromJson(Map<String, dynamic> json) => _$ParentAccountModelFromJson(json);

  Map<String, dynamic> toJson() => _$ParentAccountModelToJson(this);
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
