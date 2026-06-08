// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_admin.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountAdminModel _$AccountAdminModelFromJson(Map<String, dynamic> json) =>
    AccountAdminModel(
      topicCode: json['topicCode'] as String?,
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => Item.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AccountAdminModelToJson(AccountAdminModel instance) =>
    <String, dynamic>{
      'topicCode': instance.topicCode,
      'items': instance.items,
    };

Item _$ItemFromJson(Map<String, dynamic> json) => Item(
      accountId: (json['accountId'] as num?)?.toInt(),
      userId: (json['userId'] as num?)?.toInt(),
      name: json['name'] as String?,
    );

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      'accountId': instance.accountId,
      'userId': instance.userId,
      'name': instance.name,
    };
