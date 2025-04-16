// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_withdraw.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WalletWithdrawModel _$WalletWithdrawModelFromJson(Map<String, dynamic> json) =>
    WalletWithdrawModel(
      account: json['account'] == null
          ? null
          : AccountModel.fromJson(json['account'] as Map<String, dynamic>),
      item: json['item'] == null
          ? null
          : ItemModel.fromJson(json['item'] as Map<String, dynamic>),
      id: (json['id'] as num?)?.toInt(),
      infos: json['infos'] as List<dynamic>?,
    );

Map<String, dynamic> _$WalletWithdrawModelToJson(
        WalletWithdrawModel instance) =>
    <String, dynamic>{
      'account': instance.account,
      'item': instance.item,
      'id': instance.id,
      'infos': instance.infos,
    };
