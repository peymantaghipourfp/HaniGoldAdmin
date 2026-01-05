import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'statistics_report_header.model.g.dart';

StatisticsReportHeaderModel statisticsReportHeaderModelFromJson(String str) => StatisticsReportHeaderModel.fromJson(json.decode(str));

String statisticsReportHeaderModelToJson(StatisticsReportHeaderModel data) => json.encode(data.toJson());

@JsonSerializable()
class StatisticsReportHeaderModel {
  @JsonKey(name: "buyAccountCount")
  final int? buyAccountCount;  // تعداد مشتریان خریدکننده
  @JsonKey(name: "sellAccountCount")
  final int? sellAccountCount; // تعداد مشتریان فروشنده
  @JsonKey(name: "totalActiveAccounts")
  final int? totalActiveAccounts;  // تعداد کل مشتریان فعال
  @JsonKey(name: "approvedOrders")
  final int? approvedOrders;  // سفارشات تأیید شده
  @JsonKey(name: "rejectedOrders")
  final int? rejectedOrders;  // سفارشات رد شده
  @JsonKey(name: "adminOrders")
  final int? adminOrders;  // سفارشات ثبت‌شده توسط ادمین
  @JsonKey(name: "userOrders")
  final int? userOrders;  // سفارشات ثبت‌شده توسط کاربر

  StatisticsReportHeaderModel({
    required this.buyAccountCount,
    required this.sellAccountCount,
    required this.totalActiveAccounts,
    required this.approvedOrders,
    required this.rejectedOrders,
    required this.adminOrders,
    required this.userOrders,
  });

  factory StatisticsReportHeaderModel.fromJson(Map<String, dynamic> json) => _$StatisticsReportHeaderModelFromJson(json);

  Map<String, dynamic> toJson() => _$StatisticsReportHeaderModelToJson(this);
}