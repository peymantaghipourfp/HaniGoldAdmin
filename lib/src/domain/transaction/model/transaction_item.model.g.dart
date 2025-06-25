// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_item.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionModel _$TransactionModelFromJson(Map<String, dynamic> json) =>
    TransactionModel(
      amount: (json['amount'] as num?)?.toInt(),
      date: json['date'] as String?,
      type: json['type'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      totalPrice: (json['totalPrice'] as num?)?.toDouble(),
      wallet: json['wallet'] == null
          ? null
          : WalletModel.fromJson(json['wallet'] as Map<String, dynamic>),
      account: json['account'] == null
          ? null
          : AccountModel.fromJson(json['account'] as Map<String, dynamic>),
      toWallet: json['toWallet'] == null
          ? null
          : WalletModel.fromJson(json['toWallet'] as Map<String, dynamic>),
      toAccount: json['toAccount'] == null
          ? null
          : AccountModel.fromJson(json['toAccount'] as Map<String, dynamic>),
      item: json['item'] == null
          ? null
          : ItemModel.fromJson(json['item'] as Map<String, dynamic>),
      balances: (json['balances'] as List<dynamic>?)
          ?.map((e) => BalanceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      tobalances: (json['tobalances'] as List<dynamic>?)
          ?.map((e) => BalanceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      details: (json['details'] as List<dynamic>?)
          ?.map((e) => InventoryDetailModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      rowNum: (json['rowNum'] as num?)?.toInt(),
          recId: json['recId'] as String?,
      id: (json['id'] as num?)?.toInt(),
      infos: json['infos'] as List<dynamic>?,
    );

Map<String, dynamic> _$TransactionModelToJson(TransactionModel instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'date': instance.date,
      'type': instance.type,
      'price': instance.price,
      'totalPrice': instance.totalPrice,
      'wallet': instance.wallet,
      'account': instance.account,
      'toWallet': instance.toWallet,
      'toAccount': instance.toAccount,
      'item': instance.item,
      'balances': instance.balances,
      'tobalances': instance.tobalances,
      'details': instance.details,
      'rowNum': instance.rowNum,
      'id': instance.id,
      'infos': instance.infos,
    };
