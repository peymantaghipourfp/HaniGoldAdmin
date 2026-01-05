
import 'package:hanigold_admin/src/domain/users/model/paginated.model.dart';
import 'package:hanigold_admin/src/domain/users/model/transactions_wallet_receivables_item.model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'list_transactions_wallet_receivables.model.g.dart';

ListTransactionsWalletReceivablesModel listTransactionsWalletReceivablesModelFromJson(String str) => ListTransactionsWalletReceivablesModel.fromJson(json.decode(str));

String listTransactionsWalletReceivablesModelToJson(ListTransactionsWalletReceivablesModel data) => json.encode(data.toJson());

@JsonSerializable()
class ListTransactionsWalletReceivablesModel {
  @JsonKey(name: "transactionWalletReceivables")
  final List<TransactionsWalletReceivablesItemModel>? transactionWalletReceivables;
  @JsonKey(name: "paginated")
  final PaginatedModel? paginated;

  ListTransactionsWalletReceivablesModel({
    required this.transactionWalletReceivables,
    required this.paginated,
  });

  factory ListTransactionsWalletReceivablesModel.fromJson(Map<String, dynamic> json) => _$ListTransactionsWalletReceivablesModelFromJson(json);

  Map<String, dynamic> toJson() => _$ListTransactionsWalletReceivablesModelToJson(this);
}