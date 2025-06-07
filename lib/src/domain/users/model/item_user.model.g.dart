// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_user.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemUserModel _$ItemUserModelFromJson(Map<String, dynamic> json) =>
    ItemUserModel(
      contact: json['contact'] == null
          ? null
          : Contact.fromJson(json['contact'] as Map<String, dynamic>),
      code: json['code'] as String?,
      status: (json['status'] as num?)?.toInt(),
      userName: json['userName'] as String?,
      mobileNumber: json['mobileNumber'] as String?,
      email: json['email'] as String?,
      rowNum: (json['rowNum'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      attribute: json['attribute'] as String?,
      description: json['description'] as String?,
      recId: json['recId'] as String?,
      infos: json['infos'] as List<dynamic>?,
    );

Map<String, dynamic> _$ItemUserModelToJson(ItemUserModel instance) =>
    <String, dynamic>{
      'contact': instance.contact,
      'code': instance.code,
      'status': instance.status,
      'userName': instance.userName,
      'mobileNumber': instance.mobileNumber,
      'email': instance.email,
      'rowNum': instance.rowNum,
      'id': instance.id,
      'attribute': instance.attribute,
      'description': instance.description,
      'recId': instance.recId,
      'infos': instance.infos,
    };

Contact _$ContactFromJson(Map<String, dynamic> json) => Contact(
      account: json['account'] == null
          ? null
          : Account.fromJson(json['account'] as Map<String, dynamic>),
      name: json['name'] as String?,
      id: (json['id'] as num?)?.toInt(),
      infos: json['infos'] as List<dynamic>?,
    );

Map<String, dynamic> _$ContactToJson(Contact instance) => <String, dynamic>{
      'account': instance.account,
      'name': instance.name,
      'id': instance.id,
      'infos': instance.infos,
    };

Account _$AccountFromJson(Map<String, dynamic> json) => Account(
      name: json['name'] as String?,
      accountGroup: json['accountGroup'] == null
          ? null
          : AccountGroup.fromJson(json['accountGroup'] as Map<String, dynamic>),
      id: (json['id'] as num?)?.toInt(),
      infos: json['infos'] as List<dynamic>?,
    );

Map<String, dynamic> _$AccountToJson(Account instance) => <String, dynamic>{
      'name': instance.name,
      'accountGroup': instance.accountGroup,
      'id': instance.id,
      'infos': instance.infos,
    };

AccountGroup _$AccountGroupFromJson(Map<String, dynamic> json) => AccountGroup(
      infos: json['infos'] as List<dynamic>?,
    );

Map<String, dynamic> _$AccountGroupToJson(AccountGroup instance) =>
    <String, dynamic>{
      'infos': instance.infos,
    };
