// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_report_gold.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionReportGoldModel _$TransactionReportGoldModelFromJson(
        Map<String, dynamic> json) =>
    TransactionReportGoldModel(
      recordId: (json['recordId'] as num?)?.toInt(),
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      item: json['item'] == null
          ? null
          : ItemModel.fromJson(json['item'] as Map<String, dynamic>),
      account: json['account'] == null
          ? null
          : AccountModel.fromJson(json['account'] as Map<String, dynamic>),
      amount: (json['amount'] as num?)?.toDouble(),
      goldTotalRunning: (json['goldTotalRunning'] as num?)?.toDouble(),
      coinTotalRunning: (json['coinTotalRunning'] as num?)?.toDouble(),
      halfCoinTotalRunning: (json['halfCoinTotalRunning'] as num?)?.toDouble(),
      quarterCoinTotalRunning:
          (json['quarterCoinTotalRunning'] as num?)?.toDouble(),
      cashTotalRunning: (json['cashTotalRunning'] as num?)?.toDouble(),
      toAccount:
          AccountModel.fromJson(json['toAccount'] as Map<String, dynamic>),
      price: (json['price'] as num?)?.toDouble(),
      totalPrice: (json['totalPrice'] as num?)?.toDouble(),
      mesghalPrice: (json['mesghalPrice'] as num?)?.toDouble(),
      type: json['type'] as String?,
      isCard: json['isCard'] as bool?,
      accountChecked: json['accountChecked'] as bool?,
      checked: json['checked'] as bool?,
      detail: json['detail'] == null
          ? null
          : DetailGoldModel.fromJson(json['detail'] as Map<String, dynamic>),
      rowNum: (json['rowNum'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      recId: json['recId'] as String?,
      infos: json['infos'] as List<dynamic>?,
      parentId: (json['parentId'] as num?)?.toInt(),
      description: json['description'] as String?,
      trackingNumber: json['trackingNumber'] as String?,
    );

Map<String, dynamic> _$TransactionReportGoldModelToJson(
        TransactionReportGoldModel instance) =>
    <String, dynamic>{
      'recordId': instance.recordId,
      'date': instance.date?.toIso8601String(),
      'item': instance.item,
      'account': instance.account,
      'amount': instance.amount,
      'goldTotalRunning': instance.goldTotalRunning,
      'coinTotalRunning': instance.coinTotalRunning,
      'halfCoinTotalRunning': instance.halfCoinTotalRunning,
      'quarterCoinTotalRunning': instance.quarterCoinTotalRunning,
      'cashTotalRunning': instance.cashTotalRunning,
      'toAccount': instance.toAccount,
      'price': instance.price,
      'totalPrice': instance.totalPrice,
      'mesghalPrice': instance.mesghalPrice,
      'type': instance.type,
      'isCard': instance.isCard,
      'accountChecked': instance.accountChecked,
      'checked': instance.checked,
      'detail': instance.detail,
      'rowNum': instance.rowNum,
      'id': instance.id,
      'recId': instance.recId,
      'infos': instance.infos,
      'parentId': instance.parentId,
      'description': instance.description,
      'trackingNumber': instance.trackingNumber,
    };
