
import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import '../../account/model/account.model.dart';

part 'order.model.g.dart';

List<OrderModel> orderModelFromJson(String str) => List<OrderModel>.from(json.decode(str).map((x) => OrderModel.fromJson(x)));

String orderModelToJson(List<OrderModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class OrderModel {
  @JsonKey(name: "date")
  final DateTime date;
  @JsonKey(name: "account")
  final Parent account;
  @JsonKey(name: "registered")
  final int registered;
  @JsonKey(name: "checked")
  final int checked;
  @JsonKey(name: "isDeleted")
  final bool isDeleted;
  @JsonKey(name: "rowNum")
  final int rowNum;
  @JsonKey(name: "id")
  final int id;
  @JsonKey(name: "attribute")
  final AccountModelAttribute attribute;
  @JsonKey(name: "recId")
  final String recId;
  @JsonKey(name: "infos")
  final List<dynamic> infos;

  OrderModel({
    required this.date,
    required this.account,
    required this.registered,
    required this.checked,
    required this.isDeleted,
    required this.rowNum,
    required this.id,
    required this.attribute,
    required this.recId,
    required this.infos,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => _$OrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderModelToJson(this);
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}