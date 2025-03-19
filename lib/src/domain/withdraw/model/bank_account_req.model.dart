import 'dart:convert';

import 'package:hanigold_admin/src/domain/withdraw/model/options.model.dart';

BankAccountReqModel bankAccountReqModelFromJson(String str) => BankAccountReqModel.fromJson(json.decode(str));

String bankAccountReqModelToJson(BankAccountReqModel data) => json.encode(data.toJson());

class BankAccountReqModel {
  final OptionsModel? bankAccount;

  BankAccountReqModel({
    required this.bankAccount,
  });

  factory BankAccountReqModel.fromJson(Map<String, dynamic> json) => BankAccountReqModel(
    bankAccount: OptionsModel.fromJson(json["bankAccount"]),
  );

  Map<String, dynamic> toJson() => {
    "bankAccount": bankAccount?.toJson(),
  };
}