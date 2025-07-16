// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'withdraw.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WithdrawModel _$WithdrawModelFromJson(Map<String, dynamic> json) =>
    WithdrawModel(
      bank: json['bank'] == null
          ? null
          : BankModel.fromJson(json['bank'] as Map<String, dynamic>),
      wallet: json['wallet'] == null
          ? null
          : WalletModel.fromJson(json['wallet'] as Map<String, dynamic>),
      reasonRejection: json['reasonRejection'] == null
          ? null
          : ReasonRejectionModel.fromJson(
              json['reasonRejection'] as Map<String, dynamic>),
      ownerName: json['ownerName'] as String?,
      amount: (json['amount'] as num?)?.toDouble(),
      dividedAmount: (json['dividedAmount'] as num?)?.toDouble(),
      notConfirmedAmount: (json['notConfirmedAmount'] as num?)?.toDouble(),
      undividedAmount: (json['undividedAmount'] as num?)?.toDouble(),
      paidAmount: (json['paidAmount'] as num?)?.toDouble(),
      totalAmountPerDay: (json['totalAmountPerDay'] as num?)?.toDouble(),
      totalPaidAmountPerDay: (json['totalPaidAmountPerDay'] as num?)?.toDouble(),
      totalDepositRequestAmountPerDay: (json['totalDepositRequestAmountPerDay'] as num?)?.toDouble(),
      totalUndepositedAmountPerDay: (json['totalUndepositedAmountPerDay'] as num?)?.toDouble(),
      totalUndividedAmountPerDay: (json['totalUndividedAmountPerDay'] as num?)?.toDouble(),
      requestDate: json['requestDate'] == null
          ? null
          : DateTime.parse(json['requestDate'] as String),
      confirmDate: json['confirmDate'] == null
          ? null
          : DateTime.parse(json['confirmDate'] as String),
      datePersianToString: json['datePersianToString'] as String?,
      dateMiladiToString: json['dateMiladiToString'] as String?,
      isDeleted: json['isDeleted'] as bool?,
      status: (json['status'] as num?)?.toInt(),
      depositRequests: (json['depositRequests'] as List<dynamic>?)
          ?.map((e) => DepositRequestModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      deposits: (json['deposits'] as List<dynamic>?)
          ?.map((e) => DepositModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      number: json['number'] as String?,
      cardNumber: json['cardNumber'] as String?,
      sheba: json['sheba'] as String?,
      rowNum: (json['rowNum'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      depositRequestCount: (json['depositRequestCount'] as num?)?.toInt(),
      depositCount: (json['depositCount'] as num?)?.toInt(),
      attribute: json['attribute'] as String?,
      infos: json['infos'] as List<dynamic>?,
      description: json['description'] as String?,
      refrenceId: (json['refrenceId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$WithdrawModelToJson(WithdrawModel instance) =>
    <String, dynamic>{
      'wallet': instance.wallet,
      'bank': instance.bank,
      'reasonRejection': instance.reasonRejection,
      'ownerName': instance.ownerName,
      'amount': instance.amount,
      'dividedAmount': instance.dividedAmount,
      'notConfirmedAmount': instance.notConfirmedAmount,
      'undividedAmount': instance.undividedAmount,
      'paidAmount': instance.paidAmount,
      'totalAmountPerDay': instance.totalAmountPerDay,
      'totalPaidAmountPerDay': instance.totalPaidAmountPerDay,
      'totalDepositRequestAmountPerDay': instance.totalDepositRequestAmountPerDay,
      'totalUndepositedAmountPerDay': instance.totalUndepositedAmountPerDay,
      'totalUndividedAmountPerDay': instance.totalUndividedAmountPerDay,
      'requestDate': instance.requestDate?.toIso8601String(),
      'confirmDate': instance.confirmDate?.toIso8601String(),
      'datePersianToString': instance.datePersianToString,
      'dateMiladiToString': instance.dateMiladiToString,
      'isDeleted': instance.isDeleted,
      'status': instance.status,
      'depositRequests': instance.depositRequests,
      'deposits': instance.deposits,
      'number': instance.number,
      'cardNumber': instance.cardNumber,
      'sheba': instance.sheba,
      'rowNum': instance.rowNum,
      'id': instance.id,
      'depositRequestCount': instance.depositRequestCount,
      'depositCount': instance.depositCount,
      'attribute': instance.attribute,
      'infos': instance.infos,
      'description': instance.description,
      'refrenceId': instance.refrenceId,
    };
