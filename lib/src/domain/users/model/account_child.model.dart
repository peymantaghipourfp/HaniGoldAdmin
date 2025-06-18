// To parse this JSON data, do
//
//     final accountChildModel = accountChildModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'account_child.model.g.dart';

AccountChildModel accountChildModelFromJson(String str) => AccountChildModel.fromJson(json.decode(str));

String accountChildModelToJson(AccountChildModel data) => json.encode(data.toJson());

@JsonSerializable()
class AccountChildModel {
  @JsonKey(name: "parent")
  final ParentChildModel? parent;
  @JsonKey(name: "id")
  final int? id;

  AccountChildModel({
    required this.parent,
    required this.id,
  });

  factory AccountChildModel.fromJson(Map<String, dynamic> json) => _$AccountChildModelFromJson(json);

  Map<String, dynamic> toJson() => _$AccountChildModelToJson(this);
}

@JsonSerializable()
class ParentChildModel {
  @JsonKey(name: "id")
  final int? id;

  ParentChildModel({
    required this.id,
  });

  factory ParentChildModel.fromJson(Map<String, dynamic> json) => _$ParentChildModelFromJson(json);

  Map<String, dynamic> toJson() => _$ParentChildModelToJson(this);
}
