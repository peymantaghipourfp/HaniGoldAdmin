import 'dart:convert';

import 'package:hanigold_admin/src/domain/withdraw/model/options.model.dart';

AccountSearchReqModel accountSearchReqModelFromJson(String str) => AccountSearchReqModel.fromJson(json.decode(str));

String accountSearchReqModelToJson(AccountSearchReqModel data) => json.encode(data.toJson());

class AccountSearchReqModel {
  final OptionsModel? account;

  AccountSearchReqModel({
    required this.account,
  });

  factory AccountSearchReqModel.fromJson(Map<String, dynamic> json) => AccountSearchReqModel(
    account: OptionsModel.fromJson(json["account"]),
  );

  Map<String, dynamic> toJson() => {
    "account": account?.toJson(),
  };
}