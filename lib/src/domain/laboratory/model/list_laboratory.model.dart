// To parse this JSON data, do
//
//     final listUserModel = listUserModelFromJson(jsonString);

import 'package:hanigold_admin/src/domain/account/model/account.model.dart';
import 'package:hanigold_admin/src/domain/laboratory/model/laboratory.model.dart';
import 'package:hanigold_admin/src/domain/users/model/paginated.model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'list_laboratory.model.g.dart';

ListLaboratoryModel listUserModelFromJson(String str) => ListLaboratoryModel.fromJson(json.decode(str));

String listUserModelToJson(ListLaboratoryModel data) => json.encode(data.toJson());

@JsonSerializable()
class ListLaboratoryModel {
  @JsonKey(name: "laboratories")
  final List<LaboratoryModel>? laboratories;
  @JsonKey(name: "paginated")
  final PaginatedModel? paginated;

  ListLaboratoryModel({
    required this.laboratories,
    required this.paginated,
  });

  factory ListLaboratoryModel.fromJson(Map<String, dynamic> json) => _$ListLaboratoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$ListLaboratoryModelToJson(this);
}
