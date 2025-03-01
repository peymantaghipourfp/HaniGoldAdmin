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
      undividedAmount: (json['undividedAmount'] as num?)?.toInt(),
      requestDate: json['requestDate'] == null
          ? null
          : DateTime.parse(json['requestDate'] as String),
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
      'undividedAmount': instance.undividedAmount,
      'requestDate': instance.requestDate?.toIso8601String(),
      'rowNum': instance.rowNum,
      'id': instance.id,
      'attribute': instance.attribute,
      'infos': instance.infos,
    };
