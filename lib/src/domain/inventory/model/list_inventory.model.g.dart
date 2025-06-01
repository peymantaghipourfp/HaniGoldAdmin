// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_inventory.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListInventoryModel _$ListInventoryModelFromJson(Map<String, dynamic> json) =>
    ListInventoryModel(
      inventories: (json['inventories'] as List<dynamic>?)
          ?.map((e) => InventoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      paginated: json['paginated'] == null
          ? null
          : PaginatedModel.fromJson(json['paginated'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ListInventoryModelToJson(ListInventoryModel instance) =>
    <String, dynamic>{
      'inventories': instance.inventories,
      'paginated': instance.paginated,
    };
