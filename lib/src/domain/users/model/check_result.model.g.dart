// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_result.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckResultModel _$CheckResultModelFromJson(Map<String, dynamic> json) =>
    CheckResultModel(
      type: json['type'] as String?,
      recordId: (json['recordId'] as num?)?.toInt(),
      similarCount: (json['similarCount'] as num?)?.toInt(),
      countCheck: json['countCheck'] as bool?,
      status: (json['status'] as num?)?.toInt(),
      isDeleted: json['isDeleted'] as bool?,
      sourceTable: json['sourceTable'] as String?,
      hasParent: json['hasParent'] as bool?,
      transactions: (json['transactions'] as List<dynamic>?)
          ?.map((e) =>
              TransactionInfoItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CheckResultModelToJson(CheckResultModel instance) =>
    <String, dynamic>{
      'type': instance.type,
      'recordId': instance.recordId,
      'similarCount': instance.similarCount,
      'countCheck': instance.countCheck,
      'status': instance.status,
      'isDeleted': instance.isDeleted,
      'sourceTable': instance.sourceTable,
      'hasParent': instance.hasParent,
      'transactions': instance.transactions,
    };
