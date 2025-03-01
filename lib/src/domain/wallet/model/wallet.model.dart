import 'package:hanigold_admin/src/domain/account/model/account.model.dart';
import 'package:hanigold_admin/src/domain/product/model/item.model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'wallet.model.g.dart';

List<WalletModel> walletModelFromJson(String str) => List<WalletModel>.from(json.decode(str).map((x) => WalletModel.fromJson(x)));

String walletModelToJson(List<WalletModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class WalletModel {
  @JsonKey(name: "type")
  final int? type;
  @JsonKey(name: "address")
  final String? address;
  @JsonKey(name: "account")
  final AccountModel? account;
  @JsonKey(name: "item")
  final ItemModel? item;
  @JsonKey(name: "balance")
  final int? balance;
  @JsonKey(name: "infos")
  final List<dynamic>? infos;

  WalletModel({
    required this.type,
    required this.address,
    required this.account,
    required this.item,
    required this.balance,
    required this.infos,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) => _$WalletModelFromJson(json);

  Map<String, dynamic> toJson() => _$WalletModelToJson(this);
}