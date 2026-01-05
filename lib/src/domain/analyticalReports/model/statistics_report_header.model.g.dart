// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statistics_report_header.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatisticsReportHeaderModel _$StatisticsReportHeaderModelFromJson(
        Map<String, dynamic> json) =>
    StatisticsReportHeaderModel(
      buyAccountCount: (json['buyAccountCount'] as num?)?.toInt(),
      sellAccountCount: (json['sellAccountCount'] as num?)?.toInt(),
      totalActiveAccounts: (json['totalActiveAccounts'] as num?)?.toInt(),
      approvedOrders: (json['approvedOrders'] as num?)?.toInt(),
      rejectedOrders: (json['rejectedOrders'] as num?)?.toInt(),
      adminOrders: (json['adminOrders'] as num?)?.toInt(),
      userOrders: (json['userOrders'] as num?)?.toInt(),
    );

Map<String, dynamic> _$StatisticsReportHeaderModelToJson(
        StatisticsReportHeaderModel instance) =>
    <String, dynamic>{
      'buyAccountCount': instance.buyAccountCount,
      'sellAccountCount': instance.sellAccountCount,
      'totalActiveAccounts': instance.totalActiveAccounts,
      'approvedOrders': instance.approvedOrders,
      'rejectedOrders': instance.rejectedOrders,
      'adminOrders': instance.adminOrders,
      'userOrders': instance.userOrders,
    };
