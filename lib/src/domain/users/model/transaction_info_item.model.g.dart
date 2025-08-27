// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_info_item.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionInfoItemModel _$TransactionInfoItemModelFromJson(
        Map<String, dynamic> json) =>
    TransactionInfoItemModel(
      amount: (json['amount'] as num?)?.toDouble(),
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      type: json['type'] as String?,
      wallet: json['wallet'] == null
          ? null
          : WalletModel.fromJson(json['wallet'] as Map<String, dynamic>),
      toWallet: json['toWallet'] == null
          ? null
          : WalletModel.fromJson(json['toWallet'] as Map<String, dynamic>),
      item: json['item'] == null
          ? null
          : ItemModel.fromJson(json['item'] as Map<String, dynamic>),
      price: (json['price'] as num?)?.toDouble(),
      mesghalPrice: (json['mesghalPrice'] as num?)?.toDouble(),
      totalPrice: (json['totalPrice'] as num?)?.toDouble(),
      balances: (json['balances'] as List<dynamic>?)
          ?.map((e) => BalanceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      details: (json['details'] as List<dynamic>?)
          ?.map((e) => TransactionInfoDetailItemModel.fromJson(
              e as Map<String, dynamic>))
          .toList(),
      rowNum: (json['rowNum'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      description: json['description'] as String?,
      isCard: json['isCard'] as bool?,
      infos: json['infos'] as List<dynamic>?,
      recordId: (json['recordId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TransactionInfoItemModelToJson(
        TransactionInfoItemModel instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'date': instance.date?.toIso8601String(),
      'type': instance.type,
      'wallet': instance.wallet,
      'toWallet': instance.toWallet,
      'item': instance.item,
      'price': instance.price,
      'mesghalPrice': instance.mesghalPrice,
      'totalPrice': instance.totalPrice,
      'balances': instance.balances,
      'details': instance.details,
      'rowNum': instance.rowNum,
      'id': instance.id,
      'description': instance.description,
      'isCard': instance.isCard,
      'infos': instance.infos,
      'recordId': instance.recordId,
    };
