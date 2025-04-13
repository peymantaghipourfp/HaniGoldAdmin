import 'package:hanigold_admin/src/domain/account/model/account.model.dart';
import 'package:hanigold_admin/src/domain/deposit/model/deposit.model.dart';
import 'package:hanigold_admin/src/domain/product/model/item.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/reason_rejection.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/withdraw.model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'deposit_request.model.g.dart';

List<DepositRequestModel> depositRequestModelFromJson(String str) => List<DepositRequestModel>.from(json.decode(str).map((x) => DepositRequestModel.fromJson(x)));

String depositRequestModelToJson(List<DepositRequestModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class DepositRequestModel {
  @JsonKey(name: "withdrawRequest")
  final WithdrawModel? withdrawRequest;
  @JsonKey(name: "account")
  final AccountModel? account;
  @JsonKey(name: "item")
  final ItemModel? item;
  @JsonKey(name: "reasonRejection")
  final ReasonRejectionModel? reasonRejection;
  @JsonKey(name: "amount")
  final double? amount;
  @JsonKey(name: "requestAmount")
  final double? requestAmount;
  @JsonKey(name: "paidAmount")
  final double? paidAmount;
  @JsonKey(name: "notPaidAmount")
  final double? notPaidAmount;
  @JsonKey(name: "status")
  final int? status;
  @JsonKey(name: "date")
  final DateTime? date;
  @JsonKey(name: "confirmDate")
  final DateTime? confirmDate;
  @JsonKey(name: "deposits")
  final List<DepositModel>? deposits;
  @JsonKey(name: "rowNum")
  final int? rowNum;
  @JsonKey(name: "id")
  late final int? id;
  @JsonKey(name: "attribute")
  final String? attribute;
  @JsonKey(name: "recId")
  final String? recId;
  @JsonKey(name: "infos")
  final List<dynamic>? infos;

  DepositRequestModel({
    required this.withdrawRequest,
    required this.account,
    required this.item,
    required this.reasonRejection,
    required this.amount,
    required this.requestAmount,
    required this.paidAmount,
    required this.notPaidAmount,
    required this.status,
    required this.date,
    required this.confirmDate,
    required this.deposits,
    required this.rowNum,
    required this.id,
    required this.attribute,
    required this.recId,
    required this.infos,
  });

  factory DepositRequestModel.fromJson(Map<String, dynamic> json) => _$DepositRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$DepositRequestModelToJson(this);
}