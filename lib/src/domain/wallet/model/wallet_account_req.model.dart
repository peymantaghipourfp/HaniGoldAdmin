import 'dart:convert';

import 'package:hanigold_admin/src/domain/withdraw/model/options.model.dart';

WalletAccountReqModel walletAccountReqModelFromJson(String str) => WalletAccountReqModel.fromJson(json.decode(str));

String walletAccountReqModelToJson(WalletAccountReqModel data) => json.encode(data.toJson());

class WalletAccountReqModel {
  final OptionsModel? wallet;

  WalletAccountReqModel({
    required this.wallet,
  });

  factory WalletAccountReqModel.fromJson(Map<String, dynamic> json) => WalletAccountReqModel(
    wallet: OptionsModel.fromJson(json["wallet"]),
  );

  Map<String, dynamic> toJson() => {
    "wallet": wallet?.toJson(),
  };
}