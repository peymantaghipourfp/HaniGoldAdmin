// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_price.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemPriceModel _$ItemPriceModelFromJson(Map<String, dynamic> json) =>
    ItemPriceModel(
      itemId: (json['itemId'] as num).toInt(),
      price: (json['price'] as num).toDouble(),
      differentPrice: (json['differentPrice'] as num).toDouble(),
      rowNum: (json['rowNum'] as num).toInt(),
      id: (json['id'] as num).toInt(),
      attribute: $enumDecode(_$ItemModelAttributeEnumMap, json['attribute']),
      recId: json['recId'] as String,
      infos: json['infos'] as List<dynamic>,
    );

Map<String, dynamic> _$ItemPriceModelToJson(ItemPriceModel instance) =>
    <String, dynamic>{
      'itemId': instance.itemId,
      'price': instance.price,
      'differentPrice': instance.differentPrice,
      'rowNum': instance.rowNum,
      'id': instance.id,
      'attribute': _$ItemModelAttributeEnumMap[instance.attribute]!,
      'recId': instance.recId,
      'infos': instance.infos,
    };

const _$ItemModelAttributeEnumMap = {
  ItemModelAttribute.SYS: 'sys',
};
