// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_sub_group.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountSubGroupModel _$AccountSubGroupModelFromJson(
        Map<String, dynamic> json) =>
    AccountSubGroupModel(
      account: json['account'] == null
          ? null
          : AccountModel.fromJson(json['account'] as Map<String, dynamic>),
      name: json['name'] as String?,
      deposit: (json['deposit'] as num?)?.toDouble(),
      balance: (json['balance'] as num?)?.toDouble(),
      chiledrenCount: (json['chiledrenCount'] as num?)?.toInt(),
      color: json['color'] as String?,
      itemPrices: (json['itemPrices'] as List<dynamic>?)
          ?.map((e) => ItemPriceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      id: (json['id'] as num?)?.toInt(),
      infos: json['infos'] as List<dynamic>?,
    );

Map<String, dynamic> _$AccountSubGroupModelToJson(
        AccountSubGroupModel instance) =>
    <String, dynamic>{
      'account': instance.account,
      'name': instance.name,
      'deposit': instance.deposit,
      'balance': instance.balance,
      'chiledrenCount': instance.chiledrenCount,
      'color': instance.color,
      'itemPrices': instance.itemPrices,
      'id': instance.id,
      'infos': instance.infos,
    };
