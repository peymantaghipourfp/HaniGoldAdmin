
import 'dart:convert';

SocketRemittanceModel socketRemittanceModelFromJson(String str) => SocketRemittanceModel.fromJson(json.decode(str));

String socketRemittanceModelToJson(SocketRemittanceModel data) => json.encode(data.toJson());

class SocketRemittanceModel {
  final String? channel;
  final int? id;
  final String? payer;
  final String? reciept;
  final String? itemName;
  late double? quantity;

  SocketRemittanceModel({
    required this.channel,
    required this.id,
    required this.payer,
    required this.reciept,
    required this.itemName,
    required this.quantity,
  });

  factory SocketRemittanceModel.fromJson(Map<String, dynamic> json) => SocketRemittanceModel(
    channel: json["channel"],
    id: json["id"],
    payer: json["payer"],
    reciept: json["reciept"],
    itemName: json["itemName"],
    quantity: json["Qunatity"]?.toDouble(),

  );

  Map<String, dynamic> toJson() => {
    "channel": channel,
    "id": id,
    "payer": payer,
    "reciept": reciept,
    "itemName": itemName,
    "Qunatity": quantity,
  };
}
