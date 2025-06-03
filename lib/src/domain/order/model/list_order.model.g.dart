// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_order.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListOrderModel _$ListOrderModelFromJson(Map<String, dynamic> json) =>
    ListOrderModel(
      orders: (json['orders'] as List<dynamic>)
          .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      paginated:
          PaginatedModel.fromJson(json['paginated'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ListOrderModelToJson(ListOrderModel instance) =>
    <String, dynamic>{
      'orders': instance.orders,
      'paginated': instance.paginated,
    };
