// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'header_info_user_transaction.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HeaderInfoUserTransactionModel _$HeaderInfoUserTransactionModelFromJson(
        Map<String, dynamic> json) =>
    HeaderInfoUserTransactionModel(
      accountName: json['accountName'] as String?,
      accountGroup: json['accountGroup'] as String?,
      tell: json['tell'] as String?,
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      deposit: json['deposit'] as String?,
      address: json['address'] as String?,
      orders: (json['orders'] as List<dynamic>?)
          ?.map((e) => TransactionItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      inventorys: (json['inventorys'] as List<dynamic>?)
          ?.map((e) => TransactionItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      withdraws: (json['withdraws'] as List<dynamic>?)
          ?.map((e) => TransactionItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      remmitances: (json['remmitances'] as List<dynamic>?)
          ?.map((e) => TransactionItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$HeaderInfoUserTransactionModelToJson(
        HeaderInfoUserTransactionModel instance) =>
    <String, dynamic>{
      'accountName': instance.accountName,
      'accountGroup': instance.accountGroup,
      'tell': instance.tell,
      'startDate': instance.startDate?.toIso8601String(),
      'deposit': instance.deposit,
      'address': instance.address,
      'orders': instance.orders,
      'inventorys': instance.inventorys,
      'withdraws': instance.withdraws,
      'remmitances': instance.remmitances,
    };
