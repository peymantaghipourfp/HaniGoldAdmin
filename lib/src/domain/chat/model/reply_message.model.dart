import 'package:hanigold_admin/src/domain/home/model/user.model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'reply_message.model.g.dart';

List<ReplyMessageModel> replyMessageModelFromJson(String str) => List<ReplyMessageModel>.from(json.decode(str).map((x) => ReplyMessageModel.fromJson(x)));

String replyMessageModelToJson(List<ReplyMessageModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class ReplyMessageModel {
  @JsonKey(name: "fromUser")
  final UserModel? fromUser;
  @JsonKey(name: "toUser")
  final UserModel? toUser;
  @JsonKey(name: "infos")
  final List<dynamic>? infos;
  @JsonKey(name: "messageContent")
  final String? messageContent;
  @JsonKey(name: "id")
  final int? id;

  ReplyMessageModel({
    required this.fromUser,
    required this.toUser,
    required this.infos,
    required this.messageContent,
    required this.id,
  });

  factory ReplyMessageModel.fromJson(Map<String, dynamic> json) => _$ReplyMessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReplyMessageModelToJson(this);
}