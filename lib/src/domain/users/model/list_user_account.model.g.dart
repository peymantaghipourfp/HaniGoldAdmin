// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_user_account.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListUserAccountModel _$ListUserAccountModelFromJson(
        Map<String, dynamic> json) =>
    ListUserAccountModel(
      users: (json['users'] as List<dynamic>?)
          ?.map((e) => ItemUserModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      paginated: json['paginated'] == null
          ? null
          : PaginatedModel.fromJson(json['paginated'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ListUserAccountModelToJson(
        ListUserAccountModel instance) =>
    <String, dynamic>{
      'users': instance.users,
      'paginated': instance.paginated,
    };
