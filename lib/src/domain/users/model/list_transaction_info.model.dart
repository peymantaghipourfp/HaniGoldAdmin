// To parse this JSON data, do
//
//     final listTransactionInfoModel = listTransactionInfoModelFromJson(jsonString);

import 'package:hanigold_admin/src/domain/users/model/paginated.model.dart';
import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

import 'list_transaction_info_item.model.dart';

part 'list_transaction_info.model.g.dart';

ListTransactionInfoModel listTransactionInfoModelFromJson(String str) => ListTransactionInfoModel.fromJson(json.decode(str));

String listTransactionInfoModelToJson(ListTransactionInfoModel data) => json.encode(data.toJson());

@JsonSerializable()
class ListTransactionInfoModel {
  @JsonKey(name: "transactionWallets")
  final List<ListTransactionInfoItemModel>? transactionWallets;
  @JsonKey(name: "paginated")
  final PaginatedModel? paginated;

  ListTransactionInfoModel({
    required this.transactionWallets,
    required this.paginated,
  });

  factory ListTransactionInfoModel.fromJson(Map<String, dynamic> json) => _$ListTransactionInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$ListTransactionInfoModelToJson(this);
}