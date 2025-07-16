import 'package:hanigold_admin/src/domain/deposit/model/deposit.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/bank.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/deposit_request.model.dart';
import 'package:hanigold_admin/src/domain/wallet/model/wallet.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/reason_rejection.model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'withdraw.model.g.dart';

List<WithdrawModel> withdrawModelFromJson(String str) => List<WithdrawModel>.from(json.decode(str).map((x) => WithdrawModel.fromJson(x)));

String withdrawModelToJson(List<WithdrawModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class WithdrawModel {
  @JsonKey(name: "wallet")
  final WalletModel? wallet;
  @JsonKey(name: "bank")
  final BankModel? bank;
  @JsonKey(name: "reasonRejection")
  final ReasonRejectionModel? reasonRejection;
  @JsonKey(name: "ownerName")
  final String? ownerName;
  @JsonKey(name: "amount")
  final double? amount;
  @JsonKey(name: "dividedAmount")
  final double? dividedAmount;
  @JsonKey(name: "notConfirmedAmount")
  final double? notConfirmedAmount;
  @JsonKey(name: "undividedAmount")
  final double? undividedAmount;
  @JsonKey(name: "paidAmount")
  final double? paidAmount;
  @JsonKey(name: "totalAmountPerDay")
  final double? totalAmountPerDay;
  @JsonKey(name: "totalPaidAmountPerDay")
  final double? totalPaidAmountPerDay;
  @JsonKey(name: "totalDepositRequestAmountPerDay")
  final double? totalDepositRequestAmountPerDay;
  @JsonKey(name: "totalUndepositedAmountPerDay")
  final double? totalUndepositedAmountPerDay;
  @JsonKey(name: "totalUndividedAmountPerDay")
  final double? totalUndividedAmountPerDay;
  @JsonKey(name: "requestDate")
  final DateTime? requestDate;
  @JsonKey(name: "confirmDate")
  final DateTime? confirmDate;
  @JsonKey(name: "datePersianToString")
  final String? datePersianToString;
  @JsonKey(name: "dateMiladiToString")
  final String? dateMiladiToString;
  @JsonKey(name: "isDeleted")
  final bool? isDeleted;
  @JsonKey(name: "status")
  final int? status;
  @JsonKey(name: "depositRequests")
  final List<DepositRequestModel>? depositRequests;
  @JsonKey(name: "deposits")
  final List<DepositModel>? deposits;
  @JsonKey(name: "number")
  final String? number;
  @JsonKey(name: "cardNumber")
  final String? cardNumber;
  @JsonKey(name: "sheba")
  final String? sheba;
  @JsonKey(name: "rowNum")
  final int? rowNum;
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "depositRequestCount")
  final int? depositRequestCount;
  @JsonKey(name: "depositCount")
  final int? depositCount;
  @JsonKey(name: "attribute")
  final String? attribute;
  @JsonKey(name: "infos")
  final List<dynamic>? infos;
  @JsonKey(name: "description")
  final String? description;
  @JsonKey(name: "refrenceId")
  final int? refrenceId;

  WithdrawModel({
    required this.bank,
    required this.wallet,
    required this.reasonRejection,
    required this.ownerName,
    required this.amount,
    required this.dividedAmount,
    required this.notConfirmedAmount,
    required this.undividedAmount,
    required this.paidAmount,
    required this.totalAmountPerDay,
    required this.totalPaidAmountPerDay,
    required this.totalDepositRequestAmountPerDay,
    required this.totalUndepositedAmountPerDay,
    required this.totalUndividedAmountPerDay,
    required this.requestDate,
    required this.confirmDate,
    required this.datePersianToString,
    required this.dateMiladiToString,
    required this.isDeleted,
    required this.status,
    required this.depositRequests,
    required this.deposits,
    required this.number,
    required this.cardNumber,
    required this.sheba,
    required this.rowNum,
    required this.id,
    required this.depositRequestCount,
    required this.depositCount,
    required this.attribute,
    required this.infos,
    required this.description,
    required this.refrenceId,
  });

  factory WithdrawModel.fromJson(Map<String, dynamic> json) => _$WithdrawModelFromJson(json);

  Map<String, dynamic> toJson() => _$WithdrawModelToJson(this);
}