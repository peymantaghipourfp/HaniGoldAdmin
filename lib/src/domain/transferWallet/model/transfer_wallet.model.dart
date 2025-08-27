import 'package:hanigold_admin/src/domain/account/model/account.model.dart';
import 'package:hanigold_admin/src/domain/wallet/model/wallet.model.dart';
import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'transfer_wallet.model.g.dart';

List<TransferWalletModel> transferWalletModelFromJson(String str) => List<TransferWalletModel>.from(json.decode(str).map((x) => TransferWalletModel.fromJson(x)));

String transferWalletModelToJson(List<TransferWalletModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class TransferWalletModel {
  @JsonKey(name: "account")
  final AccountModel? account;
  @JsonKey(name: "date")
  final String? date;
  @JsonKey(name: "transferDate")
  final String? transferDate;
  @JsonKey(name: "fromWallet")
  final WalletModel? fromWallet;
  @JsonKey(name: "toWallet")
  final WalletModel? toWallet;
  @JsonKey(name: "quantity")
  final double? quantity;
  @JsonKey(name: "isDeleted")
  final int? isDeleted;
  @JsonKey(name: "rowNum")
  final int? rowNum;
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "attribute")
  final String? attribute;
  @JsonKey(name: "infos")
  final List<dynamic>? infos;

  TransferWalletModel({
    required this.account,
    required this.date,
    required this.transferDate,
    required this.fromWallet,
    required this.toWallet,
    required this.quantity,
    required this.isDeleted,
    required this.rowNum,
    required this.id,
    required this.attribute,
    required this.infos,
  });

  factory TransferWalletModel.fromJson(Map<String, dynamic> json) => _$TransferWalletModelFromJson(json);

  Map<String, dynamic> toJson() => _$TransferWalletModelToJson(this);
}