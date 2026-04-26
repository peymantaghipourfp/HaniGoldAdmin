
import 'dart:convert';

SocketItemModel socketItemModelFromJson(String str) => SocketItemModel.fromJson(json.decode(str));

String socketItemModelToJson(SocketItemModel data) => json.encode(data.toJson());

class SocketItemModel {
  final String? channel;
  final int? id;
  final String? name;
  late double? price;
  late double? differentPrice;
  late double? mesghalPrice;
  late double? mesghalDifferentPrice;
  late double? basePrice;
  late double? baseDifferentPrice;
  late double? baseMesghalPrice;
  late double? baseMesghalDifferentPrice;
  late double? salesRange;
  late double? buyRange;
  final DateTime? date;
  final int? groupId;
  final String? groupName;

  SocketItemModel({
    required this.channel,
    required this.id,
    required this.name,
    required this.price,
    required this.differentPrice,
    required this.mesghalPrice,
    required this.mesghalDifferentPrice,
    required this.basePrice,
    required this.baseDifferentPrice,
    required this.baseMesghalPrice,
    required this.baseMesghalDifferentPrice,
    required this.salesRange,
    required this.buyRange,
    required this.date,
    required this.groupId,
    required this.groupName,
  });

  factory SocketItemModel.fromJson(Map<String, dynamic> json) => SocketItemModel(
    channel: json["channel"],
    id: json["id"],
    name: json["name"],
    price: json["price"]?.toDouble(),
    differentPrice: json["differentPrice"]?.toDouble(),
    mesghalPrice: json["mesghalPrice"]?.toDouble(),
    mesghalDifferentPrice: json["mesghalDifferentPrice"]?.toDouble(),
    basePrice: json["basePrice"]?.toDouble(),
    baseDifferentPrice: json["baseDifferentPrice"]?.toDouble(),
    baseMesghalPrice: json["baseMesghalPrice"]?.toDouble(),
    baseMesghalDifferentPrice: json["baseMesghalDifferentPrice"]?.toDouble(),
    salesRange: json["salesRange"]?.toDouble(),
    buyRange: json["buyRange"]?.toDouble(),
    date: json['date'] == null ? null : DateTime.parse(json['date'] as String),
    groupId: json["groupId"],
    groupName: json["groupName"],
  );

  Map<String, dynamic> toJson() => {
    "channel": channel,
    "id": id,
    "name": name,
    "price": price,
    "differentPrice": differentPrice,
    "mesghalPrice": mesghalPrice,
    "mesghalDifferentPrice": mesghalDifferentPrice,
    "basePrice": basePrice,
    "baseDifferentPrice": baseDifferentPrice,
    "baseMesghalPrice": baseMesghalPrice,
    "baseMesghalDifferentPrice": baseMesghalDifferentPrice,
    "salesRange": salesRange,
    "buyRange": buyRange,
    'date': date?.toIso8601String(),
    "groupId": groupId,
    "groupName": groupName,
  };
}
