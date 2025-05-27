// To parse this JSON data, do
//
//     final listUserModel = listUserModelFromJson(jsonString);

import 'package:hanigold_admin/src/domain/account/model/account.model.dart';
import 'package:hanigold_admin/src/domain/remittance/model/remittance.model.dart';
import 'package:hanigold_admin/src/domain/users/model/paginated.model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'list_remittance.model.g.dart';

ListRemittanceModel listUserModelFromJson(String str) => ListRemittanceModel.fromJson(json.decode(str));

String listUserModelToJson(ListRemittanceModel data) => json.encode(data.toJson());

@JsonSerializable()
class ListRemittanceModel {
  @JsonKey(name: "remittances")
  final List<RemittanceModel>? remittances;
  @JsonKey(name: "paginated")
  final PaginatedModel? paginated;

  ListRemittanceModel({
    required this.remittances,
    required this.paginated,
  });

  factory ListRemittanceModel.fromJson(Map<String, dynamic> json) => _$ListRemittanceModelFromJson(json);

  Map<String, dynamic> toJson() => _$ListRemittanceModelToJson(this);
}
