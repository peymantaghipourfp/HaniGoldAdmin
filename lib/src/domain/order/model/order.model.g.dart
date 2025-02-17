// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) => OrderModel(
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      account: json['account'] == null
          ? null
          : AccountModel.fromJson(json['account'] as Map<String, dynamic>),
      type: (json['type'] as num?)?.toInt(),
      registered: (json['registered'] as num?)?.toInt(),
      checked: (json['checked'] as num?)?.toInt(),
      salesOrderDetails: (json['salesOrderDetails'] as List<dynamic>?)
          ?.map((e) => SalesOrderDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
      rowNum: (json['rowNum'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      attribute: json['attribute'] as String?,
      infos: json['infos'] as List<dynamic>?,
    );

Map<String, dynamic> _$OrderModelToJson(OrderModel instance) =>
    <String, dynamic>{
      'date': instance.date?.toIso8601String(),
      'account': instance.account,
      'type': instance.type,
      'registered': instance.registered,
      'checked': instance.checked,
      'salesOrderDetails': instance.salesOrderDetails,
      'rowNum': instance.rowNum,
      'id': instance.id,
      'attribute': instance.attribute,
      'infos': instance.infos,
    };

SalesOrderDetail _$SalesOrderDetailFromJson(Map<String, dynamic> json) =>
    SalesOrderDetail(
      orderId: (json['orderId'] as num?)?.toInt(),
      item: json['item'] == null
          ? null
          : ItemModel.fromJson(json['item'] as Map<String, dynamic>),
      itemPrice: json['itemPrice'] == null
          ? null
          : ItemPriceModel.fromJson(json['itemPrice'] as Map<String, dynamic>),
      amount: (json['amount'] as num?)?.toInt(),
      price: (json['price'] as num?)?.toDouble(),
      totalPrice: (json['totalPrice'] as num?)?.toDouble(),
      type: (json['type'] as num?)?.toInt(),
      registered: (json['registered'] as num?)?.toInt(),
      checked: (json['checked'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      attribute: json['attribute'] as String?,
      infos: json['infos'] as List<dynamic>?,
    );

Map<String, dynamic> _$SalesOrderDetailToJson(SalesOrderDetail instance) =>
    <String, dynamic>{
      'orderId': instance.orderId,
      'item': instance.item,
      'itemPrice': instance.itemPrice,
      'amount': instance.amount,
      'price': instance.price,
      'totalPrice': instance.totalPrice,
      'type': instance.type,
      'registered': instance.registered,
      'checked': instance.checked,
      'id': instance.id,
      'attribute': instance.attribute,
      'infos': instance.infos,
    };
