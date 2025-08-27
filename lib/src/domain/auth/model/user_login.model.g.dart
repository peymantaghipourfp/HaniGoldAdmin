// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_login.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserLoginModel _$UserLoginModelFromJson(Map<String, dynamic> json) =>
    UserLoginModel(
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      languageCode: json['languageCode'] as String,
      themeName: json['themeName'] as String,
      rowNum: (json['rowNum'] as num).toInt(),
      id: (json['id'] as num).toInt(),
      token: json['token'] as String?,
      infos: json['infos'] as List<dynamic>,
    );

Map<String, dynamic> _$UserLoginModelToJson(UserLoginModel instance) =>
    <String, dynamic>{
      'user': instance.user,
      'languageCode': instance.languageCode,
      'themeName': instance.themeName,
      'rowNum': instance.rowNum,
      'id': instance.id,
      'token': instance.token,
      'infos': instance.infos,
    };

User _$UserFromJson(Map<String, dynamic> json) => User(
      contact: Contact.fromJson(json['contact'] as Map<String, dynamic>),
      code: json['code'] as String,
      userName: json['userName'] as String,
      id: (json['id'] as num).toInt(),
      infos: json['infos'] as List<dynamic>,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'contact': instance.contact,
      'code': instance.code,
      'userName': instance.userName,
      'id': instance.id,
      'infos': instance.infos,
    };

Contact _$ContactFromJson(Map<String, dynamic> json) => Contact(
      account: Account.fromJson(json['account'] as Map<String, dynamic>),
      name: json['name'] as String,
      id: (json['id'] as num).toInt(),
      infos: json['infos'] as List<dynamic>,
    );

Map<String, dynamic> _$ContactToJson(Contact instance) => <String, dynamic>{
      'account': instance.account,
      'name': instance.name,
      'id': instance.id,
      'infos': instance.infos,
    };

Account _$AccountFromJson(Map<String, dynamic> json) => Account(
      accountGroup:
          AccountGroup.fromJson(json['accountGroup'] as Map<String, dynamic>),
      infos: json['infos'] as List<dynamic>,
    );

Map<String, dynamic> _$AccountToJson(Account instance) => <String, dynamic>{
      'accountGroup': instance.accountGroup,
      'infos': instance.infos,
    };

AccountGroup _$AccountGroupFromJson(Map<String, dynamic> json) => AccountGroup(
      infos: json['infos'] as List<dynamic>,
    );

Map<String, dynamic> _$AccountGroupToJson(AccountGroup instance) =>
    <String, dynamic>{
      'infos': instance.infos,
    };
