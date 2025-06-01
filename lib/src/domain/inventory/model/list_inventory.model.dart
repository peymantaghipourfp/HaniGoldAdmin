// To parse this JSON data, do
//
//     final listInventoryModel = listInventoryModelFromJson(jsonString);

import 'package:hanigold_admin/src/domain/inventory/model/inventory.model.dart';
import 'package:hanigold_admin/src/domain/users/model/paginated.model.dart';
import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'list_inventory.model.g.dart';

ListInventoryModel listInventoryModelFromJson(String str) => ListInventoryModel.fromJson(json.decode(str));

String listInventoryModelToJson(ListInventoryModel data) => json.encode(data.toJson());

@JsonSerializable()
class ListInventoryModel {
  @JsonKey(name: "inventories")
  final List<InventoryModel>? inventories;
  @JsonKey(name: "paginated")
  final PaginatedModel? paginated;

  ListInventoryModel({
    required this.inventories,
    required this.paginated,
  });

  factory ListInventoryModel.fromJson(Map<String, dynamic> json) => _$ListInventoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$ListInventoryModelToJson(this);
}