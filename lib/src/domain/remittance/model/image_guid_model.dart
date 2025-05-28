// To parse this JSON data, do
//
//     final imageGuidModel = imageGuidModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'image_guid_model.g.dart';

ImageGuidModel imageGuidModelFromJson(String str) => ImageGuidModel.fromJson(json.decode(str));

String imageGuidModelToJson(ImageGuidModel data) => json.encode(data.toJson());

@JsonSerializable()
class ImageGuidModel {
  @JsonKey(name: "guidIds")
  final List<String> guidIds;

  ImageGuidModel({
    required this.guidIds,
  });

  factory ImageGuidModel.fromJson(Map<String, dynamic> json) => _$ImageGuidModelFromJson(json);

  Map<String, dynamic> toJson() => _$ImageGuidModelToJson(this);
}
