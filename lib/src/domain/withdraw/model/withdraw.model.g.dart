// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'withdraw.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WithdrawModel _$WithdrawModelFromJson(Map<String, dynamic> json) =>
    WithdrawModel(
      bankAccount: json['bankAccount'] == null
          ? null
          : BankAccountModel.fromJson(
              json['bankAccount'] as Map<String, dynamic>),
      wallet: json['wallet'] == null
          ? null
          : WalletModel.fromJson(json['wallet'] as Map<String, dynamic>),
      amount: (json['amount'] as num?)?.toInt(),
      dividedAmount: (json['dividedAmount'] as num?)?.toInt(),
      notConfirmedAmount: (json['notConfirmedAmount'] as num?)?.toInt(),
      undividedAmount: (json['undividedAmount'] as num?)?.toInt(),
      paidAmount: (json['paidAmount'] as num?)?.toInt(),
      requestDate: json['requestDate'] == null
          ? null
          : DateTime.parse(json['requestDate'] as String),
      confirmDate: json['confirmDate'] == null
          ? null
          : DateTime.parse(json['confirmDate'] as String),
      status: (json['status'] as num?)?.toInt(),
      rowNum: (json['rowNum'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      attribute: json['attribute'] as String?,
      infos: json['infos'] as List<dynamic>?,
    );

Map<String, dynamic> _$WithdrawModelToJson(WithdrawModel instance) =>
    <String, dynamic>{
      'bankAccount': instance.bankAccount,
      'wallet': instance.wallet,
      'amount': instance.amount,
      'dividedAmount': instance.dividedAmount,
      'notConfirmedAmount': instance.notConfirmedAmount,
      'undividedAmount': instance.undividedAmount,
      'paidAmount': instance.paidAmount,
      'requestDate': instance.requestDate?.toIso8601String(),
      'confirmDate': instance.confirmDate?.toIso8601String(),
      'rowNum': instance.rowNum,
      'id': instance.id,
      'attribute': instance.attribute,
      'infos': instance.infos,
    };
