// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_history.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatHistoryModel _$ChatHistoryModelFromJson(Map<String, dynamic> json) =>
    ChatHistoryModel(
      chatId: json['chatId'] as String?,
      customerAccountId: (json['customerAccountId'] as num?)?.toInt(),
      customerAccountName: json['customerAccountName'] as String?,
      topicId: (json['topicId'] as num?)?.toInt(),
      topicCode: json['topicCode'] as String?,
      topicTitle: json['topicTitle'] as String?,
      topicKey: json['topicKey'] as String?,
      status: (json['status'] as num?)?.toInt(),
      currentOwnerAdminAccountId:
          (json['currentOwnerAdminAccountId'] as num?)?.toInt(),
      currentOwnerAdminUserId:
          (json['currentOwnerAdminUserId'] as num?)?.toInt(),
      currentOwnerAdminName: json['currentOwnerAdminName'] as String?,
      createdOn: json['createdOn'] == null
          ? null
          : DateTime.parse(json['createdOn'] as String),
      lastActivity: json['lastActivity'] == null
          ? null
          : DateTime.parse(json['lastActivity'] as String),
      closedOn: json['closedOn'] == null
          ? null
          : DateTime.parse(json['closedOn'] as String),
      firstPicker: json['firstPicker'] == null
          ? null
          : ClosedBy.fromJson(json['firstPicker'] as Map<String, dynamic>),
      closedBy: json['closedBy'] == null
          ? null
          : ClosedBy.fromJson(json['closedBy'] as Map<String, dynamic>),
      forwards: (json['forwards'] as List<dynamic>?)
          ?.map((e) => Forward.fromJson(e as Map<String, dynamic>))
          .toList(),
      viewers: (json['viewers'] as List<dynamic>?)
          ?.map((e) => Viewer.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ChatHistoryModelToJson(ChatHistoryModel instance) =>
    <String, dynamic>{
      'chatId': instance.chatId,
      'customerAccountId': instance.customerAccountId,
      'customerAccountName': instance.customerAccountName,
      'topicId': instance.topicId,
      'topicCode': instance.topicCode,
      'topicTitle': instance.topicTitle,
      'topicKey': instance.topicKey,
      'status': instance.status,
      'currentOwnerAdminAccountId': instance.currentOwnerAdminAccountId,
      'currentOwnerAdminUserId': instance.currentOwnerAdminUserId,
      'currentOwnerAdminName': instance.currentOwnerAdminName,
      'createdOn': instance.createdOn?.toIso8601String(),
      'lastActivity': instance.lastActivity?.toIso8601String(),
      'closedOn': instance.closedOn?.toIso8601String(),
      'firstPicker': instance.firstPicker,
      'closedBy': instance.closedBy,
      'forwards': instance.forwards,
      'viewers': instance.viewers,
    };

ClosedBy _$ClosedByFromJson(Map<String, dynamic> json) => ClosedBy(
      adminAccountId: (json['adminAccountId'] as num?)?.toInt(),
      adminUserId: (json['adminUserId'] as num?)?.toInt(),
      adminName: json['adminName'] as String?,
      on: json['on'] == null ? null : DateTime.parse(json['on'] as String),
      note: json['note'] as String?,
    );

Map<String, dynamic> _$ClosedByToJson(ClosedBy instance) => <String, dynamic>{
      'adminAccountId': instance.adminAccountId,
      'adminUserId': instance.adminUserId,
      'adminName': instance.adminName,
      'on': instance.on?.toIso8601String(),
      'note': instance.note,
    };

Forward _$ForwardFromJson(Map<String, dynamic> json) => Forward(
      seq: (json['seq'] as num?)?.toInt(),
      fromAdminAccountId: (json['fromAdminAccountId'] as num?)?.toInt(),
      fromAdminUserId: (json['fromAdminUserId'] as num?)?.toInt(),
      fromAdminName: json['fromAdminName'] as String?,
      toAdminAccountId: (json['toAdminAccountId'] as num?)?.toInt(),
      toAdminUserId: (json['toAdminUserId'] as num?)?.toInt(),
      toAdminName: json['toAdminName'] as String?,
      messageSeq: (json['messageSeq'] as num?)?.toInt(),
      note: json['note'] as String?,
      on: json['on'] == null ? null : DateTime.parse(json['on'] as String),
    );

Map<String, dynamic> _$ForwardToJson(Forward instance) => <String, dynamic>{
      'seq': instance.seq,
      'fromAdminAccountId': instance.fromAdminAccountId,
      'fromAdminUserId': instance.fromAdminUserId,
      'fromAdminName': instance.fromAdminName,
      'toAdminAccountId': instance.toAdminAccountId,
      'toAdminUserId': instance.toAdminUserId,
      'toAdminName': instance.toAdminName,
      'messageSeq': instance.messageSeq,
      'note': instance.note,
      'on': instance.on?.toIso8601String(),
    };

Viewer _$ViewerFromJson(Map<String, dynamic> json) => Viewer(
      adminAccountId: (json['adminAccountId'] as num?)?.toInt(),
      adminUserId: (json['adminUserId'] as num?)?.toInt(),
      adminName: json['adminName'] as String?,
      currentRole: (json['currentRole'] as num?)?.toInt(),
      currentRoleTitle: json['currentRoleTitle'] as String?,
      hasCurrentAccess: json['hasCurrentAccess'] as bool?,
      grantedOn: json['grantedOn'] as String?,
      grantedByAdminAccountId:
          (json['grantedByAdminAccountId'] as num?)?.toInt(),
      grantedByAdminUserId: (json['grantedByAdminUserId'] as num?)?.toInt(),
      grantedByAdminName: json['grantedByAdminName'] as String?,
      note: json['note'] as String?,
    );

Map<String, dynamic> _$ViewerToJson(Viewer instance) => <String, dynamic>{
      'adminAccountId': instance.adminAccountId,
      'adminUserId': instance.adminUserId,
      'adminName': instance.adminName,
      'currentRole': instance.currentRole,
      'currentRoleTitle': instance.currentRoleTitle,
      'hasCurrentAccess': instance.hasCurrentAccess,
      'grantedOn': instance.grantedOn,
      'grantedByAdminAccountId': instance.grantedByAdminAccountId,
      'grantedByAdminUserId': instance.grantedByAdminUserId,
      'grantedByAdminName': instance.grantedByAdminName,
      'note': instance.note,
    };
