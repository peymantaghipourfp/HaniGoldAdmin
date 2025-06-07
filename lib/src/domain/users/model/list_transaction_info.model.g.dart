// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_transaction_info.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListTransactionInfoModel _$ListTransactionInfoModelFromJson(
        Map<String, dynamic> json) =>
    ListTransactionInfoModel(
      transactionWallets: (json['transactionWallets'] as List<dynamic>?)
          ?.map((e) =>
              ListTransactionInfoItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      paginated: json['paginated'] == null
          ? null
          : PaginatedModel.fromJson(json['paginated'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ListTransactionInfoModelToJson(
        ListTransactionInfoModel instance) =>
    <String, dynamic>{
      'transactionWallets': instance.transactionWallets,
      'paginated': instance.paginated,
    };
