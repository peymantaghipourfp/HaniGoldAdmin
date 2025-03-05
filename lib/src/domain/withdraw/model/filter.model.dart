
class FilterModel {
  final String? fieldName;
  final String? filterValue;
  final int? filterType;
  final String? refTable;

  FilterModel({
    required this.fieldName,
    required this.filterValue,
    required this.filterType,
    required this.refTable,
  });

  factory FilterModel.fromJson(Map<String, dynamic> json) => FilterModel(
    fieldName: json["fieldName"],
    filterValue: json["filterValue"],
    filterType: json["filterType"],
    refTable: json["RefTable"],
  );

  Map<String, dynamic> toJson() => {
    "fieldName": fieldName,
    "filterValue": filterValue,
    "filterType": filterType,
    "RefTable": refTable,
  };
}