import 'package:hanigold_admin/src/domain/wallet/model/wallet.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/bank_account.model.dart';
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
  @JsonKey(name: "amount")
  final int? amount;
  @JsonKey(name: "undividedAmount")
  final int? undividedAmount;
  @JsonKey(name: "requestDate")
  final DateTime? requestDate;
  @JsonKey(name: "rowNum")
  final int? rowNum;
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "attribute")
  final String? attribute;
  @JsonKey(name: "infos")
  final List<dynamic>? infos;

  WithdrawModel({
    required this.bankAccount,
    required this.wallet,
    required this.amount,
    required this.undividedAmount,
    required this.requestDate,
    required this.rowNum,
    required this.id,
    required this.attribute,
    required this.infos,
  });

  factory WithdrawModel.fromJson(Map<String, dynamic> json) => _$WithdrawModelFromJson(json);

  Map<String, dynamic> toJson() => _$WithdrawModelToJson(this);
}