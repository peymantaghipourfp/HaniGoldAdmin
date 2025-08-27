// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'all_balances.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AllBalancesModel _$AllBalancesModelFromJson(Map<String, dynamic> json) =>
    AllBalancesModel(
      balance: (json['balance'] as num?)?.toDouble(),
      itemName: json['itemName'] as String?,
      unitName: json['unitName'] as String?,
    );

Map<String, dynamic> _$AllBalancesModelToJson(AllBalancesModel instance) =>
    <String, dynamic>{
      'balance': instance.balance,
      'itemName': instance.itemName,
      'unitName': instance.unitName,
    };
