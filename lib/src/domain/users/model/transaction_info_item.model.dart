// To parse this JSON data, do
//
//     final transactionInfoItemModel = transactionInfoItemModelFromJson(jsonString);

import 'package:hanigold_admin/src/domain/product/model/item.model.dart';
import 'package:hanigold_admin/src/domain/users/model/balance_item.model.dart';
import 'package:hanigold_admin/src/domain/users/model/transaction_info_detail_item.model.dart';
import 'package:hanigold_admin/src/domain/wallet/model/wallet.model.dart';
import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

import '../../remittance/model/balance.model.dart';

part 'transaction_info_item.model.g.dart';

TransactionInfoItemModel transactionInfoItemModelFromJson(String str) => TransactionInfoItemModel.fromJson(json.decode(str));

String transactionInfoItemModelToJson(TransactionInfoItemModel data) => json.encode(data.toJson());

@JsonSerializable()
class TransactionInfoItemModel {
  @JsonKey(name: "amount")
  final double? amount;
  @JsonKey(name: "date")
  final DateTime? date;
  @JsonKey(name: "type")
  final String? type;
  @JsonKey(name: "wallet")
  final WalletModel? wallet;
  @JsonKey(name: "toWallet")
  final WalletModel? toWallet;
  @JsonKey(name: "item")
  final ItemModel? item;
  @JsonKey(name: "price")
  final double? price;
  @JsonKey(name: "totalPrice")
  final double? totalPrice;
  @JsonKey(name: "balances")
  final List<BalanceModel>? balances;
  @JsonKey(name: "details")
  final List<TransactionInfoDetailItemModel>? details;
  @JsonKey(name: "rowNum")
  final int? rowNum;
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "description")
  final String? description;
  @JsonKey(name: "infos")
  final List<dynamic>? infos;

  TransactionInfoItemModel({
    required this.amount,
    required this.date,
    required this.type,
    required this.wallet,
    required this.toWallet,
    required this.item,
    required this.price,
    required this.totalPrice,
    required this.balances,
    required this.details,
    required this.rowNum,
    required this.id,
    required this.description,
    required this.infos,
  });

  factory TransactionInfoItemModel.fromJson(Map<String, dynamic> json) => _$TransactionInfoItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionInfoItemModelToJson(this);
}

