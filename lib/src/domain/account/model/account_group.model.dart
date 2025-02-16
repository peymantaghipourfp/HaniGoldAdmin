import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'account.model.dart';

part 'account_group.model.g.dart';

List<AccountGroupModel> accountGroupModelFromJson(String str) => List<AccountGroupModel>.from(json.decode(str).map((x) => AccountGroupModel.fromJson(x)));

String accountGroupModelToJson(List<AccountGroupModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));


@JsonSerializable()
class AccountGroupModel {
  @JsonKey(name: "name")
  final String name;
  @JsonKey(name: "rowNum")
  final int rowNum;
  @JsonKey(name: "id")
  final int id;
  @JsonKey(name: "attribute")
  final AccountModelAttribute attribute;
  @JsonKey(name: "recId")
  final String recId;
  @JsonKey(name: "infos")
  final List<dynamic> infos;

  AccountGroupModel({
    required this.name,
    required this.rowNum,
    required this.id,
    required this.attribute,
    required this.recId,
    required this.infos,
  });

  factory AccountGroupModel.fromJson(Map<String, dynamic> json) => _$AccountGroupModelFromJson(json);

  Map<String, dynamic> toJson() => _$AccountGroupModelToJson(this);
}


