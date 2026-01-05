// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statistics_report.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatisticsReportModel _$StatisticsReportModelFromJson(
        Map<String, dynamic> json) =>
    StatisticsReportModel(
      itemId: (json['itemId'] as num?)?.toInt(),
      itemName: json['itemName'] as String?,
      itemUnitName: json['itemUnitName'] as String?,
      itemIcon: json['itemIcon'] as String?,
      userGroup: (json['userGroup'] as List<dynamic>?)
          ?.map((e) => UserAdminGroupModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      adminGroup: (json['adminGroup'] as List<dynamic>?)
          ?.map((e) => UserAdminGroupModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      itemAccountCount: (json['itemAccountCount'] as num?)?.toInt(),
      totalAccountCount: (json['totalAccountCount'] as num?)?.toInt(),
      totalOrderCount: (json['totalOrderCount'] as num?)?.toInt(),
      totalRejectedOrderCount:
          (json['totalRejectedOrderCount'] as num?)?.toInt(),
      totalBuyCount: (json['totalBuyCount'] as num?)?.toInt(),
      totalSellCount: (json['totalSellCount'] as num?)?.toInt(),
      totalBuyQuantity: (json['totalBuyQuantity'] as num?)?.toDouble(),
      totalSellQuantity: (json['totalSellQuantity'] as num?)?.toDouble(),
      avgBuyPerOrder: (json['avgBuyPerOrder'] as num?)?.toDouble(),
      avgSellPerOrder: (json['avgSellPerOrder'] as num?)?.toDouble(),
      avgBuyPerAccount: (json['avgBuyPerAccount'] as num?)?.toDouble(),
      avgSellPerAccount: (json['avgSellPerAccount'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$StatisticsReportModelToJson(
        StatisticsReportModel instance) =>
    <String, dynamic>{
      'itemId': instance.itemId,
      'itemName': instance.itemName,
      'itemUnitName': instance.itemUnitName,
      'itemIcon': instance.itemIcon,
      'userGroup': instance.userGroup,
      'adminGroup': instance.adminGroup,
      'itemAccountCount': instance.itemAccountCount,
      'totalAccountCount': instance.totalAccountCount,
      'totalOrderCount': instance.totalOrderCount,
      'totalRejectedOrderCount': instance.totalRejectedOrderCount,
      'totalBuyCount': instance.totalBuyCount,
      'totalSellCount': instance.totalSellCount,
      'totalBuyQuantity': instance.totalBuyQuantity,
      'totalSellQuantity': instance.totalSellQuantity,
      'avgBuyPerOrder': instance.avgBuyPerOrder,
      'avgSellPerOrder': instance.avgSellPerOrder,
      'avgBuyPerAccount': instance.avgBuyPerAccount,
      'avgSellPerAccount': instance.avgSellPerAccount,
    };
