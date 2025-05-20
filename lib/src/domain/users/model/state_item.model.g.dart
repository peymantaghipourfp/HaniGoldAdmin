// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state_item.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StateItemModel _$StateItemModelFromJson(Map<String, dynamic> json) =>
    StateItemModel(
      country: json['country'] == null
          ? null
          : Country.fromJson(json['country'] as Map<String, dynamic>),
      name: json['name'] as String?,
      preTell: json['preTell'] as String?,
      rowNum: (json['rowNum'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      attribute: json['attribute'] as String?,
      recId: json['recId'] as String?,
      infos: json['infos'] as List<dynamic>?,
    );

Map<String, dynamic> _$StateItemModelToJson(StateItemModel instance) =>
    <String, dynamic>{
      'country': instance.country,
      'name': instance.name,
      'preTell': instance.preTell,
      'rowNum': instance.rowNum,
      'id': instance.id,
      'attribute': instance.attribute,
      'recId': instance.recId,
      'infos': instance.infos,
    };

Country _$CountryFromJson(Map<String, dynamic> json) => Country(
      name: json['name'] as String?,
      id: (json['id'] as num?)?.toInt(),
      infos: json['infos'] as List<dynamic>?,
    );

Map<String, dynamic> _$CountryToJson(Country instance) => <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'infos': instance.infos,
    };
