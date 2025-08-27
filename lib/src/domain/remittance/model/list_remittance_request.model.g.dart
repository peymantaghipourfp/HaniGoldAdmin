// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_remittance_request.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListRemittanceRequestModel _$ListRemittanceRequestModelFromJson(
        Map<String, dynamic> json) =>
    ListRemittanceRequestModel(
      remittanceRequests: (json['remittanceRequests'] as List<dynamic>?)
          ?.map(
              (e) => RemittanceRequestModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      paginated: json['paginated'] == null
          ? null
          : PaginatedModel.fromJson(json['paginated'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ListRemittanceRequestModelToJson(
        ListRemittanceRequestModel instance) =>
    <String, dynamic>{
      'remittanceRequests': instance.remittanceRequests,
      'paginated': instance.paginated,
    };
