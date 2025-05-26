// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_transaction_info_item.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListTransactionInfoItemModel _$ListTransactionInfoItemModelFromJson(
        Map<String, dynamic> json) =>
    ListTransactionInfoItemModel(
      accountId: (json['accountId'] as num).toInt(),
      accountName: json['accountName'] as String,
      currencyValue: (json['currencyValue'] as num).toDouble(),
      rowNum: (json['rowNum'] as num).toInt(),
      goldValue: (json['goldValue'] as num).toDouble(),
      coinValue: (json['coinValue'] as num).toDouble(),
      balances: (json['balances'] as List<dynamic>)
          .map((e) => BalanceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ListTransactionInfoItemModelToJson(
        ListTransactionInfoItemModel instance) =>
    <String, dynamic>{
      'accountId': instance.accountId,
      'accountName': instance.accountName,
      'currencyValue': instance.currencyValue,
      'goldValue': instance.goldValue,
      'coinValue': instance.coinValue,
      'rowNum': instance.rowNum,
      'balances': instance.balances,
    };
