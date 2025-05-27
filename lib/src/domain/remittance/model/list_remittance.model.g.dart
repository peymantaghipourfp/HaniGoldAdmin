// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_remittance.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListRemittanceModel _$ListRemittanceModelFromJson(Map<String, dynamic> json) =>
    ListRemittanceModel(
      remittances: (json['remittances'] as List<dynamic>?)
          ?.map((e) => RemittanceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      paginated: json['paginated'] == null
          ? null
          : PaginatedModel.fromJson(json['paginated'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ListRemittanceModelToJson(
        ListRemittanceModel instance) =>
    <String, dynamic>{
      'remittances': instance.remittances,
      'paginated': instance.paginated,
    };
