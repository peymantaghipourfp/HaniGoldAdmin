// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parent_account.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParentAccountModel _$ParentAccountModelFromJson(Map<String, dynamic> json) =>
    ParentAccountModel(
      type: (json['type'] as num?)?.toInt(),
      code: json['code'] as String?,
      name: json['name'] as String?,
      accountGroup: json['accountGroup'] == null
          ? null
          : AccountGroup.fromJson(json['accountGroup'] as Map<String, dynamic>),
      accountSubGroup: json['accountSubGroup'] == null
          ? null
          : AccountGroup.fromJson(
              json['accountSubGroup'] as Map<String, dynamic>),
      id: (json['id'] as num?)?.toInt(),
      infos: json['infos'] as List<dynamic>?,
    );

Map<String, dynamic> _$ParentAccountModelToJson(ParentAccountModel instance) =>
    <String, dynamic>{
      'type': instance.type,
      'code': instance.code,
      'name': instance.name,
      'accountGroup': instance.accountGroup,
      'accountSubGroup': instance.accountSubGroup,
      'id': instance.id,
      'infos': instance.infos,
    };

AccountGroup _$AccountGroupFromJson(Map<String, dynamic> json) => AccountGroup(
      infos: json['infos'] as List<dynamic>,
    );

Map<String, dynamic> _$AccountGroupToJson(AccountGroup instance) =>
    <String, dynamic>{
      'infos': instance.infos,
    };
