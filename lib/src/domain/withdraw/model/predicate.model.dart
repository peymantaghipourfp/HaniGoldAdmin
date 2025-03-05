
import 'package:hanigold_admin/src/domain/withdraw/model/filter.model.dart';

class PredicateModel {
  final int? innerCondition;
  final int? outerCondition;
  final List<FilterModel>? filters;

  PredicateModel({
    required this.innerCondition,
    required this.outerCondition,
    required this.filters,
  });

  factory PredicateModel.fromJson(Map<String, dynamic> json) => PredicateModel(
    innerCondition: json["innerCondition"],
    outerCondition: json["outerCondition"],
    filters: List<FilterModel>.from(json["filters"].map((x) => FilterModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "innerCondition": innerCondition,
    "outerCondition": outerCondition,
    "filters": List<dynamic>.from(filters!.map((x) => x.toJson())),
  };
}