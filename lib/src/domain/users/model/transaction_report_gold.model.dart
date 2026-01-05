
import 'package:hanigold_admin/src/domain/account/model/account.model.dart';
import 'package:hanigold_admin/src/domain/product/model/item.model.dart';
import 'package:hanigold_admin/src/domain/users/model/detail_gold.model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'transaction_report_gold.model.g.dart';

TransactionReportGoldModel transactionReportGoldModelFromJson(String str) => TransactionReportGoldModel.fromJson(json.decode(str));

String transactionReportGoldModelToJson(TransactionReportGoldModel data) => json.encode(data.toJson());


@JsonSerializable()
class TransactionReportGoldModel {
  @JsonKey(name: "recordId")
  final int? recordId;
  @JsonKey(name: "date")
  final DateTime? date;
  @JsonKey(name: "item")
  final ItemModel? item;
  @JsonKey(name: "account")
  final AccountModel? account;
  @JsonKey(name: "amount")
  final double? amount;
  @JsonKey(name: "goldTotalRunning")
  final double? goldTotalRunning;
  @JsonKey(name: "coinTotalRunning")
  final double? coinTotalRunning;
  @JsonKey(name: "halfCoinTotalRunning")
  final double? halfCoinTotalRunning;
  @JsonKey(name: "quarterCoinTotalRunning")
  final double? quarterCoinTotalRunning;
  @JsonKey(name: "cashTotalRunning")
  final double? cashTotalRunning;
  @JsonKey(name: "toAccount")
  final AccountModel toAccount;
  @JsonKey(name: "price")
  final double? price;
  @JsonKey(name: "totalPrice")
  final double? totalPrice;
  @JsonKey(name: "mesghalPrice")
  final double? mesghalPrice;
  @JsonKey(name: "type")
  final String? type;
  @JsonKey(name: "isCard")
  final bool? isCard;
  @JsonKey(name: "accountChecked")
  final bool? accountChecked;
  @JsonKey(name: "checked")
  late bool? checked;
  @JsonKey(name: "detail")
  final DetailGoldModel? detail;
  @JsonKey(name: "rowNum")
  final int? rowNum;
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "recId")
  final String? recId;
  @JsonKey(name: "infos")
  final List<dynamic>? infos;
  @JsonKey(name: "parentId")
  final int? parentId;
  @JsonKey(name: "description")
  final String? description;
  @JsonKey(name: "trackingNumber")
  final String? trackingNumber;

  TransactionReportGoldModel({
    required this.recordId,
    required this.date,
    required this.item,
    required this.account,
    required this.amount,
    required this.goldTotalRunning,
    required this.coinTotalRunning,
    required this.halfCoinTotalRunning,
    required this.quarterCoinTotalRunning,
    required this.cashTotalRunning,
    required this.toAccount,
    required this.price,
    required this.totalPrice,
    required this.mesghalPrice,
    required this.type,
    required this.isCard,
    required this.accountChecked,
    required this.checked,
    required this.detail,
    required this.rowNum,
    required this.id,
    required this.recId,
    required this.infos,
    required this.parentId,
    required this.description,
    required this.trackingNumber,
  });

  factory TransactionReportGoldModel.fromJson(Map<String, dynamic> json) => _$TransactionReportGoldModelFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionReportGoldModelToJson(this);
}