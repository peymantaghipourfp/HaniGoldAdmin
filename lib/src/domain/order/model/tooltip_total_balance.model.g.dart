// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tooltip_total_balance.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TooltipTotalBalanceModel _$TooltipTotalBalanceModelFromJson(
        Map<String, dynamic> json) =>
    TooltipTotalBalanceModel(
      account: json['account'] == null
          ? null
          : AccountModel.fromJson(json['account'] as Map<String, dynamic>),
      currencyValue: (json['currencyValue'] as num?)?.toDouble(),
      goldValue: (json['goldValue'] as num?)?.toDouble(),
      coinValue: (json['coinValue'] as num?)?.toDouble(),
      balances: (json['balances'] as List<dynamic>?)
          ?.map((e) => BalanceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TooltipTotalBalanceModelToJson(
        TooltipTotalBalanceModel instance) =>
    <String, dynamic>{
      'account': instance.account,
      'currencyValue': instance.currencyValue,
      'goldValue': instance.goldValue,
      'coinValue': instance.coinValue,
      'balances': instance.balances,
    };
