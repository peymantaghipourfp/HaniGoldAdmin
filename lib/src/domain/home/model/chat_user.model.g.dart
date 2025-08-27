// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_user.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatUserModel _$ChatUserModelFromJson(Map<String, dynamic> json) =>
    ChatUserModel(
      lastMessageDate: json['lastMessageDate'] == null
          ? null
          : DateTime.parse(json['lastMessageDate'] as String),
      chatUserId: (json['chatUserId'] as num?)?.toInt(),
      chatUserName: json['chatUserName'] as String?,
      unseenCount: (json['unseenCount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ChatUserModelToJson(ChatUserModel instance) =>
    <String, dynamic>{
      'lastMessageDate': instance.lastMessageDate?.toIso8601String(),
      'chatUserId': instance.chatUserId,
      'chatUserName': instance.chatUserName,
      'unseenCount': instance.unseenCount,
    };
