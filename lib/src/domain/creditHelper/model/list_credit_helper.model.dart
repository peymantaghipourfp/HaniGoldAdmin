import 'package:hanigold_admin/src/domain/creditHelper/model/credit_helper.model.dart';
import 'package:hanigold_admin/src/domain/users/model/paginated.model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'list_credit_helper.model.g.dart';

ListCreditHelperModel listCreditHelperModelFromJson(String str) => ListCreditHelperModel.fromJson(json.decode(str));

String listCreditHelperModelToJson(ListCreditHelperModel data) => json.encode(data.toJson());

@JsonSerializable()
class ListCreditHelperModel {
  @JsonKey(name: "creditHelpers")
  final List<CreditHelperModel>? creditHelpers;
  @JsonKey(name: "paginated")
  final PaginatedModel? paginated;

  ListCreditHelperModel({
    required this.creditHelpers,
    required this.paginated,
  });

  factory ListCreditHelperModel.fromJson(Map<String, dynamic> json) => _$ListCreditHelperModelFromJson(json);

  Map<String, dynamic> toJson() => _$ListCreditHelperModelToJson(this);
}