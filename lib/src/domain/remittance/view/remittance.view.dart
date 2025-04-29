import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../widget/custom_appbar.widget.dart';
import '../controller/remittance.controller.dart';

class RemittanceView extends GetView<RemittanceController> {
   RemittanceView({super.key});
  final List<PlutoColumn> columns = <PlutoColumn>[
    PlutoColumn(
      title: 'ثبت کننده',
      field: 'register',
      type: PlutoColumnType.text(),
      backgroundColor: AppColor.textFieldColor,
    ),
    PlutoColumn(
      title: 'بدهکار',
      field: 'Reciept',
      type: PlutoColumnType.text(),
      backgroundColor: AppColor.textFieldColor,
    ),
    PlutoColumn(
      title: 'بستانکار',
      field: 'Payer',
      type: PlutoColumnType.text(),
      backgroundColor: AppColor.textFieldColor,
    ),
    PlutoColumn(
      title: 'محصول',
      field: 'Product',
      type: PlutoColumnType.text(),
      backgroundColor: AppColor.textFieldColor,
    ),
    PlutoColumn(
      title: 'مبلغ/مقدار',
      field: 'Total',
      type: PlutoColumnType.text(),
      backgroundColor: AppColor.textFieldColor,
    ),
    PlutoColumn(
      title: 'وضعیت',
      field: 'Status',
      backgroundColor: AppColor.textFieldColor,
      type: PlutoColumnType.select(<String>[
        'نامشخص',
        'تایید نشده',
        'تایید شده',
      ]),
    ),
    PlutoColumn(
      title: 'شرح',
      field: 'Description',
      type: PlutoColumnType.text(),
      backgroundColor: AppColor.textFieldColor,
    ),
    PlutoColumn(
      title: 'تاریخ ایجاد',
      field: 'DateTime',
      type: PlutoColumnType.date(),
      backgroundColor: AppColor.textFieldColor,
        renderer: (rendererContext) {
          return Text(
            textAlign: TextAlign.right,
            rendererContext.cell.value.toString(),
            style: const TextStyle(
                debugLabel: 'blackCupertino bodySmall',
                fontFamily: '.SF UI Text',
                color: AppColor.textColor
               ),
          );
        }

    ),
    // PlutoColumn(
    //   title: 'salary',
    //   field: 'salary',
    //   type: PlutoColumnType.currency(),
    //   footerRenderer: (rendererContext) {
    //     return PlutoAggregateColumnFooter(
    //       rendererContext: rendererContext,
    //       formatAsCurrency: true,
    //       type: PlutoAggregateColumnType.sum,
    //       format: '#,###',
    //       alignment: Alignment.center,
    //       titleSpanBuilder: (text) {
    //         return [
    //           const TextSpan(
    //             text: 'Sum',
    //             style: TextStyle(color: Colors.red),
    //           ),
    //           const TextSpan(text: ' : '),
    //           TextSpan(text: text),
    //         ];
    //       },
    //     );
    //   },
    // ),
  ];

  final List<PlutoRow> rows = [
    PlutoRow(
      cells: {
        'register': PlutoCell(value: 'جلیل نوری'),
        'Reciept': PlutoCell(value: 'پیمان تقی پور'),
        'Payer': PlutoCell(value: "محمود نصرالهی"),
        'Product': PlutoCell(value: 'طلای آب شده'),
        'Total': PlutoCell(value: "400 گرم"),
        'Status': PlutoCell(value: "تایید شده"),
        'Description': PlutoCell(value: "انتقال ار حساب ح به حساب ح داخلی"),
        'DateTime': PlutoCell(value: '2021-01-01'),
      },
    ),
  ];

  /// columnGroups that can group columns can be omitted.
  final List<PlutoColumnGroup> columnGroups = [
    PlutoColumnGroup(title: 'Id', fields: ['id'], expandedColumn: true),
    PlutoColumnGroup(title: 'User information', fields: ['name', 'age']),
    PlutoColumnGroup(title: 'Status', children: [
      PlutoColumnGroup(title: 'A', fields: ['role'], expandedColumn: true),
      PlutoColumnGroup(title: 'Etc.', fields: ['joined', 'working_time']),
    ]),
  ];
   late final PlutoGridStateManager stateManager;
  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    return Scaffold(
      appBar: CustomAppBar(
        title: 'لیست حواله', onBackTap: () => Get.back(),),
      body: SafeArea(
        child: SizedBox(
          child: Column(
            children: [
              //فیلد جستجو
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                height: 41,
                child: TextFormField(
                  controller: controller.searchController,
                  style: AppTextStyle.labelText,
                  textInputAction: TextInputAction.search,
                  onFieldSubmitted: (value) async {
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: AppColor.textFieldColor,
                    hintText: "جستجو ... ",
                    hintStyle: AppTextStyle.labelText,
                    prefixIcon: IconButton(
                        onPressed: () async {
                        },
                        icon: Icon(
                          Icons.search, color: AppColor.textColor,
                          size: 30,)
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(15),
                  color: AppColor.secondaryColor,

                  child: PlutoGrid(
                    rowColorCallback: (rowColorContext) {
                      return AppColor.textFieldColor;
                    },
                    columns: columns,
                    rows: rows,
                   // columnGroups: columnGroups,
                    onLoaded: (PlutoGridOnLoadedEvent event) {
                      stateManager = event.stateManager;
                      stateManager.setShowColumnFilter(true);
                    },
                    onChanged: (PlutoGridOnChangedEvent event) {
                      print(event);
                    },
                    configuration: const PlutoGridConfiguration(),
                  ),
                ),
              ),




            ],
          ),
        ),
      ),
    );
  }
}
