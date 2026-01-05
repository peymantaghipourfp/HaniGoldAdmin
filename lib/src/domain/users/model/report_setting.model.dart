import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'report_setting.model.g.dart';

ReportSettingModel reportSettingModelFromJson(String str) => ReportSettingModel.fromJson(json.decode(str));

String reportSettingModelToJson(ReportSettingModel data) => json.encode(data.toJson());

@JsonSerializable()
class ReportSettingModel {
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "includes")
  final List<Clude>? includes;
  @JsonKey(name: "excludes")
  final List<Clude>? excludes;
  @JsonKey(name: "includeString")
  final String? includeString;
  @JsonKey(name: "excludeString")
  final String? excludeString;
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "infos")
  final List<dynamic>? infos;

  ReportSettingModel({
    required this.name,
    required this.includes,
    required this.excludes,
    required this.includeString,
    required this.excludeString,
    required this.id,
    required this.infos,
  });

  factory ReportSettingModel.fromJson(Map<String, dynamic> json) => _$ReportSettingModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReportSettingModelToJson(this);
}

@JsonSerializable()
class Clude {
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "name")
  final String? name;

  Clude({
    required this.id,
    required this.name,
  });

  factory Clude.fromJson(Map<String, dynamic> json) => _$CludeFromJson(json);

  Map<String, dynamic> toJson() => _$CludeToJson(this);
}