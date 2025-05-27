// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_detail.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InventoryDetailModel _$InventoryDetailModelFromJson(
        Map<String, dynamic> json) =>
    InventoryDetailModel(
      inventoryId: (json['inventoryId'] as num?)?.toInt(),
      wallet: json['wallet'] == null
          ? null
          : WalletModel.fromJson(json['wallet'] as Map<String, dynamic>),
      item: json['item'] == null
          ? null
          : ItemModel.fromJson(json['item'] as Map<String, dynamic>),
      laboratory: json['laboratory'] == null
          ? null
          : LaboratoryModel.fromJson(
              json['laboratory'] as Map<String, dynamic>),
      itemUnit: json['itemUnit'] == null
          ? null
          : ItemUnitModel.fromJson(json['itemUnit'] as Map<String, dynamic>),
      quantity: (json['quantity'] as num?)?.toDouble(),
      impurity: (json['impurity'] as num?)?.toDouble(),
      weight750: (json['weight750'] as num?)?.toDouble(),
      quantityRemainded: (json['quantityRemainded'] as num?)?.toDouble(),
      carat: (json['carat'] as num?)?.toInt(),
      receiptNumber: json['receiptNumber'] as String?,
      price: (json['price'] as num?)?.toInt(),
      totalPrice: (json['totalPrice'] as num?)?.toInt(),
      type: (json['type'] as num?)?.toInt(),
      isDeleted: json['isDeleted'] as bool?,
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => Attachment.fromJson(e as Map<String, dynamic>))
          .toList(),
      rowNum: (json['rowNum'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      attribute: json['attribute'] as String?,
      stateMode: (json['stateMode'] as num?)?.toInt(),
      createdOn: json['createdOn'] == null
          ? null
          : DateTime.parse(json['createdOn'] as String),
      modifiedOn: json['modifiedOn'] == null
          ? null
          : DateTime.parse(json['modifiedOn'] as String),
      recId: json['recId'] as String?,
      infos: json['infos'] as List<dynamic>?,
      description: json['description'] as String?,
      inputItemId: (json['inputItemId'] as num?)?.toInt(),
          date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$InventoryDetailModelToJson(
        InventoryDetailModel instance) =>
    <String, dynamic>{
      'inventoryId': instance.inventoryId,
      'wallet': instance.wallet,
      'item': instance.item,
      'laboratory': instance.laboratory,
      'itemUnit': instance.itemUnit,
      'quantity': instance.quantity,
      'impurity': instance.impurity,
      'weight750': instance.weight750,
      'quantityRemainded': instance.quantityRemainded,
      'carat': instance.carat,
      'receiptNumber': instance.receiptNumber,
      'price': instance.price,
      'totalPrice': instance.totalPrice,
      'type': instance.type,
      'isDeleted': instance.isDeleted,
      'attachments': instance.attachments,
      'rowNum': instance.rowNum,
      'id': instance.id,
      'attribute': instance.attribute,
      'stateMode': instance.stateMode,
      'createdOn': instance.createdOn?.toIso8601String(),
      'modifiedOn': instance.modifiedOn?.toIso8601String(),
      'recId': instance.recId,
      'infos': instance.infos,
      'description': instance.description,
      'inputItemId': instance.inputItemId,
      'date': instance.date?.toIso8601String(),
    };

Attachment _$AttachmentFromJson(Map<String, dynamic> json) => Attachment(
      recordId: json['recordId'] as String?,
      guidId: json['guidId'] as String?,
      name: json['name'] as String?,
      extension: json['extension'] as String?,
      entityType: json['entityType'] as String?,
      type: json['type'] as String?,
      rowNum: (json['rowNum'] as num?)?.toInt(),
      attribute: json['attribute'] as String?,
      infos: json['infos'] as List<dynamic>?,
    );

Map<String, dynamic> _$AttachmentToJson(Attachment instance) =>
    <String, dynamic>{
      'recordId': instance.recordId,
      'guidId': instance.guidId,
      'name': instance.name,
      'extension': instance.extension,
      'entityType': instance.entityType,
      'type': instance.type,
      'rowNum': instance.rowNum,
      'attribute': instance.attribute,
      'infos': instance.infos,
    };
