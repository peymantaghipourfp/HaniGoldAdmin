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
      quantity: (json['quantity'] as num?)?.toDouble(),
      price: (json['price'] as num?)?.toDouble(),
      mesghalPrice: (json['mesghalPrice'] as num?)?.toDouble(),
      differentPrice: (json['differentPrice'] as num?)?.toDouble(),
      totalPrice: (json['totalPrice'] as num?)?.toDouble(),
      status: (json['status'] as num?)?.toInt(),
      balances: (json['balances'] as List<dynamic>?)
          ?.map((e) => Balance.fromJson(e as Map<String, dynamic>))
          .toList(),
      rowNum: (json['rowNum'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      attribute: json['attribute'] as String?,
      recId: json['recId'] as String?,
      infos: json['infos'] as List<dynamic>?,
      limitPrice: (json['limitPrice'] as num?)?.toDouble(),
      description: json['description'] as String?,
      registered: json['registered'] as bool?,
      notLimit: json['notLimit'] as bool?,
      manualPrice: json['manualPrice'] as bool?,
      accountParent: json['accountParent'] == null
          ? null
          : AccountParent.fromJson(
              json['accountParent'] as Map<String, dynamic>),
      extraAmount: (json['extraAmount'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$OrderModelToJson(OrderModel instance) =>
    <String, dynamic>{
      'date': instance.date?.toIso8601String(),
      'limitDate': instance.limitDate?.toIso8601String(),
      'account': instance.account,
      'type': instance.type,
      'mode': instance.mode,
      'item': instance.item,
      'quantity': instance.quantity,
      'price': instance.price,
      'mesghalPrice': instance.mesghalPrice,
      'differentPrice': instance.differentPrice,
      'totalPrice': instance.totalPrice,
      'status': instance.status,
      'balances': instance.balances,
      'rowNum': instance.rowNum,
      'id': instance.id,
      'attribute': instance.attribute,
      'recId': instance.recId,
      'infos': instance.infos,
      'limitPrice': instance.limitPrice,
      'description': instance.description,
      'registered': instance.registered,
      'notLimit': instance.notLimit,
      'manualPrice': instance.manualPrice,
      'accountParent': instance.accountParent,
      'extraAmount': instance.extraAmount,
    };

Balance _$BalanceFromJson(Map<String, dynamic> json) => Balance(
      balance: (json['balance'] as num?)?.toDouble(),
      itemName: json['itemName'] as String?,
      unitName: json['unitName'] as String?,
    );

Map<String, dynamic> _$BalanceToJson(Balance instance) => <String, dynamic>{
      'balance': instance.balance,
      'itemName': instance.itemName,
      'unitName': instance.unitName,
    };

AccountParent _$AccountParentFromJson(Map<String, dynamic> json) =>
    AccountParent(
      code: json['code'] as String?,
      name: json['name'] as String?,
      contactInfo: json['contactInfo'] as String?,
      accountGroup: json['accountGroup'] == null
          ? null
          : AccountGroupModel.fromJson(
              json['accountGroup'] as Map<String, dynamic>),
      accountSubGroup: json['accountSubGroup'] == null
          ? null
          : AccountSubGroupModel.fromJson(
              json['accountSubGroup'] as Map<String, dynamic>),
      id: (json['id'] as num?)?.toInt(),
      infos: json['infos'] as List<dynamic>?,
    );

Map<String, dynamic> _$AccountParentToJson(AccountParent instance) =>
    <String, dynamic>{
      'code': instance.code,
      'name': instance.name,
      'contactInfo': instance.contactInfo,
      'accountGroup': instance.accountGroup,
      'accountSubGroup': instance.accountSubGroup,
      'id': instance.id,
      'infos': instance.infos,
    };
