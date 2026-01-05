// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_admin_group.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserAdminGroupModel _$UserAdminGroupModelFromJson(Map<String, dynamic> json) =>
    UserAdminGroupModel(
      byAdmin: (json['byAdmin'] as num?)?.toInt(),
      byAdminName: json['byAdminName'] as String?,
      accountCountDistinct: (json['accountCountDistinct'] as num?)?.toInt(),
      orderCount: (json['orderCount'] as num?)?.toInt(),
      rejectedOrderCount: (json['rejectedOrderCount'] as num?)?.toInt(),
      buyCount: (json['buyCount'] as num?)?.toInt(),
      sellCount: (json['sellCount'] as num?)?.toInt(),
      totalBuyQuantity: (json['totalBuyQuantity'] as num?)?.toDouble(),
      totalSellQuantity: (json['totalSellQuantity'] as num?)?.toDouble(),
      minBuyQuantity: (json['minBuyQuantity'] as num?)?.toDouble(),
      maxBuyQuantity: (json['maxBuyQuantity'] as num?)?.toDouble(),
      minSellQuantity: (json['minSellQuantity'] as num?)?.toDouble(),
      maxSellQuantity: (json['maxSellQuantity'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$UserAdminGroupModelToJson(
        UserAdminGroupModel instance) =>
    <String, dynamic>{
      'byAdmin': instance.byAdmin,
      'byAdminName': instance.byAdminName,
      'accountCountDistinct': instance.accountCountDistinct,
      'orderCount': instance.orderCount,
      'rejectedOrderCount': instance.rejectedOrderCount,
      'buyCount': instance.buyCount,
      'sellCount': instance.sellCount,
      'totalBuyQuantity': instance.totalBuyQuantity,
      'totalSellQuantity': instance.totalSellQuantity,
      'minBuyQuantity': instance.minBuyQuantity,
      'maxBuyQuantity': instance.maxBuyQuantity,
      'minSellQuantity': instance.minSellQuantity,
      'maxSellQuantity': instance.maxSellQuantity,
    };
