import 'dart:convert';

import 'package:hanigold_admin/src/domain/withdraw/model/options.model.dart';

ReasonRejectionReqModel reasonRejectionReqModelFromJson(String str) => ReasonRejectionReqModel.fromJson(json.decode(str));

String reasonRejectionReqModelToJson(ReasonRejectionReqModel data) => json.encode(data.toJson());

class ReasonRejectionReqModel {
  final OptionsModel? reasonrejection;

  ReasonRejectionReqModel({
    required this.reasonrejection,
  });

  factory ReasonRejectionReqModel.fromJson(Map<String, dynamic> json) => ReasonRejectionReqModel(
    reasonrejection: OptionsModel.fromJson(json["reasonrejection"]),
  );

  Map<String, dynamic> toJson() => {
    "reasonrejection": reasonrejection?.toJson(),
  };
}