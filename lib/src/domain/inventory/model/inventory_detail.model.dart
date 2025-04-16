
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

import '../../laboratory/model/laboratory.model.dart';
import '../../product/model/item.model.dart';
import '../../product/model/item_unit.model.dart';
import '../../wallet/model/wallet.model.dart';

part 'inventory_detail.model.g.dart';

InventoryDetailModel inventoryDetailModelFromJson(String str) => InventoryDetailModel.fromJson(json.decode(str));

String inventoryDetailModelToJson(InventoryDetailModel data) => json.encode(data.toJson());


@JsonSerializable()
class InventoryDetailModel {
  @JsonKey(name: "inventoryId")
  final int? inventoryId;
  @JsonKey(name: "wallet")
  final WalletModel? wallet;
  @JsonKey(name: "item")
  final ItemModel? item;
  @JsonKey(name: "laboratory")
  final LaboratoryModel? laboratory;
  @JsonKey(name: "itemUnit")
  final ItemUnitModel? itemUnit;
  @JsonKey(name: "quantity")
  final double? quantity;
  @JsonKey(name: "impurity")
  final double? impurity;
  @JsonKey(name: "weight750")
  final double? weight750;
  @JsonKey(name: "carat")
  final int? carat;
  @JsonKey(name: "receiptNumber")
  final String? receiptNumber ;
  @JsonKey(name: "price")
  final int? price;
  @JsonKey(name: "totalPrice")
  final int? totalPrice;
  @JsonKey(name: "type")
  final int? type;
  @JsonKey(name: "isDeleted")
  final bool? isDeleted;
  @JsonKey(name: "attachments")
  final List<Attachment>? attachments;
  @JsonKey(name: "rowNum")
  final int? rowNum;
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "attribute")
  final String? attribute;
  @JsonKey(name: "stateMode")
  final int? stateMode;
  @JsonKey(name: "createdOn")
  final DateTime? createdOn;
  @JsonKey(name: "modifiedOn")
  final DateTime? modifiedOn;
  @JsonKey(name: "recId")
  final String? recId;
  @JsonKey(name: "infos")
  final List<dynamic>? infos;

  InventoryDetailModel({
    this.inventoryId,
    this.wallet,
    this.item,
    this.laboratory,
    this.itemUnit,
    this.quantity,
    this.impurity,
    this.weight750,
    this.carat,
    this.receiptNumber,
    this.price,
    this.totalPrice,
    this.type,
    this.isDeleted,
    this.attachments,
    this.rowNum,
    this.id,
    this.attribute,
    this.stateMode,
    this.createdOn,
    this.modifiedOn,
    this.recId,
    this.infos,
  });

  factory InventoryDetailModel.fromJson(Map<String, dynamic> json) => _$InventoryDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$InventoryDetailModelToJson(this);
}

@JsonSerializable()
class Attachment {
  @JsonKey(name: "recordId")
  final String? recordId;
  @JsonKey(name: "guidId")
  final String? guidId;
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "extension")
  final String? extension;
  @JsonKey(name: "entityType")
  final String? entityType;
  @JsonKey(name: "type")
  final String? type;
  @JsonKey(name: "rowNum")
  final int? rowNum;
  @JsonKey(name: "attribute")
  final String? attribute;
  @JsonKey(name: "infos")
  final List<dynamic>? infos;

  Attachment({
    required this.recordId,
    required this.guidId,
    required this.name,
    required this.extension,
    required this.entityType,
    required this.type,
    required this.rowNum,
    required this.attribute,
    required this.infos,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) => _$AttachmentFromJson(json);

  Map<String, dynamic> toJson() => _$AttachmentToJson(this);
}