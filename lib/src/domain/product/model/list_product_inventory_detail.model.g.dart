// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_product_inventory_detail.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListProductInventoryDetailModel _$ListProductInventoryDetailModelFromJson(
        Map<String, dynamic> json) =>
    ListProductInventoryDetailModel(
      inventories: (json['inventories'] as List<dynamic>?)
          ?.map((e) =>
              ProductInventoryDetailModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      paginated: json['paginated'] == null
          ? null
          : PaginatedModel.fromJson(json['paginated'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ListProductInventoryDetailModelToJson(
        ListProductInventoryDetailModel instance) =>
    <String, dynamic>{
      'inventories': instance.inventories,
      'paginated': instance.paginated,
    };
