// To parse this JSON data, do
//
//     final headerInfoUserTransactionModel = headerInfoUserTransactionModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'transaction_item.model.g.dart';

@JsonSerializable()
class TransactionItemModel {
  @JsonKey(name: "itemName")
  final String? itemName;
  @JsonKey(name: "groupName")
  final String? groupName;
  @JsonKey(name: "type")
  final String? type;
  @JsonKey(name: "transactionCount")
  final int? transactionCount;

  TransactionItemModel({
    required this.itemName,
    required this.groupName,
    required this.type,
    required this.transactionCount,
  });

  factory TransactionItemModel.fromJson(Map<String, dynamic> json) => _$TransactionItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionItemModelToJson(this);
}


