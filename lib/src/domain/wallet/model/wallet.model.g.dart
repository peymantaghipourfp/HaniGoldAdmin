// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WalletModel _$WalletModelFromJson(Map<String, dynamic> json) => WalletModel(
      type: (json['type'] as num?)?.toInt(),
      address: json['address'] as String?,
      account: json['account'] == null
          ? null
          : AccountModel.fromJson(json['account'] as Map<String, dynamic>),
      item: json['item'] == null
          ? null
          : ItemModel.fromJson(json['item'] as Map<String, dynamic>),
      balance: (json['balance'] as num?)?.toInt(),
      infos: json['infos'] as List<dynamic>?,
    );

Map<String, dynamic> _$WalletModelToJson(WalletModel instance) =>
    <String, dynamic>{
      'type': instance.type,
      'address': instance.address,
      'account': instance.account,
      'item': instance.item,
      'balance': instance.balance,
      'infos': instance.infos,
    };
