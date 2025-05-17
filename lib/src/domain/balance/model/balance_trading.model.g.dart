// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'balance_trading.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BalanceTradingModel _$BalanceTradingModelFromJson(Map<String, dynamic> json) =>
    BalanceTradingModel(
      itemGroup: json['itemGroup'] as String?,
      dateName: json['dateName'] as String?,
      balances: (json['balances'] as List<dynamic>?)
          ?.map((e) =>
              BalanceTradingItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BalanceTradingModelToJson(
        BalanceTradingModel instance) =>
    <String, dynamic>{
      'itemGroup': instance.itemGroup,
      'dateName': instance.dateName,
      'balances': instance.balances,
    };
