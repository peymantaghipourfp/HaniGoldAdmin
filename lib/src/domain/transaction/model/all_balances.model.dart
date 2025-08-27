import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'all_balances.model.g.dart';

List<AllBalancesModel> allBalancesModelFromJson(String str) => List<AllBalancesModel>.from(json.decode(str).map((x) => AllBalancesModel.fromJson(x)));

String allBalancesModelToJson(List<AllBalancesModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class AllBalancesModel {
  @JsonKey(name: "balance")
  final double? balance;
  @JsonKey(name: "itemName")
  final String? itemName;
  @JsonKey(name: "unitName")
  final String? unitName;

  AllBalancesModel({
    required this.balance,
    required this.itemName,
    required this.unitName,
  });

  factory AllBalancesModel.fromJson(Map<String, dynamic> json) => _$AllBalancesModelFromJson(json);

  Map<String, dynamic> toJson() => _$AllBalancesModelToJson(this);
}
