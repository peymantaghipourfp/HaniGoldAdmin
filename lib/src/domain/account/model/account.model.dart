
import 'package:hanigold_admin/src/domain/account/model/account_group.model.dart';
import 'package:hanigold_admin/src/domain/account/model/account_item_group.model.dart';
import 'package:hanigold_admin/src/domain/account/model/account_price_group.model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'account.model.g.dart';

List<AccountModel> accountModelFromJson(String str) => List<AccountModel>.from(json.decode(str).map((x) => AccountModel.fromJson(x)));

String accountModelToJson(List<AccountModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class AccountModel {
  @JsonKey(name: "type")
  final int? type;
  @JsonKey(name: "code")
  final String? code;
  @JsonKey(name: "contactInfo")
  final String? contactInfo;
  @JsonKey(name: "name")
  late final String? name;
  @JsonKey(name: "parent")
  final Parent? parent;
  @JsonKey(name: "accountGroup")
  final AccountGroupModel? accountGroup;
  @JsonKey(name: "accountItemGroup")
  final AccountItemGroupModel? accountItemGroup;
  @JsonKey(name: "accountPriceGroup")
  final AccountPriceGroupModel? accountPriceGroup;
  @JsonKey(name: "rowNum")
  final int? rowNum;
  @JsonKey(name: "id")
  late final int? id;
  @JsonKey(name: "attribute")
  final String? attribute;
  @JsonKey(name: "tags")
  final String? tags;
  @JsonKey(name: "recId")
  final String? recId;
  @JsonKey(name: "infos")
  final List<dynamic>? infos;
  @JsonKey(name: "firstName")
  final String? firstName;
  @JsonKey(name: "lastName")
  final String? lastName;

  AccountModel({
    required this.type,
    required this.code,
    required this.contactInfo,
    required this.name,
    required this.parent,
    required this.accountGroup,
    required this.accountItemGroup,
    required this.accountPriceGroup,
    required this.rowNum,
    required this.id,
    required this.attribute,
    required this.tags,
    required this.recId,
    required this.infos,
    required this.firstName,
    required this.lastName,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) => _$AccountModelFromJson(json);

  Map<String, dynamic> toJson() => _$AccountModelToJson(this);
}

@JsonSerializable()
class Parent {
  @JsonKey(name: "accountGroup")
  final ParentAccountGroup? accountGroup;
  @JsonKey(name: "accountItemGroup")
  final ParentAccountGroup? accountItemGroup;
  @JsonKey(name: "accountPriceGroup")
  final ParentAccountGroup? accountPriceGroup;
  @JsonKey(name: "infos")
  final List<dynamic>? infos;


  Parent({
    required this.accountGroup,
    required this.accountItemGroup,
    required this.accountPriceGroup,
    required this.infos,

  });

  factory Parent.fromJson(Map<String, dynamic> json) => _$ParentFromJson(json);

  Map<String, dynamic> toJson() => _$ParentToJson(this);
}

@JsonSerializable()
class ParentAccountGroup {
  @JsonKey(name: "infos")
  final List<dynamic>? infos;

  ParentAccountGroup({
    required this.infos,
  });

  factory ParentAccountGroup.fromJson(Map<String, dynamic> json) => _$ParentAccountGroupFromJson(json);

  Map<String, dynamic> toJson() => _$ParentAccountGroupToJson(this);
}


