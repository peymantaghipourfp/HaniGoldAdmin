// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_price_group.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountPriceGroupModel _$AccountPriceGroupModelFromJson(
        Map<String, dynamic> json) =>
    AccountPriceGroupModel(
      name: $enumDecode(_$NameEnumMap, json['name']),
      rowNum: (json['rowNum'] as num).toInt(),
      id: (json['id'] as num).toInt(),
      attribute: $enumDecode(_$AccountModelAttributeEnumMap, json['attribute']),
      recId: json['recId'] as String,
      infos: json['infos'] as List<dynamic>,
    );

Map<String, dynamic> _$AccountPriceGroupModelToJson(
        AccountPriceGroupModel instance) =>
    <String, dynamic>{
      'name': _$NameEnumMap[instance.name]!,
      'rowNum': instance.rowNum,
      'id': instance.id,
      'attribute': _$AccountModelAttributeEnumMap[instance.attribute]!,
      'recId': instance.recId,
      'infos': instance.infos,
    };

const _$NameEnumMap = {
  Name.EMPTY: 'گروه ویژه',
  Name.FLUFFY: 'سکه',
  Name.NAME: 'گروه قیمت اول',
  Name.PURPLE: 'طلا',
  Name.STICKY: 'ارز',
  Name.TENTACLED: 'ریال',
  Name.THE_1: 'گروه 1    ',
  Name.THE_2: 'گروه 2    ',
};

const _$AccountModelAttributeEnumMap = {
  AccountModelAttribute.CUS: 'cus',
};
