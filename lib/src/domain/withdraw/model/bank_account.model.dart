import 'package:hanigold_admin/src/domain/account/model/account.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/bank.model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'bank_account.model.g.dart';

List<BankAccountModel> bankAccountModelFromJson(String str) => List<BankAccountModel>.from(json.decode(str).map((x) => BankAccountModel.fromJson(x)));

String bankAccountModelToJson(List<BankAccountModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class BankAccountModel {
  @JsonKey(name: "bank")
  final BankModel? bank;
  @JsonKey(name: "account")
  final AccountModel? account;
  @JsonKey(name: "number")
  final String? number;
  @JsonKey(name: "ownerName")
  final String? ownerName;
  @JsonKey(name: "cardNumber")
  final String? cardNumber;
  @JsonKey(name: "sheba")
  final String? sheba;
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

  BankAccountModel({
    required this.bank,
    required this.account,
    required this.number,
    required this.ownerName,
    required this.cardNumber,
    required this.sheba,
    required this.rowNum,
    required this.id,
    required this.attribute,
    required this.recId,
    required this.infos,
  });

  factory BankAccountModel.fromJson(Map<String, dynamic> json) => _$BankAccountModelFromJson(json);

  Map<String, dynamic> toJson() => _$BankAccountModelToJson(this);
}