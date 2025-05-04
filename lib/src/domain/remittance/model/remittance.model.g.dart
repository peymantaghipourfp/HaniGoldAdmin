// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remittance.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RemittanceModel _$RemittanceModelFromJson(Map<String, dynamic> json) =>
    RemittanceModel(
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      walletPayer: json['walletPayer'] == null
          ? null
          : WalletModel.fromJson(json['walletPayer'] as Map<String, dynamic>),
      walletReciept: json['walletReciept'] == null
          ? null
          : WalletModel.fromJson(json['walletReciept'] as Map<String, dynamic>),
      item: json['item'] == null
          ? null
          : ItemModel.fromJson(json['item'] as Map<String, dynamic>),
      quantity: (json['quantity'] as num?)?.toInt(),
      status: (json['status'] as num?)?.toInt(),
      isDeleted: json['isDeleted'] as bool?,
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => Attachment.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdBy: json['createdBy'] == null
          ? null
          : UserModel.fromJson(json['createdBy'] as Map<String, dynamic>),
      id: (json['id'] as num?)?.toInt(),
      attribute: json['attribute'] as String?,
      balancePayer: json['balancePayer'] as String?,
      balanceReciept: json['balanceReciept'] as String?,
      description: json['description'] as String?,
      recId: json['recId'] as String?,
      infos: json['infos'] as List<dynamic>?,
    );

Map<String, dynamic> _$RemittanceModelToJson(RemittanceModel instance) =>
    <String, dynamic>{
      'date': instance.date?.toIso8601String(),
      'walletPayer': instance.walletPayer,
      'walletReciept': instance.walletReciept,
      'item': instance.item,
      'createdBy': instance.createdBy,
      'quantity': instance.quantity,
      'status': instance.status,
      'isDeleted': instance.isDeleted,
      'attachments': instance.attachments,
      'id': instance.id,
      'attribute': instance.attribute,
      'balancePayer': instance.balancePayer,
      'balanceReciept': instance.balanceReciept,
      'description': instance.description,
      'recId': instance.recId,
      'infos': instance.infos,
    };
