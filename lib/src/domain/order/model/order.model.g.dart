// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) => OrderModel(
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      limitDate: json['limitDate'] == null
          ? null
          : DateTime.parse(json['limitDate'] as String),
      account: json['account'] == null
          ? null
          : AccountModel.fromJson(json['account'] as Map<String, dynamic>),
      type: (json['type'] as num?)?.toInt(),
      mode: (json['mode'] as num?)?.toInt(),
      checked: json['checked'] as bool?,
      orderDetails: (json['orderDetails'] as List<dynamic>?)
          ?.map((e) => OrderDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
      rowNum: (json['rowNum'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      attribute: json['attribute'] as String?,
      infos: json['infos'] as List<dynamic>?,
    );

Map<String, dynamic> _$OrderModelToJson(OrderModel instance) =>
    <String, dynamic>{
      'date': instance.date?.toIso8601String(),
      'limitDate': instance.limitDate?.toIso8601String(),
      'account': instance.account,
      'type': instance.type,
      'mode': instance.mode,
      'checked': instance.checked,
      'orderDetails': instance.orderDetails,
      'rowNum': instance.rowNum,
      'id': instance.id,
      'attribute': instance.attribute,
      'infos': instance.infos,
    };

OrderDetail _$OrderDetailFromJson(Map<String, dynamic> json) => OrderDetail(
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
      id: (json['id'] as num?)?.toInt(),
      attribute: json['attribute'] as String?,
      infos: json['infos'] as List<dynamic>?,
    );

Map<String, dynamic> _$OrderDetailToJson(OrderDetail instance) =>
    <String, dynamic>{
      'orderId': instance.orderId,
      'item': instance.item,
      'itemPrice': instance.itemPrice,
      'amount': instance.amount,
      'price': instance.price,
      'totalPrice': instance.totalPrice,
      'id': instance.id,
      'attribute': instance.attribute,
      'infos': instance.infos,
    };
