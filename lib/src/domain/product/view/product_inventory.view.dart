import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/product/controller/product_inventory.controller.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../widget/app_drawer.widget.dart';
import '../../../widget/background_image_total.widget.dart';
import '../../../widget/custom_appbar1.widget.dart';
import '../../../widget/err_page.dart';
import '../../../widget/pager_widget.dart';
import '../../home/widget/chat_dialog.widget.dart';
import '../model/product_inventory_detail.model.dart';

class ProductInventoryView extends GetView<ProductInventoryController> {
  const ProductInventoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    return Obx(() => Scaffold(
      appBar: CustomAppbar1(
        title: 'گردش موجودی محصولات',
        onBackTap: () => Get.toNamed("/home"),
      ),
      drawer: const AppDrawer(),
      body: Stack(
        children: [
          BackgroundImageTotal(),
          SafeArea(
            child: controller.state.value == PageState.loading
                ? Center(
              child: SizedBox(
                  height: Get.height,
                  width: Get.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: 50,
                          width: 50,
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: CircularProgressIndicator(),
                          )),
                    ],
                  )),
            )
                : controller.state.value == PageState.list
                ? SizedBox(
              height: Get.height * 0.85,
              width: Get.width,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Filter button
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      color: AppColor.appBarColor.withOpacity(0.5),
                      alignment: Alignment.center,
                      height: 50,
                      child: Row(
                        children: [
                          /*ElevatedButton(
                            style: ButtonStyle(
                                padding: WidgetStatePropertyAll(
                                    EdgeInsets.symmetric(horizontal: 23, vertical: 19)),
                                backgroundColor: WidgetStatePropertyAll(
                                    AppColor.appBarColor.withOpacity(0.5)),
                                shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                                    side: BorderSide(color: AppColor.textColor),
                                    borderRadius: BorderRadius.circular(5)))),
                            onPressed: () async {
                              // TODO: Implement filter functionality
                            },
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                    'assets/svg/filter3.svg',
                                    height: 17,
                                    colorFilter: ColorFilter.mode(
                                      AppColor.textColor,
                                      BlendMode.srcIn,
                                    )),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'فیلتر نتایج',
                                  style: AppTextStyle.labelText.copyWith(
                                      fontSize: isDesktop ? 12 : 10,
                                      color: AppColor.textColor),
                                ),
                              ],
                            ),
                          ),*/
                        ],
                      ),
                    ),
                    // Main inventory table
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                      color: AppColor.appBarColor.withOpacity(0.5),
                      child: Column(
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: ClampingScrollPhysics(),
                            child: Row(
                              children: [
                                SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      DataTable(
                                        columns: buildDataColumns(),
                                        border: TableBorder.symmetric(
                                            inside: BorderSide(
                                                color: AppColor.textColor, width: 0.3),
                                            outside: BorderSide(
                                                color: AppColor.textColor, width: 0.3),
                                            borderRadius: BorderRadius.circular(8)),
                                        dividerThickness: 0.3,
                                        rows: buildDataRows(context),
                                        dataRowMaxHeight: 50,
                                        headingRowHeight: 40,
                                        columnSpacing: 90,
                                        horizontalMargin: 30,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Detailed reports section
                    if (controller.isDetailsExpanded.value)
                      buildDetailedReportSection(),
                  ],
                ),
              ),
            )
                : Center(
              child: ErrPage(
                callback: () {
                  controller.getProductInventoryList();
                },
                title: "خطا در لیست موجودی محصولات",
                des: 'برای دریافت لیست موجودی محصولات مجددا تلاش کنید',
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.dialog(const ChatDialog());
        },
        backgroundColor: AppColor.primaryColor,
        child: Icon(
          Icons.chat,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    ));
  }

  List<DataColumn> buildDataColumns() {
    return [
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 50,),
              child: Text('ردیف',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11))),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: Text('نام محصول',
              style: AppTextStyle.labelText.copyWith(fontSize: 11)),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: Text('موجودی اول دوره',
              style: AppTextStyle.labelText.copyWith(fontSize: 11)),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: Text('ورودی',
              style: AppTextStyle.labelText.copyWith(fontSize: 11)),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: Text('خروجی',
              style: AppTextStyle.labelText.copyWith(fontSize: 11)),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: Text('باقیمانده',
              style: AppTextStyle.labelText.copyWith(fontSize: 11)),
          headingRowAlignment: MainAxisAlignment.center),
    ];
  }

  List<DataRow> buildDataRows(BuildContext context) {
    return controller.productInventoryList
        .map((inventory) => DataRow(
      cells: [
        DataCell(
            Center(
              child: Text(
                "${inventory.rowNum ?? 0}",
                style: AppTextStyle.bodyText.copyWith(
                  color: AppColor.textColor,
                  fontSize: 12,
                ),
              ),
            )),
        DataCell(Center(
          child: GestureDetector(
            onTap: () {
              if (inventory.item?.id != null) {
                controller.toggleItemDetails(inventory.item!.id!);
              }
            },
            child: Text(
              inventory.item?.name ?? "",
              style: AppTextStyle.bodyText.copyWith(
                  color: AppColor.textColor,
                  fontSize: 12,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColor.textColor,
                  decorationThickness: 3
              ),
            ),
          ),
        )),
        DataCell(
            Center(
              child: Row(
                children: [
                  Text(
                    inventory.initBalance.toString().seRagham() ?? "",
                    style: AppTextStyle.bodyText.copyWith(
                        color: inventory.initBalance!<0 ?  AppColor.accentColor : inventory.initBalance!>0 ?AppColor.primaryColor :AppColor.textColor,
                        fontSize: 12, fontWeight:
                    FontWeight.bold
                    ),
                    textDirection:
                    TextDirection.ltr,
                  ),
                  SizedBox(width: 4,),
                  Text(
                    inventory.itemUnit?.name ?? "",
                    style: AppTextStyle.bodyText.copyWith(color: AppColor.textColor,
                        fontSize: 12,fontWeight:
                        FontWeight.bold),
                  ),
                ],
              ),
            )
        ),
        DataCell(
            Center(
              child: Row(
                children: [
                  Text(
                    inventory.quantityIn.toString().seRagham() ?? "",
                    style: AppTextStyle.bodyText.copyWith(
                        color: inventory.quantityIn!<0 ?  AppColor.accentColor : inventory.quantityIn!>0 ?AppColor.primaryColor :AppColor.textColor,
                        fontSize: 12, fontWeight:
                    FontWeight.bold
                    ),
                    textDirection:
                    TextDirection.ltr,
                  ),
                  SizedBox(width: 4,),
                  Text(
                    inventory.itemUnit?.name ?? "",
                    style: AppTextStyle.bodyText.copyWith(color: AppColor.textColor,
                        fontSize: 12,fontWeight:
                        FontWeight.bold),
                  ),
                ],
              ),
            )
        ),
        DataCell(
            Center(
              child: Row(
                children: [
                  Text(
                    inventory.quantityOut.toString().seRagham() ?? "",
                    style: AppTextStyle.bodyText.copyWith(
                        color: inventory.quantityOut!<0 ?  AppColor.accentColor : inventory.quantityOut!>0 ?AppColor.primaryColor :AppColor.textColor,
                        fontSize: 12, fontWeight:
                    FontWeight.bold
                    ),
                    textDirection:
                    TextDirection.ltr,
                  ),
                  SizedBox(width: 4,),
                  Text(
                    inventory.itemUnit?.name ?? "",
                    style: AppTextStyle.bodyText.copyWith(color: AppColor.textColor,
                        fontSize: 12,fontWeight:
                        FontWeight.bold),
                  ),
                ],
              ),
            )
        ),
        DataCell(
            Center(
              child: Row(
                children: [
                  Text(
                    inventory.quantity.toString().seRagham() ?? "",
                    style: AppTextStyle.bodyText.copyWith(
                        color: inventory.quantity!<0 ?  AppColor.accentColor : inventory.quantity!>0 ?AppColor.primaryColor :AppColor.textColor,
                        fontSize: 12, fontWeight:
                    FontWeight.bold
                    ),
                    textDirection:
                    TextDirection.ltr,
                  ),
                  SizedBox(width: 4,),
                  Text(
                    inventory.itemUnit?.name ?? "",
                    style: AppTextStyle.bodyText.copyWith(color: AppColor.textColor,
                        fontSize: 12,fontWeight:
                        FontWeight.bold),
                  ),
                ],
              ),
            )
        ),
      ],
    ))
        .toList();
  }

  Widget buildDetailedReportSection() {
    // Find the selected inventory item
    var selectedInventory = controller.productInventoryList.firstWhereOrNull(
            (inventory) => inventory.item?.id == controller.selectedItemId.value
    );

    if (selectedInventory == null) {
      return SizedBox.shrink();
    }

    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
          color: AppColor.appBarColor.withOpacity(0.3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Section header
              Row(
                children: [
                  Text(
                    'موجودی های ${selectedInventory.item?.name ?? ""}',
                    style: AppTextStyle.labelText.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColor.textColor,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () {
                      controller.toggleItemDetails(controller.selectedItemId.value);
                    },
                    icon: Icon(Icons.close, color: AppColor.textColor),
                  ),
                ],
              ),
              SizedBox(height: 10),
              // Date range filter
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColor.textColor.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  'از ابتدا دوره تا پایان دوره',
                  style: AppTextStyle.bodyText.copyWith(
                    color: AppColor.textColor.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ),
              SizedBox(height: 15),
              // Details table
              buildDetailsTable(controller.selectedItemId.value),
            ],
          ),
        ),
        // Pagination section
        Obx(() => Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            controller.paginated.value != null ? Container(
              height: 70,
              margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              padding: EdgeInsets.symmetric(horizontal: 20),
              color: AppColor.appBarColor.withOpacity(0.5),
              alignment: Alignment.bottomCenter,
              child: PagerWidget(
                countPage: controller.paginated.value?.totalCount ?? 0,
                callBack: (int index) {
                  controller.isChangePage(index);
                },
              ),
            ) : SizedBox(),
          ],
        )),
      ],
    );
  }

  Widget buildDetailsTable(int itemId) {
    if (controller.isLoadingDetails.value) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: CircularProgressIndicator(),
        ),
      );
    }

    List<ProductInventoryDetailModel> details = controller.productInventoryDetailList;

    if (details.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            'هیچ جزئیاتی یافت نشد',
            style: AppTextStyle.bodyText.copyWith(
              color: AppColor.textColor.withOpacity(0.7),
            ),
          ),
        ),
      );
    }

    return SizedBox(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: ClampingScrollPhysics(),
        child: Row(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  DataTable(
                    columns: buildDetailsColumns(),
                    rows: buildDetailsRows(details),
                    border: TableBorder.symmetric(
                      inside: BorderSide(color: AppColor.textColor.withOpacity(0.3), width: 0.3),
                      outside: BorderSide(color: AppColor.textColor.withOpacity(0.3), width: 0.3),
                    ),
                    dividerThickness: 0.3,
                    dataRowMaxHeight: double
                        .infinity,
                    headingRowHeight: 60,
                    columnSpacing: 40,
                    horizontalMargin: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<DataColumn> buildDetailsColumns() {
    return [
      DataColumn(
        label: Text('ردیف', style: AppTextStyle.labelText.copyWith(fontSize: 11)),
        headingRowAlignment: MainAxisAlignment.center,
      ),
      DataColumn(
        label: Text('دریافت/پرداخت', style: AppTextStyle.labelText.copyWith(fontSize: 11)),
        headingRowAlignment: MainAxisAlignment.center,
      ),
      DataColumn(
        label: Text('ثبت کننده', style: AppTextStyle.labelText.copyWith(fontSize: 11)),
        headingRowAlignment: MainAxisAlignment.center,
      ),
      DataColumn(
        label: Text('کاربر', style: AppTextStyle.labelText.copyWith(fontSize: 11)),
        headingRowAlignment: MainAxisAlignment.center,
      ),
      DataColumn(
        label: Text('مقدار', style: AppTextStyle.labelText.copyWith(fontSize: 11)),
        headingRowAlignment: MainAxisAlignment.center,
      ),
      DataColumn(
        label: Text('تصویر', style: AppTextStyle.labelText.copyWith(fontSize: 11)),
        headingRowAlignment: MainAxisAlignment.center,
      ),
      DataColumn(
        label: Text('شرح', style: AppTextStyle.labelText.copyWith(fontSize: 11)),
        headingRowAlignment: MainAxisAlignment.center,
      ),
    ];
  }

  List<DataRow> buildDetailsRows(List<ProductInventoryDetailModel> details) {
    return details.map((detail) => DataRow(
      cells: [
        DataCell(
          Center(
            child: Text(
              "${detail.rowNum ?? 0}",
              style: AppTextStyle.bodyText.copyWith(
                color: AppColor.textColor,
                fontSize: 11,
              ),
            ),
          ),
        ),
        DataCell(
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: detail.type == 0 ? Colors.green : Colors.red,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                detail.type == 0 ? 'دریافت' : 'پرداخت',
                style: AppTextStyle.bodyText.copyWith(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        DataCell(
          Center(
            child: Text(
              detail.createdBy?.name ?? "",
              style: AppTextStyle.bodyText.copyWith(
                color: AppColor.textColor,
                fontSize: 11,
              ),
            ),
          ),
        ),
        DataCell(
          Center(
            child: Text(
              detail.wallet?.account?.name ?? "",
              style: AppTextStyle.bodyText.copyWith(
                color: AppColor.dividerColor,
                fontSize: 11,
              ),
            ),
          ),
        ),
        DataCell(
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${detail.quantity?.toString().seRagham() ?? "0"}",
                  style: AppTextStyle.bodyText.copyWith(
                    color: detail.type == 0 ?  AppColor.primaryColor : AppColor.accentColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  textDirection: TextDirection.ltr,
                ),
                SizedBox(width: 4),
                Text(
                  detail.item?.itemUnit?.name ?? "",
                  style: AppTextStyle.bodyText.copyWith(
                    color: detail.type == 0 ?  AppColor.primaryColor : AppColor.accentColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
        DataCell(
          Center(
            child: Icon(
              Icons.attach_file,
              color: AppColor.textColor.withOpacity(0.7),
              size: 16,
            ),
          ),
        ),
        DataCell(
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 5),
                detail.item?.itemUnit?.id==2 ?
                Row(
                  children: [
                    SizedBox(width: 2),
                    if (detail.weight750 != null)
                      Row(
                        children: [
                          Text(
                            "وزن ترازو: ",
                            style: AppTextStyle.bodyText.copyWith(
                              color: AppColor.textColor,
                              fontSize: 9,
                            ),
                          ),
                          Text(
                            "${detail.weight750.toString().seRagham()} گرم",
                            style: AppTextStyle.bodyText.copyWith(
                              color: AppColor.dividerColor,fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    SizedBox(width: 3),
                    if (detail.carat != null)
                      Row(
                        children: [
                          Text(
                            "عیار: ",
                            style: AppTextStyle.bodyText.copyWith(
                              color: AppColor.textColor,
                              fontSize: 9,
                            ),
                          ),
                          Text(
                            "${detail.carat}",
                            style: AppTextStyle.bodyText.copyWith(
                              color: AppColor.dividerColor,
                              fontSize: 10,fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                    SizedBox(width: 3),
                    if (detail.weight750 != null)
                      Row(
                        children: [
                          Text(
                            "وزن ۷۵۰: ",
                            style: AppTextStyle.bodyText.copyWith(
                              color: AppColor.textColor,
                              fontSize: 9,
                            ),
                          ),
                          Text(
                            "${detail.weight750.toString().seRagham()} گرم",
                            style: AppTextStyle.bodyText.copyWith(
                              color: AppColor.dividerColor,
                                fontSize: 10,fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                    SizedBox(width: 3),
                    if (detail.impurity != null)
                      Row(
                        children: [
                          Text(
                            "ناخالصی: ",
                            style: AppTextStyle.bodyText.copyWith(
                              color: AppColor.textColor,
                              fontSize: 9,
                            ),
                          ),
                          Text(
                            "${detail.impurity.toString().seRagham()} گرم",
                            style: AppTextStyle.bodyText.copyWith(
                              color: AppColor.dividerColor,
                                fontSize: 10,fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                  ],
                )  :
                    Row(
                      children: [
                        Text(
                          "${detail.weight750.toString().seRagham()} ${detail.item?.itemUnit?.name}",
                          style: AppTextStyle.bodyText.copyWith(
                            color: AppColor.dividerColor,
                            fontSize: 11,
                          ),
                        ),
                        SizedBox(width: 3,),
                        Text(
                          "${detail.item?.name}",
                          style: AppTextStyle.bodyText.copyWith(
                            color: AppColor.textColor,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                SizedBox(height: 5),
                Row(
                  children: [
                    SizedBox(width: 3),
                    if (detail.laboratory?.name != null)
                      Row(
                        children: [
                          Text(
                            "آزمایشگاه: ",
                            style: AppTextStyle.bodyText.copyWith(
                              color: AppColor.textColor,
                              fontSize: 10,
                            ),
                          ),
                          Text(
                            "${detail.laboratory!.name}",
                            style: AppTextStyle.bodyText.copyWith(
                              color: AppColor.dividerColor,
                                fontSize: 10,fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                    SizedBox(width: 3),
                    if (detail.laboratory?.id != null)
                      Row(
                        children: [
                          Text(
                            "شماره آزمایشگاه: ",
                            style: AppTextStyle.bodyText.copyWith(
                              color: AppColor.textColor,
                              fontSize: 10,
                            ),
                          ),
                          Text(
                            "${detail.laboratory!.id}",
                            style: AppTextStyle.bodyText.copyWith(
                              color: AppColor.dividerColor,
                                fontSize: 10,fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                SizedBox(height: 3),
                Divider(color: AppColor.dividerColor,height: 1,),
                SizedBox(height: 3),
                // Main description
                Row(
                  children: [
                    Text(
                      "توضیحات: ",
                      style: AppTextStyle.bodyText.copyWith(
                          color: AppColor.textColor,
                          fontSize: 10,
                      ),
                    ),
                    Text(
                      detail.description ?? "",
                      style: AppTextStyle.bodyText.copyWith(
                        color: AppColor.textColor,
                        fontSize: 10,fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3),
                if (detail.date != null)
                  Text(
                    "${detail.date!.toPersianDate(twoDigits: true, showTime: true, timeSeprator: '-')}",
                    style: AppTextStyle.bodyText.copyWith(
                      color: AppColor.secondary3Color,
                      fontSize: 10,fontWeight: FontWeight.bold
                    ),
                  ),
                SizedBox(height: 3),
              ],
            ),
          ),
        ),
      ],
    )).toList();
  }

}
