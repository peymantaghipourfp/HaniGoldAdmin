import 'package:hanigold_admin/src/domain/withdraw/model/predicate.model.dart';

class BankAccountOptionsModel {
  final List<PredicateModel>? predicate;
  final String? orderBy;
  final String? orderByType;
  final int? startIndex;
  final int? toIndex;

  BankAccountOptionsModel({
    required this.predicate,
    required this.orderBy,
    required this.orderByType,
    required this.startIndex,
    required this.toIndex,
  });

  factory BankAccountOptionsModel.fromJson(Map<String, dynamic> json) => BankAccountOptionsModel(
    predicate: List<PredicateModel>.from(json["Predicate"].map((x) => PredicateModel.fromJson(x))),
    orderBy: json["orderBy"],
    orderByType: json["orderByType"],
    startIndex: json["StartIndex"],
    toIndex: json["ToIndex"],
  );

  Map<String, dynamic> toJson() => {
    "Predicate": List<dynamic>.from(predicate!.map((x) => x.toJson())),
    "orderBy": orderBy,
    "orderByType": orderByType,
    "StartIndex": startIndex,
    "ToIndex": toIndex,
  };
}