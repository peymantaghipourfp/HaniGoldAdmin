// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginatedModel _$PaginatedModelFromJson(Map<String, dynamic> json) =>
    PaginatedModel(
      fromNumber: (json['fromNumber'] as num?)?.toInt(),
      toNumber: (json['toNumber'] as num?)?.toInt(),
      totalCount: (json['totalCount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PaginatedModelToJson(PaginatedModel instance) =>
    <String, dynamic>{
      'fromNumber': instance.fromNumber,
      'toNumber': instance.toNumber,
      'totalCount': instance.totalCount,
    };
