// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setting.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SettingModel _$SettingModelFromJson(Map<String, dynamic> json) => SettingModel(
      status: json['status'] as bool?,
      orderStatus: json['orderStatus'] as bool?,
      adminStatus: json['adminStatus'] as bool?,
      startTime: json['startTime'] as String?,
      endTime: json['endTime'] as String?,
      isOrderAvailable: json['isOrderAvailable'] as bool?,
      rowNum: (json['rowNum'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      infos: json['infos'] as List<dynamic>?,
    );

Map<String, dynamic> _$SettingModelToJson(SettingModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'orderStatus': instance.orderStatus,
      'adminStatus': instance.adminStatus,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'isOrderAvailable': instance.isOrderAvailable,
      'rowNum': instance.rowNum,
      'id': instance.id,
      'infos': instance.infos,
    };
