import 'package:hanigold_admin/src/domain/users/model/paginated.model.dart';
import 'package:hanigold_admin/src/domain/users/model/transaction_report_gold.model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'transaction_info_gold_list_pager.model.g.dart';

TransactionInfoGoldListPagerModel transactionInfoGoldListPagerModelFromJson(String str) => TransactionInfoGoldListPagerModel.fromJson(json.decode(str));

String transactionInfoGoldListPagerModelToJson(TransactionInfoGoldListPagerModel data) => json.encode(data.toJson());

@JsonSerializable()
class TransactionInfoGoldListPagerModel {
  @JsonKey(name: "transactionReportGolds")
  final List<TransactionReportGoldModel>? transactionReportGolds;
  @JsonKey(name: "paginated")
  final PaginatedModel? paginated;

  TransactionInfoGoldListPagerModel({
    required this.transactionReportGolds,
    required this.paginated,
  });

  factory TransactionInfoGoldListPagerModel.fromJson(Map<String, dynamic> json) => _$TransactionInfoGoldListPagerModelFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionInfoGoldListPagerModelToJson(this);
}