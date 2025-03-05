import 'dart:convert';

import 'package:hanigold_admin/src/domain/withdraw/model/bank_account_options.model.dart';

BankAccountReqModel bankAccountReqModelFromJson(String str) => BankAccountReqModel.fromJson(json.decode(str));

String bankAccountReqModelToJson(BankAccountReqModel data) => json.encode(data.toJson());

class BankAccountReqModel {
  final BankAccountOptionsModel? bankAccount;

  BankAccountReqModel({
    required this.bankAccount,
  });

  factory BankAccountReqModel.fromJson(Map<String, dynamic> json) => BankAccountReqModel(
    bankAccount: BankAccountOptionsModel.fromJson(json["bankAccount"]),
  );

  Map<String, dynamic> toJson() => {
    "bankAccount": bankAccount?.toJson(),
  };
}