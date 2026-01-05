// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_credit_helper.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListCreditHelperModel _$ListCreditHelperModelFromJson(
        Map<String, dynamic> json) =>
    ListCreditHelperModel(
      creditHelpers: (json['creditHelpers'] as List<dynamic>?)
          ?.map((e) => CreditHelperModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      paginated: json['paginated'] == null
          ? null
          : PaginatedModel.fromJson(json['paginated'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ListCreditHelperModelToJson(
        ListCreditHelperModel instance) =>
    <String, dynamic>{
      'creditHelpers': instance.creditHelpers,
      'paginated': instance.paginated,
    };
