import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'candle_price_chart.model.g.dart';

List<CandlePriceChartModel> candlePriceChartModelFromJson(String str) => List<CandlePriceChartModel>.from(json.decode(str).map((x) => CandlePriceChartModel.fromJson(x)));

String candlePriceChartModelToJson(List<CandlePriceChartModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class CandlePriceChartModel {
  @JsonKey(name: "candleTime")
  final String? candleTime;
  @JsonKey(name: "endTime")
  final String? endTime;
  @JsonKey(name: "openPrice")
  final int? openPrice;
  @JsonKey(name: "closePrice")
  final int? closePrice;
  @JsonKey(name: "highPrice")
  final int? highPrice;
  @JsonKey(name: "lowPrice")
  final int? lowPrice;
  @JsonKey(name: "volume")
  final double? volume;

  CandlePriceChartModel({
    required this.candleTime,
    required this.endTime,
    required this.openPrice,
    required this.closePrice,
    required this.highPrice,
    required this.lowPrice,
    required this.volume,
  });

  factory CandlePriceChartModel.fromJson(Map<String, dynamic> json) => _$CandlePriceChartModelFromJson(json);

  Map<String, dynamic> toJson() => _$CandlePriceChartModelToJson(this);
}