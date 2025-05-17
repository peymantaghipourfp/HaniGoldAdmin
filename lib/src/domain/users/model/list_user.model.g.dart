// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_user.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListUserModel _$ListUserModelFromJson(Map<String, dynamic> json) =>
    ListUserModel(
      accounts: (json['accounts'] as List<dynamic>?)
          ?.map((e) => AccountModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      paginated: json['paginated'] == null
          ? null
          : PaginatedModel.fromJson(json['paginated'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ListUserModelToJson(ListUserModel instance) =>
    <String, dynamic>{
      'accounts': instance.accounts,
      'paginated': instance.paginated,
    };
