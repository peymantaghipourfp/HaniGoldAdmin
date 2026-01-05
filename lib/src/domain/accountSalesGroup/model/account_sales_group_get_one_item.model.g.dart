// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_sales_group_get_one_item.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountSalesGroupGetOneItemModel _$AccountSalesGroupGetOneItemModelFromJson(
        Map<String, dynamic> json) =>
    AccountSalesGroupGetOneItemModel(
      name: json['name'] as String?,
      hasDeposit: json['hasDeposit'] as bool?,
      deposit: (json['deposit'] as num?)?.toDouble(),
      hasBalance: json['hasBalance'] as bool?,
      balance: (json['balance'] as num?)?.toDouble(),
      color: json['color'] as String?,
      chiledrenCount: (json['chiledrenCount'] as num?)?.toInt(),
      accountSalesGroupItems: (json['accountSalesGroupItems'] as List<dynamic>?)
          ?.map((e) =>
              AccountSalesGroupItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      id: (json['id'] as num?)?.toInt(),
      infos: json['infos'] as List<dynamic>?,
    );

Map<String, dynamic> _$AccountSalesGroupGetOneItemModelToJson(
        AccountSalesGroupGetOneItemModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'hasDeposit': instance.hasDeposit,
      'deposit': instance.deposit,
      'hasBalance': instance.hasBalance,
      'balance': instance.balance,
      'color': instance.color,
      'chiledrenCount': instance.chiledrenCount,
      'accountSalesGroupItems': instance.accountSalesGroupItems,
      'id': instance.id,
      'infos': instance.infos,
    };
