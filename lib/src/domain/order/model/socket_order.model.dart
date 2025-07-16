
import 'dart:convert';

SocketOrderModel socketOrderModelFromJson(String str) => SocketOrderModel.fromJson(json.decode(str));

String socketOrderModelToJson(SocketOrderModel data) => json.encode(data.toJson());

class SocketOrderModel {
  final String channel;
  final int id;
  final String accountName;
  final String itemName;
  late double quantity;
  late double price;
  late double totalPrice;

  SocketOrderModel({
    required this.channel,
    required this.id,
    required this.accountName,
    required this.itemName,
    required this.quantity,
    required this.price,
    required this.totalPrice,
  });

  factory SocketOrderModel.fromJson(Map<String, dynamic> json) => SocketOrderModel(
    channel: json["channel"],
    id: json["id"],
    accountName: json["AccountName"],
    itemName: json["ItemName"],
    quantity: json["Qunatity"]?.toDouble(),
    price: json["Price"]?.toDouble(),
    totalPrice: json["TotalPrice"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "channel": channel,
    "id": id,
    "AccountName": accountName,
    "ItemName": itemName,
    "Qunatity": quantity,
    "Price": price,
    "TotalPrice": totalPrice,
  };
}
