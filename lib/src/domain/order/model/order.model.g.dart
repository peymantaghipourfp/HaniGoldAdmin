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
      item: json['item'] == null
          ? null
          : ItemModel.fromJson(json['item'] as Map<String, dynamic>),
      amount: (json['amount'] as num?)?.toInt(),
      price: (json['price'] as num?)?.toDouble(),
      differentPrice: (json['differentPrice'] as num?)?.toDouble(),
      totalPrice: (json['totalPrice'] as num?)?.toDouble(),
      checked: json['checked'] as bool?,
      rowNum: (json['rowNum'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      attribute: json['attribute'] as String?,
      recId: json['recId'] as String?,
      infos: json['infos'] as List<dynamic>?,
      limitPrice: (json['limitPrice'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$OrderModelToJson(OrderModel instance) =>
    <String, dynamic>{
      'date': instance.date?.toIso8601String(),
      'limitDate': instance.limitDate?.toIso8601String(),
      'account': instance.account,
      'type': instance.type,
      'mode': instance.mode,
      'item': instance.item,
      'amount': instance.amount,
      'price': instance.price,
      'differentPrice': instance.differentPrice,
      'totalPrice': instance.totalPrice,
      'checked': instance.checked,
      'rowNum': instance.rowNum,
      'id': instance.id,
      'attribute': instance.attribute,
      'recId': instance.recId,
      'infos': instance.infos,
      'limitPrice': instance.limitPrice,
    };
