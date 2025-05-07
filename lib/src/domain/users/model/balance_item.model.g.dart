// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'balance_item.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BalanceItemModel _$BalanceItemModelFromJson(Map<String, dynamic> json) =>
    BalanceItemModel(
      type: (json['type'] as num?)?.toInt(),
      address: json['address'] as String?,
      account: json['account'] == null
          ? null
          : AccountModel.fromJson(json['account'] as Map<String, dynamic>),
      item: json['item'] == null
          ? null
          : ItemModel.fromJson(json['item'] as Map<String, dynamic>),
      balance: (json['balance'] as num?)?.toDouble(),
      isMainCurrency: json['isMainCurrency'] as bool?,
      id: (json['id'] as num?)?.toInt(),
      infos: json['infos'] as List<dynamic>?,
    );

Map<String, dynamic> _$BalanceItemModelToJson(BalanceItemModel instance) =>
    <String, dynamic>{
      'type': instance.type,
      'address': instance.address,
      'account': instance.account,
      'item': instance.item,
      'balance': instance.balance,
      'isMainCurrency': instance.isMainCurrency,
      'id': instance.id,
      'infos': instance.infos,
    };
