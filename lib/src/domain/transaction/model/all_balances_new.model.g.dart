// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'all_balances_new.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AllBalancesNewModel _$AllBalancesNewModelFromJson(Map<String, dynamic> json) =>
    AllBalancesNewModel(
      totalValue: (json['totalValue'] as num?)?.toDouble(),
      balances: (json['balances'] as List<dynamic>?)
          ?.map((e) => BalanceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AllBalancesNewModelToJson(
        AllBalancesNewModel instance) =>
    <String, dynamic>{
      'totalValue': instance.totalValue,
      'balances': instance.balances,
    };

BalanceModel _$BalanceModelFromJson(Map<String, dynamic> json) => BalanceModel(
      balance: (json['balance'] as num?)?.toDouble(),
      itemName: json['itemName'] as String?,
      unitName: json['unitName'] as String?,
    );

Map<String, dynamic> _$BalanceModelToJson(BalanceModel instance) =>
    <String, dynamic>{
      'balance': instance.balance,
      'itemName': instance.itemName,
      'unitName': instance.unitName,
    };
