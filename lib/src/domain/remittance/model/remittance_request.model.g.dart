// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remittance_request.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RemittanceRequestModel _$RemittanceRequestModelFromJson(
        Map<String, dynamic> json) =>
    RemittanceRequestModel(
      account: json['account'] == null
          ? null
          : AccountModel.fromJson(json['account'] as Map<String, dynamic>),
      wallet: json['wallet'] == null
          ? null
          : WalletModel.fromJson(json['wallet'] as Map<String, dynamic>),
      date: json['date'] as String?,
      quantity: (json['quantity'] as num?)?.toDouble(),
      toDescription: json['toDescription'] as String?,
      reasonRejection: json['reasonRejection'] == null
          ? null
          : ReasonRejectionModel.fromJson(
              json['reasonRejection'] as Map<String, dynamic>),
      status: (json['status'] as num?)?.toInt(),
      isDeleted: json['isDeleted'] as bool?,
      rowNum: (json['rowNum'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      attribute: json['attribute'] as String?,
      description: json['description'] as String?,
      infos: json['infos'] as List<dynamic>?,
    );

Map<String, dynamic> _$RemittanceRequestModelToJson(
        RemittanceRequestModel instance) =>
    <String, dynamic>{
      'account': instance.account,
      'wallet': instance.wallet,
      'date': instance.date,
      'quantity': instance.quantity,
      'toDescription': instance.toDescription,
      'reasonRejection': instance.reasonRejection,
      'status': instance.status,
      'isDeleted': instance.isDeleted,
      'rowNum': instance.rowNum,
      'id': instance.id,
      'attribute': instance.attribute,
      'description': instance.description,
      'infos': instance.infos,
    };
