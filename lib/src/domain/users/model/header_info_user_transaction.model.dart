// To parse this JSON data, do
//
//     final headerInfoUserTransactionModel = headerInfoUserTransactionModelFromJson(jsonString);

import 'package:hanigold_admin/src/domain/users/model/transaction_item.model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'header_info_user_transaction.model.g.dart';

HeaderInfoUserTransactionModel headerInfoUserTransactionModelFromJson(String str) => HeaderInfoUserTransactionModel.fromJson(json.decode(str));

String headerInfoUserTransactionModelToJson(HeaderInfoUserTransactionModel data) => json.encode(data.toJson());

@JsonSerializable()
class HeaderInfoUserTransactionModel {
  @JsonKey(name: "accountName")
  final String? accountName;
  @JsonKey(name: "accountGroup")
  final String? accountGroup;
  @JsonKey(name: "tell")
  final String? tell;
  @JsonKey(name: "startDate")
  final DateTime? startDate;
  @JsonKey(name: "deposit")
  final String? deposit;
  @JsonKey(name: "address")
  final String? address;
  @JsonKey(name: "orders")
  final List<TransactionItemModel>? orders;
  @JsonKey(name: "inventorys")
  final List<TransactionItemModel>? inventorys;
  @JsonKey(name: "withdraws")
  final List<TransactionItemModel>? withdraws;
  @JsonKey(name: "remmitances")
  final List<TransactionItemModel>? remmitances;

  HeaderInfoUserTransactionModel({
    required this.accountName,
    required this.accountGroup,
    required this.tell,
    required this.startDate,
    required this.deposit,
    required this.address,
    required this.orders,
    required this.inventorys,
    required this.withdraws,
    required this.remmitances,
  });

  factory HeaderInfoUserTransactionModel.fromJson(Map<String, dynamic> json) => _$HeaderInfoUserTransactionModelFromJson(json);

  Map<String, dynamic> toJson() => _$HeaderInfoUserTransactionModelToJson(this);
}

