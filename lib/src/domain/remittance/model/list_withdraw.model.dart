// To parse this JSON data, do
//
//     final listUserModel = listUserModelFromJson(jsonString);

import 'package:hanigold_admin/src/domain/account/model/account.model.dart';
import 'package:hanigold_admin/src/domain/remittance/model/remittance.model.dart';
import 'package:hanigold_admin/src/domain/users/model/paginated.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/withdraw.model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';


part 'list_withdraw.model.g.dart';


@JsonSerializable()
class ListWithdrawModel {
  @JsonKey(name: "withdrawRequests")
  final List<WithdrawModel>? withdrawRequests;
  @JsonKey(name: "paginated")
  final PaginatedModel? paginated;

  ListWithdrawModel({
    required this.withdrawRequests,
    required this.paginated,
  });

  factory ListWithdrawModel.fromJson(Map<String, dynamic> json) => _$ListWithdrawModelFromJson(json);

  Map<String, dynamic> toJson() => _$ListWithdrawModelToJson(this);
}
