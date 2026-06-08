
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'account_admin.model.g.dart';

AccountAdminModel accountAdminModelFromJson(String str) => AccountAdminModel.fromJson(json.decode(str));

String accountAdminModelToJson(AccountAdminModel data) => json.encode(data.toJson());

@JsonSerializable()
class AccountAdminModel {
  @JsonKey(name: "topicCode")
  final String? topicCode;
  @JsonKey(name: "items")
  final List<Item>? items;

  AccountAdminModel({
    required this.topicCode,
    required this.items,
  });

  factory AccountAdminModel.fromJson(Map<String, dynamic> json) => _$AccountAdminModelFromJson(json);

  Map<String, dynamic> toJson() => _$AccountAdminModelToJson(this);
}

@JsonSerializable()
class Item {
  @JsonKey(name: "accountId")
  final int? accountId;
  @JsonKey(name: "userId")
  final int? userId;
  @JsonKey(name: "name")
  final String? name;

  Item({
    required this.accountId,
    required this.userId,
    required this.name,
  });

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  Map<String, dynamic> toJson() => _$ItemToJson(this);
}