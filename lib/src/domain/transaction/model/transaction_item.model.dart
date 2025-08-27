// To parse this JSON data, do
//
//     final transactionItemModel = transactionItemModelFromJson(jsonString);

import 'package:hanigold_admin/src/domain/account/model/account.model.dart';
import 'package:hanigold_admin/src/domain/inventory/model/inventory_detail.model.dart';
import 'package:hanigold_admin/src/domain/product/model/item.model.dart';
import 'package:hanigold_admin/src/domain/remittance/model/balance.model.dart';
import 'package:hanigold_admin/src/domain/wallet/model/wallet.model.dart';
import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'transaction_item.model.g.dart';

TransactionModel transactionItemModelFromJson(String str) => TransactionModel.fromJson(json.decode(str));

String transactionItemModelToJson(TransactionModel data) => json.encode(data.toJson());

@JsonSerializable()
class TransactionModel {
  @JsonKey(name: "toId")
  final int? toId;
  @JsonKey(name: "fromId")
  final int? fromId;
  @JsonKey(name: "amount")
  final int? amount;
  @JsonKey(name: "date")
  final String? date;
  @JsonKey(name: "type")
  final String? type;
  @JsonKey(name: "price")
  final double? price;
  @JsonKey(name: "totalPrice")
  final double? totalPrice;
  @JsonKey(name: "wallet")
  final WalletModel? wallet;
  @JsonKey(name: "account")
  final AccountModel? account;
  @JsonKey(name: "toWallet")
  final WalletModel? toWallet;
  @JsonKey(name: "toAccount")
  final AccountModel? toAccount;
  @JsonKey(name: "item")
  final ItemModel? item;
  @JsonKey(name: "toItem")
  final ItemModel? toItem;
  @JsonKey(name: "balances")
  final List<BalanceModel>? balances;
  @JsonKey(name: "tobalances")
  final List<BalanceModel>? tobalances;
  @JsonKey(name: "details")
  final List<InventoryDetailModel>? details;
  @JsonKey(name: "rowNum")
  final int? rowNum;
  @JsonKey(name: "recId")
  final String? recId;
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "isCard")
  final bool? isCard;
  @JsonKey(name: "infos")
  final List<dynamic>? infos;

  TransactionModel({
    required this.toId,
    required this.fromId,
    required this.amount,
    required this.date,
    required this.type,
    required this.price,
    required this.totalPrice,
    required this.wallet,
    required this.account,
    required this.toWallet,
    required this.toAccount,
    required this.item,
    required this.toItem,
    required this.balances,
    required this.tobalances,
    required this.details,
    required this.rowNum,
    required this.recId,
    required this.id,
    required this.isCard,
    required this.infos,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) => _$TransactionModelFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionModelToJson(this);
}
