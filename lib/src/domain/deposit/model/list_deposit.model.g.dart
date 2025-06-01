// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_deposit.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListDepositModel _$ListDepositModelFromJson(Map<String, dynamic> json) =>
    ListDepositModel(
      deposit: (json['deposits'] as List<dynamic>?)
          ?.map((e) => DepositModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      paginated: json['paginated'] == null
          ? null
          : PaginatedModel.fromJson(json['paginated'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ListDepositModelToJson(ListDepositModel instance) =>
    <String, dynamic>{
      'deposits': instance.deposit,
      'paginated': instance.paginated,
    };
