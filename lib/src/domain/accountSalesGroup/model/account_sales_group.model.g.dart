// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_sales_group.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountSalesGroupModel _$AccountSalesGroupModelFromJson(
        Map<String, dynamic> json) =>
    AccountSalesGroupModel(
      name: json['name'] as String?,
      isDefault: json['isDefault'] as bool?,
      hasDeposit: json['hasDeposit'] as bool?,
      deposit: (json['deposit'] as num?)?.toDouble(),
      hasBalance: json['hasBalance'] as bool?,
      balance: (json['balance'] as num?)?.toDouble(),
      color: json['color'] as String?,
      accountSalesGroupItems: (json['accountSalesGroupItems'] as List<dynamic>?)
          ?.map((e) =>
              AccountSalesGroupItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      rowNum: (json['rowNum'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      attribute: json['attribute'] as String?,
      recId: json['recId'] as String?,
      infos: json['infos'] as List<dynamic>?,
      accountCount: (json['accountCount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$AccountSalesGroupModelToJson(
        AccountSalesGroupModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'isDefault': instance.isDefault,
      'hasDeposit': instance.hasDeposit,
      'deposit': instance.deposit,
      'hasBalance': instance.hasBalance,
      'balance': instance.balance,
      'color': instance.color,
      'accountSalesGroupItems': instance.accountSalesGroupItems,
      'rowNum': instance.rowNum,
      'id': instance.id,
      'attribute': instance.attribute,
      'recId': instance.recId,
      'infos': instance.infos,
      'accountCount': instance.accountCount,
    };
