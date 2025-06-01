// To parse this JSON data, do
//
//     final listUserModel = listUserModelFromJson(jsonString);

import 'package:hanigold_admin/src/domain/account/model/account.model.dart';
import 'package:hanigold_admin/src/domain/remittance/model/remittance.model.dart';
import 'package:hanigold_admin/src/domain/users/model/paginated.model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

import 'deposit.model.dart';

part 'list_deposit.model.g.dart';


@JsonSerializable()
class ListDepositModel {
  @JsonKey(name: "deposits")
  final List<DepositModel>? deposit;
  @JsonKey(name: "paginated")
  final PaginatedModel? paginated;

  ListDepositModel({
    required this.deposit,
    required this.paginated,
  });

  factory ListDepositModel.fromJson(Map<String, dynamic> json) => _$ListDepositModelFromJson(json);

  Map<String, dynamic> toJson() => _$ListDepositModelToJson(this);
}
