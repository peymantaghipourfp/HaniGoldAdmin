// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_info_gold_list_pager.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionInfoGoldListPagerModel _$TransactionInfoGoldListPagerModelFromJson(
        Map<String, dynamic> json) =>
    TransactionInfoGoldListPagerModel(
      transactionReportGolds: (json['transactionReportGolds'] as List<dynamic>?)
          ?.map((e) =>
              TransactionReportGoldModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      paginated: json['paginated'] == null
          ? null
          : PaginatedModel.fromJson(json['paginated'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TransactionInfoGoldListPagerModelToJson(
        TransactionInfoGoldListPagerModel instance) =>
    <String, dynamic>{
      'transactionReportGolds': instance.transactionReportGolds,
      'paginated': instance.paginated,
    };
