
import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'account.model.dart';

part 'account_price_group.model.g.dart';

List<AccountPriceGroupModel> accountPriceGroupModelFromJson(String str) => List<AccountPriceGroupModel>.from(json.decode(str).map((x) => AccountPriceGroupModel.fromJson(x)));

String accountPriceGroupModelToJson(List<AccountPriceGroupModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class AccountPriceGroupModel {
  @JsonKey(name: "name")
  final Name name;
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

  AccountPriceGroupModel({
    required this.name,
    required this.rowNum,
    required this.id,
    required this.attribute,
    required this.recId,
    required this.infos,
  });

  factory AccountPriceGroupModel.fromJson(Map<String, dynamic> json) => _$AccountPriceGroupModelFromJson(json);

  Map<String, dynamic> toJson() => _$AccountPriceGroupModelToJson(this);
}