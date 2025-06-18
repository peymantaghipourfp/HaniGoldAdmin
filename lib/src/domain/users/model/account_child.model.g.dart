// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_child.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountChildModel _$AccountChildModelFromJson(Map<String, dynamic> json) =>
    AccountChildModel(
      parent: json['parent'] == null
          ? null
          : ParentChildModel.fromJson(json['parent'] as Map<String, dynamic>),
      id: (json['id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$AccountChildModelToJson(AccountChildModel instance) =>
    <String, dynamic>{
      'parent': instance.parent,
      'id': instance.id,
    };

ParentChildModel _$ParentChildModelFromJson(Map<String, dynamic> json) =>
    ParentChildModel(
      id: (json['id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ParentChildModelToJson(ParentChildModel instance) =>
    <String, dynamic>{
      'id': instance.id,
    };
