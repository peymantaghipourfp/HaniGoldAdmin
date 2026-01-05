// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_transactions_wallet_receivables.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListTransactionsWalletReceivablesModel
    _$ListTransactionsWalletReceivablesModelFromJson(
            Map<String, dynamic> json) =>
        ListTransactionsWalletReceivablesModel(
          transactionWalletReceivables:
              (json['transactionWalletReceivables'] as List<dynamic>?)
                  ?.map((e) => TransactionsWalletReceivablesItemModel.fromJson(
                      e as Map<String, dynamic>))
                  .toList(),
          paginated: json['paginated'] == null
              ? null
              : PaginatedModel.fromJson(
                  json['paginated'] as Map<String, dynamic>),
        );

Map<String, dynamic> _$ListTransactionsWalletReceivablesModelToJson(
        ListTransactionsWalletReceivablesModel instance) =>
    <String, dynamic>{
      'transactionWalletReceivables': instance.transactionWalletReceivables,
      'paginated': instance.paginated,
    };
