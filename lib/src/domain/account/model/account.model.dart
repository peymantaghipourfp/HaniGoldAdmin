//
// import 'package:hanigold_admin/src/domain/account/model/account_group.model.dart';
// import 'package:hanigold_admin/src/domain/account/model/account_item_group.model.dart';
// import 'package:hanigold_admin/src/domain/account/model/account_price_group.model.dart';
// import 'package:json_annotation/json_annotation.dart';
// import 'dart:convert';
//
// part 'account.model.g.dart';
//
// List<AccountModel> accountModelFromJson(String str) => List<AccountModel>.from(json.decode(str).map((x) => AccountModel.fromJson(x)));
//
// String accountModelToJson(List<AccountModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
//
// @JsonSerializable()
// class AccountModel {
//   @JsonKey(name: "type")
//   final int? type;
//   @JsonKey(name: "code")
//   final String? code;
//   @JsonKey(name: "hasDeposit")
//   final bool? hasDeposit;
//   @JsonKey(name: "contactInfo")
//   final String? contactInfo;
//   @JsonKey(name: "name")
//   late final String? name;
//   @JsonKey(name: "parent")
//   final Parent? parent;
//   @JsonKey(name: "accountGroup")
//   final AccountGroupModel? accountGroup;
//   @JsonKey(name: "accountItemGroup")
//   final AccountItemGroupModel? accountItemGroup;
//   @JsonKey(name: "accountPriceGroup")
//   final AccountPriceGroupModel? accountPriceGroup;
//   @JsonKey(name: "rowNum")
//   final int? rowNum;
//   @JsonKey(name: "id")
//   late final int? id;
//   @JsonKey(name: "status")
//   late final int? status;
//   @JsonKey(name: "attribute")
//   final String? attribute;
//   @JsonKey(name: "startDate")
//   final DateTime? startDate;
//   @JsonKey(name: "tags")
//   final String? tags;
//   @JsonKey(name: "recId")
//   final String? recId;
//   @JsonKey(name: "infos")
//   final List<dynamic>? infos;
//   @JsonKey(name: "firstName")
//   final String? firstName;
//   @JsonKey(name: "lastName")
//   final String? lastName;
//
//   AccountModel({
//     required this.type,
//     required this.code,
//     required this.hasDeposit,
//     required this.contactInfo,
//     required this.name,
//     required this.parent,
//     required this.accountGroup,
//     required this.accountItemGroup,
//     required this.accountPriceGroup,
//     required this.rowNum,
//     required this.id,
//     required this.status,
//     required this.attribute,
//     required this.startDate,
//     required this.tags,
//     required this.recId,
//     required this.infos,
//     required this.firstName,
//     required this.lastName,
//   });
//
//   factory AccountModel.fromJson(Map<String, dynamic> json) => _$AccountModelFromJson(json);
//
//   Map<String, dynamic> toJson() => _$AccountModelToJson(this);
// }
//
import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

import '../../users/model/city_item.model.dart';
import '../../users/model/state_item.model.dart';
import 'account_group.model.dart';

part 'account.model.g.dart';




// To parse this JSON data, do
//
//     final accountModel = accountModelFromJson(jsonString);



AccountModel accountModelFromJson(String str) => AccountModel.fromJson(json.decode(str));

String accountModelToJson(AccountModel data) => json.encode(data.toJson());

@JsonSerializable()
class AccountModel {
  @JsonKey(name: "type")
  final int? type;
  @JsonKey(name: "code")
  final String? code;
  @JsonKey(name: "contactInfo")
  final String? contactInfo;
  @JsonKey(name: "firstName")
  final String? firstName;
  @JsonKey(name: "lastName")
  final String? lastName;
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "status")
  final int? status;
  @JsonKey(name: "hasDeposit")
  final bool? hasDeposit;
  @JsonKey(name: "startDate")
  final DateTime? startDate;
  @JsonKey(name: "parent")
  final Parent? parent;
  @JsonKey(name: "accountGroup")
  final AccountGroupModel? accountGroup;
  @JsonKey(name: "contacts")
  final List<ContactElement>? contacts;
  @JsonKey(name: "addresses")
  final List<Address>? addresses;
  @JsonKey(name: "contactInfos")
  final List<ContactInfo>? contactInfos;
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

  AccountModel({
    required this.type,
    required this.contactInfo,
    required this.code,
    required this.firstName,
    required this.lastName,
    required this.name,
    required this.status,
    required this.hasDeposit,
    required this.startDate,
    required this.parent,
    required this.accountGroup,
    required this.contacts,
    required this.addresses,
    required this.contactInfos,
    required this.rowNum,
    required this.id,
    required this.attribute,
    required this.recId,
    required this.infos,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) => _$AccountModelFromJson(json);

  Map<String, dynamic> toJson() => _$AccountModelToJson(this);
}


@JsonSerializable()
class Address {
  @JsonKey(name: "isMain")
  final bool? isMain;
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "account")
  final AddressAccount? account;
  @JsonKey(name: "contact")
  final dynamic contact;
  @JsonKey(name: "country")
  final Country? country;
  @JsonKey(name: "state")
  final StateItemModel? state;
  @JsonKey(name: "city")
  final CityItemModel? city;
  @JsonKey(name: "fullAddress")
  final String? fullAddress;
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

  Address({
    required this.isMain,
    required this.name,
    required this.account,
    required this.contact,
    required this.country,
    required this.state,
    required this.city,
    required this.fullAddress,
    required this.rowNum,
    required this.id,
    required this.attribute,
    required this.recId,
    required this.infos,
  });

  factory Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);

  Map<String, dynamic> toJson() => _$AddressToJson(this);
}

@JsonSerializable()
class AddressAccount {
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "infos")
  final List<dynamic>? infos;

  AddressAccount({
    required this.id,
    required this.infos,
  });

  factory AddressAccount.fromJson(Map<String, dynamic> json) => _$AddressAccountFromJson(json);

  Map<String, dynamic> toJson() => _$AddressAccountToJson(this);
}



@JsonSerializable()
class ContactInfo {
  @JsonKey(name: "account")
  final AddressAccount? account;
  @JsonKey(name: "contact")
  final ContactInfoContact? contact;
  @JsonKey(name: "type")
  final int? type;
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "value")
  final String? value;
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

  ContactInfo({
    required this.account,
    required this.contact,
    required this.type,
    required this.name,
    required this.value,
    required this.rowNum,
    required this.id,
    required this.attribute,
    required this.recId,
    required this.infos,
  });

  factory ContactInfo.fromJson(Map<String, dynamic> json) => _$ContactInfoFromJson(json);

  Map<String, dynamic> toJson() => _$ContactInfoToJson(this);
}

@JsonSerializable()
class ContactInfoContact {
  @JsonKey(name: "account")
  final Parent? account;
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "infos")
  final List<dynamic>? infos;

  ContactInfoContact({
    required this.account,
    required this.id,
    required this.infos,
  });

  factory ContactInfoContact.fromJson(Map<String, dynamic> json) => _$ContactInfoContactFromJson(json);

  Map<String, dynamic> toJson() => _$ContactInfoContactToJson(this);
}

@JsonSerializable()
class ContactElement {
  @JsonKey(name: "account")
  final ContactAccount? account;
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "firstName")
  final String? firstName;
  @JsonKey(name: "lastName")
  final String? lastName;
  @JsonKey(name: "gender")
  final int? gender;
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

  ContactElement({
    required this.account,
    required this.name,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.rowNum,
    required this.id,
    required this.attribute,
    required this.recId,
    required this.infos,
  });

  factory ContactElement.fromJson(Map<String, dynamic> json) => _$ContactElementFromJson(json);

  Map<String, dynamic> toJson() => _$ContactElementToJson(this);
}

@JsonSerializable()
class ContactAccount {
  @JsonKey(name: "code")
  final String? code;
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "accountGroup")
  final dynamic accountGroup;
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "infos")
  final List<dynamic>? infos;

  ContactAccount({
    required this.code,
    required this.name,
    required this.accountGroup,
    required this.id,
    required this.infos,
  });

  factory ContactAccount.fromJson(Map<String, dynamic> json) => _$ContactAccountFromJson(json);

  Map<String, dynamic> toJson() => _$ContactAccountToJson(this);
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
