import 'package:hanigold_admin/src/domain/deposit/model/deposit_request.model.dart';
import 'package:hanigold_admin/src/domain/wallet/model/wallet.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/bank_account.model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'deposit.model.g.dart';

List<DepositModel> depositModelFromJson(String str) => List<DepositModel>.from(json.decode(str).map((x) => DepositModel.fromJson(x)));

String depositModelToJson(List<DepositModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class DepositModel {
  @JsonKey(name: "depositRequest")
  final DepositRequestModel? depositRequest;
  @JsonKey(name: "wallet")
  final WalletModel? wallet;
  @JsonKey(name: "bankAccount")
  final BankAccountModel? bankAccount;
  @JsonKey(name: "amount")
  final int? amount;
  @JsonKey(name: "status")
  final int? status;
  @JsonKey(name: "rowNum")
  final int? rowNum;
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "attribute")
  final String? attribute;
  @JsonKey(name: "recId")
  final String? recId;
  @JsonKey(name: "infos")
  final List<dynamic>? infos;
  @JsonKey(name: "date")
  final DateTime? date;

  DepositModel({
    required this.depositRequest,
    required this.wallet,
    required this.bankAccount,
    required this.amount,
    required this.status,
    required this.rowNum,
    required this.id,
    required this.attribute,
    required this.recId,
    required this.infos,
    required this.date,
  });

  factory DepositModel.fromJson(Map<String, dynamic> json) => _$DepositModelFromJson(json);

  Map<String, dynamic> toJson() => _$DepositModelToJson(this);
}