import 'package:hanigold_admin/src/domain/account/model/account.model.dart';
import 'package:hanigold_admin/src/domain/remittance/model/remittance.model.dart';
import 'package:hanigold_admin/src/domain/remittance/model/remittance_request.model.dart';
import 'package:hanigold_admin/src/domain/users/model/paginated.model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'list_remittance_request.model.g.dart';

ListRemittanceRequestModel listRemittanceRequestModelFromJson(String str) => ListRemittanceRequestModel.fromJson(json.decode(str));

String listRemittanceRequestModelToJson(ListRemittanceRequestModel data) => json.encode(data.toJson());

@JsonSerializable()
class ListRemittanceRequestModel {
  @JsonKey(name: "remittanceRequests")
  final List<RemittanceRequestModel>? remittanceRequests;
  @JsonKey(name: "paginated")
  final PaginatedModel? paginated;

  ListRemittanceRequestModel({
    required this.remittanceRequests,
    required this.paginated,
  });

  factory ListRemittanceRequestModel.fromJson(Map<String, dynamic> json) => _$ListRemittanceRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$ListRemittanceRequestModelToJson(this);
}