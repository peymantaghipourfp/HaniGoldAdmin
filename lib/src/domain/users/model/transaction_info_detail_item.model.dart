// To parse this JSON data, do
//
//     final transactionInfoDetailItemModel = transactionInfoDetailItemModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'transaction_info_detail_item.model.g.dart';

TransactionInfoDetailItemModel transactionInfoDetailItemModelFromJson(String str) => TransactionInfoDetailItemModel.fromJson(json.decode(str));

String transactionInfoDetailItemModelToJson(TransactionInfoDetailItemModel data) => json.encode(data.toJson());

@JsonSerializable()
class TransactionInfoDetailItemModel {
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "quantity")
  final double? quantity;
  @JsonKey(name: "weight")
  final double? weight;
  @JsonKey(name: "carat")
  final int? carat;
  @JsonKey(name: "impurity")
  final int? impurity;
  @JsonKey(name: "receiptNumber")
  final String? receiptNumber;
  @JsonKey(name: "itemId")
  final int? itemId;
  @JsonKey(name: "itemName")
  final String? itemName;
  @JsonKey(name: "itemUnitId")
  final int? itemUnitId;
  @JsonKey(name: "itemUnitName")
  final String? itemUnitName;
  @JsonKey(name: "walletId")
  final int? walletId;
  @JsonKey(name: "walletAddress")
  final String? walletAddress;
  @JsonKey(name: "description")
  final String? description;
  @JsonKey(name: "laboratoryId")
  final int? laboratoryId;
  @JsonKey(name: "name")
  final String? laboratoryName;

  TransactionInfoDetailItemModel({
    required this.id,
    required this.quantity,
    required this.weight,
    required this.carat,
    required this.impurity,
    required this.receiptNumber,
    required this.itemId,
    required this.itemName,
    required this.itemUnitId,
    required this.itemUnitName,
    required this.walletId,
    required this.walletAddress,
    required this.description,
    required this.laboratoryId,
    required this.laboratoryName,
  });

  factory TransactionInfoDetailItemModel.fromJson(Map<String, dynamic> json) => _$TransactionInfoDetailItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionInfoDetailItemModelToJson(this);
}
