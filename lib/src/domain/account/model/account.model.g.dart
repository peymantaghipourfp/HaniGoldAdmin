// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountModel _$AccountModelFromJson(Map<String, dynamic> json) => AccountModel(
      type: (json['type'] as num?)?.toInt(),
      accountLevel: (json['accountLevel'] as num?)?.toInt(),
      childrenCount: (json['childrenCount'] as num?)?.toInt(),
      subGroupCount: (json['subGroupCount'] as num?)?.toInt(),
      contactInfo: json['contactInfo'] as String?,
      code: json['code'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      name: json['name'] as String?,
      status: (json['status'] as num?)?.toInt(),
      hasDeposit: json['hasDeposit'] as bool?,
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      parent: json['parent'] == null
          ? null
          : ParentAccountModel.fromJson(json['parent'] as Map<String, dynamic>),
      accountGroup: json['accountGroup'] == null
          ? null
          : AccountGroupModel.fromJson(
              json['accountGroup'] as Map<String, dynamic>),
      contacts: (json['contacts'] as List<dynamic>?)
          ?.map((e) => ContactElement.fromJson(e as Map<String, dynamic>))
          .toList(),
      accountSubGroups: (json['accountSubGroups'] as List<dynamic>?)
          ?.map((e) => AccountSubGroupModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      addresses: (json['addresses'] as List<dynamic>?)
          ?.map((e) => Address.fromJson(e as Map<String, dynamic>))
          .toList(),
      contactInfos: (json['contactInfos'] as List<dynamic>?)
          ?.map((e) => ContactInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      childs: (json['childs'] as List<dynamic>?)
          ?.map((e) => AccountModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      rowNum: (json['rowNum'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      attribute: json['attribute'] as String?,
      recId: json['recId'] as String?,
      infos: json['infos'] as List<dynamic>?,
    );

Map<String, dynamic> _$AccountModelToJson(AccountModel instance) =>
    <String, dynamic>{
      'type': instance.type,
      'accountLevel': instance.accountLevel,
      'childrenCount': instance.childrenCount,
      'subGroupCount': instance.subGroupCount,
      'code': instance.code,
      'contactInfo': instance.contactInfo,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'name': instance.name,
      'status': instance.status,
      'hasDeposit': instance.hasDeposit,
      'startDate': instance.startDate?.toIso8601String(),
      'parent': instance.parent,
      'accountGroup': instance.accountGroup,
      'contacts': instance.contacts,
      'accountSubGroups': instance.accountSubGroups,
      'addresses': instance.addresses,
      'contactInfos': instance.contactInfos,
      'childs': instance.childs,
      'rowNum': instance.rowNum,
      'id': instance.id,
      'attribute': instance.attribute,
      'recId': instance.recId,
      'infos': instance.infos,
    };

Address _$AddressFromJson(Map<String, dynamic> json) => Address(
      isMain: json['isMain'] as bool?,
      name: json['name'] as String?,
      account: json['account'] == null
          ? null
          : AddressAccount.fromJson(json['account'] as Map<String, dynamic>),
      contact: json['contact'],
      country: json['country'] == null
          ? null
          : Country.fromJson(json['country'] as Map<String, dynamic>),
      state: json['state'] == null
          ? null
          : StateItemModel.fromJson(json['state'] as Map<String, dynamic>),
      city: json['city'] == null
          ? null
          : CityItemModel.fromJson(json['city'] as Map<String, dynamic>),
      fullAddress: json['fullAddress'] as String?,
      rowNum: (json['rowNum'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      attribute: json['attribute'] as String?,
      recId: json['recId'] as String?,
      infos: json['infos'] as List<dynamic>?,
    );

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
      'isMain': instance.isMain,
      'name': instance.name,
      'account': instance.account,
      'contact': instance.contact,
      'country': instance.country,
      'state': instance.state,
      'city': instance.city,
      'fullAddress': instance.fullAddress,
      'rowNum': instance.rowNum,
      'id': instance.id,
      'attribute': instance.attribute,
      'recId': instance.recId,
      'infos': instance.infos,
    };

AddressAccount _$AddressAccountFromJson(Map<String, dynamic> json) =>
    AddressAccount(
      id: (json['id'] as num?)?.toInt(),
      infos: json['infos'] as List<dynamic>?,
    );

Map<String, dynamic> _$AddressAccountToJson(AddressAccount instance) =>
    <String, dynamic>{
      'id': instance.id,
      'infos': instance.infos,
    };

ContactInfo _$ContactInfoFromJson(Map<String, dynamic> json) => ContactInfo(
      account: json['account'] == null
          ? null
          : AddressAccount.fromJson(json['account'] as Map<String, dynamic>),
      contact: json['contact'] == null
          ? null
          : ContactInfoContact.fromJson(
              json['contact'] as Map<String, dynamic>),
      type: (json['type'] as num?)?.toInt(),
      name: json['name'] as String?,
      value: json['value'] as String?,
      rowNum: (json['rowNum'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      attribute: json['attribute'] as String?,
      recId: json['recId'] as String?,
      infos: json['infos'] as List<dynamic>?,
    );

Map<String, dynamic> _$ContactInfoToJson(ContactInfo instance) =>
    <String, dynamic>{
      'account': instance.account,
      'contact': instance.contact,
      'type': instance.type,
      'name': instance.name,
      'value': instance.value,
      'rowNum': instance.rowNum,
      'id': instance.id,
      'attribute': instance.attribute,
      'recId': instance.recId,
      'infos': instance.infos,
    };

ContactInfoContact _$ContactInfoContactFromJson(Map<String, dynamic> json) =>
    ContactInfoContact(
      account: json['account'] == null
          ? null
          : ParentAccountModel.fromJson(
              json['account'] as Map<String, dynamic>),
      id: (json['id'] as num?)?.toInt(),
      infos: json['infos'] as List<dynamic>?,
    );

Map<String, dynamic> _$ContactInfoContactToJson(ContactInfoContact instance) =>
    <String, dynamic>{
      'account': instance.account,
      'id': instance.id,
      'infos': instance.infos,
    };

ContactElement _$ContactElementFromJson(Map<String, dynamic> json) =>
    ContactElement(
      account: json['account'] == null
          ? null
          : ContactAccount.fromJson(json['account'] as Map<String, dynamic>),
      name: json['name'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      gender: (json['gender'] as num?)?.toInt(),
      rowNum: (json['rowNum'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      attribute: json['attribute'] as String?,
      recId: json['recId'] as String?,
      infos: json['infos'] as List<dynamic>?,
    );

Map<String, dynamic> _$ContactElementToJson(ContactElement instance) =>
    <String, dynamic>{
      'account': instance.account,
      'name': instance.name,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'gender': instance.gender,
      'rowNum': instance.rowNum,
      'id': instance.id,
      'attribute': instance.attribute,
      'recId': instance.recId,
      'infos': instance.infos,
    };

ContactAccount _$ContactAccountFromJson(Map<String, dynamic> json) =>
    ContactAccount(
      code: json['code'] as String?,
      name: json['name'] as String?,
      accountGroup: json['accountGroup'],
      id: (json['id'] as num?)?.toInt(),
      infos: json['infos'] as List<dynamic>?,
    );

Map<String, dynamic> _$ContactAccountToJson(ContactAccount instance) =>
    <String, dynamic>{
      'code': instance.code,
      'name': instance.name,
      'accountGroup': instance.accountGroup,
      'id': instance.id,
      'infos': instance.infos,
    };
