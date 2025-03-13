// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deposit.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DepositModel _$DepositModelFromJson(Map<String, dynamic> json) => DepositModel(
      depositRequest: json['depositRequest'] == null
          ? null
          : DepositRequestModel.fromJson(
              json['depositRequest'] as Map<String, dynamic>),
      wallet: json['wallet'] == null
          ? null
          : WalletModel.fromJson(json['wallet'] as Map<String, dynamic>),
      bankAccount: json['bankAccount'] == null
          ? null
          : BankAccountModel.fromJson(
              json['bankAccount'] as Map<String, dynamic>),
      amount: (json['amount'] as num?)?.toInt(),
      status: (json['status'] as num?)?.toInt(),
      rowNum: (json['rowNum'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      attribute: json['attribute'] as String?,
      recId: json['recId'] as String?,
      infos: json['infos'] as List<dynamic>?,
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$DepositModelToJson(DepositModel instance) =>
    <String, dynamic>{
      'depositRequest': instance.depositRequest,
      'wallet': instance.wallet,
      'bankAccount': instance.bankAccount,
      'amount': instance.amount,
      'status': instance.status,
      'rowNum': instance.rowNum,
      'id': instance.id,
      'attribute': instance.attribute,
      'recId': instance.recId,
      'infos': instance.infos,
      'date': instance.date?.toIso8601String(),
    };
