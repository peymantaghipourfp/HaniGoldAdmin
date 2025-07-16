

import 'package:hanigold_admin/src/domain/users/model/paginated.model.dart';
import 'package:hanigold_admin/src/domain/users/model/transaction_info_item.model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'transaction_info_item_list_pager.model.g.dart';

TransactionInfoItemListPagerModel transactionInfoItemListPagerModelFromJson(String str) => TransactionInfoItemListPagerModel.fromJson(json.decode(str));

String transactionInfoItemListPagerModelToJson(TransactionInfoItemListPagerModel data) => json.encode(data.toJson());

@JsonSerializable()
class TransactionInfoItemListPagerModel {
  @JsonKey(name: "transactionReports")
  final List<TransactionInfoItemModel>? transactionInfoItems;
  @JsonKey(name: "paginated")
  final PaginatedModel paginated;

  TransactionInfoItemListPagerModel({
    required this.transactionInfoItems,
    required this.paginated,
  });

  factory TransactionInfoItemListPagerModel.fromJson(Map<String, dynamic> json) => _$TransactionInfoItemListPagerModelFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionInfoItemListPagerModelToJson(this);
}