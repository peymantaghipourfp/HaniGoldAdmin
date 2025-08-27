// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'createdBy.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreatedByModel _$CreatedByModelFromJson(Map<String, dynamic> json) =>
    CreatedByModel(
      contact: json['contact'] == null
          ? null
          : ContactModel.fromJson(json['contact'] as Map<String, dynamic>),
      name: json['name'] as String?,
      id: (json['id'] as num?)?.toInt(),
      infos: json['infos'] as List<dynamic>?,
    );

Map<String, dynamic> _$CreatedByModelToJson(CreatedByModel instance) =>
    <String, dynamic>{
      'contact': instance.contact,
      'name': instance.name,
      'id': instance.id,
      'infos': instance.infos,
    };
