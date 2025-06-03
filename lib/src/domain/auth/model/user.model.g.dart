// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      languageCode: json['languageCode'] as String?,
      themeName: json['themeName'] as String?,
      rowNum: (json['rowNum'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      infos: json['infos'] as List<dynamic>?,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'user': instance.user,
      'languageCode': instance.languageCode,
      'themeName': instance.themeName,
      'rowNum': instance.rowNum,
      'id': instance.id,
      'infos': instance.infos,
    };

User _$UserFromJson(Map<String, dynamic> json) => User(
      contact: json['contact'] == null
          ? null
          : Contact.fromJson(json['contact'] as Map<String, dynamic>),
      code: json['code'] as String?,
      userName: json['userName'] as String?,
      id: (json['id'] as num?)?.toInt(),
      infos: json['infos'] as List<dynamic>?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'contact': instance.contact,
      'code': instance.code,
      'userName': instance.userName,
      'id': instance.id,
      'infos': instance.infos,
    };

Contact _$ContactFromJson(Map<String, dynamic> json) => Contact(
      account: json['account'],
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
