
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../widget/app_drawer.widget.dart';
import '../../../widget/background_image_total.widget.dart';
import '../../../widget/custom_appbar1.widget.dart';
import '../../../widget/err_page.dart';
import '../../../widget/pager_widget.dart';
import '../../../widget/pager_widget1.dart';
import '../../home/widget/chat_dialog.widget.dart';
import '../../inventory/model/inventory_detail.model.dart';
import '../controller/product_inventory_quantity.controller.dart';
import '../model/product_inventory_quantity.model.dart';
import '../widget/product_inventory_quantity_filter.widget.dart';

class ProductInventoryQuantityView extends GetView<ProductInventoryQuantityController> {
  ProductInventoryQuantityView({super.key});

  // ScrollController to manage scrolling to details section
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _detailsSectionKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    return Obx(() => Scaffold(
      appBar: CustomAppbar1(
        title: 'موجودی محصولات',
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
                ? isDesktop
                ? SizedBox(
              height: Get.height * 0.95,
              width: Get.width,
              child: SingleChildScrollView(
                //controller: _scrollController,
                child: Column(
                  children: [
                    // Main inventory table
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                      decoration: BoxDecoration(
                        color: AppColor.backGroundColor1,
                        borderRadius: BorderRadius.circular(10),
                        //border: Border.all(color: const Color(0xFF64748B)),
                      ),
                      child: Column(
                        children: [
                          // Section header
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            margin: EdgeInsets.symmetric(
                                horizontal:  30 , vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColor.appBarColor.withAlpha(30),
                              borderRadius: BorderRadius.circular(10),
                              //border: Border.all(color: const Color(0xFF64748B)),
                            ),
                            child: Row(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'موجودی ها',
                                      style: AppTextStyle.labelText.copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColor.textColor,
                                      ),
                                    ),
                                    SizedBox(width: 15,),
                                    // خروجی اکسل
                                    OutlinedButton.icon(
                                        onPressed: () {
                                          controller.getInventoryQuantityExcel();
                                          Get.back();
                                        },
                                        label: Text(
                                          'خروجی اکسل',
                                          style: AppTextStyle
                                              .labelText.copyWith(color: AppColor.primaryColor,fontSize: 12),
                                        ),
                                      icon: SvgPicture.asset(
                                        'assets/svg/excel.svg',
                                        height: 24,
                                      ),
                                    ),
                                    /*ElevatedButton(
                                      style: ButtonStyle(
                                          padding: WidgetStatePropertyAll(
                                            EdgeInsets.symmetric(
                                                horizontal: 15,
                                                vertical: 7
                                            ),
                                          ),
                                          fixedSize: WidgetStatePropertyAll(
                                              Size(100, 30)),
                                          elevation: WidgetStatePropertyAll(
                                              5),
                                          backgroundColor:
                                          WidgetStatePropertyAll(
                                              AppColor.secondary3Color),
                                          shape: WidgetStatePropertyAll(
                                              RoundedRectangleBorder(
                                                  borderRadius: BorderRadius
                                                      .circular(5)))),
                                      onPressed: () {
                                        controller.getInventoryQuantityExcel();
                                        Get.back();
                                      },
                                      child: Text(
                                        'خروجی اکسل',
                                        style: AppTextStyle.labelText,
                                      ),
                                    ),*/
                                    SizedBox(width: 15,),
                                    // خروجی pdf
                                    OutlinedButton.icon(
                                        onPressed: () {
                                          controller.getInventoryQuantityPdf();
                                          Get.back();
                                        },
                                        label: Text(
                                          'خروجی pdf',
                                          style: AppTextStyle.labelText.copyWith(color: AppColor.textAccentColor,fontSize: 12),
                                        ),
                                      icon: SvgPicture.asset(
                                        'assets/svg/pdf.svg',
                                        height: 24,
                                      ),
                                    ),
                                    /*ElevatedButton(
                                      style: ButtonStyle(
                                          padding: WidgetStatePropertyAll(
                                            EdgeInsets.symmetric(
                                                horizontal: 15,
                                                vertical: 7
                                            ),
                                          ),
                                          fixedSize: WidgetStatePropertyAll(
                                              Size(100, 30)),
                                          elevation: WidgetStatePropertyAll(
                                              5),
                                          backgroundColor:
                                          WidgetStatePropertyAll(
                                              AppColor.secondary3Color),
                                          shape: WidgetStatePropertyAll(
                                              RoundedRectangleBorder(
                                                  borderRadius: BorderRadius
                                                      .circular(5)))),
                                      onPressed: () {
                                        controller.getInventoryQuantityPdf();
                                        Get.back();
                                      },
                                      child: Text(
                                        'خروجی pdf',
                                        style: AppTextStyle.labelText,
                                      ),
                                    ),*/
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
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
                                        rows: buildDataRows(context),
                                        border: TableBorder.symmetric(
                                            inside: BorderSide(
                                                color: AppColor.textColor, width: 0.3),
                                            outside: BorderSide(
                                                color: AppColor.textColor, width: 0.3),
                                            borderRadius: BorderRadius.circular(8)),
                                        headingRowColor: WidgetStatePropertyAll(AppColor.buttonColor.withAlpha(40)),
                                        dividerThickness: 0.3,
                                        //dataRowMaxHeight: 50,
                                        headingRowHeight: 35,
                                        columnSpacing: 50,
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
                      Container(
                        key: _detailsSectionKey,
                        child: buildDetailedReportSection(),
                      ),
                  ],
                ),
              ),
            )
                :_buildMobileInventoryList(context)
                : Center(
              child: ErrPage(
                callback: () {
                  controller.getProductInventoryQuantityList();
                },
                title: "خطا در لیست موجودی محصولات",
                des: 'برای دریافت لیست موجودی محصولات مجددا تلاش کنید',
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: isDesktop ? FloatingActionButton(
        onPressed: () {
          Get.dialog(const ChatDialog());
        },
        backgroundColor: AppColor.primaryColor,
        child: Icon(
          Icons.chat,
          color: Colors.white,
        ),
      ) : SizedBox.shrink(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    ));
  }

  // Method to scroll to the details section
  void _scrollToDetailsSection() {
    if (_detailsSectionKey.currentContext != null) {
      Scrollable.ensureVisible(
        _detailsSectionKey.currentContext!,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        alignment: 0.0, // Align to top of the viewport
      );
    }
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
          label: Text('مقدار',
              style: AppTextStyle.labelText.copyWith(fontSize: 11)),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: Text('موجودی 750',
              style: AppTextStyle.labelText.copyWith(fontSize: 11)),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: Text('وزن 750',
              style: AppTextStyle.labelText.copyWith(fontSize: 11)),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: Text('معادل عددی',
              style: AppTextStyle.labelText.copyWith(fontSize: 11)),
          headingRowAlignment: MainAxisAlignment.center),
    ];
  }

  List<DataRow> buildDataRows(BuildContext context) {
    return controller.productInventoryQuantityList.asMap().entries.map((entry) {
      final index = entry.key;
      final inventory = entry.value;
      final rowColor = index.isEven
          ? AppColor.backGroundColor
          : AppColor.secondaryColor.withAlpha(100);
          return DataRow(
            color: WidgetStateProperty.all(rowColor),
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
                      controller.toggleItemDetails(inventory.item?.id ?? 0);
                      // Scroll to details section after a short delay to allow the details to load
                      Future.delayed(Duration(milliseconds: 300), () {
                        _scrollToDetailsSection();
                      });
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
                          inventory.quantity!<0 ?
                          "-${inventory.quantity?.abs().toString().seRagham() ?? ""}" :
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
              DataCell(
                  Center(
                    child: Row(
                      children: [
                        Text(
                          inventory.quantity750!<0 ?
                          "-${inventory.quantity750?.abs().toString().seRagham() ?? ""}" :
                          inventory.quantity750.toString().seRagham() ?? "",
                          style: AppTextStyle.bodyText.copyWith(
                              color: inventory.quantity750!<0 ?  AppColor.accentColor : inventory.quantity750!>0 ?AppColor.primaryColor :AppColor.textColor,
                              fontSize: 12, fontWeight:
                          FontWeight.bold
                          ),
                          textDirection:
                          TextDirection.ltr,
                        ),
                        SizedBox(width: 4,),
                        Text(
                          "گرم",
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
                    child: Text(
                      "${inventory.item?.w750 ?? 0}",
                      style: AppTextStyle.bodyText.copyWith(
                        color: AppColor.textColor,
                        fontSize: 12,
                      ),
                    ),
                  )),
              DataCell(
                  Center(
                    child: Row(
                      children: [
                        inventory.itemUnit?.id==2 && inventory.item?.id!=1 ?
                        Text(
                          (inventory.quantityCount ?? 0) < 0 ?
                          "-${inventory.quantityCount?.abs().toString().seRagham() ?? "0"}":
                          inventory.quantityCount.toString().seRagham(),
                          style: AppTextStyle.bodyText.copyWith(
                              color: AppColor.dividerColor,
                              fontSize: 12, fontWeight:
                          FontWeight.bold
                          ),
                          textDirection:
                          TextDirection.ltr,
                        ):SizedBox.shrink(),
                        SizedBox(width: 4,),
                        Text(
                          inventory.itemUnit?.id==2 && inventory.item?.id!=1 ? "عدد" : "",
                          style: AppTextStyle.bodyText.copyWith(color: AppColor.textColor,
                              fontSize: 12,fontWeight:
                              FontWeight.bold),
                        ),
                      ],
                    ),
                  )
              ),
            ],
          );
    }
    ).toList();
  }

  Widget buildDetailedReportSection() {
    // Find the selected inventory item
    var selectedInventoryQuantity = controller.productInventoryQuantityList.firstWhereOrNull(
            (inventory) => inventory.item?.id == controller.selectedItemId.value
    );

    if (selectedInventoryQuantity == null) {
      return SizedBox.shrink();
    }

    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
          decoration: BoxDecoration(
            color: AppColor.appBarColor.withAlpha(75),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFF64748B)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Section header
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 30, vertical: 10),
                margin: EdgeInsets.symmetric(
                    horizontal:  30 , vertical: 4),
                decoration: BoxDecoration(
                  color: AppColor.appBarColor.withAlpha(30),
                  borderRadius: BorderRadius.circular(10),
                  //border: Border.all(color: const Color(0xFF64748B)),
                ),
                child: Row(
                  children: [
                    Row(
                      children: [
                        Text(
                          'موجودی های ${selectedInventoryQuantity.item?.name ?? ""}',
                          style: AppTextStyle.labelText.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColor.textColor,
                          ),
                        ),
                        SizedBox(width: 15,),
                        // Filter button
                        ProductInventoryQuantityFilterWidget(
                          controller: controller,
                          onFilterApplied: () {
                            if (controller.selectedItemId.value > 0) {
                              controller.getRecieptRemaindedListPager(controller.selectedItemId.value.toString());
                            }
                          },
                          onFilterCleared: () {
                            if (controller.selectedItemId.value > 0) {
                              controller.getRecieptRemaindedListPager(controller.selectedItemId.value.toString());
                            }
                          },
                        ),
                        SizedBox(width: 8,),
                        // خروجی اکسل ریز موجودی ها
                        OutlinedButton.icon(
                            onPressed: () {
                              controller.getRecieptRemaindedListExcel(controller.selectedItemId.value.toString());
                            },
                            label: Text(
                              'خروجی اکسل',
                              style: AppTextStyle
                                  .labelText.copyWith(color: AppColor.primaryColor,fontSize: 12),
                            ),
                          icon: SvgPicture.asset(
                            'assets/svg/excel.svg',
                            height: 24,
                          ),
                        ),
                        /*ElevatedButton(
                          style: ButtonStyle(
                              padding: WidgetStatePropertyAll(
                                EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 7
                                ),
                              ),
                              fixedSize: WidgetStatePropertyAll(
                                  Size(100, 30)),
                              elevation: WidgetStatePropertyAll(
                                  5),
                              backgroundColor:
                              WidgetStatePropertyAll(
                                  AppColor.secondary3Color),
                              shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius
                                          .circular(5)))),
                          onPressed: () {
                            controller.getRecieptRemaindedListExcel(controller.selectedItemId.value.toString());
                          },
                          child: Text(
                            'خروجی اکسل',
                            style: AppTextStyle.labelText,
                          ),
                        ),*/
                        SizedBox(width: 15,),
                        // خروجی pdf ریز موجودی ها
                        OutlinedButton.icon(
                            onPressed: () {
                              controller.getRemaindedListPdf(controller.selectedItemId.value.toString());
                            },
                            label: Text(
                              'خروجی pdf',
                              style: AppTextStyle.labelText.copyWith(color: AppColor.textAccentColor,fontSize: 12),
                            ),
                          icon: SvgPicture.asset(
                            'assets/svg/pdf.svg',
                            height: 24,
                          ),
                        ),
                        /*ElevatedButton(
                          style: ButtonStyle(
                              padding: WidgetStatePropertyAll(
                                EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 7
                                ),
                              ),
                              fixedSize: WidgetStatePropertyAll(
                                  Size(100, 30)),
                              elevation: WidgetStatePropertyAll(
                                  5),
                              backgroundColor:
                              WidgetStatePropertyAll(
                                  AppColor.secondary3Color),
                              shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius
                                          .circular(5)))),
                          onPressed: () {
                            controller.getRemaindedListPdf(controller.selectedItemId.value.toString());
                          },
                          child: Text(
                            'خروجی pdf',
                            style: AppTextStyle.labelText,
                          ),
                        ),*/
                      ],
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
                  controller.hasActiveFilters()
                      ? 'فیلترهای فعال: ${controller.dateStartController.text.isNotEmpty ? "از ${controller.dateStartController.text}" : ""} ${controller.dateEndController.text.isNotEmpty ? "تا ${controller.dateEndController.text}" : ""} ${controller.userFilterController.text.isNotEmpty ? "کاربر: ${controller.userFilterController.text}" : ""} ${controller.amountFilterController.text.isNotEmpty ? "مقدار: ${controller.amountFilterController.text}" : ""}'
                      : 'از ابتدا دوره تا پایان دوره',
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
              //color: AppColor.appBarColor.withAlpha(130),
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

    List<InventoryDetailModel> details = controller.recieptRemaindedList;

    if (details.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/svg/empty.svg',
                height: 80,
                colorFilter: ColorFilter.mode(
                  AppColor.textColor.withOpacity(0.5),
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(height: 20),
              Text(
                controller.hasActiveFilters()
                    ? 'نتیجه فیلتر خالی است'
                    : 'هیچ جزئیاتی یافت نشد',
                style: AppTextStyle.labelText.copyWith(
                  fontSize: 16,
                  color: AppColor.textColor.withOpacity(0.7),
                ),
              ),
              SizedBox(height: 10),
              Text(
                controller.hasActiveFilters()
                    ? 'لطفاً فیلترهای خود را تغییر دهید'
                    : 'جزئیات موجودی برای این محصول موجود نیست',
                style: AppTextStyle.bodyText.copyWith(
                  fontSize: 12,
                  color: AppColor.textColor.withOpacity(0.5),
                ),
              ),
              SizedBox(height: 15),
              GestureDetector(
                onTap: () {
                  controller.clearFilter();
                  if (controller.selectedItemId.value > 0) {
                    controller.getRecieptRemaindedListPager(controller.selectedItemId.value.toString());
                  }
                },
                child: Text('تلاش مجدد',
                  style: AppTextStyle.bodyText.copyWith(
                      fontSize: 16,
                      color: AppColor.accentColor,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ],
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
                      inside: BorderSide(color: AppColor.textColor.withAlpha(75), width: 0.3),
                      outside: BorderSide(color: AppColor.textColor.withAlpha(75), width: 0.3),
                        borderRadius: BorderRadius.circular(8),
                    ),
                    headingRowColor: WidgetStateProperty.all(AppColor.secondaryColor.withAlpha(120)),
                    dividerThickness: 0.3,
                    dataRowMaxHeight: double
                        .infinity,
                    headingRowHeight: 35,
                    columnSpacing: 50,
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
        label: Text('ثبت کننده', style: AppTextStyle.labelText.copyWith(fontSize: 11)),
        headingRowAlignment: MainAxisAlignment.center,
      ),
      DataColumn(
        label: Text('دریافت از', style: AppTextStyle.labelText.copyWith(fontSize: 11)),
        headingRowAlignment: MainAxisAlignment.center,
      ),
      DataColumn(
        label: Text('مقدار', style: AppTextStyle.labelText.copyWith(fontSize: 11)),
        headingRowAlignment: MainAxisAlignment.center,
      ),
      /*DataColumn(
        label: Text('تصویر', style: AppTextStyle.labelText.copyWith(fontSize: 11)),
        headingRowAlignment: MainAxisAlignment.center,
      ),*/
      DataColumn(
        label: Text('شرح', style: AppTextStyle.labelText.copyWith(fontSize: 11)),
        headingRowAlignment: MainAxisAlignment.center,
      ),
    ];
  }

  List<DataRow> buildDetailsRows(List<InventoryDetailModel> details) {
    return details.asMap().entries.map((entry) {
      final index = entry.key;
      final detail = entry.value;
      final rowColor = index.isEven
          ? AppColor.backGroundColor
          : AppColor.secondaryColor.withAlpha(50);
      return DataRow(
        color: WidgetStateProperty.all(rowColor),
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
                    "${detail.quantityRemainded?.toString().seRagham() ?? "0"}",
                    style: AppTextStyle.bodyText.copyWith(
                      color: detail.type == 0 ?  AppColor.primaryColor : AppColor.accentColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    textDirection: TextDirection.ltr,
                  ),
                  SizedBox(width: 4),
                  Text(
                    detail.itemUnit?.name ?? "",
                    style: AppTextStyle.bodyText.copyWith(
                      color: detail.type == 0 ?  AppColor.primaryColor : AppColor.accentColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          /*DataCell(
          Center(
            child: Icon(
              Icons.attach_file,
              color: AppColor.textColor.withOpacity(0.7),
              size: 16,
            ),
          ),
        ),*/
          DataCell(
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 5),
                  detail.itemUnit?.id==2 ?
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
                              "${detail.weight.toString().seRagham()} گرم",
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
                        "${detail.weight750.toString().seRagham()} ${detail.itemUnit?.name}",
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
                      if (detail.item?.id==1)
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
                      if (detail.item?.id==1)
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
      );
    }
    ).toList();
  }

  // Mobile inventory list builder
  Widget _buildMobileInventoryList(BuildContext context) {
    return Container(
      height: Get.height * 0.93,
      width: Get.width,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
            // Export buttons for mobile
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
              padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
              decoration: BoxDecoration(
                color: AppColor.appBarColor.withAlpha(30),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF64748B)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // خروجی اکسل
                  GestureDetector(
                    onTap: () {
                      controller.getInventoryQuantityExcel();
                    },
                    child: SvgPicture.asset(
                      'assets/svg/excel.svg',
                      height: 30,
                    ),
                  ),
                  SizedBox(width: 20,),
                  // خروجی pdf
                  GestureDetector(
                    onTap: () {
                      controller.getInventoryQuantityPdf();
                    },
                    child: SvgPicture.asset(
                      'assets/svg/pdf.svg',
                      height: 30,
                    ),
                  ),
                ],
              ),
            ),
            // Inventory cards list
            ListView.builder(
              itemCount: controller.productInventoryQuantityList.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (ctx, index) {
                final inventory = controller.productInventoryQuantityList[index];
                return _buildMobileInventoryCard(context, inventory);
              },
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  // Mobile inventory card widget
  Widget _buildMobileInventoryCard(BuildContext context, ProductInventoryQuantityModel inventory) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColor.appBarColor.withAlpha(200),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.textColor.withAlpha(75)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with row number and product name
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    final itemId = inventory.item?.id;
                    if (itemId != null) {
                      _showMobileDetailsSheet(context, inventory);
                    }
                  },
                  child: Text(
                    inventory.item?.name ?? "",
                    style: AppTextStyle.labelText.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColor.secondary3Color,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColor.textColor,
                    ),
                  ),
                ),
              ),
              /*Text(
                "${inventory.rowNum ?? 0}",
                style: AppTextStyle.labelText.copyWith(
                  fontSize: 12,
                  color: AppColor.textColor.withOpacity(0.8),
                ),
              ),*/
            ],
          ),
          SizedBox(height: 8),
          Divider(height: 0.5, color: AppColor.dividerColor),
          SizedBox(height: 10),

          // Quantity & Quantity 750
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColor.primaryColor.withAlpha(30),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColor.textColor.withOpacity(0.2)),
            ),
            child: Column(
              children: [
                _mobileLine(
                  "مقدار",
                  inventory.quantity! < 0
                      ? "-${inventory.quantity?.abs().toString().seRagham() ?? "0"}"
                      : inventory.quantity?.toString().seRagham() ?? "0",
                  inventory.quantity! < 0
                      ? AppColor.accentColor
                      : inventory.quantity! > 0
                      ? AppColor.primaryColor
                      : AppColor.textColor,
                  inventory.itemUnit?.name ?? "",
                ),
                _mobileLine(
                  "موجودی 750",
                  inventory.quantity750! < 0
                      ? "-${inventory.quantity750?.abs().toString().seRagham() ?? "0"}"
                      : inventory.quantity750?.toString().seRagham() ?? "0",
                  inventory.quantity750! < 0
                      ? AppColor.accentColor
                      : inventory.quantity750! > 0
                      ? AppColor.primaryColor
                      : AppColor.textColor,
                  "گرم",
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(right: 12,left: 12,top: 8),
            child: Row(
              children: [
                // Weight 750
                //Expanded(child: _mobileLine("وزن 750: ", "${inventory.item?.w750 ?? 0}", AppColor.textColor, "")),
                Expanded(
                    child: Row(crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("وزن 750: ",style: AppTextStyle.labelText.copyWith(
                          fontSize: 11,
                          color: AppColor.textColor,
                        ),),
                        Text("${inventory.item?.w750 ?? 0}",style: AppTextStyle.labelText.copyWith(
                          fontSize: 12,
                          color: AppColor.textColor,
                          fontWeight: FontWeight.bold,
                        ),
                          textDirection: TextDirection.ltr,),
                      ],
                    )
                ),
                // Numeric equivalent (only if applicable)
                if (inventory.itemUnit?.id == 2 && inventory.item?.id != 1) ...[
                  SizedBox(height: 8),
                  Expanded(
                    child: _mobileLine(
                      "معادل عددی: ",
                      (inventory.quantityCount ?? 0) < 0 ?
                      "-${inventory.quantityCount?.abs().toString().seRagham() ?? "0"}":
                      inventory.quantityCount.toString().seRagham(),
                      AppColor.dividerColor,
                      "عدد",
                    ),
                  ),
                ],
              ],
            ),
          )

        ],
      ),
    );
  }

  // Mobile line helper widget
  Widget _mobileLine(String label, String value, Color color, String unit) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyle.labelText.copyWith(
                fontSize: 11,
                color: AppColor.textColor,
              ),
            ),
          ),
          SizedBox(width: 8),
          Text(
            value,
            style: AppTextStyle.labelText.copyWith(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.bold,
            ),
            textDirection: TextDirection.ltr,
          ),
          if (unit.isNotEmpty) ...[
            SizedBox(width: 4),
            Text(
              unit,
              style: AppTextStyle.labelText.copyWith(
                fontSize: 10,
                color: AppColor.textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Show mobile details bottom sheet
  void _showMobileDetailsSheet(BuildContext context, ProductInventoryQuantityModel inventory) {
    final itemId = inventory.item?.id;
    if (itemId != null) {
      controller.toggleItemDetails(itemId);
      // Wait for details to load, then show bottom sheet
      Future.delayed(Duration(milliseconds: 500), () {
        if (context.mounted) {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => _buildMobileDetailsSheet(context),
          );
        }
      });
    }
  }

  // Mobile details bottom sheet widget
  Widget _buildMobileDetailsSheet(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppColor.backGroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColor.textColor.withAlpha(75),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // خروجی اکسل
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3,vertical: 5),
                        padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColor.appBarColor.withAlpha(30),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFF64748B)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Obx(() {
                                var selectedInventory = controller.productInventoryQuantityList.firstWhereOrNull(
                                      (inv) => inv.item?.id == controller.selectedItemId.value,
                                );
                                return Text(
                                  'موجودی های ${selectedInventory?.item?.name ?? ""}',
                                  style: AppTextStyle.labelText.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.textColor,
                                  ),
                                );
                              }),
                            ),
                            SizedBox(width: 20,),
                            GestureDetector(
                              onTap: () {
                                controller.getRecieptRemaindedListExcel(controller.selectedItemId.value.toString());
                              },
                              child: SvgPicture.asset(
                                'assets/svg/excel.svg',
                                height: 30,
                              ),
                            ),
                            SizedBox(width: 20,),
                            // خروجی pdf
                            GestureDetector(
                              onTap: () {
                                controller.getRemaindedListPdf(controller.selectedItemId.value.toString());
                              },
                              child: SvgPicture.asset(
                                'assets/svg/pdf.svg',
                                height: 30,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Get.back();
                        controller.clearFilter();
                      },
                      icon: Icon(Icons.close, color: AppColor.textColor),
                    ),
                  ],
                ),
              ),
              Divider(color: AppColor.dividerColor, height: 1),
              // Filter info
              Obx(() => Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ProductInventoryQuantityFilterWidget(
                    controller: controller,
                    onFilterApplied: () {
                      if (controller.selectedItemId.value > 0) {
                        controller.getRecieptRemaindedListPager(
                            controller.selectedItemId.value.toString());
                      }
                    },
                    onFilterCleared: () {
                      if (controller.selectedItemId.value > 0) {
                        controller.getRecieptRemaindedListPager(
                            controller.selectedItemId.value.toString());
                      }
                    },
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColor.textColor.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      controller.hasActiveFilters()
                          ? 'فیلترهای فعال: ${controller.dateStartController.text.isNotEmpty ? "از ${controller.dateStartController.text}" : ""} ${controller.dateEndController.text.isNotEmpty ? "تا ${controller.dateEndController.text}" : ""} ${controller.userFilterController.text.isNotEmpty ? "کاربر: ${controller.userFilterController.text}" : ""} ${controller.amountFilterController.text.isNotEmpty ? "مقدار: ${controller.amountFilterController.text}" : ""}'
                          : 'از ابتدا دوره تا پایان دوره',
                      style: AppTextStyle.bodyText.copyWith(
                        color: AppColor.textColor.withOpacity(0.7),
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              )),
              // Details list
              Expanded(
                child: _buildMobileDetailsList(context, controller.scrollControllerMobile),
              ),
            ],
          ),
        );
      },
    );
  }

  // Mobile details list builder
  Widget _buildMobileDetailsList(BuildContext context, ScrollController scrollController) {
    return Obx(() {
      if (controller.isLoadingDetails.value) {
        return Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: CircularProgressIndicator(),
          ),
        );
      }

      List<InventoryDetailModel> details = controller.recieptRemaindedList;

      if (details.isEmpty) {
        return Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/svg/empty.svg',
                  height: 80,
                  colorFilter: ColorFilter.mode(
                    AppColor.textColor.withOpacity(0.5),
                    BlendMode.srcIn,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  controller.hasActiveFilters()
                      ? 'نتیجه فیلتر خالی است'
                      : 'هیچ جزئیاتی یافت نشد',
                  style: AppTextStyle.labelText.copyWith(
                    fontSize: 16,
                    color: AppColor.textColor.withOpacity(0.7),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  controller.hasActiveFilters()
                      ? 'لطفاً فیلترهای خود را تغییر دهید'
                      : 'جزئیات موجودی برای این محصول موجود نیست',
                  style: AppTextStyle.bodyText.copyWith(
                    fontSize: 12,
                    color: AppColor.textColor.withOpacity(0.5),
                  ),
                ),
                SizedBox(height: 15),
                GestureDetector(
                  onTap: () {
                    controller.clearFilter();
                    if (controller.selectedItemId.value > 0) {
                      controller.getRecieptRemaindedListPager(
                          controller.selectedItemId.value.toString());
                    }
                  },
                  child: Text(
                    'تلاش مجدد',
                    style: AppTextStyle.bodyText.copyWith(
                      fontSize: 16,
                      color: AppColor.accentColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }

      return ListView.builder(
        controller: controller.scrollControllerMobile,
        itemCount: details.length + 1,
        itemBuilder: (context, index) {
          if (index == details.length) {
            // Loading more indicator
            return Obx(() {
              if (controller.isLoading.value && controller.recieptRemaindedList.isNotEmpty) {
                return Container(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (!controller.hasMore.value && controller.recieptRemaindedList.isNotEmpty) {
                return Container(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "همه موجودی ها نمایش داده شد",
                    textAlign: TextAlign.center,
                    style: AppTextStyle.bodyText.copyWith(
                      color: AppColor.textColor.withOpacity(0.7),
                    ),
                  ),
                );
              }

              return SizedBox.shrink();
            });
          }
          final detail = details[index];
          return _buildMobileDetailCard(detail);
        },
      );
    });
  }

  // Mobile detail card widget
  Widget _buildMobileDetailCard(InventoryDetailModel detail) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColor.appBarColor.withAlpha(200),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.textColor.withAlpha(75)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${detail.rowNum ?? 0}",
                style: AppTextStyle.labelText.copyWith(
                  fontSize: 11,
                  color: AppColor.textColor.withOpacity(0.8),
                ),
              ),
              if (detail.date != null)
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    "${detail.date!.toPersianDate(twoDigits: true, showTime: true, timeSeprator: '-')}",
                    style: AppTextStyle.bodyText.copyWith(
                      color: AppColor.secondary3Color,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 12),
          Divider(height: 0.5, color: AppColor.dividerColor),
          SizedBox(height: 12),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // User/Wallet
              _mobileDetailLine("دریافت از",
                  (detail.wallet?.account?.name?.length ?? 0) > 20 ?
                  "...${detail.wallet?.account?.name?.substring(0 , 20)}" :
                  detail.wallet?.account?.name ?? "",
                  AppColor.dividerColor,"",9,10),
              // Registrar
              _mobileDetailLine("ثبت کننده",
                  (detail.createdBy?.name?.length ?? 0) > 18 ?
                  "...${detail.createdBy?.name?.substring(0 , 18)}" :
                  detail.createdBy?.name ?? "",
                  AppColor.textColor,"",9,10),
            ],
          ),
          // Quantity
          _mobileDetailLine(
            "مقدار",
            detail.quantityRemainded?.toString().seRagham() ?? "0",
            detail.type == 0 ? AppColor.primaryColor : AppColor.accentColor,detail.itemUnit?.name,10,13
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                //margin: const EdgeInsets.symmetric(vertical: 3),
                padding: EdgeInsets.symmetric(horizontal: 3, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: AppColor.secondary3Color.withAlpha(80),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Additional details for specific item types
                        if (detail.itemUnit?.id == 2) ...[
                          SizedBox(height: 8),
                          if (detail.weight != null)
                            _mobileDetailLine(
                                "وزن ترازو",
                                detail.weight.toString().seRagham(),
                                AppColor.dividerColor,"گرم",10,11
                            ),
                          if (detail.carat != null)
                            _mobileDetailLine("عیار", "${detail.carat}", AppColor.dividerColor,"",10,11),
                          if (detail.weight750 != null)
                            _mobileDetailLine(
                                "وزن ۷۵۰",
                                "${detail.weight750.toString().seRagham()}",
                                AppColor.dividerColor,"گرم",10,11
                            ),
                          if (detail.impurity != null)
                            _mobileDetailLine(
                                "ناخالصی",
                                "${detail.impurity.toString().seRagham()}",
                                AppColor.dividerColor,"کرم",10,11
                            ),
                        ] else ...[
                          SizedBox(height: 8),
                          if (detail.weight750 != null)
                            _mobileDetailLine(
                                "${detail.weight750.toString().seRagham()} ${detail.itemUnit?.name}",
                                detail.item?.name ?? "",
                                AppColor.dividerColor,"",12,12
                            ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Laboratory info (for specific items)
                        if (detail.item?.id == 1) ...[
                          SizedBox(height: 8),
                          if (detail.laboratory != null) ...[
                            _mobileDetailLine("آزمایشگاه", detail.laboratory!.name ?? "", AppColor.dividerColor,"",10,11),
                            _mobileDetailLine("شماره آزمایشگاه", "${detail.laboratory!.id}", AppColor.dividerColor,"",10,11),
                          ],
                        ],
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 8),
          Divider(height: 0.5, color: AppColor.dividerColor),
          SizedBox(height: 8),
          // Description
          _buildDescriptionInRow(detail.description ?? ""),
        ],
      ),
    );
  }

  // Mobile detail line helper
  Widget _mobileDetailLine(String label, String value, Color color, String? unitValue,double? fontSizeLabel,double? fontSizeBody) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 4,),
          Text(
            "$label: ",
            style: AppTextStyle.bodyText.copyWith(
              fontSize: fontSizeLabel ?? 10,
              color: AppColor.textColor,
            ),
          ),
          Text(
              value,
              style: AppTextStyle.bodyText.copyWith(
                fontSize: fontSizeBody ?? 10,
                color: color,
                fontWeight: FontWeight.bold,
              ),
              textDirection: TextDirection.ltr,
            ),
          SizedBox(width: 3,),
          Text(
            unitValue ?? "",
            style: AppTextStyle.bodyText.copyWith(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.bold,
            ),
            textDirection: TextDirection.ltr,
          ),
        ],
      ),
    );
  }
  Widget _buildDescriptionInRow(String description) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "توضیحات: ",
            style: AppTextStyle.bodyText.copyWith(
              fontSize: 10,
              color: AppColor.textColor,
            ),
          ),
          SizedBox(width: 4),
          Expanded(
            child: Text(
              description,
              style: AppTextStyle.bodyText.copyWith(
                fontSize: 10,
                color: AppColor.textColor,
                fontWeight: FontWeight.bold,
              ),
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
    );
  }
}