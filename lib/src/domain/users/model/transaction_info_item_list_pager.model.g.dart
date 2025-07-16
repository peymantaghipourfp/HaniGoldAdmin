// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_info_item_list_pager.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionInfoItemListPagerModel _$TransactionInfoItemListPagerModelFromJson(
        Map<String, dynamic> json) =>
    TransactionInfoItemListPagerModel(
      transactionInfoItems: (json['transactionReports'] as List<dynamic>)
          .map((e) =>
              TransactionInfoItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      paginated:
          PaginatedModel.fromJson(json['paginated'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TransactionInfoItemListPagerModelToJson(
        TransactionInfoItemListPagerModel instance) =>
    <String, dynamic>{
      'transactionReports': instance.transactionInfoItems,
      'paginated': instance.paginated,
    };
