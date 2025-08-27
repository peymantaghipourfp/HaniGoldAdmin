import 'package:hanigold_admin/src/domain/account/model/account.model.dart';
import 'package:hanigold_admin/src/domain/wallet/model/wallet.model.dart';
import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

import '../../withdraw/model/reason_rejection.model.dart';

part 'remittance_request.model.g.dart';

List<RemittanceRequestModel> remittanceRequestModelFromJson(String str) => List<RemittanceRequestModel>.from(json.decode(str).map((x) => RemittanceRequestModel.fromJson(x)));

String remittanceRequestModelToJson(List<RemittanceRequestModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class RemittanceRequestModel {
  @JsonKey(name: "account")
  final AccountModel? account;
  @JsonKey(name: "wallet")
  final WalletModel? wallet;
  @JsonKey(name: "date")
  final String? date;
  @JsonKey(name: "quantity")
  final double? quantity;
  @JsonKey(name: "toDescription")
  final String? toDescription;
  @JsonKey(name: "reasonRejection")
  final ReasonRejectionModel? reasonRejection;
  @JsonKey(name: "status")
  final int? status;
  @JsonKey(name: "isDeleted")
  final bool? isDeleted;
  @JsonKey(name: "rowNum")
  final int? rowNum;
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "attribute")
  final String? attribute;
  @JsonKey(name: "description")
  final String? description;
  @JsonKey(name: "infos")
  final List<dynamic>? infos;

  RemittanceRequestModel({
    required this.account,
    required this.wallet,
    required this.date,
    required this.quantity,
    required this.toDescription,
    required this.reasonRejection,
    required this.status,
    required this.isDeleted,
    required this.rowNum,
    required this.id,
    required this.attribute,
    required this.description,
    required this.infos,
  });

  factory RemittanceRequestModel.fromJson(Map<String, dynamic> json) => _$RemittanceRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$RemittanceRequestModelToJson(this);
}