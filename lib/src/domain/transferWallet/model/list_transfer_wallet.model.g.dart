// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_transfer_wallet.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListTransferWalletModel _$ListTransferWalletModelFromJson(
        Map<String, dynamic> json) =>
    ListTransferWalletModel(
      transferWallets: (json['transferWallets'] as List<dynamic>?)
          ?.map((e) => TransferWalletModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      paginated: json['paginated'] == null
          ? null
          : PaginatedModel.fromJson(json['paginated'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ListTransferWalletModelToJson(
        ListTransferWalletModel instance) =>
    <String, dynamic>{
      'transferWallets': instance.transferWallets,
      'paginated': instance.paginated,
    };
