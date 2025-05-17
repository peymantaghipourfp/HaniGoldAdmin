
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'paginated.model.g.dart';

PaginatedModel paginatedModelFromJson(String str) => PaginatedModel.fromJson(json.decode(str));

String paginatedModelToJson(PaginatedModel data) => json.encode(data.toJson());

@JsonSerializable()
class PaginatedModel {
  @JsonKey(name: "fromNumber")
  final int? fromNumber;
  @JsonKey(name: "toNumber")
  final int? toNumber;
  @JsonKey(name: "totalCount")
  final int? totalCount;

  PaginatedModel({
    required this.fromNumber,
    required this.toNumber,
    required this.totalCount,
  });

  factory PaginatedModel.fromJson(Map<String, dynamic> json) => _$PaginatedModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaginatedModelToJson(this);
}
