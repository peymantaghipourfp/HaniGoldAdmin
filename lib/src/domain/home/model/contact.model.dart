
import 'package:hanigold_admin/src/domain/account/model/account.model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'contact.model.g.dart';

List<ContactModel> contactModelFromJson(String str) => List<ContactModel>.from(json.decode(str).map((x) => ContactModel.fromJson(x)));

String contactModelToJson(List<ContactModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class ContactModel {
  @JsonKey(name: "account")
  final AccountModel? account;
  @JsonKey(name: "infos")
  final List<dynamic>? infos;

  ContactModel({
    required this.account,
    required this.infos,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) => _$ContactModelFromJson(json);

  Map<String, dynamic> toJson() => _$ContactModelToJson(this);
}