// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_byAccount_report.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderByAccountReportModel _$OrderByAccountReportModelFromJson(
        Map<String, dynamic> json) =>
    OrderByAccountReportModel(
      rowNum: (json['rowNum'] as num?)?.toInt(),
      reportDate: json['reportDate'] as String?,
      accountId: (json['accountId'] as num?)?.toInt(),
      accountName: json['accountName'] as String?,
      totalSaleAmount: (json['totalSaleAmount'] as num?)?.toDouble(),
      totalBuyAmount: (json['totalBuyAmount'] as num?)?.toDouble(),
      balanceAmount: (json['balanceAmount'] as num?)?.toDouble(),
      currencyValue: (json['currencyValue'] as num?)?.toDouble(),
      goldValue: (json['goldValue'] as num?)?.toDouble(),
      coinValue: (json['coinValue'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$OrderByAccountReportModelToJson(
        OrderByAccountReportModel instance) =>
    <String, dynamic>{
      'rowNum': instance.rowNum,
      'reportDate': instance.reportDate,
      'accountId': instance.accountId,
      'accountName': instance.accountName,
      'totalSaleAmount': instance.totalSaleAmount,
      'totalBuyAmount': instance.totalBuyAmount,
      'balanceAmount': instance.balanceAmount,
      'currencyValue': instance.currencyValue,
      'goldValue': instance.goldValue,
      'coinValue': instance.coinValue,
    };
