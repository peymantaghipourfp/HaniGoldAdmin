// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_laboratory.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListLaboratoryModel _$ListLaboratoryModelFromJson(Map<String, dynamic> json) =>
    ListLaboratoryModel(
      laboratories: (json['laboratories'] as List<dynamic>?)
          ?.map((e) => LaboratoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      paginated: json['paginated'] == null
          ? null
          : PaginatedModel.fromJson(json['paginated'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ListLaboratoryModelToJson(
        ListLaboratoryModel instance) =>
    <String, dynamic>{
      'laboratories': instance.laboratories,
      'paginated': instance.paginated,
    };
