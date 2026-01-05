import 'package:hanigold_admin/src/domain/account/model/account.model.dart';
import 'package:hanigold_admin/src/domain/product/model/item.model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'credit_helper.model.g.dart';

List<CreditHelperModel> creditHelperModelFromJson(String str) => List<CreditHelperModel>.from(json.decode(str).map((x) => CreditHelperModel.fromJson(x)));

String creditHelperModelToJson(List<CreditHelperModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class CreditHelperModel {
  @JsonKey(name: "account")
  final AccountModel? account;
  @JsonKey(name: "item")
  final ItemModel? item;
  @JsonKey(name: "type")
  final int? type;
  @JsonKey(name: "typeName")
  final String? typeName;
  @JsonKey(name: "amount")
  final double? amount;
  @JsonKey(name: "isActive")
  late bool? isActive;
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
  @JsonKey(name: "startDate")
  final DateTime? startDate;
  @JsonKey(name: "endDate")
  final DateTime? endDate;
  @JsonKey(name: "description")
  final String? description;

  CreditHelperModel({
    required this.account,
    required this.item,
    required this.type,
    required this.typeName,
    required this.amount,
    required this.isActive,
    required this.rowNum,
    required this.id,
    required this.attribute,
    required this.recId,
    required this.infos,
    required this.startDate,
    required this.endDate,
    required this.description,
  });

  factory CreditHelperModel.fromJson(Map<String, dynamic> json) => _$CreditHelperModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreditHelperModelToJson(this);
}