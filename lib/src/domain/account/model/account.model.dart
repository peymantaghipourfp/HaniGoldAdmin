import 'package:meta/meta.dart';
import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

import '../../order/model/order.model.dart';
part 'account.model.g.dart';

List<AccountModel> accountModelFromJson(String str) => List<AccountModel>.from(json.decode(str).map((x) => AccountModel.fromJson(x)));

String accountModelToJson(List<AccountModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class AccountModel {
  @JsonKey(name: "type")
  final int type;
  @JsonKey(name: "code")
  final String code;
  @JsonKey(name: "name")
  final String name;
  @JsonKey(name: "parent")
  final Parent parent;
  @JsonKey(name: "accountGroup")
  final Group accountGroup;
  @JsonKey(name: "accountItemGroup")
  final Group accountItemGroup;
  @JsonKey(name: "accountPriceGroup")
  final Group accountPriceGroup;
  @JsonKey(name: "rowNum")
  final int rowNum;
  @JsonKey(name: "id")
  final int id;
  @JsonKey(name: "attribute")
  final AccountModelAttribute attribute;
  @JsonKey(name: "tags")
  final String tags;
  @JsonKey(name: "recId")
  final String recId;
  @JsonKey(name: "infos")
  final List<dynamic> infos;
  @JsonKey(name: "firstName")
  final String firstName;
  @JsonKey(name: "lastName")
  final String lastName;

  AccountModel({
    required this.type,
    required this.code,
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
class Group {
  @JsonKey(name: "name")
  final Name name;
  @JsonKey(name: "id")
  final int id;
  @JsonKey(name: "infos")
  final List<dynamic> infos;

  Group({
    required this.name,
    required this.id,
    required this.infos,
  });

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);

  Map<String, dynamic> toJson() => _$GroupToJson(this);
}

enum Name {
  @JsonValue("گروه ویژه")
  EMPTY,
  @JsonValue("سکه")
  FLUFFY,
  @JsonValue("گروه قیمت اول")
  NAME,
  @JsonValue("طلا")
  PURPLE,
  @JsonValue("ارز")
  STICKY,
  @JsonValue("ریال")
  TENTACLED,
  @JsonValue("گروه 1    ")
  THE_1,
  @JsonValue("گروه 2    ")
  THE_2
}

final nameValues = EnumValues({
  "گروه ویژه": Name.EMPTY,
  "سکه": Name.FLUFFY,
  "گروه قیمت اول": Name.NAME,
  "طلا": Name.PURPLE,
  "ارز": Name.STICKY,
  "ریال": Name.TENTACLED,
  "گروه 1    ": Name.THE_1,
  "گروه 2    ": Name.THE_2
});

enum AccountModelAttribute {
  @JsonValue("cus")
  CUS
}

final accountModelAttributeValues = EnumValues({
  "cus": AccountModelAttribute.CUS
});

@JsonSerializable()
class Parent {
  @JsonKey(name: "accountGroup")
  final AccountGroup accountGroup;
  @JsonKey(name: "accountItemGroup")
  final AccountGroup accountItemGroup;
  @JsonKey(name: "accountPriceGroup")
  final AccountGroup accountPriceGroup;
  @JsonKey(name: "infos")
  final List<dynamic> infos;
  @JsonKey(name: "type")
  final int type;
  @JsonKey(name: "code")
  final String code;
  @JsonKey(name: "name")
  final String name;
  @JsonKey(name: "id")
  final int id;

  Parent({
    required this.accountGroup,
    required this.accountItemGroup,
    required this.accountPriceGroup,
    required this.infos,
    required this.type,
    required this.code,
    required this.name,
    required this.id,
  });

  factory Parent.fromJson(Map<String, dynamic> json) => _$ParentFromJson(json);

  Map<String, dynamic> toJson() => _$ParentToJson(this);
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