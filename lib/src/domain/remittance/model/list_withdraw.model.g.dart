// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_withdraw.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListWithdrawModel _$ListWithdrawModelFromJson(Map<String, dynamic> json) =>
    ListWithdrawModel(
      withdrawRequests: (json['withdrawRequests'] as List<dynamic>?)
          ?.map((e) => WithdrawModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      paginated: json['paginated'] == null
          ? null
          : PaginatedModel.fromJson(json['paginated'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ListWithdrawModelToJson(ListWithdrawModel instance) =>
    <String, dynamic>{
      'withdrawRequests': instance.withdrawRequests,
      'paginated': instance.paginated,
    };
