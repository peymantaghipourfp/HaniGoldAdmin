// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deposit_request.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DepositRequestModel _$DepositRequestModelFromJson(Map<String, dynamic> json) =>
    DepositRequestModel(
      withdrawRequest: json['withdrawRequest'] == null
          ? null
          : WithdrawModel.fromJson(
              json['withdrawRequest'] as Map<String, dynamic>),
      account: json['account'] == null
          ? null
          : AccountModel.fromJson(json['account'] as Map<String, dynamic>),
      item: json['item'] == null
          ? null
          : ItemModel.fromJson(json['item'] as Map<String, dynamic>),
      reasonRejection: json['reasonRejection'] == null
          ? null
          : ReasonRejectionModel.fromJson(
              json['reasonRejection'] as Map<String, dynamic>),
      amount: (json['amount'] as num?)?.toDouble(),
      requestAmount: (json['requestAmount'] as num?)?.toDouble(),
      paidAmount: (json['paidAmount'] as num?)?.toDouble(),
      notPaidAmount: (json['notPaidAmount'] as num?)?.toDouble(),
      status: (json['status'] as num?)?.toInt(),
      isDeleted: json['isDeleted'] as bool?,
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      confirmDate: json['confirmDate'] == null
          ? null
          : DateTime.parse(json['confirmDate'] as String),
      deposits: (json['deposits'] as List<dynamic>?)
          ?.map((e) => DepositModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      rowNum: (json['rowNum'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      attribute: json['attribute'] as String?,
      recId: json['recId'] as String?,
      infos: json['infos'] as List<dynamic>?,
      depositCount: (json['depositCount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$DepositRequestModelToJson(
        DepositRequestModel instance) =>
    <String, dynamic>{
      'withdrawRequest': instance.withdrawRequest,
      'account': instance.account,
      'item': instance.item,
      'reasonRejection': instance.reasonRejection,
      'amount': instance.amount,
      'requestAmount': instance.requestAmount,
      'paidAmount': instance.paidAmount,
      'notPaidAmount': instance.notPaidAmount,
      'status': instance.status,
      'isDeleted': instance.isDeleted,
      'date': instance.date?.toIso8601String(),
      'confirmDate': instance.confirmDate?.toIso8601String(),
      'deposits': instance.deposits,
      'rowNum': instance.rowNum,
      'id': instance.id,
      'attribute': instance.attribute,
      'recId': instance.recId,
      'infos': instance.infos,
      'depositCount': instance.depositCount,
    };
