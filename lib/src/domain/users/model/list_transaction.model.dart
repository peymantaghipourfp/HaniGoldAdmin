// To parse this JSON data, do
//
//     final listUserModel = listUserModelFromJson(jsonString);

import 'package:hanigold_admin/src/domain/account/model/account.model.dart';
import 'package:hanigold_admin/src/domain/users/model/paginated.model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

import '../../transaction/model/transaction_item.model.dart';

part 'list_transaction.model.g.dart';

ListTransactionModel listUserModelFromJson(String str) => ListTransactionModel.fromJson(json.decode(str));

String listUserModelToJson(ListTransactionModel data) => json.encode(data.toJson());

@JsonSerializable()
class ListTransactionModel {
  @JsonKey(name: "transactionJournals")
  final List<TransactionModel>? transactionJournals;
  @JsonKey(name: "paginated")
  final PaginatedModel? paginated;

  ListTransactionModel({
    required this.transactionJournals,
    required this.paginated,
  });

  factory ListTransactionModel.fromJson(Map<String, dynamic> json) => _$ListTransactionModelFromJson(json);

  Map<String, dynamic> toJson() => _$ListTransactionModelToJson(this);
}
