// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_transaction.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListTransactionModel _$ListTransactionModelFromJson(
        Map<String, dynamic> json) =>
    ListTransactionModel(
      transactionJournals: (json['transactionJournals'] as List<dynamic>?)
          ?.map((e) => TransactionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      paginated: json['paginated'] == null
          ? null
          : PaginatedModel.fromJson(json['paginated'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ListTransactionModelToJson(
        ListTransactionModel instance) =>
    <String, dynamic>{
      'transactionJournals': instance.transactionJournals,
      'paginated': instance.paginated,
    };
