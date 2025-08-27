
import 'dart:convert';

SocketRemittanceRequestModel socketRemittanceRequestModelFromJson(String str) => SocketRemittanceRequestModel.fromJson(json.decode(str));

String socketRemittanceRequestModelToJson(SocketRemittanceRequestModel data) => json.encode(data.toJson());

class SocketRemittanceRequestModel {
  final String? channel;
  final int? id;
  final String? accountName;
  late double? quantity;

  SocketRemittanceRequestModel({
    required this.channel,
    required this.id,
    required this.accountName,
    required this.quantity,
  });

  factory SocketRemittanceRequestModel.fromJson(Map<String, dynamic> json) => SocketRemittanceRequestModel(
    channel: json["channel"],
    id: json["id"],
    accountName: json["accountName"],
    quantity: json["Qunatity"]?.toDouble(),

  );

  Map<String, dynamic> toJson() => {
    "channel": channel,
    "id": id,
    "AccountName": accountName,
    "Qunatity": quantity,
  };
}
