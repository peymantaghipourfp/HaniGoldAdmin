import 'package:hanigold_admin/src/domain/order/model/user_admin_group.model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'statistics_report.model.g.dart';

List<StatisticsReportModel> statisticsReportModelFromJson(String str) => List<StatisticsReportModel>.from(json.decode(str).map((x) => StatisticsReportModel.fromJson(x)));

String statisticsReportModelToJson(List<StatisticsReportModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class StatisticsReportModel {
  @JsonKey(name: "itemId")
  final int? itemId;
  @JsonKey(name: "itemName")
  final String? itemName;
  @JsonKey(name: "itemUnitName")
  final String? itemUnitName;
  @JsonKey(name: "itemIcon")
  final String? itemIcon;
  @JsonKey(name: "userGroup")
  final List<UserAdminGroupModel>? userGroup;
  @JsonKey(name: "adminGroup")
  final List<UserAdminGroupModel>? adminGroup;
  @JsonKey(name: "itemAccountCount")
  final int? itemAccountCount;
  @JsonKey(name: "totalAccountCount")
  final int? totalAccountCount;
  @JsonKey(name: "totalOrderCount")
  final int? totalOrderCount;
  @JsonKey(name: "totalRejectedOrderCount")
  final int? totalRejectedOrderCount;
  @JsonKey(name: "totalBuyCount")
  final int? totalBuyCount;
  @JsonKey(name: "totalSellCount")
  final int? totalSellCount;
  @JsonKey(name: "totalBuyQuantity")
  final double? totalBuyQuantity;
  @JsonKey(name: "totalSellQuantity")
  final double? totalSellQuantity;
  @JsonKey(name: "avgBuyPerOrder")
  final double? avgBuyPerOrder;
  @JsonKey(name: "avgSellPerOrder")
  final double? avgSellPerOrder;
  @JsonKey(name: "avgBuyPerAccount")
  final double? avgBuyPerAccount;
  @JsonKey(name: "avgSellPerAccount")
  final double? avgSellPerAccount;

  StatisticsReportModel({
    required this.itemId,
    required this.itemName,
    required this.itemUnitName,
    required this.itemIcon,
    required this.userGroup,
    required this.adminGroup,
    required this.itemAccountCount,
    required this.totalAccountCount,
    required this.totalOrderCount,
    required this.totalRejectedOrderCount,
    required this.totalBuyCount,
    required this.totalSellCount,
    required this.totalBuyQuantity,
    required this.totalSellQuantity,
    required this.avgBuyPerOrder,
    required this.avgSellPerOrder,
    required this.avgBuyPerAccount,
    required this.avgSellPerAccount,
  });

  factory StatisticsReportModel.fromJson(Map<String, dynamic> json) => _$StatisticsReportModelFromJson(json);

  Map<String, dynamic> toJson() => _$StatisticsReportModelToJson(this);
}