// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transactions_wallet_receivables_item.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionsWalletReceivablesItemModel
    _$TransactionsWalletReceivablesItemModelFromJson(
            Map<String, dynamic> json) =>
        TransactionsWalletReceivablesItemModel(
          rowNum: (json['rowNum'] as num?)?.toInt(),
          accountId: (json['accountId'] as num?)?.toInt(),
          accountName: json['accountName'] as String?,
          goldInCurrency: (json['goldInCurrency'] as num?)?.toDouble(),
          coinInCurrency: (json['coinInCurrency'] as num?)?.toDouble(),
          currencyValue: (json['currencyValue'] as num?)?.toDouble(),
          goldBalance: (json['goldBalance'] as num?)?.toDouble(),
          halfCoinBalance: (json['halfCoinBalance'] as num?)?.toDouble(),
          quarterCoinBalance: (json['quarterCoinBalance'] as num?)?.toDouble(),
          goldValue: (json['goldValue'] as num?)?.toDouble(),
          coinValue: (json['coinValue'] as num?)?.toDouble(),
          afterGoldBalance: (json['afterGoldBalance'] as num?)?.toDouble(),
          afterCashBalance: (json['afterCashBalance'] as num?)?.toDouble(),
          balances: (json['balances'] as List<dynamic>?)
              ?.map((e) => BalanceModel.fromJson(e as Map<String, dynamic>))
              .toList(),
        );

Map<String, dynamic> _$TransactionsWalletReceivablesItemModelToJson(
        TransactionsWalletReceivablesItemModel instance) =>
    <String, dynamic>{
      'rowNum': instance.rowNum,
      'accountId': instance.accountId,
      'accountName': instance.accountName,
      'goldInCurrency': instance.goldInCurrency,
      'coinInCurrency': instance.coinInCurrency,
      'currencyValue': instance.currencyValue,
      'goldBalance': instance.goldBalance,
      'halfCoinBalance': instance.halfCoinBalance,
      'quarterCoinBalance': instance.quarterCoinBalance,
      'goldValue': instance.goldValue,
      'coinValue': instance.coinValue,
      'afterGoldBalance': instance.afterGoldBalance,
      'afterCashBalance': instance.afterCashBalance,
      'balances': instance.balances,
    };
