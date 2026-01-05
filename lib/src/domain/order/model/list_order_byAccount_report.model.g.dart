// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_order_byAccount_report.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListOrderByAccountReportModel _$ListOrderByAccountReportModelFromJson(
        Map<String, dynamic> json) =>
    ListOrderByAccountReportModel(
      balanceDayOrderAccounts:
          (json['balanceDayOrderAccounts'] as List<dynamic>)
              .map((e) =>
                  OrderByAccountReportModel.fromJson(e as Map<String, dynamic>))
              .toList(),
      paginated:
          PaginatedModel.fromJson(json['paginated'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ListOrderByAccountReportModelToJson(
        ListOrderByAccountReportModel instance) =>
    <String, dynamic>{
      'balanceDayOrderAccounts': instance.balanceDayOrderAccounts,
      'paginated': instance.paginated,
    };
