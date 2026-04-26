import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/utils/num_display.dart';
import 'package:hanigold_admin/src/widget/custom_appbar1.widget.dart';
import 'package:hanigold_admin/src/widget/empty.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../widget/app_drawer.widget.dart';
import '../../../widget/background_image_total.widget.dart';
import '../../../widget/err_page.dart';
import '../../../widget/pager_widget.dart';
import '../../chat/widget/chat_dialog.widget.dart';
import '../controller/credit_helper.controller.dart';
import '../widget/credit_helper_filter.widget.dart';
import '../widget/credit_helper_create_dialog.widget.dart';
import '../widget/credit_helper_update_dialog.widget.dart';

class CreditHelperListView extends GetView<CreditHelperController> {
  const CreditHelperListView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    return Obx(() => Scaffold(
      appBar: CustomAppbar1(
        title: 'لیست اعتبارسنجی',
        onBackTap: () => Get.toNamed("/home"),
      ),
      drawer: const AppDrawer(),
      body: Stack(
        children: [
          BackgroundImageTotal(),
          SafeArea(
            child: controller.state.value == PageState.loading
                ? Center(
              child: CircularProgressIndicator(),
            )
                : controller.state.value == PageState.list
                ? SizedBox(
              height: Get.height,
              width: Get.width,
              child: SingleChildScrollView(
                controller: isDesktop ? null : controller.scrollControllerMobile,
                child: Column(
                  children: [
                    //فیلد جستجو
                    isDesktop ? SizedBox.shrink() :
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      height: 41,
                      child: TextFormField(
                        controller: controller.accountNameController,
                        style: AppTextStyle.labelText,
                        textInputAction: TextInputAction.search,
                        onEditingComplete: () async {
                          await controller.getCreditHelperListPager();
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
                                  controller.getCreditHelperListPager();
                                },
                                icon: Icon(
                                  Icons.search,
                                  color: AppColor.textColor,
                                  size: 30,
                                )),
                            suffixIcon: IconButton(
                              onPressed: controller.clearSearch,
                              icon: Icon(Icons.close, color: AppColor.textColor),
                            )
                        ),
                      ),
                    ),
                    isDesktop ?
                    Container(
                      margin: EdgeInsets.only(left: 30,right: 30, top: 5,bottom: 30),
                      padding: EdgeInsets.only(left: 20,right: 20, top: 5, bottom: 40),
                      color: AppColor.backGroundColor1.withAlpha(150),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        controller: controller.scrollController,
                        physics: ClampingScrollPhysics(),
                        child: Row(
                          children: [
                            SingleChildScrollView(
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric( vertical: 5),
                                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: 400,
                                          child: TextFormField(
                                            controller: controller.accountNameController,
                                            style: AppTextStyle.labelText,
                                            textInputAction: TextInputAction.search,
                                            onEditingComplete: () async {
                                              await controller.getCreditHelperListPager();
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
                                                      controller.getCreditHelperListPager();
                                                    },
                                                    icon: Icon(
                                                      Icons.search,
                                                      color: AppColor.textColor,
                                                      size: 30,
                                                    )),
                                                suffixIcon: IconButton(
                                                  onPressed: controller.clearSearch,
                                                  icon: Icon(Icons.close, color: AppColor.textColor),
                                                )
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Row(
                                          children: [
                                            // ایجاد اعتبار جدید
                                            TextButton.icon(
                                              onPressed: () {
                                                Get.dialog(
                                                  const CreditHelperCreateDialogWidget(),
                                                  barrierDismissible: false,
                                                );
                                              },
                                              icon: SvgPicture.asset(
                                                'assets/svg/add-plus.svg',
                                                height: 24,
                                              ),
                                              label: Text(
                                                'ایجاد اعتبار جدید',
                                                style: AppTextStyle
                                                    .labelText.copyWith(fontSize: 12),
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            // Filter Widget
                                            CreditHelperFilterWidget(
                                              controller: controller,
                                              onFilterApplied: () {
                                                controller.getCreditHelperListPager();
                                              },
                                              onFilterCleared: () {
                                                controller.getCreditHelperListPager();
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  DataTable(
                                    columns:
                                    buildDataColumns(),
                                    sortColumnIndex: controller
                                        .sortColumnIndex
                                        .value,
                                    sortAscending: controller
                                        .sortAscending
                                        .value,
                                    border: TableBorder.symmetric(inside: BorderSide(color: AppColor.textColor,width: 0.3),
                                      outside: BorderSide(color: AppColor.textColor,width: 0.3),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    dividerThickness: 0.3,
                                    rows: buildDataRows(
                                        context),
                                    dataRowMaxHeight: double.infinity,
                                    headingRowColor: WidgetStatePropertyAll(AppColor.buttonColor.withAlpha(40)),
                                    headingRowHeight: 35,
                                    columnSpacing: 30,
                                    horizontalMargin: 5,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ):
                    _buildMobileCreditHelperList(context),
                  ],
                ),
              ),
            ) :
            controller.state.value == PageState.empty ?
                EmptyPage(
                  tryText: "ایجاد اعتبار جدید",
                  callback: (){
                    Get.dialog(
                      const CreditHelperCreateDialogWidget(),
                      barrierDismissible: false,
                    );
                  },
                )
                : Center(
              child: ErrPage(
                callback: () {
                  controller.clearSearch();
                  controller.getCreditHelperListPager();
                },
                title: "خطا در لیست اعتبارسنجی",
                des: 'برای دریافت لیست اعتبارسنجی مجددا تلاش کنید',
              ),
            ),
          ),
          isDesktop ?
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Pagination
              controller.paginated.value!=null?   Container(
                  height: 70,
                  margin: EdgeInsets.symmetric(horizontal: 50,vertical: 10),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.bottomCenter,
                  child:PagerWidget(countPage: controller.paginated.value?.totalCount??0, callBack: (int index) {
                    controller.isChangePage(index);
                  },)):SizedBox(),
            ],
          ): SizedBox.shrink(),
        ],
      ),
      floatingActionButton:isDesktop ? FloatingActionButton(
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

  List<DataColumn> buildDataColumns() {
    return [
      DataColumn(
        label: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 60),
            child: Text('ردیف',
                style: AppTextStyle.labelText)),
        headingRowAlignment: MainAxisAlignment.center,
      ),
      DataColumn(
        label: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 120),
            child: Text('نام حساب',
                style: AppTextStyle.labelText.copyWith(fontSize: 11))),
        headingRowAlignment: MainAxisAlignment.center,
      ),
      DataColumn(
        label: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 120),
            child: Text('آیتم',
                style: AppTextStyle.labelText.copyWith(fontSize: 11))),
        headingRowAlignment: MainAxisAlignment.center,
      ),
      DataColumn(
        label: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 100),
            child: Text('نوع',
                style: AppTextStyle.labelText.copyWith(fontSize: 11))),
        headingRowAlignment: MainAxisAlignment.center,
      ),
      DataColumn(
        label: Row(
          children: [
            Text('مقدار',
                style: AppTextStyle.labelText.copyWith(fontSize: 11)),
          ],
        ),
        headingRowAlignment: MainAxisAlignment.center,
        onSort: (columnIndex, ascending){
          controller.onSort(columnIndex, ascending);
        },
      ),
      DataColumn(
        label: Row(
          children: [
            Text('فعال',
                style: AppTextStyle.labelText.copyWith(fontSize: 11)),
          ],
        ),
        headingRowAlignment: MainAxisAlignment.center,
        onSort: (columnIndex, ascending){
          controller.onSort(columnIndex, ascending);
        },
      ),
      DataColumn(
        label: Row(
          children: [
            Text('تاریخ شروع',
                style: AppTextStyle.labelText.copyWith(fontSize: 11)),
          ],
        ),
        headingRowAlignment: MainAxisAlignment.center,
        onSort: (columnIndex, ascending){
          controller.onSort(columnIndex, ascending);
        },
      ),
      DataColumn(
        label: Row(
          children: [
            Text('تاریخ پایان',
                style: AppTextStyle.labelText.copyWith(fontSize: 11)),
          ],
        ),
        headingRowAlignment: MainAxisAlignment.center,
        onSort: (columnIndex, ascending){
          controller.onSort(columnIndex, ascending);
        },
      ),
      DataColumn(
        label: Row(
          children: [
            Text('توضیحات',
                style: AppTextStyle.labelText.copyWith(fontSize: 11)),
          ],
        ),
        headingRowAlignment: MainAxisAlignment.center,
      ),
      DataColumn(
        label: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 80),
            child: Text('وضعیت',
                style: AppTextStyle.labelText.copyWith(fontSize: 11))),
        headingRowAlignment: MainAxisAlignment.center,
      ),
      DataColumn(
        label: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 120),
            child: Text('عملیات',
                style: AppTextStyle.labelText.copyWith(fontSize: 11))),
        headingRowAlignment: MainAxisAlignment.center,
      ),
    ];
  }

  List<DataRow> buildDataRows(BuildContext context) {
    return controller.creditHelperList.asMap().entries.map((entry) {
      final index = entry.key;
      final creditHelper = entry.value;
      final rowColor = index.isEven
          ? AppColor.backGroundColor
          : AppColor.secondaryColor.withAlpha(100);
      return DataRow(
        color: WidgetStateProperty.all(rowColor),
        cells: [
          // ردیف
          DataCell(
              Center(
                child: Text(
                  "${creditHelper.rowNum ?? ''}",
                  style: AppTextStyle.bodyText,
                ),
              )),
          // نام حساب
          DataCell(Center(
            child: Text(
              "${creditHelper.account?.name ?? ''} ",
              style: AppTextStyle.bodyText
                  .copyWith(color: AppColor.textColor, fontSize: 11),
            ),
          )),
          // آیتم
          DataCell(Center(
            child: Text(
              "${creditHelper.item?.name ?? ''} ",
              style: AppTextStyle.bodyText
                  .copyWith(color: AppColor.textColor, fontSize: 11),
            ),
          )),
          // نوع
          DataCell(Center(
            child: Text(
              "${creditHelper.typeName ?? ''} ",
              style: AppTextStyle.bodyText
                  .copyWith(color: AppColor.textColor, fontSize: 11),
            ),
          )),
          // مقدار
          DataCell(Center(
            child: Text(
              "${creditHelper.amount?.toDisplayString().seRagham() ?? ''} ${creditHelper.item?.itemUnit?.name!=null ? creditHelper.item?.itemUnit?.name : ''}",
              style: AppTextStyle.bodyText
                  .copyWith(color: AppColor.textColor, fontSize: 11),
              textDirection: TextDirection.rtl,
            ),
          )),
          // فعال
          DataCell(Center(
            child: Icon(
              creditHelper.isActive ?? false ? Icons.check_circle : Icons.cancel,
              color: creditHelper.isActive ?? false ? AppColor.primaryColor : AppColor.accentColor,
              size: 20,
            ),
          )),
          // تاریخ شروع
          DataCell(Center(
            child: Text(
              creditHelper.startDate?.toPersianDate(twoDigits: true, showTime: true, timeSeprator: '-') ?? '',
              style: AppTextStyle.bodyText
                  .copyWith(color: AppColor.textColor, fontSize: 11),
            ),
          )),
          // تاریخ پایان
          DataCell(Center(
            child: Text(
              creditHelper.endDate?.toPersianDate(twoDigits: true, showTime: true, timeSeprator: '-') ?? '',
              style: AppTextStyle.bodyText
                  .copyWith(color: AppColor.textColor, fontSize: 11),
            ),
          )),
          // توضیحات
          DataCell(Center(
            child: Text(
              creditHelper.description ?? '',
              style: AppTextStyle.bodyText
                  .copyWith(color: AppColor.textColor, fontSize: 11),
            ),
          )),
          // وضعیت (فعال/غیرفعال)
          DataCell(Center(
            child: Transform.scale(
              scale: 0.80,
              child: Switch(
                value: creditHelper.isActive ?? false,
                onChanged: (value) {
                  controller.updateActiveCreditHelper(creditHelper.id ?? 0, value);
                },
                activeColor: AppColor.primaryColor,
                inactiveThumbColor: AppColor.accentColor,
                activeTrackColor: AppColor.primaryColor.withAlpha(100),
                inactiveTrackColor: AppColor.accentColor.withAlpha(100),
              ),
            ),
          )),
          // عملیات
          DataCell(Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // دکمه ویرایش
                GestureDetector(
                  onTap: () {
                    Get.dialog(
                      CreditHelperUpdateDialogWidget(
                        creditHelperId: creditHelper.id ?? 0,
                      ),
                      barrierDismissible: false,
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: AppColor.primaryColor.withAlpha(20),
                    ),
                    child: Icon(
                      Icons.edit,
                      size: 16,
                      color: AppColor.primaryColor,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                // دکمه حذف
                GestureDetector(
                  onTap: () {
                    controller.deleteCreditHelper(creditHelper.id ?? 0);
                  },
                  child: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: AppColor.accentColor.withAlpha(20),
                    ),
                    child: Icon(
                      Icons.delete,
                      size: 16,
                      color: AppColor.accentColor,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      );
    }).toList();
  }

  Widget _buildMobileCreditHelperList(BuildContext context){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                child: Row(mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // دکمه ایجاد اعتبار جدید
                    GestureDetector(
                      onTap: () {
                        Get.dialog(
                          const CreditHelperCreateDialogWidget(),
                          barrierDismissible: false,
                        );
                      },
                      child: SvgPicture.asset(
                        'assets/svg/add-plus.svg',
                        height: 30,
                      ),
                    ),
                    SizedBox(width: 17),
                    // فیلتر
                    CreditHelperFilterWidget(
                      controller: controller,
                      onFilterApplied: () {
                        controller.getCreditHelperListPager();
                      },
                      onFilterCleared: () {
                        controller.getCreditHelperListPager();
                      },
                    ),
                  ],
                ),
              ),
              Expanded(child: _buildMobileSortHeader()),
            ],
          ),
          SizedBox(height: 10),
          ListView.builder(
            itemCount: controller.creditHelperList.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (ctx, index){
              final creditHelper = controller.creditHelperList[index];
              return Container(
                margin: EdgeInsets.only(bottom: 12),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColor.secondary100Color.withAlpha(200),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColor.textColor.withAlpha(75)),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("${creditHelper.rowNum}", style: AppTextStyle.labelText.copyWith(fontSize: 11, color: AppColor.textColor.withAlpha(230))),
                        SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            creditHelper.account?.name ?? "",
                            style: AppTextStyle.labelText.copyWith(fontSize: 13, fontWeight: FontWeight.bold, color: AppColor.textColor),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // وضعیت فعال/غیرفعال
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text("وضعیت", style: AppTextStyle.labelText.copyWith(fontSize: 11, color: AppColor.textColor)),
                            Transform.scale(
                              scale: 0.75,
                              child: Switch(
                                value: creditHelper.isActive ?? false,
                                onChanged: (value) {
                                  controller.updateActiveCreditHelper(creditHelper.id ?? 0, value);
                                },
                                activeThumbColor: AppColor.primaryColor,
                                inactiveThumbColor: AppColor.accentColor,
                                activeTrackColor: AppColor.primaryColor.withAlpha(100),
                                inactiveTrackColor: AppColor.accentColor.withAlpha(100),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Divider(height: 0.5,color: AppColor.dividerColor),
                    SizedBox(height: 8),
                    // آیتم
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.only(left: 8, right: 8, top: 5,),
                      decoration: BoxDecoration(
                        color: AppColor.dividerColor.withAlpha(20),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFF64748B)),
                      ),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _mobileLine("آیتم:", creditHelper.item?.name ?? "", AppColor.secondary3Color),
                          // نوع
                          _mobileLine("نوع:", creditHelper.typeName ?? "", AppColor.dividerColor),
                        ],
                      ),
                    ),
                    // مقدار
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.only(left: 8, right: 8, top: 5,),
                      decoration: BoxDecoration(
                        color: AppColor.primaryColor.withAlpha(20),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFF64748B)),
                      ),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _mobileLine("مقدار:", "${creditHelper.amount?.toDisplayString().seRagham()} ${creditHelper.item?.itemUnit?.name ?? ''}", AppColor.primaryColor,),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    // تاریخ شروع
                    _mobileLine("تاریخ شروع:", creditHelper.startDate?.toPersianDate(twoDigits: true, showTime: true, timeSeprator: '-') ?? "تعیین نشده", AppColor.textPrimaryColor),
                    // تاریخ پایان
                    _mobileLine("تاریخ پایان:", creditHelper.endDate?.toPersianDate(twoDigits: true, showTime: true, timeSeprator: '-') ?? "تعیین نشده", AppColor.textAccentColor),
                    SizedBox(height: 5),
                    Divider(height: 0.5,color: AppColor.dividerColor),
                    SizedBox(height: 4),
                    // عملیات
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // دکمه ویرایش
                        GestureDetector(
                          onTap: () {
                            Get.dialog(
                              CreditHelperUpdateDialogWidget(
                                creditHelperId: creditHelper.id ?? 0,
                              ),
                              barrierDismissible: false,
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: AppColor.primaryColor.withAlpha(20),
                            ),
                            child: Icon(
                              Icons.edit,
                              size: 20,
                              color: AppColor.primaryColor,
                            ),
                          ),
                        ),
                        // دکمه حذف
                        GestureDetector(
                          onTap: () {
                            controller.deleteCreditHelper(creditHelper.id ?? 0);
                          },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: AppColor.accentColor.withAlpha(20),
                            ),
                            child: Icon(
                              Icons.delete,
                              size: 20,
                              color: AppColor.accentColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMobileSortHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12,),
      decoration: BoxDecoration(
        color: AppColor.appBarColor.withAlpha(80),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColor.textColor.withAlpha(80)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.sort,
            color: AppColor.textColor,
            size: 18,
          ),
          SizedBox(width: 8),
          Text(
            'مرتب‌سازی:',
            style: AppTextStyle.labelText.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColor.textColor,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: controller.sortColumnIndex.value,
                isExpanded: true,
                style: AppTextStyle.labelText.copyWith(
                  fontSize: 11,
                  color: AppColor.textColor,
                ),
                dropdownColor: AppColor.appBarColor,
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: AppColor.textColor,
                ),
                items: [
                  DropdownMenuItem(
                    value: 0,
                    child: Text('ردیف'),
                  ),
                  DropdownMenuItem(
                    value: 1,
                    child: Text('نام حساب'),
                  ),
                  DropdownMenuItem(
                    value: 2,
                    child: Text('آیتم'),
                  ),
                  DropdownMenuItem(
                    value: 3,
                    child: Text('نوع'),
                  ),
                  DropdownMenuItem(
                    value: 4,
                    child: Text('مقدار'),
                  ),
                  DropdownMenuItem(
                    value: 5,
                    child: Text('فعال'),
                  ),
                  DropdownMenuItem(
                    value: 6,
                    child: Text('تاریخ شروع'),
                  ),
                  DropdownMenuItem(
                    value: 7,
                    child: Text('تاریخ پایان'),
                  ),
                ],
                onChanged: (int? newValue) {
                  if (newValue != null) {
                    controller.onSort(newValue, !controller.sortAscending.value);
                  }
                },
              ),
            ),
          ),
          SizedBox(width: 8),
          // Sort direction toggle button
          GestureDetector(
            onTap: () {
              if (controller.sortColumnIndex.value != null) {
                controller.onSort(controller.sortColumnIndex.value!, !controller.sortAscending.value);
              }
            },
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: controller.sortColumnIndex.value != null
                    ? AppColor.primaryColor.withAlpha(30)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: controller.sortColumnIndex.value != null
                      ? AppColor.primaryColor
                      : AppColor.textColor.withAlpha(30),
                  width: 1,
                ),
              ),
              child: Icon(
                controller.sortAscending.value ? Icons.arrow_upward : Icons.arrow_downward,
                size: 16,
                color: controller.sortColumnIndex.value != null
                    ? AppColor.primaryColor
                    : AppColor.textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _mobileLine(String label, String value, Color color, [String? unit]){
    return Padding(
      padding: EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyle.labelText.copyWith(fontSize: 11, color: AppColor.textColor)),
          SizedBox(width: 8),
          Text(value, style: AppTextStyle.labelText.copyWith(fontSize: 12, color: color, fontWeight: FontWeight.bold), textDirection: TextDirection.rtl),
          if (unit != null) ...[
            SizedBox(width: 4),
            Text(unit, style: AppTextStyle.labelText.copyWith(fontSize: 10, color: AppColor.textColor, fontWeight: FontWeight.bold),),
          ],
        ],
      ),
    );
  }
}

