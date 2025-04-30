// To parse this JSON data, do
//
//     final remittanceModel = remittanceModelFromJson(jsonString);

import 'package:hanigold_admin/src/domain/deposit/model/deposit.model.dart';
import 'package:hanigold_admin/src/domain/product/model/item.model.dart';
import 'package:hanigold_admin/src/domain/remittance/model/balance.model.dart';
import 'package:hanigold_admin/src/domain/remittance/model/user.model.dart';
import 'package:hanigold_admin/src/domain/wallet/model/wallet.model.dart';
import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'remittance.model.g.dart';

RemittanceModel remittanceModelFromJson(String str) => RemittanceModel.fromJson(json.decode(str));

String remittanceModelToJson(RemittanceModel data) => json.encode(data.toJson());

@JsonSerializable()
class RemittanceModel {
  @JsonKey(name: "date")
  final DateTime? date;
  @JsonKey(name: "walletPayer")
  final WalletModel? walletPayer;
  @JsonKey(name: "walletReciept")
  final WalletModel? walletReciept;
  @JsonKey(name: "item")
  final ItemModel? item;
  @JsonKey(name: "createdBy")
  final UserModel? createdBy;
  @JsonKey(name: "quantity")
  final int? quantity;
  @JsonKey(name: "status")
  final int? status;
  @JsonKey(name: "isDeleted")
  final bool? isDeleted;
  @JsonKey(name: "attachments")
  final List<Attachment>? attachments;
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "attribute")
  final String? attribute;
  @JsonKey(name: "balancePayer")
  final String? balancePayer;
  @JsonKey(name: "balanceReciept")
  final String? balanceReciept;
  @JsonKey(name: "description")
  final String? description;
  @JsonKey(name: "recId")
  final String? recId;
  @JsonKey(name: "infos")
  final List<dynamic>? infos;

  RemittanceModel( {
    required this.date,
    required this.walletPayer,
    required this.walletReciept,
    required this.item,
    required this.quantity,
    required this.status,
    required this.isDeleted,
    required this.attachments,
    required this.createdBy,
    required this.id,
    required this.attribute,
    required this.balancePayer,
    required this.balanceReciept,
    required this.description,
    required this.recId,
    required this.infos,
  });

  factory RemittanceModel.fromJson(Map<String, dynamic> json) => _$RemittanceModelFromJson(json);

  Map<String, dynamic> toJson() => _$RemittanceModelToJson(this);
}