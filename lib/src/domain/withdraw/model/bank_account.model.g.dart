// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_account.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BankAccountModel _$BankAccountModelFromJson(Map<String, dynamic> json) =>
    BankAccountModel(
      bank: json['bank'] == null
          ? null
          : BankModel.fromJson(json['bank'] as Map<String, dynamic>),
      account: json['account'] == null
          ? null
          : AccountModel.fromJson(json['account'] as Map<String, dynamic>),
      number: json['number'] as String?,
      ownerName: json['ownerName'] as String?,
      cardNumber: json['cardNumber'] as String?,
      sheba: json['sheba'] as String?,
      rowNum: (json['rowNum'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      attribute: json['attribute'] as String?,
      recId: json['recId'] as String?,
      infos: json['infos'] as List<dynamic>?,
    );

Map<String, dynamic> _$BankAccountModelToJson(BankAccountModel instance) =>
    <String, dynamic>{
      'bank': instance.bank,
      'account': instance.account,
      'number': instance.number,
      'ownerName': instance.ownerName,
      'cardNumber': instance.cardNumber,
      'sheba': instance.sheba,
      'rowNum': instance.rowNum,
      'id': instance.id,
      'attribute': instance.attribute,
      'recId': instance.recId,
      'infos': instance.infos,
    };
