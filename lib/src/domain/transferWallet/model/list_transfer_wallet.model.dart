import 'package:hanigold_admin/src/domain/transferWallet/model/transfer_wallet.model.dart';
import 'package:hanigold_admin/src/domain/users/model/paginated.model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'list_transfer_wallet.model.g.dart';

ListTransferWalletModel listTransferWalletModelFromJson(String str) => ListTransferWalletModel.fromJson(json.decode(str));

String listTransferWalletModelToJson(ListTransferWalletModel data) => json.encode(data.toJson());

@JsonSerializable()
class ListTransferWalletModel {
  @JsonKey(name: "transferWallets")
  final List<TransferWalletModel>? transferWallets;
  @JsonKey(name: "paginated")
  final PaginatedModel? paginated;

  ListTransferWalletModel({
    required this.transferWallets,
    required this.paginated,
  });

  factory ListTransferWalletModel.fromJson(Map<String, dynamic> json) => _$ListTransferWalletModelFromJson(json);

  Map<String, dynamic> toJson() => _$ListTransferWalletModelToJson(this);
}