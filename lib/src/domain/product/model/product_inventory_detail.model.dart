
import 'package:hanigold_admin/src/domain/inventory/model/createdBy.model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

import '../../laboratory/model/laboratory.model.dart';
import '../../product/model/item.model.dart';
import '../../product/model/item_unit.model.dart';
import '../../wallet/model/wallet.model.dart';

part 'product_inventory_detail.model.g.dart';

ProductInventoryDetailModel productInventoryDetailModelFromJson(String str) => ProductInventoryDetailModel.fromJson(json.decode(str));

String productInventoryDetailModelToJson(ProductInventoryDetailModel data) => json.encode(data.toJson());


@JsonSerializable()
class ProductInventoryDetailModel {
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
  @JsonKey(name: "quantityRemainded")
  final double? quantityRemainded;
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
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "stateMode")
  final int? stateMode;
  @JsonKey(name: "createdOn")
  final DateTime? createdOn;
  @JsonKey(name: "modifiedOn")
  final DateTime? modifiedOn;
  @JsonKey(name: "recId")
  late  String? recId;
  @JsonKey(name: "infos")
  final List<dynamic>? infos;
  @JsonKey(name: "description")
  final String? description;
  @JsonKey(name: "inputItemId")
  final int? inputItemId;
  @JsonKey(name: "date")
  final DateTime? date;
  @JsonKey(name: "createdBy")
  final CreatedByModel? createdBy;
  @JsonKey(ignore: true)
  late List<XFile>? listXfile;

  ProductInventoryDetailModel({
    this.inventoryId,
    this.wallet,
    this.item,
    this.laboratory,
    this.itemUnit,
    this.quantity,
    this.impurity,
    this.weight750,
    this.quantityRemainded,
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
    this.name,
    this.stateMode,
    this.createdOn,
    this.modifiedOn,
    this.recId,
    this.infos,
    this.description,
    this.inputItemId,
    this.date,
    required this.createdBy,
    this.listXfile,
  });

  factory ProductInventoryDetailModel.fromJson(Map<String, dynamic> json) => _$ProductInventoryDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductInventoryDetailModelToJson(this);
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