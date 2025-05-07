
import 'dart:convert';

InfoModel infoModelFromJson(String str) => InfoModel.fromJson(json.decode(str));

String infoModelToJson(InfoModel data) => json.encode(data.toJson());

class InfoModel {
  final int infoType;
  final int code;
  final String title;
  final bool sendToDecom;
  final String description;
  final String languageCode;

  InfoModel({
    required this.infoType,
    required this.code,
    required this.title,
    required this.sendToDecom,
    required this.description,
    required this.languageCode,
  });

  factory InfoModel.fromJson(Map<String, dynamic> json) => InfoModel(
    infoType: json["infoType"],
    code: json["code"],
    title: json["title"],
    sendToDecom: json["sendToDecom"],
    description: json["description"],
    languageCode: json["languageCode"],
  );

  Map<String, dynamic> toJson() => {
    "infoType": infoType,
    "code": code,
    "title": title,
    "sendToDecom": sendToDecom,
    "description": description,
    "languageCode": languageCode,
  };
}
