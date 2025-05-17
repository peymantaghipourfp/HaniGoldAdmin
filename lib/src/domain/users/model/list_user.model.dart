// To parse this JSON data, do
//
//     final listUserModel = listUserModelFromJson(jsonString);

import 'package:hanigold_admin/src/domain/account/model/account.model.dart';
import 'package:hanigold_admin/src/domain/users/model/paginated.model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'list_user.model.g.dart';

ListUserModel listUserModelFromJson(String str) => ListUserModel.fromJson(json.decode(str));

String listUserModelToJson(ListUserModel data) => json.encode(data.toJson());

@JsonSerializable()
class ListUserModel {
  @JsonKey(name: "accounts")
  final List<AccountModel>? accounts;
  @JsonKey(name: "paginated")
  final PaginatedModel? paginated;

  ListUserModel({
    required this.accounts,
    required this.paginated,
  });

  factory ListUserModel.fromJson(Map<String, dynamic> json) => _$ListUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$ListUserModelToJson(this);
}
