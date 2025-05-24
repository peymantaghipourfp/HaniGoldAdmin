import 'package:hanigold_admin/src/domain/order/model/info.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/deposit_request.model.dart';
import 'package:hanigold_admin/src/domain/wallet/model/wallet.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/bank_account.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/reason_rejection.model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

import '../../wallet/model/wallet_withdraw.model.dart';

part 'deposit.model.g.dart';

List<DepositModel> depositModelFromJson(String str) => List<DepositModel>.from(json.decode(str).map((x) => DepositModel.fromJson(x)));

String depositModelToJson(List<DepositModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class DepositModel {
  @JsonKey(name: "depositRequest")
  final DepositRequestModel? depositRequest;
  @JsonKey(name: "walletWithdraw")
  final WalletWithdrawModel? walletWithdraw;
  @JsonKey(name: "wallet")
  final WalletModel? wallet;
  @JsonKey(name: "bankAccount")
  final BankAccountModel? bankAccount;
  @JsonKey(name: "reasonRejection")
  final ReasonRejectionModel? reasonRejection;
  @JsonKey(name: "amount")
  final int? amount;
  @JsonKey(name: "status")
  final int? status;
  @JsonKey(name: "isDeleted")
  final bool? isDeleted;
  @JsonKey(name: "registered")
  final bool? registered;
  @JsonKey(name: "attachments")
  final List<Attachment>? attachments;
  @JsonKey(name: "rowNum")
  final int? rowNum;
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "attribute")
  final String? attribute;
  @JsonKey(name: "recId")
  final String? recId;
  @JsonKey(name: "infos")
  final List<InfoModel>? infos;
  @JsonKey(name: "date")
  final DateTime? date;
  @JsonKey(name: "trackingNumber")
  final String? trackingNumber;

  DepositModel({
    required this.depositRequest,
    required this.walletWithdraw,
    required this.wallet,
    required this.bankAccount,
    required this.reasonRejection,
    required this.amount,
    required this.status,
    required this.isDeleted,
    required this.registered,
    required this.attachments,
    required this.rowNum,
    required this.id,
    required this.attribute,
    required this.recId,
    required this.infos,
    required this.date,
    required this.trackingNumber,
  });

  factory DepositModel.fromJson(Map<String, dynamic> json) => _$DepositModelFromJson(json);

  Map<String, dynamic> toJson() => _$DepositModelToJson(this);
}

@JsonSerializable()
class Attachment {
  @JsonKey(name: "recordId")
  final String? recordId;
  @JsonKey(name: "guidId")
  final String? guidId;
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "extension")
  final String? extension;
  @JsonKey(name: "entityType")
  final String? entityType;
  @JsonKey(name: "type")
  final String? type;
  @JsonKey(name: "rowNum")
  final int? rowNum;
  @JsonKey(name: "attribute")
  final String? attribute;
  @JsonKey(name: "infos")
  final List<dynamic>? infos;

  Attachment({
    required this.recordId,
    required this.guidId,
    required this.name,
    required this.extension,
    required this.entityType,
    required this.type,
    required this.rowNum,
    required this.attribute,
    required this.infos,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) => _$AttachmentFromJson(json);

  Map<String, dynamic> toJson() => _$AttachmentToJson(this);
}