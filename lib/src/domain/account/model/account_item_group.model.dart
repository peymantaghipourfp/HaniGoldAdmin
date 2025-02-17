

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'account_item_group.model.g.dart';

List<AccountItemGroupModel> accountItemGroupModelFromJson(String str) => List<AccountItemGroupModel>.from(json.decode(str).map((x) => AccountItemGroupModel.fromJson(x)));

String accountItemGroupModelToJson(List<AccountItemGroupModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class AccountItemGroupModel {
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "rowNum")
  final int? rowNum;
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "attribute")
  final String? attribute;
  @JsonKey(name: "recId")
  final String? recId;
  @JsonKey(name: "infos")
  final List<dynamic>? infos;

  AccountItemGroupModel({
    required this.name,
    required this.rowNum,
    required this.id,
    required this.attribute,
    required this.recId,
    required this.infos,
  });

  factory AccountItemGroupModel.fromJson(Map<String, dynamic> json) => _$AccountItemGroupModelFromJson(json);

  Map<String, dynamic> toJson() => _$AccountItemGroupModelToJson(this);
}
