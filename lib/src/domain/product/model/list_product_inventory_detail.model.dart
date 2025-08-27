import 'package:hanigold_admin/src/domain/product/model/product_inventory_detail.model.dart';
import 'package:hanigold_admin/src/domain/users/model/paginated.model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'list_product_inventory_detail.model.g.dart';

ListProductInventoryDetailModel listProductInventoryDetailModelFromJson(String str) => ListProductInventoryDetailModel.fromJson(json.decode(str));

String listProductInventoryDetailModelToJson(ListProductInventoryDetailModel data) => json.encode(data.toJson());

@JsonSerializable()
class ListProductInventoryDetailModel {
  @JsonKey(name: "inventories")
  final List<ProductInventoryDetailModel>? inventories;
  @JsonKey(name: "paginated")
  final PaginatedModel? paginated;

  ListProductInventoryDetailModel({
    required this.inventories,
    required this.paginated,
  });

  factory ListProductInventoryDetailModel.fromJson(Map<String, dynamic> json) => _$ListProductInventoryDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$ListProductInventoryDetailModelToJson(this);
}