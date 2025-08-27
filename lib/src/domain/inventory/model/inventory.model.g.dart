// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InventoryModel _$InventoryModelFromJson(Map<String, dynamic> json) =>
    InventoryModel(
      recordId: (json['recordId'] as num?)?.toInt(),
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      account: json['account'] == null
          ? null
          : AccountModel.fromJson(json['account'] as Map<String, dynamic>),
      item: json['item'] == null
          ? null
          : ItemModel.fromJson(json['item'] as Map<String, dynamic>),
      type: (json['type'] as num?)?.toInt(),
      isDeleted: json['isDeleted'] as bool?,
      inventoryDetails: (json['inventoryDetails'] as List<dynamic>?)
          ?.map((e) => InventoryDetailModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      rowNum: (json['rowNum'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      recId: json['recId'] as String?,
      infos: json['infos'] as List<dynamic>?,
      description: json['description'] as String?,
      inventoryDetailsCount: (json['inventoryDetailsCount'] as num?)?.toInt(),
      balances: (json['balances'] as List<dynamic>?)
          ?.map((e) => Balance.fromJson(e as Map<String, dynamic>))
          .toList(),
      registered: json['registered'] as bool?,
      confirmByAdmin: json['confirmByAdmin'] as bool?,
      recipient: json['recipient'] as String?,
      totalQuantity: (json['totalQuantity'] as num?)?.toDouble(),
      createdBy: json['createdBy'] == null
          ? null
          : CreatedByModel.fromJson(json['createdBy'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$InventoryModelToJson(InventoryModel instance) =>
    <String, dynamic>{
      'recordId': instance.recordId,
      'date': instance.date?.toIso8601String(),
      'account': instance.account,
      'item': instance.item,
      'type': instance.type,
      'isDeleted': instance.isDeleted,
      'inventoryDetails': instance.inventoryDetails,
      'rowNum': instance.rowNum,
      'id': instance.id,
      'recId': instance.recId,
      'infos': instance.infos,
      'description': instance.description,
      'inventoryDetailsCount': instance.inventoryDetailsCount,
      'balances': instance.balances,
      'registered': instance.registered,
      'confirmByAdmin': instance.confirmByAdmin,
      'recipient': instance.recipient,
      'totalQuantity': instance.totalQuantity,
      'createdBy': instance.createdBy,
    };

Balance _$BalanceFromJson(Map<String, dynamic> json) => Balance(
      balance: (json['balance'] as num?)?.toDouble(),
      itemName: json['itemName'] as String?,
      unitName: json['unitName'] as String?,
    );

Map<String, dynamic> _$BalanceToJson(Balance instance) => <String, dynamic>{
      'balance': instance.balance,
      'itemName': instance.itemName,
      'unitName': instance.unitName,
    };
