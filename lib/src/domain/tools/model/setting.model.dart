
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'setting.model.g.dart';

SettingModel settingModelFromJson(String str) => SettingModel.fromJson(json.decode(str));

String settingModelToJson(SettingModel data) => json.encode(data.toJson());

@JsonSerializable()
class SettingModel {
  @JsonKey(name: "status")
  final bool? status;
  @JsonKey(name: "orderStatus")
  final bool? orderStatus;
  @JsonKey(name: "adminStatus")
  final bool? adminStatus;
  @JsonKey(name: "startTime")
  final String? startTime;
  @JsonKey(name: "endTime")
  final String? endTime;
  @JsonKey(name: "isOrderAvailable")
  final bool? isOrderAvailable;
  @JsonKey(name: "rowNum")
  final int? rowNum;
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "infos")
  final List<dynamic>? infos;

  SettingModel({
    required this.status,
    required this.orderStatus,
    required this.adminStatus,
    required this.startTime,
    required this.endTime,
    required this.isOrderAvailable,
    required this.rowNum,
    required this.id,
    required this.infos,
  });

  factory SettingModel.fromJson(Map<String, dynamic> json) => _$SettingModelFromJson(json);

  Map<String, dynamic> toJson() => _$SettingModelToJson(this);
}