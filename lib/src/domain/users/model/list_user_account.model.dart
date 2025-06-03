// To parse this JSON data, do
//
//     final listUserAccountModel = listUserAccountModelFromJson(jsonString);

import 'package:hanigold_admin/src/domain/auth/model/user_login.model.dart';
import 'package:hanigold_admin/src/domain/users/model/paginated.model.dart';
import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

import 'item_user.model.dart';

part 'list_user_account.model.g.dart';

ListUserAccountModel listUserAccountModelFromJson(String str) => ListUserAccountModel.fromJson(json.decode(str));

String listUserAccountModelToJson(ListUserAccountModel data) => json.encode(data.toJson());

@JsonSerializable()
class ListUserAccountModel {
  @JsonKey(name: "users")
  final List<ItemUserModel>? users;
  @JsonKey(name: "paginated")
  final PaginatedModel? paginated;

  ListUserAccountModel({
    required this.users,
    required this.paginated,
  });

  factory ListUserAccountModel.fromJson(Map<String, dynamic> json) => _$ListUserAccountModelFromJson(json);

  Map<String, dynamic> toJson() => _$ListUserAccountModelToJson(this);
}