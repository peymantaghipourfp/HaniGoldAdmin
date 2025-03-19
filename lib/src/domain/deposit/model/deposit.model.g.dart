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
      reasonRejection: json['reasonRejection'] == null
          ? null
          : ReasonRejectionModel.fromJson(
              json['reasonRejection'] as Map<String, dynamic>),
      amount: (json['amount'] as num?)?.toInt(),
      status: (json['status'] as num?)?.toInt(),
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => Attachment.fromJson(e as Map<String, dynamic>))
          .toList(),
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
      'reasonRejection': instance.reasonRejection,
      'amount': instance.amount,
      'status': instance.status,
      'attachments': instance.attachments,
      'rowNum': instance.rowNum,
      'id': instance.id,
      'attribute': instance.attribute,
      'recId': instance.recId,
      'infos': instance.infos,
      'date': instance.date?.toIso8601String(),
    };

Attachment _$AttachmentFromJson(Map<String, dynamic> json) => Attachment(
      recordId: json['recordId'] as String?,
      guidId: json['guidId'] as String?,
      name: json['name'] as String?,
      extension: json['extension'] as String?,
      entityType: json['entityType'] as String?,
      type: json['type'] as String?,
      rowNum: (json['rowNum'] as num?)?.toInt(),
      attribute: json['attribute'] as String?,
      infos: json['infos'] as List<dynamic>?,
    );

Map<String, dynamic> _$AttachmentToJson(Attachment instance) =>
    <String, dynamic>{
      'recordId': instance.recordId,
      'guidId': instance.guidId,
      'name': instance.name,
      'extension': instance.extension,
      'entityType': instance.entityType,
      'type': instance.type,
      'rowNum': instance.rowNum,
      'attribute': instance.attribute,
      'infos': instance.infos,
    };
