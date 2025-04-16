
import 'package:hanigold_admin/src/domain/account/model/account.model.dart';
import 'package:hanigold_admin/src/domain/product/model/item.model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'wallet_withdraw.model.g.dart';

List<WalletWithdrawModel> walletWithdrawModelFromJson(String str) => List<WalletWithdrawModel>.from(json.decode(str).map((x) => WalletWithdrawModel.fromJson(x)));

String walletWithdrawModelToJson(List<WalletWithdrawModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
@JsonSerializable()
class WalletWithdrawModel {
  @JsonKey(name: "account")
  final AccountModel? account;
  @JsonKey(name: "item")
  final ItemModel? item;
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "infos")
  final List<dynamic>? infos;

  WalletWithdrawModel({
    required this.account,
    required this.item,
    required this.id,
    required this.infos,
  });

  factory WalletWithdrawModel.fromJson(Map<String, dynamic> json) => _$WalletWithdrawModelFromJson(json);

  Map<String, dynamic> toJson() => _$WalletWithdrawModelToJson(this);
}