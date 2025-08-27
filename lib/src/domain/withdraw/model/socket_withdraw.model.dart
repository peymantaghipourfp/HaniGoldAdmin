
import 'dart:convert';

SocketWithdrawModel socketWithdrawModelFromJson(String str) => SocketWithdrawModel.fromJson(json.decode(str));

String socketWithdrawModelToJson(SocketWithdrawModel data) => json.encode(data.toJson());

class SocketWithdrawModel {
  final String? channel;
  final int? id;
  final String? accountName;
  late double? amount;

  SocketWithdrawModel({
    required this.channel,
    required this.id,
    required this.accountName,
    required this.amount,
  });

  factory SocketWithdrawModel.fromJson(Map<String, dynamic> json) => SocketWithdrawModel(
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
