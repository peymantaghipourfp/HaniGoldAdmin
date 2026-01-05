

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'order_byAccount_report.model.g.dart';

List<OrderByAccountReportModel> orderByAccountReportModelFromJson(String str) => List<OrderByAccountReportModel>.from(json.decode(str).map((x) => OrderByAccountReportModel.fromJson(x)));

String orderByAccountReportModelToJson(List<OrderByAccountReportModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class OrderByAccountReportModel {
  @JsonKey(name: "rowNum")
  final int? rowNum;
  @JsonKey(name: "reportDate")
  final String? reportDate;
  @JsonKey(name: "accountId")
  final int? accountId;
  @JsonKey(name: "accountName")
  final String? accountName;
  @JsonKey(name: "totalSaleAmount")
  final double? totalSaleAmount;
  @JsonKey(name: "totalBuyAmount")
  final double? totalBuyAmount;
  @JsonKey(name: "balanceAmount")
  final double? balanceAmount;
  @JsonKey(name: "currencyValue")
  final double? currencyValue;
  @JsonKey(name: "goldValue")
  final double? goldValue;
  @JsonKey(name: "coinValue")
  final double? coinValue;

  OrderByAccountReportModel({
    required this.rowNum,
    required this.reportDate,
    required this.accountId,
    required this.accountName,
    required this.totalSaleAmount,
    required this.totalBuyAmount,
    required this.balanceAmount,
    required this.currencyValue,
    required this.goldValue,
    required this.coinValue,
  });

  factory OrderByAccountReportModel.fromJson(Map<String, dynamic> json) => _$OrderByAccountReportModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderByAccountReportModelToJson(this);
}