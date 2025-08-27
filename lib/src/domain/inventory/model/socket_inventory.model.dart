
import 'dart:convert';

SocketInventoryModel socketInventoryModelFromJson(String str) => SocketInventoryModel.fromJson(json.decode(str));

String socketInventoryModelToJson(SocketInventoryModel data) => json.encode(data.toJson());

class SocketInventoryModel {
  final String? channel;
  final int? id;
  final String? accountName;
  final String? itemName;

  SocketInventoryModel({
    required this.channel,
    required this.id,
    required this.accountName,
    required this.itemName,
  });

  factory SocketInventoryModel.fromJson(Map<String, dynamic> json) => SocketInventoryModel(
    channel: json["channel"],
    id: json["id"],
    accountName: json["accountName"],
    itemName: json["itemName"],

  );

  Map<String, dynamic> toJson() => {
    "channel": channel,
    "id": id,
    "AccountName": accountName,
    "itemName": itemName,
  };
}
