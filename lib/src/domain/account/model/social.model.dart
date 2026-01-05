import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'social.model.g.dart';

SocialModel socialModelFromJson(String str) => SocialModel.fromJson(json.decode(str));

String socialModelToJson(SocialModel data) => json.encode(data.toJson());

@JsonSerializable()
class SocialModel {
  @JsonKey(name: "accountId")
  final int? accountId;
  @JsonKey(name: "telegramStatus")
  final bool? telegramStatus;
  @JsonKey(name: "whatsappStatus")
  final bool? whatsappStatus;
  @JsonKey(name: "infos")
  final List<dynamic>? infos;

  SocialModel({
    required this.accountId,
    required this.telegramStatus,
    required this.whatsappStatus,
    required this.infos,
  });

  factory SocialModel.fromJson(Map<String, dynamic> json) => _$SocialModelFromJson(json);

  Map<String, dynamic> toJson() => _$SocialModelToJson(this);
}