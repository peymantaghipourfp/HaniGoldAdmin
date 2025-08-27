import 'package:hanigold_admin/src/domain/home/model/user.model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'topic.model.g.dart';

List<TopicModel> topicModelFromJson(String str) => List<TopicModel>.from(json.decode(str).map((x) => TopicModel.fromJson(x)));

String topicModelToJson(List<TopicModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class TopicModel {
  @JsonKey(name: "user")
  final UserModel? user;
  @JsonKey(name: "code")
  final String? code;
  @JsonKey(name: "topic")
  final String? topic;
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "infos")
  final List<dynamic>? infos;

  TopicModel({
    required this.user,
    required this.code,
    required this.topic,
    required this.id,
    required this.infos,
  });

  factory TopicModel.fromJson(Map<String, dynamic> json) => _$TopicModelFromJson(json);

  Map<String, dynamic> toJson() => _$TopicModelToJson(this);
}