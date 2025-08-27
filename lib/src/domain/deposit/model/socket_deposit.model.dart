
import 'dart:convert';

SocketDepositModel socketDepositModelFromJson(String str) => SocketDepositModel.fromJson(json.decode(str));

String socketDepositModelToJson(SocketDepositModel data) => json.encode(data.toJson());

class SocketDepositModel {
  final String? channel;
  final int? id;
  final String? accountName;
  late double? amount;

  SocketDepositModel({
    required this.channel,
    required this.id,
    required this.accountName,
    required this.amount,
  });

  factory SocketDepositModel.fromJson(Map<String, dynamic> json) => SocketDepositModel(
    channel: json["channel"],
    id: json["id"],
    accountName: json["accountName"],
    amount: json["amount"]?.toDouble(),

  );

  Map<String, dynamic> toJson() => {
    "channel": channel,
    "id": id,
    "AccountName": accountName,
    "Amount": amount,
  };
}
