// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountModel _$AccountModelFromJson(Map<String, dynamic> json) => AccountModel(
      type: (json['type'] as num).toInt(),
      code: json['code'] as String,
      name: json['name'] as String,
      parent: Parent.fromJson(json['parent'] as Map<String, dynamic>),
      accountGroup:
          Group.fromJson(json['accountGroup'] as Map<String, dynamic>),
      accountItemGroup:
          Group.fromJson(json['accountItemGroup'] as Map<String, dynamic>),
      accountPriceGroup:
          Group.fromJson(json['accountPriceGroup'] as Map<String, dynamic>),
      rowNum: (json['rowNum'] as num).toInt(),
      id: (json['id'] as num).toInt(),
      attribute: $enumDecode(_$AccountModelAttributeEnumMap, json['attribute']),
      tags: json['tags'] as String,
      recId: json['recId'] as String,
      infos: json['infos'] as List<dynamic>,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
    );

Map<String, dynamic> _$AccountModelToJson(AccountModel instance) =>
    <String, dynamic>{
      'type': instance.type,
      'code': instance.code,
      'name': instance.name,
      'parent': instance.parent,
      'accountGroup': instance.accountGroup,
      'accountItemGroup': instance.accountItemGroup,
      'accountPriceGroup': instance.accountPriceGroup,
      'rowNum': instance.rowNum,
      'id': instance.id,
      'attribute': _$AccountModelAttributeEnumMap[instance.attribute]!,
      'tags': instance.tags,
      'recId': instance.recId,
      'infos': instance.infos,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
    };

const _$AccountModelAttributeEnumMap = {
  AccountModelAttribute.CUS: 'cus',
};

Group _$GroupFromJson(Map<String, dynamic> json) => Group(
      name: $enumDecode(_$NameEnumMap, json['name']),
      id: (json['id'] as num).toInt(),
      infos: json['infos'] as List<dynamic>,
    );

Map<String, dynamic> _$GroupToJson(Group instance) => <String, dynamic>{
      'name': _$NameEnumMap[instance.name]!,
      'id': instance.id,
      'infos': instance.infos,
    };

const _$NameEnumMap = {
  Name.EMPTY: 'گروه ویژه',
  Name.FLUFFY: 'سکه',
  Name.NAME: 'گروه قیمت اول',
  Name.PURPLE: 'طلا',
  Name.STICKY: 'ارز',
  Name.TENTACLED: 'ریال',
  Name.THE_1: 'گروه 1    ',
  Name.THE_2: 'گروه 2    ',
};

Parent _$ParentFromJson(Map<String, dynamic> json) => Parent(
      accountGroup:
          AccountGroup.fromJson(json['accountGroup'] as Map<String, dynamic>),
      accountItemGroup: AccountGroup.fromJson(
          json['accountItemGroup'] as Map<String, dynamic>),
      accountPriceGroup: AccountGroup.fromJson(
          json['accountPriceGroup'] as Map<String, dynamic>),
      infos: json['infos'] as List<dynamic>,
      type: (json['type'] as num).toInt(),
      code: json['code'] as String,
      name: json['name'] as String,
      id: (json['id'] as num).toInt(),
    );

Map<String, dynamic> _$ParentToJson(Parent instance) => <String, dynamic>{
      'accountGroup': instance.accountGroup,
      'accountItemGroup': instance.accountItemGroup,
      'accountPriceGroup': instance.accountPriceGroup,
      'infos': instance.infos,
      'type': instance.type,
      'code': instance.code,
      'name': instance.name,
      'id': instance.id,
    };

AccountGroup _$AccountGroupFromJson(Map<String, dynamic> json) => AccountGroup(
      infos: json['infos'] as List<dynamic>,
    );

Map<String, dynamic> _$AccountGroupToJson(AccountGroup instance) =>
    <String, dynamic>{
      'infos': instance.infos,
    };
