// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_wallet.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransferWalletModel _$TransferWalletModelFromJson(Map<String, dynamic> json) =>
    TransferWalletModel(
      account: json['account'] == null
          ? null
          : AccountModel.fromJson(json['account'] as Map<String, dynamic>),
      date: json['date'] as String?,
      transferDate: json['transferDate'] as String?,
      fromWallet: json['fromWallet'] == null
          ? null
          : WalletModel.fromJson(json['fromWallet'] as Map<String, dynamic>),
      toWallet: json['toWallet'] == null
          ? null
          : WalletModel.fromJson(json['toWallet'] as Map<String, dynamic>),
      quantity: (json['quantity'] as num?)?.toDouble(),
      isDeleted: (json['isDeleted'] as num?)?.toInt(),
      rowNum: (json['rowNum'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      attribute: json['attribute'] as String?,
      infos: json['infos'] as List<dynamic>?,
    );

Map<String, dynamic> _$TransferWalletModelToJson(
        TransferWalletModel instance) =>
    <String, dynamic>{
      'account': instance.account,
      'date': instance.date,
      'transferDate': instance.transferDate,
      'fromWallet': instance.fromWallet,
      'toWallet': instance.toWallet,
      'quantity': instance.quantity,
      'isDeleted': instance.isDeleted,
      'rowNum': instance.rowNum,
      'id': instance.id,
      'attribute': instance.attribute,
      'infos': instance.infos,
    };
