import 'package:hanigold_admin/src/domain/deposit/model/deposit.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/deposit_request.model.dart';
import 'package:hanigold_admin/src/domain/wallet/model/wallet.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/bank_account.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/reason_rejection.model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'withdraw.model.g.dart';

List<WithdrawModel> withdrawModelFromJson(String str) => List<WithdrawModel>.from(json.decode(str).map((x) => WithdrawModel.fromJson(x)));

String withdrawModelToJson(List<WithdrawModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class WithdrawModel {
  @JsonKey(name: "bankAccount")
  final BankAccountModel? bankAccount;
  @JsonKey(name: "wallet")
  final WalletModel? wallet;
  @JsonKey(name: "reasonRejection")
  final ReasonRejectionModel? reasonRejection;
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
  @JsonKey(name: "requestDate")
  final DateTime? requestDate;
  @JsonKey(name: "confirmDate")
  final DateTime? confirmDate;
  @JsonKey(name: "status")
  final int? status;
  @JsonKey(name: "depositRequests")
  final List<DepositRequestModel>? depositRequests;
  @JsonKey(name: "deposits")
  final List<DepositModel>? deposits;
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

  WithdrawModel({
    required this.bankAccount,
    required this.wallet,
    required this.reasonRejection,
    required this.amount,
    required this.dividedAmount,
    required this.notConfirmedAmount,
    required this.undividedAmount,
    required this.paidAmount,
    required this.requestDate,
    required this.confirmDate,
    required this.status,
    required this.depositRequests,
    required this.deposits,
    required this.rowNum,
    required this.id,
    required this.depositRequestCount,
    required this.depositCount,
    required this.attribute,
    required this.infos,
    required this.description
  });

  factory WithdrawModel.fromJson(Map<String, dynamic> json) => _$WithdrawModelFromJson(json);

  Map<String, dynamic> toJson() => _$WithdrawModelToJson(this);
}