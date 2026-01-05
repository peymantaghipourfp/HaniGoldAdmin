// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'candle_price_chart.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CandlePriceChartModel _$CandlePriceChartModelFromJson(
        Map<String, dynamic> json) =>
    CandlePriceChartModel(
      candleTime: json['candleTime'] as String?,
      endTime: json['endTime'] as String?,
      openPrice: (json['openPrice'] as num?)?.toInt(),
      closePrice: (json['closePrice'] as num?)?.toInt(),
      highPrice: (json['highPrice'] as num?)?.toInt(),
      lowPrice: (json['lowPrice'] as num?)?.toInt(),
      volume: (json['volume'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$CandlePriceChartModelToJson(
        CandlePriceChartModel instance) =>
    <String, dynamic>{
      'candleTime': instance.candleTime,
      'endTime': instance.endTime,
      'openPrice': instance.openPrice,
      'closePrice': instance.closePrice,
      'highPrice': instance.highPrice,
      'lowPrice': instance.lowPrice,
      'volume': instance.volume,
    };
