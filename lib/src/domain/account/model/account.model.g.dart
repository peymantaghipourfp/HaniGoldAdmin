// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountModel _$AccountModelFromJson(Map<String, dynamic> json) => AccountModel(
      type: (json['type'] as num?)?.toInt(),
      code: json['code'] as String?,
      contactInfo: json['contactInfo'] as String?,
      name: json['name'] as String?,
      parent: json['parent'] == null
          ? null
          : Parent.fromJson(json['parent'] as Map<String, dynamic>),
      accountGroup: json['accountGroup'] == null
          ? null
          : AccountGroupModel.fromJson(
              json['accountGroup'] as Map<String, dynamic>),
      accountItemGroup: json['accountItemGroup'] == null
          ? null
          : AccountItemGroupModel.fromJson(
              json['accountItemGroup'] as Map<String, dynamic>),
      accountPriceGroup: json['accountPriceGroup'] == null
          ? null
          : AccountPriceGroupModel.fromJson(
              json['accountPriceGroup'] as Map<String, dynamic>),
      rowNum: (json['rowNum'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      status: (json['status'] as num?)?.toInt(),
      attribute: json['attribute'] as String?,
      startDate:
      json['startDate'] == null ? null : DateTime.parse(json['startDate'] as String),
      tags: json['tags'] as String?,
      recId: json['recId'] as String?,
      infos: json['infos'] as List<dynamic>?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
    );

Map<String, dynamic> _$AccountModelToJson(AccountModel instance) =>
    <String, dynamic>{
      'type': instance.type,
      'code': instance.code,
      'contactInfo': instance.contactInfo,
      'name': instance.name,
      'parent': instance.parent,
      'accountGroup': instance.accountGroup,
      'accountItemGroup': instance.accountItemGroup,
      'accountPriceGroup': instance.accountPriceGroup,
      'rowNum': instance.rowNum,
      'id': instance.id,
      'status': instance.status,
      'attribute': instance.attribute,
      'createdOn': instance.startDate,
      'tags': instance.tags,
      'recId': instance.recId,
      'infos': instance.infos,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
    };

Parent _$ParentFromJson(Map<String, dynamic> json) => Parent(
      accountGroup: json['accountGroup'] == null
          ? null
          : ParentAccountGroup.fromJson(
              json['accountGroup'] as Map<String, dynamic>),
      accountItemGroup: json['accountItemGroup'] == null
          ? null
          : ParentAccountGroup.fromJson(
              json['accountItemGroup'] as Map<String, dynamic>),
      accountPriceGroup: json['accountPriceGroup'] == null
          ? null
          : ParentAccountGroup.fromJson(
              json['accountPriceGroup'] as Map<String, dynamic>),
      infos: json['infos'] as List<dynamic>?,
    );

Map<String, dynamic> _$ParentToJson(Parent instance) => <String, dynamic>{
      'accountGroup': instance.accountGroup,
      'accountItemGroup': instance.accountItemGroup,
      'accountPriceGroup': instance.accountPriceGroup,
      'infos': instance.infos,
    };

ParentAccountGroup _$ParentAccountGroupFromJson(Map<String, dynamic> json) =>
    ParentAccountGroup(
      infos: json['infos'] as List<dynamic>?,
    );

Map<String, dynamic> _$ParentAccountGroupToJson(ParentAccountGroup instance) =>
    <String, dynamic>{
      'infos': instance.infos,
    };
