
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'transaction_info_footer.model.g.dart';

List<TransactionInfoFooterModel> transactionInfoFooterModelFromJson(String str) => List<TransactionInfoFooterModel>.from(json.decode(str).map((x) => TransactionInfoFooterModel.fromJson(x)));

String transactionInfoFooterModelToJson(List<TransactionInfoFooterModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class TransactionInfoFooterModel {
  @JsonKey(name: "rowNum")
  final int? rowNum;
  @JsonKey(name: "itemId")
  final int? itemId;
  @JsonKey(name: "itemName")
  final String? itemName;
  @JsonKey(name: "unitName")
  final String? unitName;
  @JsonKey(name: "itemGroupName")
  final String? itemGroupName;
  @JsonKey(name: "totalPositiveBalance")
  final double? totalPositiveBalance;
  @JsonKey(name: "totalPositiveValue")
  final double? totalPositiveValue;
  @JsonKey(name: "totalNegativeBalance")
  final double? totalNegativeBalance;
  @JsonKey(name: "totalNegativeValue")
  final double? totalNegativeValue;

  TransactionInfoFooterModel({
    required this.rowNum,
    required this.itemId,
    required this.itemName,
    required this.unitName,
    required this.itemGroupName,
    required this.totalPositiveBalance,
    required this.totalPositiveValue,
    required this.totalNegativeBalance,
    required this.totalNegativeValue,
  });

  factory TransactionInfoFooterModel.fromJson(Map<String, dynamic> json) => _$TransactionInfoFooterModelFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionInfoFooterModelToJson(this);
}