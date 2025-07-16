
import 'dart:convert';

SocketItemModel socketItemModelFromJson(String str) => SocketItemModel.fromJson(json.decode(str));

String socketItemModelToJson(SocketItemModel data) => json.encode(data.toJson());

class SocketItemModel {
  final String channel;
  final int id;
  final String name;
  late double price;
  late double differentPrice;
  late double mesghalPrice;
  late double mesghalDifferentPrice;

  SocketItemModel({
    required this.channel,
    required this.id,
    required this.name,
    required this.price,
    required this.differentPrice,
    required this.mesghalPrice,
    required this.mesghalDifferentPrice,
  });

  factory SocketItemModel.fromJson(Map<String, dynamic> json) => SocketItemModel(
    channel: json["channel"],
    id: json["id"],
    name: json["Name"],
    price: json["price"]?.toDouble(),
    differentPrice: json["differentPrice"]?.toDouble(),
    mesghalPrice: json["mesghalPrice"]?.toDouble(),
    mesghalDifferentPrice: json["mesghalDifferentPrice"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "channel": channel,
    "id": id,
    "Name": name,
    "price": price,
    "differentPrice": differentPrice,
    "mesghalPrice": mesghalPrice,
    "mesghalDifferentPrice": mesghalDifferentPrice,
  };
}
