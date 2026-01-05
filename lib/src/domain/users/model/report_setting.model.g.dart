// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_setting.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportSettingModel _$ReportSettingModelFromJson(Map<String, dynamic> json) =>
    ReportSettingModel(
      name: json['name'] as String?,
      includes: (json['includes'] as List<dynamic>?)
          ?.map((e) => Clude.fromJson(e as Map<String, dynamic>))
          .toList(),
      excludes: (json['excludes'] as List<dynamic>?)
          ?.map((e) => Clude.fromJson(e as Map<String, dynamic>))
          .toList(),
      includeString: json['includeString'] as String?,
      excludeString: json['excludeString'] as String?,
      id: (json['id'] as num?)?.toInt(),
      infos: json['infos'] as List<dynamic>?,
    );

Map<String, dynamic> _$ReportSettingModelToJson(ReportSettingModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'includes': instance.includes,
      'excludes': instance.excludes,
      'includeString': instance.includeString,
      'excludeString': instance.excludeString,
      'id': instance.id,
      'infos': instance.infos,
    };

Clude _$CludeFromJson(Map<String, dynamic> json) => Clude(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
    );

Map<String, dynamic> _$CludeToJson(Clude instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
