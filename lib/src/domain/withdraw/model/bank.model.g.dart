// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BankModel _$BankModelFromJson(Map<String, dynamic> json) => BankModel(
      name: json['name'] as String?,
      icon: json['icon'] as String?,
      id: (json['id'] as num?)?.toInt(),
      recId: json['recId'] as String?,
      infos: json['infos'] as List<dynamic>?,
    );

Map<String, dynamic> _$BankModelToJson(BankModel instance) => <String, dynamic>{
      'name': instance.name,
      'icon': instance.icon,
      'id': instance.id,
      'recId': instance.recId,
      'infos': instance.infos,
    };
