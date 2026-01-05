import 'package:hanigold_admin/src/domain/order/model/order_byAccount_report.model.dart';
import 'package:hanigold_admin/src/domain/users/model/paginated.model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'list_order_byAccount_report.model.g.dart';

ListOrderByAccountReportModel listOrderByAccountReportModelFromJson(String str) => ListOrderByAccountReportModel.fromJson(json.decode(str));

String listOrderByAccountReportModelToJson(ListOrderByAccountReportModel data) => json.encode(data.toJson());

@JsonSerializable()
class ListOrderByAccountReportModel {
  @JsonKey(name: "balanceDayOrderAccounts")
  final List<OrderByAccountReportModel> balanceDayOrderAccounts;
  @JsonKey(name: "paginated")
  final PaginatedModel paginated;

  ListOrderByAccountReportModel({
    required this.balanceDayOrderAccounts,
    required this.paginated,
  });

  factory ListOrderByAccountReportModel.fromJson(Map<String, dynamic> json) => _$ListOrderByAccountReportModelFromJson(json);

  Map<String, dynamic> toJson() => _$ListOrderByAccountReportModelToJson(this);
}