
import 'package:hanigold_admin/src/domain/inventory/model/inventory_detail.model.dart';
import 'package:hanigold_admin/src/domain/users/model/paginated.model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'list_forPayment.model.g.dart';

ListForPaymentModel listForPaymentModelFromJson(String str) => ListForPaymentModel.fromJson(json.decode(str));

String listForPaymentModelToJson(ListForPaymentModel data) => json.encode(data.toJson());

@JsonSerializable()
class ListForPaymentModel {
  @JsonKey(name: "inventories")
  final List<InventoryDetailModel>? inventories;
  @JsonKey(name: "paginated")
  final PaginatedModel? paginated;

  ListForPaymentModel({
    required this.inventories,
    required this.paginated,
  });

  factory ListForPaymentModel.fromJson(Map<String, dynamic> json) => _$ListForPaymentModelFromJson(json);

  Map<String, dynamic> toJson() => _$ListForPaymentModelToJson(this);
}