// To parse this JSON data, do
//
//     final listOrderModel = listOrderModelFromJson(jsonString);

import 'package:hanigold_admin/src/domain/order/model/order.model.dart';
import 'package:hanigold_admin/src/domain/users/model/paginated.model.dart';
import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'list_order.model.g.dart';

ListOrderModel listOrderModelFromJson(String str) => ListOrderModel.fromJson(json.decode(str));

String listOrderModelToJson(ListOrderModel data) => json.encode(data.toJson());

@JsonSerializable()
class ListOrderModel {
  @JsonKey(name: "orders")
  final List<OrderModel> orders;
  @JsonKey(name: "paginated")
  final PaginatedModel paginated;

  ListOrderModel({
    required this.orders,
    required this.paginated,
  });

  factory ListOrderModel.fromJson(Map<String, dynamic> json) => _$ListOrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$ListOrderModelToJson(this);
}