import 'package:hanigold_admin/src/domain/users/model/transaction_info_item.model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'check_result.model.g.dart';

CheckResultModel checkResultModelFromJson(String str) => CheckResultModel.fromJson(json.decode(str));

String checkResultModelToJson(CheckResultModel data) => json.encode(data.toJson());

@JsonSerializable()
class CheckResultModel {
  @JsonKey(name: "type")
  final String? type;
  @JsonKey(name: "recordId")
  final int? recordId;
  @JsonKey(name: "similarCount")
  final int? similarCount;
  @JsonKey(name: "countCheck")
  final bool? countCheck;
  @JsonKey(name: "status")
  final int? status;
  @JsonKey(name: "isDeleted")
  final bool? isDeleted;
  @JsonKey(name: "sourceTable")
  final String? sourceTable;
  @JsonKey(name: "hasParent")
  final bool? hasParent;
  @JsonKey(name: "transactions")
  final List<TransactionInfoItemModel>? transactions;

  CheckResultModel({
    required this.type,
    required this.recordId,
    required this.similarCount,
    required this.countCheck,
    required this.status,
    required this.isDeleted,
    required this.sourceTable,
    required this.hasParent,
    required this.transactions,
  });

  factory CheckResultModel.fromJson(Map<String, dynamic> json) => _$CheckResultModelFromJson(json);

  Map<String, dynamic> toJson() => _$CheckResultModelToJson(this);
}