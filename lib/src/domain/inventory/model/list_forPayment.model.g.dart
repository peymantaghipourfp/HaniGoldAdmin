// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_forPayment.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListForPaymentModel _$ListForPaymentModelFromJson(Map<String, dynamic> json) =>
    ListForPaymentModel(
      inventories: (json['inventories'] as List<dynamic>?)
          ?.map((e) => InventoryDetailModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      paginated: json['paginated'] == null
          ? null
          : PaginatedModel.fromJson(json['paginated'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ListForPaymentModelToJson(
        ListForPaymentModel instance) =>
    <String, dynamic>{
      'inventories': instance.inventories,
      'paginated': instance.paginated,
    };
