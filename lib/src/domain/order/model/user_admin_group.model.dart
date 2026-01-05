import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'user_admin_group.model.g.dart';

UserAdminGroupModel userAdminGroupModelFromJson(String str) => UserAdminGroupModel.fromJson(json.decode(str));

String userAdminGroupModelToJson(UserAdminGroupModel data) => json.encode(data.toJson());

@JsonSerializable()
class UserAdminGroupModel {
  @JsonKey(name: "byAdmin")
  final int? byAdmin;
  @JsonKey(name: "byAdminName")
  final String? byAdminName;
  @JsonKey(name: "accountCountDistinct")
  final int? accountCountDistinct;
  @JsonKey(name: "orderCount")
  final int? orderCount;
  @JsonKey(name: "rejectedOrderCount")
  final int? rejectedOrderCount;
  @JsonKey(name: "buyCount")
  final int? buyCount;
  @JsonKey(name: "sellCount")
  final int? sellCount;
  @JsonKey(name: "totalBuyQuantity")
  final double? totalBuyQuantity;
  @JsonKey(name: "totalSellQuantity")
  final double? totalSellQuantity;
  @JsonKey(name: "minBuyQuantity")
  final double? minBuyQuantity;
  @JsonKey(name: "maxBuyQuantity")
  final double? maxBuyQuantity;
  @JsonKey(name: "minSellQuantity")
  final double? minSellQuantity;
  @JsonKey(name: "maxSellQuantity")
  final double? maxSellQuantity;

  UserAdminGroupModel({
    required this.byAdmin,
    required this.byAdminName,
    required this.accountCountDistinct,
    required this.orderCount,
    required this.rejectedOrderCount,
    required this.buyCount,
    required this.sellCount,
    required this.totalBuyQuantity,
    required this.totalSellQuantity,
    required this.minBuyQuantity,
    required this.maxBuyQuantity,
    required this.minSellQuantity,
    required this.maxSellQuantity,
  });

  factory UserAdminGroupModel.fromJson(Map<String, dynamic> json) => _$UserAdminGroupModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserAdminGroupModelToJson(this);
}