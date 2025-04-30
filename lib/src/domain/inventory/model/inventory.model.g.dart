// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InventoryModel _$InventoryModelFromJson(Map<String, dynamic> json) =>
    InventoryModel(
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      account: json['account'] == null
          ? null
          : AccountModel.fromJson(json['account'] as Map<String, dynamic>),
      type: (json['type'] as num?)?.toInt(),
      isDeleted: json['isDeleted'] as bool?,
      inventoryDetails: (json['inventoryDetails'] as List<dynamic>?)
          ?.map((e) => InventoryDetailModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      rowNum: (json['rowNum'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      attribute: json['attribute'] as String?,
      createdOn: json['createdOn'] == null
          ? null
          : DateTime.parse(json['createdOn'] as String),
      modifiedOn: json['modifiedOn'] == null
          ? null
          : DateTime.parse(json['modifiedOn'] as String),
      recId: json['recId'] as String?,
      infos: json['infos'] as List<dynamic>?,
      description: json['description'] as String?,
      inventoryDetailsCount: (json['inventoryDetailsCount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$InventoryModelToJson(InventoryModel instance) =>
    <String, dynamic>{
      'date': instance.date?.toIso8601String(),
      'account': instance.account,
      'type': instance.type,
      'isDeleted': instance.isDeleted,
      'inventoryDetails': instance.inventoryDetails,
      'rowNum': instance.rowNum,
      'id': instance.id,
      'attribute': instance.attribute,
      'createdOn': instance.createdOn?.toIso8601String(),
      'modifiedOn': instance.modifiedOn?.toIso8601String(),
      'recId': instance.recId,
      'infos': instance.infos,
      'description': instance.description,
      'inventoryDetailsCount': instance.inventoryDetailsCount,
    };
