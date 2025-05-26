import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/inventory/controller/inventory.controller.dart';
import 'package:hanigold_admin/src/domain/inventory/model/inventory.model.dart';
import 'package:hanigold_admin/src/widget/custom_appbar1.widget.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../config/repository/url/base_url.dart';
import '../../../widget/background_image_total.widget.dart';
import '../../../widget/custom_appbar.widget.dart';
import '../../../widget/empty.dart';
import '../../../widget/err_page.dart';

class InventoryListView extends StatelessWidget {
  InventoryListView({super.key});

  final InventoryController inventoryController = Get.find<
      InventoryController>();

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    return Scaffold(
      appBar: CustomAppbar1(title: 'لیست دریافت/پرداخت',
        onBackTap: () => Get.offNamed('/home'),
      ),
      body: Stack(
        children: [
          BackgroundImageTotal(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: Get.height,
                width: Get.width,
                child: Column(
                  children: [
                    isDesktop?
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          //فیلد جستجو
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 50,vertical: 10),
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              color: AppColor.appBarColor.withOpacity(0.5),
                              alignment: Alignment.center,
                              height: 80,
                              child: TextFormField(
                                controller: inventoryController.searchController,
                                style: AppTextStyle.labelText,
                                textInputAction: TextInputAction.search,
                                onFieldSubmitted: (value) async {
                                  if (value.isNotEmpty) {
                                    await inventoryController.searchAccounts(value);
                                    showSearchResults(context);
                                  } else {
                                    inventoryController.clearSearch();
                                  }
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
                                        if (inventoryController.searchController
                                            .text.isNotEmpty) {
                                          await inventoryController.searchAccounts(
                                              inventoryController.searchController
                                                  .text
                                          );
                                          showSearchResults(context);
                                        } else {
                                          inventoryController.clearSearch();
                                        }
                                      },
                                      icon: Icon(
                                        Icons.search, color: AppColor.textColor,
                                        size: 30,)
                                  ),
                                  suffixIcon: inventoryController.selectedAccountId
                                      .value > 0
                                      ? IconButton(
                                    onPressed: inventoryController.clearSearch,
                                    icon: Icon(
                                        Icons.close, color: AppColor.textColor),
                                  )
                                      : null,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ) :
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          // فیلد جستجو
                          Row(
                            children: [
                              //فیلد جستجو
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 50,vertical: 10),
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  color: AppColor.appBarColor.withOpacity(0.5),
                                  alignment: Alignment.center,
                                  height: 80,
                                  child: TextFormField(
                                    controller: inventoryController.searchController,
                                    style: AppTextStyle.labelText,
                                    textInputAction: TextInputAction.search,
                                    onFieldSubmitted: (value) async {
                                      if (value.isNotEmpty) {
                                        await inventoryController.searchAccounts(value);
                                        showSearchResults(context);
                                      } else {
                                        inventoryController.clearSearch();
                                      }
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
                                            if (inventoryController.searchController
                                                .text.isNotEmpty) {
                                              await inventoryController.searchAccounts(
                                                  inventoryController.searchController
                                                      .text
                                              );
                                              showSearchResults(context);
                                            } else {
                                              inventoryController.clearSearch();
                                            }
                                          },
                                          icon: Icon(
                                            Icons.search, color: AppColor.textColor,
                                            size: 30,)
                                      ),
                                      suffixIcon: inventoryController.selectedAccountId
                                          .value > 0
                                          ? IconButton(
                                        onPressed: inventoryController.clearSearch,
                                        icon: Icon(
                                            Icons.close, color: AppColor.textColor),
                                      )
                                          : null,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  //دکمه ایجاد دریافت/پرداخت
                                  ElevatedButton(
                                    style: ButtonStyle(
                                        padding: WidgetStatePropertyAll(
                                            EdgeInsets.symmetric(horizontal: 7)),
                                        elevation: WidgetStatePropertyAll(5),
                                        backgroundColor:
                                        WidgetStatePropertyAll(AppColor.buttonColor),
                                        shape: WidgetStatePropertyAll(
                                            RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(5)))),
                                    onPressed: () {
                                      Get.toNamed('/inventoryCreate');
                                    },
                                    child: Text(
                                      'ایجاد دریافت/پرداخت جدید',
                                      style: AppTextStyle.labelText,
                                    ),
                                  ),
                                  SizedBox(width: 5,),
                                  // خروجی اکسل
                                  ElevatedButton(
                                    style: ButtonStyle(
                                        padding: WidgetStatePropertyAll(
                                          EdgeInsets.symmetric(
                                              horizontal: 15,vertical: 7
                                          ),
                                        ),
                                        fixedSize: WidgetStatePropertyAll(Size(100,30)),
                                        elevation: WidgetStatePropertyAll(5),
                                        backgroundColor:
                                        WidgetStatePropertyAll(AppColor.secondary3Color),
                                        shape: WidgetStatePropertyAll(
                                            RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(5)))),
                                    onPressed: () {
                                      inventoryController.exportToExcel();
                                    },
                                    child: Text(
                                      'خروجی اکسل',
                                      style: AppTextStyle.labelText,
                                    ),
                                  ),
                                  SizedBox(width: 5,),
                                  // خروجی pdf
                                  ElevatedButton(
                                    style: ButtonStyle(
                                        padding: WidgetStatePropertyAll(
                                          EdgeInsets.symmetric(
                                              horizontal: 15,vertical: 7
                                          ),
                                        ),
                                        elevation: WidgetStatePropertyAll(5),
                                        fixedSize: WidgetStatePropertyAll(Size(100,30)),
                                        backgroundColor:
                                        WidgetStatePropertyAll(AppColor.secondary3Color),
                                        shape: WidgetStatePropertyAll(
                                            RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(5)))),
                                    onPressed: () {
                                      inventoryController.exportToPdf();
                                    },
                                    child: Text(
                                      'خروجی pdf',
                                      style: AppTextStyle.labelText,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 15,vertical: 8),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                    border: Border.all(color: AppColor.textColor)

                                ),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                        'assets/svg/filter3.svg',
                                        height: 17,
                                        colorFilter:
                                        ColorFilter
                                            .mode(
                                          AppColor
                                              .textColor,
                                          BlendMode
                                              .srcIn,
                                        )),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      'فیلتر',
                                      style: AppTextStyle
                                          .labelText
                                          .copyWith(
                                          fontSize: isDesktop
                                              ? 12
                                              : 10),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Obx(() {
                      if (inventoryController.state.value == PageState.loading) {
                        EasyLoading.show(status: 'دریافت اطلاعات از سرور...');
                        return Center(child: CircularProgressIndicator());
                      } else
                      if (inventoryController.state.value == PageState.empty) {
                        EasyLoading.dismiss();
                        return EmptyPage(
                          title: 'دریافت/پرداختی وجود ندارد',
                          callback: () {
                            inventoryController.fetchInventoryList();
                          },
                        );
                      } else
                      if (inventoryController.state.value == PageState.list) {
                        EasyLoading.dismiss();
                        return
                          isDesktop ?
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 60,vertical: 10),
                            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                            color: AppColor.appBarColor.withOpacity(0.5),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
                                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            //دکمه ایجاد دریافت/پرداخت
                                            ElevatedButton(
                                              style: ButtonStyle(
                                                  padding: WidgetStatePropertyAll(
                                                      EdgeInsets.symmetric(horizontal: 7)),
                                                  elevation: WidgetStatePropertyAll(5),
                                                  backgroundColor:
                                                  WidgetStatePropertyAll(AppColor.buttonColor),
                                                  shape: WidgetStatePropertyAll(
                                                      RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(5)))),
                                              onPressed: () {
                                                Get.toNamed('/inventoryCreate');
                                              },
                                              child: Text(
                                                'ایجاد دریافت/پرداخت جدید',
                                                style: AppTextStyle.labelText,
                                              ),
                                            ),
                                            SizedBox(width: 5,),
                                            // خروجی اکسل
                                            ElevatedButton(
                                              style: ButtonStyle(
                                                  padding: WidgetStatePropertyAll(
                                                    EdgeInsets.symmetric(
                                                        horizontal: 15,vertical: 7
                                                    ),
                                                  ),
                                                  fixedSize: WidgetStatePropertyAll(Size(100,30)),
                                                  elevation: WidgetStatePropertyAll(5),
                                                  backgroundColor:
                                                  WidgetStatePropertyAll(AppColor.secondary3Color),
                                                  shape: WidgetStatePropertyAll(
                                                      RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(5)))),
                                              onPressed: () {
                                                inventoryController.exportToExcel();
                                              },
                                              child: Text(
                                                'خروجی اکسل',
                                                style: AppTextStyle.labelText,
                                              ),
                                            ),
                                            SizedBox(width: 5,),
                                            // خروجی pdf
                                            ElevatedButton(
                                              style: ButtonStyle(
                                                  padding: WidgetStatePropertyAll(
                                                    EdgeInsets.symmetric(
                                                        horizontal: 15,vertical: 7
                                                    ),
                                                  ),
                                                  elevation: WidgetStatePropertyAll(5),
                                                  fixedSize: WidgetStatePropertyAll(Size(100,30)),
                                                  backgroundColor:
                                                  WidgetStatePropertyAll(AppColor.secondary3Color),
                                                  shape: WidgetStatePropertyAll(
                                                      RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(5)))),
                                              onPressed: () {
                                                inventoryController.exportToPdf();
                                              },
                                              child: Text(
                                                'خروجی pdf',
                                                style: AppTextStyle.labelText,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 15,vertical: 8),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(5)),
                                              border: Border.all(color: AppColor.textColor)

                                          ),
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(
                                                  'assets/svg/filter3.svg',
                                                  height: 17,
                                                  colorFilter:
                                                  ColorFilter
                                                      .mode(
                                                    AppColor
                                                        .textColor,
                                                    BlendMode
                                                        .srcIn,
                                                  )),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                'فیلتر',
                                                style: AppTextStyle
                                                    .labelText
                                                    .copyWith(
                                                    fontSize: isDesktop
                                                        ? 12
                                                        : 10),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          SingleChildScrollView(
                                            child: Column(
                                              children: [

                                                DataTable(
                                                  columns: buildDataColumns(),
                                                  rows: buildDataRows(context),
                                                  dataRowMaxHeight: double.infinity,
                                                  dividerThickness: 0.3,
                                                  border: TableBorder.symmetric(
                                                      inside: BorderSide(color: AppColor.textColor,width: 0.3),
                                                      outside: BorderSide(color: AppColor.textColor,width: 0.3),
                                                      borderRadius: BorderRadius.circular(8)
                                                  ),
                                                  //dataRowColor: WidgetStatePropertyAll(AppColor.secondaryColor),
                                                  //headingRowColor: WidgetStatePropertyAll(AppColor.primaryColor.withOpacity(0.2)),
                                                  headingRowHeight: 40,
                                                  columnSpacing: 25,
                                                  horizontalMargin: 6,
                                                ),
                                                buildPaginationControls(),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                            :
                        Expanded(
                          child: ListView.builder(
                            controller: inventoryController.scrollController,
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemCount: inventoryController.inventoryList
                                .length +
                                (inventoryController.hasMore.value ? 1 : 0),
                            itemBuilder: (context, index) {
                              print(inventoryController.inventoryList.length);
                              if (index >=
                                  inventoryController.inventoryList.length) {
                                return inventoryController.hasMore.value
                                    ? Center(child: CircularProgressIndicator())
                                    : SizedBox.shrink();
                              }
                              var inventories = inventoryController
                                  .inventoryList[index];
                              return Obx(() {
                                bool isExpanded = inventoryController
                                    .isItemExpanded(index);
                                return Card(
                                  margin: EdgeInsets.all(8),
                                  color: AppColor.secondaryColor,
                                  elevation: 10,
                                  child: Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceEvenly,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [

                                        ListTile(
                                          title: Column(
                                            children: [
                                              //  تاریخ
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Text(
                                                    inventories.date
                                                        ?.toPersianDate(
                                                        twoDigits: true,
                                                        timeSeprator: '-',
                                                        showTime: true) ?? '',
                                                    style:
                                                    AppTextStyle.bodyText,
                                                  ),
                                                  Card(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius
                                                          .circular(5),
                                                    ),
                                                    color: inventories.type == 1
                                                        ? AppColor.primaryColor
                                                        : AppColor.accentColor,
                                                    margin: EdgeInsets
                                                        .symmetric(
                                                        vertical: 0,
                                                        horizontal: 5),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .all(2),
                                                      child: Text(
                                                          inventories.type == 1
                                                              ? 'دریافت'
                                                              : 'پرداخت',
                                                          style: AppTextStyle
                                                              .labelText,
                                                          textAlign: TextAlign
                                                              .center),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 5,),
                                              SizedBox(child: Divider(
                                                height: 1, color: AppColor
                                                  .dividerColor,),),
                                              SizedBox(height: 8,),
                                              // نام ثبت کننده
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .start,
                                                children: [

                                                  Text('نام ثبت کننده:  ',
                                                    style: AppTextStyle
                                                        .labelText,),
                                                  SizedBox(height: 2,),
                                                  Text(inventories.account
                                                      ?.name ?? "",
                                                    style: AppTextStyle
                                                        .bodyText,),

                                                ],

                                              ),
                                              SizedBox(height: 12,),
                                              // آیکون ها
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  //آیکون اضافه
                                                  GestureDetector(
                                                    onTap: () {
                                                      Get.toNamed(
                                                          '/inventoryDetailInsertReceive',
                                                          arguments: inventories);
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Text(' اضافه',
                                                          style: AppTextStyle
                                                              .labelText
                                                              .copyWith(
                                                              color: AppColor
                                                                  .buttonColor),),
                                                        SvgPicture.asset(
                                                            'assets/svg/add.svg',
                                                            colorFilter: ColorFilter
                                                                .mode(AppColor
                                                                .buttonColor,
                                                              BlendMode.srcIn,)
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  //آیکون حذف
                                                  GestureDetector(
                                                    onTap: () {
                                                      Get.defaultDialog(
                                                        backgroundColor: AppColor
                                                            .backGroundColor,
                                                        title: "حذف ",
                                                        titleStyle: AppTextStyle
                                                            .smallTitleText,
                                                        middleText: "آیا از حذف مطمئن هستید؟",
                                                        middleTextStyle: AppTextStyle
                                                            .bodyText,
                                                        confirm: ElevatedButton(
                                                            style: ButtonStyle(
                                                                backgroundColor: WidgetStatePropertyAll(
                                                                    AppColor
                                                                        .primaryColor)),
                                                            onPressed: () {
                                                              Get.back();
                                                              inventoryController
                                                                  .deleteInventory(
                                                                  inventories
                                                                      .id!,
                                                                  true);
                                                            },
                                                            child: Text(
                                                              'حذف',
                                                              style: AppTextStyle
                                                                  .bodyText,
                                                            )
                                                        ),
                                                      );
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Text(' حذف',
                                                          style: AppTextStyle
                                                              .labelText
                                                              .copyWith(
                                                              color: AppColor
                                                                  .accentColor),),
                                                        SvgPicture.asset(
                                                            'assets/svg/trash-bin.svg',
                                                            colorFilter: ColorFilter
                                                                .mode(AppColor
                                                                .accentColor,
                                                              BlendMode.srcIn,)
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              // فلش نمایش ایتم های دریافت/پرداخت
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .center,
                                                children: [
                                                  IconButton(
                                                    onPressed: () async {
                                                      await inventoryController
                                                          .fetchGetOneInventory(
                                                          inventories.id!);
                                                      inventoryController
                                                          .toggleItemExpansion(
                                                          index);
                                                    },
                                                    icon: Icon(
                                                      isExpanded ? Icons
                                                          .expand_less : Icons
                                                          .expand_more,
                                                      color: isExpanded ?
                                                      AppColor.accentColor :
                                                      AppColor.primaryColor,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                          minVerticalPadding: 5,
                                        ),

                                        // زیر مجموعه دریافت و پرداخت
                                        AnimatedSize(
                                          duration: Duration(
                                              milliseconds: 300),
                                          curve: Curves.easeInOut,
                                          child: isExpanded ?
                                          Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 3),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment
                                                    .start,
                                                mainAxisAlignment: MainAxisAlignment
                                                    .spaceEvenly,
                                                children: [
                                                  SizedBox(height: 8,),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment
                                                        .center,
                                                    children: [
                                                      inventoryController
                                                          .isLoading.value
                                                          ?
                                                      CircularProgressIndicator(
                                                        valueColor: AlwaysStoppedAnimation<
                                                            Color>(
                                                            AppColor.textColor),
                                                      )
                                                          : inventoryController.getOneInventory.value==null ?
                                                            Text(
                                                            'اطلاعاتی موجود نیست',
                                                            style: AppTextStyle
                                                                .labelText):
                                                      Expanded(
                                                        child: ListView.builder(
                                                          shrinkWrap: true,
                                                          physics: NeverScrollableScrollPhysics(),
                                                          itemCount: inventoryController.getOneInventory.value?.inventoryDetails?.length,
                                                          itemBuilder: (context,
                                                              index) {
                                                            var getOneInventories = inventoryController.getOneInventory.value?.inventoryDetails?[index];
                                                            return ListTile(
                                                              title: Card(
                                                                color: AppColor
                                                                    .backGroundColor,
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                      .only(
                                                                      top: 8,
                                                                      left: 12,
                                                                      right: 12,
                                                                      bottom: 8),
                                                                  child: Column(
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment
                                                                            .end,
                                                                        children: [
                                                                          Text(
                                                                            'الصاق تصویر  ',
                                                                            style: AppTextStyle
                                                                                .labelText,),
                                                                          GestureDetector(
                                                                            onTap: () =>
                                                                                inventoryController
                                                                                    .pickImage(
                                                                                    getOneInventories!
                                                                                        .recId
                                                                                        .toString(),
                                                                                    "image",
                                                                                    "Inventory",
                                                                                    inventoryId: inventories
                                                                                        .id!),
                                                                            child: SvgPicture
                                                                                .asset(
                                                                              'assets/svg/camera.svg',
                                                                              width: 25,
                                                                              height: 25,
                                                                              colorFilter: ColorFilter
                                                                                  .mode(
                                                                                  AppColor
                                                                                      .iconViewColor,
                                                                                  BlendMode
                                                                                      .srcIn),),

                                                                          ),
                                                                          Obx(() {
                                                                            if (inventoryController
                                                                                .isUploading
                                                                                .value) {
                                                                              return CircularProgressIndicator();
                                                                            }
                                                                            return Wrap(
                                                                              children: inventoryController
                                                                                  .selectedImages
                                                                                  .asMap()
                                                                                  .entries
                                                                                  .map((
                                                                                  entry) =>
                                                                                  Chip(
                                                                                    label: Text(
                                                                                        'تصویر ${entry
                                                                                            .key +
                                                                                            1}'),
                                                                                    deleteIcon: inventoryController
                                                                                        .uploadStatuses[entry
                                                                                        .key]
                                                                                        ? Icon(
                                                                                        Icons
                                                                                            .check)
                                                                                        : Icon(
                                                                                        Icons
                                                                                            .close),
                                                                                    onDeleted: () {},
                                                                                  ))
                                                                                  .toList(),
                                                                            );
                                                                          }),
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        height: 10,),
                                                                      // آیتم- مقدار
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment
                                                                            .spaceBetween,
                                                                        children: [
                                                                          Row(
                                                                            children: [
                                                                              Text(
                                                                                  ' آیتم: ',
                                                                                  style: AppTextStyle
                                                                                      .labelText),
                                                                              Text(
                                                                                  getOneInventories
                                                                                      ?.item
                                                                                      ?.name ??
                                                                                      "",
                                                                                  style: AppTextStyle
                                                                                      .bodyText),
                                                                            ],
                                                                          ),
                                                                          SizedBox(
                                                                            width: 4,),
                                                                          Row(
                                                                            children: [
                                                                              Text(
                                                                                  ' مقدار: ',
                                                                                  style: AppTextStyle
                                                                                      .bodyText
                                                                              ),
                                                                              Text(
                                                                                  '${getOneInventories
                                                                                      ?.quantity ??
                                                                                      0} ${getOneInventories
                                                                                      ?.itemUnit
                                                                                      ?.name ??
                                                                                      ""}',
                                                                                  style: AppTextStyle
                                                                                      .bodyText
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        height: 8,),
                                                                      // عیار - وزن750- ناخالصی
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment
                                                                            .spaceBetween,
                                                                        children: [
                                                                          Row(
                                                                            children: [
                                                                              Text(
                                                                                  ' عیار: ',
                                                                                  style: AppTextStyle
                                                                                      .labelText),
                                                                              Text(
                                                                                  '${getOneInventories
                                                                                      ?.carat ??
                                                                                      0}',
                                                                                  style: AppTextStyle
                                                                                      .bodyText),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Text(
                                                                                  ' وزن 750: ',
                                                                                  style: AppTextStyle
                                                                                      .labelText),
                                                                              Text(
                                                                                  '${getOneInventories
                                                                                      ?.weight750 ??
                                                                                      0} گرم ',
                                                                                  style: AppTextStyle
                                                                                      .bodyText),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Text(
                                                                                  '  ناخالصی: ',
                                                                                  style: AppTextStyle
                                                                                      .labelText),
                                                                              Text(
                                                                                  '${getOneInventories
                                                                                      ?.impurity ??
                                                                                      0} گرم ',
                                                                                  style: AppTextStyle
                                                                                      .bodyText),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        height: 4,),
                                                                      Divider(
                                                                        height: 1,
                                                                        color: AppColor
                                                                            .secondaryColor,),
                                                                      SizedBox(
                                                                        height: 5,),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment
                                                                            .spaceBetween,
                                                                        children: [
                                                                          // نمایش عکس
                                                                          GestureDetector(
                                                                            onTap: () {
                                                                              if (getOneInventories
                                                                                  ?.attachments ==
                                                                                  null ||
                                                                                  getOneInventories!
                                                                                      .attachments!
                                                                                      .isEmpty) {
                                                                                Get
                                                                                    .snackbar(
                                                                                    'پیغام',
                                                                                    'تصویری ثبت نشده است');
                                                                                return;
                                                                              }

                                                                              showDialog(
                                                                                context: context,
                                                                                builder: (
                                                                                    BuildContext context) {
                                                                                  return Dialog(
                                                                                    backgroundColor: AppColor
                                                                                        .backGroundColor,
                                                                                    shape: RoundedRectangleBorder(
                                                                                      borderRadius: BorderRadius
                                                                                          .circular(
                                                                                          10),
                                                                                    ),
                                                                                    child: Container(
                                                                                      padding: EdgeInsets
                                                                                          .all(
                                                                                          8),
                                                                                      child: Column(
                                                                                        mainAxisSize: MainAxisSize
                                                                                            .min,
                                                                                        children: [
                                                                                          // نمایش اسلایدی عکس‌ها
                                                                                          SizedBox(
                                                                                            width: 500,
                                                                                            height: 500,
                                                                                            child: Stack(
                                                                                              children: [
                                                                                                PageView
                                                                                                    .builder(
                                                                                                  controller: inventoryController
                                                                                                      .pageController,
                                                                                                  itemCount: getOneInventories
                                                                                                      .attachments!
                                                                                                      .length,
                                                                                                  onPageChanged: (
                                                                                                      index) =>
                                                                                                  inventoryController
                                                                                                      .currentImagePage
                                                                                                      .value =
                                                                                                      index,
                                                                                                  itemBuilder: (
                                                                                                      context,
                                                                                                      index) {
                                                                                                    final attachment = getOneInventories
                                                                                                        .attachments![index];
                                                                                                    return Image
                                                                                                        .network(
                                                                                                      "${BaseUrl
                                                                                                          .baseUrl}Attachment/downloadAttachment?fileName=${attachment
                                                                                                          .guidId}",
                                                                                                      loadingBuilder: (
                                                                                                          context,
                                                                                                          child,
                                                                                                          loadingProgress) {
                                                                                                        if (loadingProgress ==
                                                                                                            null)
                                                                                                          return child;
                                                                                                        return Center(
                                                                                                          child: CircularProgressIndicator(),
                                                                                                        );
                                                                                                      },
                                                                                                      errorBuilder: (
                                                                                                          context,
                                                                                                          error,
                                                                                                          stackTrace) =>
                                                                                                          Icon(
                                                                                                              Icons
                                                                                                                  .error,
                                                                                                              color: Colors
                                                                                                                  .red),
                                                                                                      fit: BoxFit.contain,
                                                                                                    );
                                                                                                  },
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                          SizedBox(
                                                                                            height: 2,),
                                                                                          // نمایش نقاط راهنما
                                                                                          Obx(() =>
                                                                                              Row(
                                                                                                mainAxisAlignment: MainAxisAlignment
                                                                                                    .center,
                                                                                                children: List
                                                                                                    .generate(
                                                                                                  getOneInventories
                                                                                                      .attachments!
                                                                                                      .length,
                                                                                                      (
                                                                                                      index) =>
                                                                                                      Container(
                                                                                                        width: 8,
                                                                                                        height: 8,
                                                                                                        margin: EdgeInsets
                                                                                                            .symmetric(
                                                                                                            horizontal: 4),
                                                                                                        decoration: BoxDecoration(
                                                                                                          shape: BoxShape
                                                                                                              .circle,
                                                                                                          color: inventoryController
                                                                                                              .currentImagePage
                                                                                                              .value ==
                                                                                                              index
                                                                                                              ? Colors
                                                                                                              .blue
                                                                                                              : Colors
                                                                                                              .grey,
                                                                                                        ),
                                                                                                      ),
                                                                                                ),
                                                                                              )),

                                                                                          SizedBox(
                                                                                              height: 10),
                                                                                          TextButton(
                                                                                            onPressed: () =>
                                                                                                Get
                                                                                                    .back(),
                                                                                            child: Text(
                                                                                              "بستن",
                                                                                              style: AppTextStyle
                                                                                                  .bodyText,),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  );
                                                                                },
                                                                              );
                                                                            },
                                                                            child: Row(
                                                                              children: [
                                                                                Text(
                                                                                  'عکس‌ها (${getOneInventories
                                                                                      ?.attachments
                                                                                      ?.length ??
                                                                                      0}) ',
                                                                                  style: AppTextStyle
                                                                                      .bodyText
                                                                                      .copyWith(
                                                                                      color: AppColor
                                                                                          .iconViewColor
                                                                                  ),
                                                                                ),
                                                                                SizedBox(
                                                                                  width: 25,
                                                                                  height: 25,
                                                                                  child: SvgPicture
                                                                                      .asset(
                                                                                    'assets/svg/picture.svg',
                                                                                    colorFilter: ColorFilter
                                                                                        .mode(
                                                                                      AppColor
                                                                                          .iconViewColor,
                                                                                      BlendMode
                                                                                          .srcIn,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          //  آیکون ویرایش
                                                                          GestureDetector(
                                                                            onTap: () {
                                                                              getOneInventories?.type==1 ?
                                                                              Get.toNamed('/inventoryDetailUpdateReceive', arguments: getOneInventories):
                                                                              Get.toNamed('/inventoryDetailUpdatePayment', arguments: getOneInventories);
                                                                            },
                                                                            child: Row(
                                                                              children: [
                                                                                Text(
                                                                                  'ویرایش  ',
                                                                                  style: AppTextStyle
                                                                                      .bodyText
                                                                                      .copyWith(
                                                                                      color: AppColor
                                                                                          .iconViewColor),),
                                                                                Container(
                                                                                  width: 25,
                                                                                  height: 25,
                                                                                  child: SvgPicture
                                                                                      .asset(
                                                                                      'assets/svg/edit.svg',
                                                                                      colorFilter: ColorFilter
                                                                                          .mode(
                                                                                        AppColor
                                                                                            .iconViewColor,
                                                                                        BlendMode
                                                                                            .srcIn,)
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          // آیکون حذف

                                                                          GestureDetector(
                                                                            onTap: () {
                                                                              Get
                                                                                  .defaultDialog(
                                                                                  backgroundColor: AppColor
                                                                                      .backGroundColor,
                                                                                  title: "حذف واریزی",
                                                                                  titleStyle: AppTextStyle
                                                                                      .smallTitleText,
                                                                                  middleText: "آیا از حذف واریزی مطمئن هستید؟",
                                                                                  middleTextStyle: AppTextStyle
                                                                                      .bodyText,
                                                                                  confirm: ElevatedButton(
                                                                                      style: ButtonStyle(
                                                                                          backgroundColor: WidgetStatePropertyAll(
                                                                                              AppColor
                                                                                                  .primaryColor)),
                                                                                      onPressed: () {
                                                                                        Get.back();
                                                                                        getOneInventories?.type==1 ?
                                                                                        inventoryController.updateDeleteInventoryReceive(
                                                                                            inventories.id!,
                                                                                            getOneInventories!.id!, 3,0,
                                                                                            inventories.account!.id!,
                                                                                          getOneInventories.wallet!.id!,
                                                                                            getOneInventories.item!.id!,
                                                                                          getOneInventories.quantity!,
                                                                                        )
                                                                                            : inventoryController.updateDeleteInventoryPayment(
                                                                                            inventories.id!,
                                                                                            getOneInventories!.id!, 3,1,
                                                                                            inventories.account!.id!,
                                                                                          getOneInventories.wallet!.id!,
                                                                                          getOneInventories.item!.id!,
                                                                                          getOneInventories.quantity!,
                                                                                        );
                                                                                      },
                                                                                      child: Text(
                                                                                        'حذف',
                                                                                        style: AppTextStyle
                                                                                            .bodyText,
                                                                                      )));
                                                                            },
                                                                            child: Row(
                                                                              children: [
                                                                                Text(
                                                                                  'حذف  ',
                                                                                  style: AppTextStyle
                                                                                      .bodyText
                                                                                      .copyWith(
                                                                                      color: AppColor
                                                                                          .accentColor),),
                                                                                Container(
                                                                                  width: 25,
                                                                                  height: 25,
                                                                                  child: SvgPicture
                                                                                      .asset(
                                                                                      'assets/svg/trash-bin.svg',
                                                                                      colorFilter: ColorFilter
                                                                                          .mode(
                                                                                        AppColor
                                                                                            .accentColor,
                                                                                        BlendMode
                                                                                            .srcIn,)
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              )
                                          ) : SizedBox.shrink(),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                            },
                          ),
                        );
                      }
                      EasyLoading.dismiss();
                      return ErrPage(
                        callback: () {
                          inventoryController.fetchInventoryList();
                        },
                        title: "خطا در دریافت",
                        des: 'مجددا تلاش کنید',
                      );
                    })
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showSearchResults(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(backgroundColor: AppColor.backGroundColor,
            title: Text('انتخاب کنید', style: AppTextStyle.smallTitleText,),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: inventoryController.searchedAccounts.length,
                itemBuilder: (context, index) {
                  final account = inventoryController.searchedAccounts[index];
                  return ListTile(
                    title: Text(account.name ?? '',
                      style: AppTextStyle.bodyText.copyWith(fontSize: 15),),
                    onTap: () => inventoryController.selectAccount(account),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: Text('بستن', style: AppTextStyle.bodyText,),
              ),
            ],
          ),
    );
  }

  Widget buildListItem(BuildContext context, int index) {
    /* if (index >= withdrawController.withdrawList.length) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: withdrawController.hasMore.value
              ? CircularProgressIndicator()
              : SizedBox.shrink(),
        ),
      );
    }*/

    var inventories = inventoryController.inventoryList[index];
    return Obx(() {
      bool isExpanded = inventoryController.isItemExpanded(index);
      return Card(
        margin: EdgeInsets.all(12),
        color: AppColor.secondaryColor,
        elevation: 10,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Column(
                  children: [

                    //  تاریخ
                    Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceBetween,
                      children: [
                        Text(
                          inventories.date!.toPersianDate(
                              twoDigits: true, timeSeprator: '-'),
                          style:
                          AppTextStyle.bodyText,
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          color: inventories.type == 1
                              ? AppColor.primaryColor
                              : AppColor.accentColor,
                          margin: EdgeInsets.symmetric(
                              vertical: 0, horizontal: 5),
                          child: Padding(
                            padding: const EdgeInsets.all(2),
                            child: Text(
                                inventories.type == 1
                                    ? 'دریافت'
                                    : 'پرداخت',
                                style: AppTextStyle.labelText,
                                textAlign: TextAlign.center),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5,),
                    SizedBox(child: Divider(
                      height: 1, color: AppColor.dividerColor,),),
                    SizedBox(height: 8,),
                    // نام ثبت کننده
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [

                        Text('نام ثبت کننده:  ',
                          style: AppTextStyle
                              .labelText,),
                        SizedBox(height: 2,),
                        Text(inventories.account!.name ?? "",
                          style: AppTextStyle
                              .bodyText,),

                      ],

                    ),
                    SizedBox(height: 12,),
                    // آیکون ها
                    Row(mainAxisAlignment: MainAxisAlignment
                        .spaceBetween,
                      children: [
                        //آیکون اضافه
                        GestureDetector(
                          onTap: () {
                            inventories.type==1 ?
                            Get.toNamed('/inventoryDetailInsertReceive', arguments: inventories):
                            Get.toNamed('/inventoryDetailInsertPayment', arguments: inventories);
                          },
                          child: Row(
                            children: [
                              Text(' اضافه',
                                style: AppTextStyle
                                    .labelText
                                    .copyWith(
                                    color: AppColor
                                        .buttonColor),),
                              SvgPicture.asset(
                                  'assets/svg/add.svg',
                                  colorFilter: ColorFilter
                                      .mode(AppColor
                                      .buttonColor,
                                    BlendMode.srcIn,)
                              ),
                            ],
                          ),
                        ),
                        //آیکون حذف
                        GestureDetector(
                          onTap: () {
                            Get.defaultDialog(
                              backgroundColor: AppColor
                                  .backGroundColor,
                              title: "حذف ",
                              titleStyle: AppTextStyle
                                  .smallTitleText,
                              middleText: "آیا از حذف مطمئن هستید؟",
                              middleTextStyle: AppTextStyle
                                  .bodyText,
                              confirm: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor: WidgetStatePropertyAll(
                                          AppColor.primaryColor)),
                                  onPressed: () {
                                    Get.back();
                                    inventoryController.deleteInventory(
                                        inventories.id!, true);
                                  },
                                  child: Text(
                                    'حذف', style: AppTextStyle.bodyText,
                                  )
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              Text(' حذف',
                                style: AppTextStyle
                                    .labelText
                                    .copyWith(
                                    color: AppColor
                                        .accentColor),),
                              SvgPicture.asset(
                                  'assets/svg/trash-bin.svg',
                                  colorFilter: ColorFilter
                                      .mode(AppColor
                                      .accentColor,
                                    BlendMode.srcIn,)
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // فلش نمایش ایتم های دریافت/پرداخت
                    Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () async {
                            await inventoryController.fetchGetOneInventory(inventories.id!);
                            inventoryController.toggleItemExpansion(index);
                          },
                          icon: Icon(
                            isExpanded ? Icons.expand_less : Icons.expand_more,
                            color: isExpanded ?
                            AppColor.accentColor :
                            AppColor.primaryColor,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                minVerticalPadding: 5,
              ),
              AnimatedSize(
                duration: Duration(
                    milliseconds: 300),
                curve: Curves.easeInOut,
                child: isExpanded ?
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 1),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment
                          .start,
                      mainAxisAlignment: MainAxisAlignment
                          .spaceEvenly,
                      children: [
                        SizedBox(height: 8,),
                    inventoryController.getOneInventory.value==null ?
                        Center(child: CircularProgressIndicator()) :
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: inventoryController.getOneInventory.value?.inventoryDetails?.length,
                          itemBuilder: (context, index) {
                            var getOneInventories = inventoryController.getOneInventory.value?.inventoryDetails?[index];
                            return ListTile(
                              title: Card(
                                color: AppColor.backGroundColor,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8,
                                      left: 12,
                                      right: 12,
                                      bottom: 8),
                                  child: Column(
                                    children: [
                                      Row(mainAxisAlignment: MainAxisAlignment
                                          .end,
                                        children: [
                                          Text('الصاق تصویر  ',
                                            style: AppTextStyle.labelText,),
                                          GestureDetector(
                                            onTap: () =>
                                                inventoryController.pickImage(
                                                    getOneInventories!.recId
                                                        .toString(), "image",
                                                    "Inventory",
                                                    inventoryId: inventories
                                                        .id!),
                                            child: SvgPicture.asset(
                                              'assets/svg/camera.svg',
                                              width: 25,
                                              height: 25,
                                              colorFilter: ColorFilter.mode(
                                                  AppColor.iconViewColor,
                                                  BlendMode.srcIn),),

                                          ),
                                          Obx(() {
                                            if (inventoryController.isUploading
                                                .value) {
                                              return CircularProgressIndicator();
                                            }
                                            return Wrap(
                                              children: inventoryController
                                                  .selectedImages
                                                  .asMap()
                                                  .entries
                                                  .map((entry) =>
                                                  Chip(
                                                    label: Text(
                                                        'تصویر ${entry.key +
                                                            1}'),
                                                    deleteIcon: inventoryController
                                                        .uploadStatuses[entry
                                                        .key]
                                                        ? Icon(Icons.check)
                                                        : Icon(Icons.close),
                                                    onDeleted: () {},
                                                  ))
                                                  .toList(),
                                            );
                                          }),
                                        ],
                                      ),
                                      SizedBox(height: 10,),
                                      // آیتم- مقدار
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                  ' آیتم: ',
                                                  style: AppTextStyle
                                                      .labelText),
                                              Text(
                                                  getOneInventories?.item
                                                      ?.name ?? "",
                                                  style: AppTextStyle
                                                      .bodyText),
                                            ],
                                          ),
                                          SizedBox(
                                            width: 4,),
                                          Row(
                                            children: [
                                              Text(
                                                  ' مقدار: ',
                                                  style: AppTextStyle
                                                      .bodyText
                                              ),
                                              Text(
                                                  '${getOneInventories
                                                      ?.quantity ??
                                                      0} ${getOneInventories
                                                      ?.itemUnit?.name ?? ""}',
                                                  style: AppTextStyle
                                                      .bodyText
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8,),
                                      // عیار - وزن750- ناخالصی
                                      Row(mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                  ' عیار: ',
                                                  style: AppTextStyle
                                                      .labelText),
                                              Text(
                                                  '${getOneInventories?.carat ??
                                                      0}',
                                                  style: AppTextStyle
                                                      .bodyText),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                  ' وزن 750: ',
                                                  style: AppTextStyle
                                                      .labelText),
                                              Text(
                                                  '${getOneInventories
                                                      ?.weight750 ?? 0} گرم ',
                                                  style: AppTextStyle
                                                      .bodyText),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                  '  ناخالصی: ',
                                                  style: AppTextStyle
                                                      .labelText),
                                              Text(
                                                  '${getOneInventories
                                                      ?.impurity ?? 0} گرم ',
                                                  style: AppTextStyle
                                                      .bodyText),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 4,),
                                      Divider(
                                        height: 1,
                                        color: AppColor
                                            .secondaryColor,),
                                      SizedBox(
                                        height: 5,),
                                      Row(mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween,
                                        children: [
                                          // نمایش عکس
                                          GestureDetector(
                                            onTap: () {
                                              if (getOneInventories
                                                  ?.attachments == null ||
                                                  getOneInventories!
                                                      .attachments!.isEmpty) {
                                                Get.snackbar('پیغام',
                                                    'تصویری ثبت نشده است');
                                                return;
                                              }

                                              showDialog(
                                                context: context,
                                                builder: (
                                                    BuildContext context) {
                                                  return Dialog(
                                                    backgroundColor: AppColor
                                                        .backGroundColor,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius
                                                          .circular(10),
                                                    ),
                                                    child: Container(
                                                      padding: EdgeInsets.all(
                                                          8),
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize
                                                            .min,
                                                        children: [
                                                          // نمایش اسلایدی عکس‌ها
                                                          SizedBox(
                                                            height: 300,
                                                            child: PageView
                                                                .builder(
                                                              controller: inventoryController
                                                                  .pageController,
                                                              itemCount: getOneInventories
                                                                  .attachments!
                                                                  .length,
                                                              onPageChanged: (
                                                                  index) =>
                                                              inventoryController
                                                                  .currentImagePage
                                                                  .value =
                                                                  index,
                                                              itemBuilder: (
                                                                  context,
                                                                  index) {
                                                                final attachment = getOneInventories
                                                                    .attachments![index];
                                                                return Image
                                                                    .network(
                                                                  "${BaseUrl
                                                                      .baseUrl}Attachment/downloadAttachment?fileName=${attachment
                                                                      .guidId}",
                                                                  loadingBuilder: (
                                                                      context,
                                                                      child,
                                                                      loadingProgress) {
                                                                    if (loadingProgress ==
                                                                        null)
                                                                      return child;
                                                                    return Center(
                                                                      child: CircularProgressIndicator(),
                                                                    );
                                                                  },
                                                                  errorBuilder: (
                                                                      context,
                                                                      error,
                                                                      stackTrace) =>
                                                                      Icon(Icons
                                                                          .error,
                                                                          color: Colors
                                                                              .red),
                                                                  fit: BoxFit.contain,
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                          SizedBox(height: 2,),
                                                          // نمایش نقاط راهنما
                                                          Obx(() =>
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment
                                                                    .center,
                                                                children: List
                                                                    .generate(
                                                                  getOneInventories
                                                                      .attachments!
                                                                      .length,
                                                                      (index) =>
                                                                      Container(
                                                                        width: 8,
                                                                        height: 8,
                                                                        margin: EdgeInsets
                                                                            .symmetric(
                                                                            horizontal: 4),
                                                                        decoration: BoxDecoration(
                                                                          shape: BoxShape
                                                                              .circle,
                                                                          color: inventoryController
                                                                              .currentImagePage
                                                                              .value ==
                                                                              index
                                                                              ? Colors
                                                                              .blue
                                                                              : Colors
                                                                              .grey,
                                                                        ),
                                                                      ),
                                                                ),
                                                              )),

                                                          SizedBox(height: 10),
                                                          TextButton(
                                                            onPressed: () =>
                                                                Get.back(),
                                                            child: Text("بستن",
                                                              style: AppTextStyle
                                                                  .bodyText,),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: Row(
                                              children: [
                                                Text(
                                                  'عکس‌ها (${getOneInventories
                                                      ?.attachments?.length ??
                                                      0}) ',
                                                  style: AppTextStyle.bodyText
                                                      .copyWith(
                                                      color: AppColor
                                                          .iconViewColor
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 25,
                                                  height: 25,
                                                  child: SvgPicture.asset(
                                                    'assets/svg/picture.svg',
                                                    colorFilter: ColorFilter
                                                        .mode(
                                                      AppColor.iconViewColor,
                                                      BlendMode.srcIn,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          //  آیکون ویرایش
                                          GestureDetector(
                                            onTap: () {
                                              getOneInventories?.type==1 ?
                                              Get.toNamed('/inventoryDetailUpdateReceive', arguments: getOneInventories):
                                              Get.toNamed('/inventoryDetailUpdatePayment', arguments: getOneInventories);

                                            },
                                            child: Row(
                                              children: [
                                                Text('ویرایش  ',
                                                  style: AppTextStyle.bodyText
                                                      .copyWith(color: AppColor
                                                      .iconViewColor),),
                                                Container(
                                                  width: 25,
                                                  height: 25,
                                                  child: SvgPicture
                                                      .asset(
                                                      'assets/svg/edit.svg',
                                                      colorFilter: ColorFilter
                                                          .mode(
                                                        AppColor
                                                            .iconViewColor,
                                                        BlendMode
                                                            .srcIn,)
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // آیکون حذف

                                          GestureDetector(
                                            onTap: () {
                                              Get.defaultDialog(
                                                  backgroundColor: AppColor
                                                      .backGroundColor,
                                                  title: "حذف واریزی",
                                                  titleStyle: AppTextStyle
                                                      .smallTitleText,
                                                  middleText: "آیا از حذف واریزی مطمئن هستید؟",
                                                  middleTextStyle: AppTextStyle
                                                      .bodyText,
                                                  confirm: ElevatedButton(
                                                      style: ButtonStyle(
                                                          backgroundColor: WidgetStatePropertyAll(
                                                              AppColor
                                                                  .primaryColor)),
                                                      onPressed: () {
                                                        Get.back();
                                                        getOneInventories?.type==1 ?
                                                        inventoryController.updateDeleteInventoryReceive(
                                                            inventories.id!,
                                                            getOneInventories!.id!, 3,0,
                                                            inventories.account!.id!,
                                                          getOneInventories.wallet!.id!,
                                                          getOneInventories.item!.id!,
                                                          getOneInventories.quantity!,
                                                        )
                                                            : inventoryController.updateDeleteInventoryPayment(
                                                            inventories.id!,
                                                            getOneInventories!.id!, 3,1,
                                                            inventories.account!.id!,
                                                          getOneInventories.wallet!.id!,
                                                          getOneInventories.item!.id!,
                                                          getOneInventories.quantity!,
                                                        );
                                                      },
                                                      child: Text(
                                                        'حذف',
                                                        style: AppTextStyle
                                                            .bodyText,
                                                      )));
                                            },
                                            child: Row(
                                              children: [
                                                Text('حذف  ',
                                                  style: AppTextStyle.bodyText
                                                      .copyWith(color: AppColor
                                                      .accentColor),),
                                                Container(
                                                  width: 25,
                                                  height: 25,
                                                  child: SvgPicture
                                                      .asset(
                                                      'assets/svg/trash-bin.svg',
                                                      colorFilter: ColorFilter
                                                          .mode(
                                                        AppColor
                                                            .accentColor,
                                                        BlendMode
                                                            .srcIn,)
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                      ],
                    )
                ) : SizedBox(),
              ),
            ],
          ),
        ),
      );
    });
  }

  List<DataColumn> buildDataColumns() {
    return [
      DataColumn(label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
          child: Text('ردیف', style: AppTextStyle.labelText)),headingRowAlignment:MainAxisAlignment.center ),
      DataColumn(
          onSort: (columnIndex, desc) {
            inventoryController.sortByDate(columnIndex, desc);
            inventoryController.setSort(columnIndex,desc);
          },
          label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
              child: Text('تاریخ', style: AppTextStyle.labelText)),
          headingRowAlignment: MainAxisAlignment.center
      ),
      DataColumn(
          label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
              child: Text('نام ثبت کننده', style: AppTextStyle.labelText)),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
              child: Text('محصول', style: AppTextStyle.labelText)),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
              child: Text('مقدار', style: AppTextStyle.labelText)),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
              child: Text('شرح', style: AppTextStyle.labelText)),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
              child: Text('دریافت/پرداخت', style: AppTextStyle.labelText)),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
              child: Text('الصاق تصاویر', style: AppTextStyle.labelText)),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
              child: Text('نمایش تصاویر', style: AppTextStyle.labelText)),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
              child: Text('عملیات', style: AppTextStyle.labelText)),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
              child: Text('اطلاعات کامل', style: AppTextStyle.labelText)),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
          child: Text('مانده سکه', style: AppTextStyle.labelText)),headingRowAlignment:MainAxisAlignment.center ),
      DataColumn(label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
          child: Text('مانده ریالی', style: AppTextStyle.labelText)),headingRowAlignment:MainAxisAlignment.center ),
      DataColumn(label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
          child: Text('مانده طلایی', style: AppTextStyle.labelText)),headingRowAlignment:MainAxisAlignment.center ),
    ];
  }

  List<DataRow> buildDataRows(BuildContext context) {
    return inventoryController.inventoryList.map((inventory) {
      //print(" تسسسسسسسست ${inventory.inventoryDetails?.first.itemUnit?.name}");
      return DataRow(
        cells: [
          // ردیف
          DataCell(
              Center(
                child: Row(
                  children: [
                    Checkbox(
                      value: inventory.registered ?? false,
                      onChanged: (value) async{
                        if (value != null) {
                          //EasyLoading.show(status: 'لطفا منتظر بمانید');
                          await inventoryController.updateRegistered(
                              inventory.id!,
                              value
                          );
                        }
                        inventoryController.fetchInventoryList();
                        //EasyLoading.dismiss();
                      },
                    ),
                    SizedBox(width: 5,),
                    Text(
                      "${inventory.rowNum}",
                      style: AppTextStyle.labelText,
                    ),
                  ],
                ),
              )),
          // تاریخ
          DataCell(
              Center(
                child: Text(
                  inventory.date?.toPersianDate(twoDigits: true, showTime: true, timeSeprator: '-') ?? 'نامشخص',
                  style: AppTextStyle.bodyText,
                ),
              )),
          // نام ثبت کننده
          DataCell(
              Center(
                child: Text(inventory.account?.name ?? "",
                    style: AppTextStyle.bodyText),
              )),
          // محصول
          DataCell(
              Center(
                child: Row(
                  children: [
                    Image.network('${BaseUrl.baseUrl}Attachment/downloadResource?fileName=${inventory.inventoryDetails!.first.item?.icon}',
                      width: 35,
                      height: 35,),
                    SizedBox(width: 5,),
                    Text(
                      inventory.inventoryDetails?.isNotEmpty == true
                          ? inventory.inventoryDetails!.first.item?.name ?? ""
                          : "",
                      style: AppTextStyle.bodyText,
                    ),
                  ],
                ),
              )
          ),
          // مقدار
          DataCell(
              Center(
                child: Text(
                    inventory.inventoryDetails?.first !=null
                        ? '${inventory.inventoryDetails!.first.quantity ?? 0} ${inventory.inventoryDetails!.first.itemUnit?.name ?? ""}'
                        : "",
                    style: AppTextStyle.bodyText.copyWith(color: AppColor.primaryColor,fontWeight: FontWeight.bold)
                ),
              )
          ),
          // شرح
          DataCell(
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceBetween,
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      color: AppColor.textColor,
                      child: Column(
                        children: [
                          Container(padding: EdgeInsets.all(2),
                            child: Row(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                        ' عیار: ',
                                        style: AppTextStyle
                                            .labelText.copyWith(color: AppColor.appBarColor,fontWeight: FontWeight.bold)),
                                    Text(inventory.inventoryDetails?.first !=null ?
                                        '${inventory.inventoryDetails?.first
                                            .carat ?? 0}' : "",
                                        style: AppTextStyle
                                            .bodyText.copyWith(
                                            color: AppColor.iconViewColor)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                        ' وزن 750: ',
                                        style: AppTextStyle
                                            .labelText.copyWith(color: AppColor.appBarColor,fontWeight: FontWeight.bold)),
                                    Text(inventory.inventoryDetails?.first !=null ?
                                        '${inventory.inventoryDetails?.first
                                            .weight750 ?? 0} گرم ' : "",
                                        style: AppTextStyle
                                            .bodyText.copyWith(
                                            color: AppColor.iconViewColor)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                        '  ناخالصی: ',
                                        style: AppTextStyle
                                            .labelText.copyWith(color: AppColor.appBarColor,fontWeight: FontWeight.bold)),
                                    Text(inventory.inventoryDetails?.first !=null ?
                                        '${inventory.inventoryDetails?.first
                                            .impurity ?? 0} گرم ' : "",
                                        style: AppTextStyle
                                            .bodyText.copyWith(
                                            color: AppColor.iconViewColor)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(padding: EdgeInsets.all(2),
                            child: Row(
                              children: [
                                Text(
                                    ' آزمایشگاه: ',
                                    style: AppTextStyle
                                        .labelText.copyWith(color: AppColor.appBarColor,fontWeight: FontWeight.bold)),
                                Text(inventory.inventoryDetails?.first !=null ?
                                    inventory.inventoryDetails?.first.laboratory
                                        ?.name ?? "" : "",
                                    style: AppTextStyle
                                        .bodyText.copyWith(
                                        color: AppColor.iconViewColor)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(padding: EdgeInsets.only(bottom: 10),
                      child: Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              ' توضیحات: ',
                              style: AppTextStyle
                                  .labelText),
                          Text(inventory.inventoryDetails?.first !=null ?
                              inventory.inventoryDetails?.first.description ??
                                  '' : "",
                              style: AppTextStyle
                                  .bodyText.copyWith(
                                  color: AppColor.iconViewColor)),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
          // دریافت/پرداخت
          DataCell(
              Center(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius
                        .circular(5),
                  ),
                  color: inventory.type == 1
                      ? AppColor.primaryColor
                      : AppColor.accentColor,
                  margin: EdgeInsets
                      .symmetric(
                      vertical: 0,
                      horizontal: 5),
                  child: Padding(
                    padding: const EdgeInsets
                        .all(4),
                    child: Text(
                        inventory.type == 1
                            ? 'دریافت'
                            : 'پرداخت',
                        style: AppTextStyle
                            .labelText,
                        textAlign: TextAlign
                            .center),
                  ),
                ),
              )),
          // الصاق تصاویر
          DataCell(
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () =>
                          inventoryController.pickImageDesktop(
                              inventory.inventoryDetails!.first.recId
                                  .toString(), "image", "Inventory",
                              inventoryId: inventory.id!),
                      child: Container(
                        constraints: BoxConstraints(maxWidth: 100),
                        child: SvgPicture
                            .asset(
                          'assets/svg/camera.svg',
                          width: 25,
                          height: 25,
                          colorFilter: ColorFilter
                              .mode(
                              AppColor
                                  .iconViewColor,
                              BlendMode
                                  .srcIn),),
                      ),

                    ),
                    Obx(() {
                      if (inventoryController
                          .isUploadingDesktop
                          .value) {
                        return CircularProgressIndicator();
                      }
                      return Wrap(
                        children: inventoryController.selectedImagesDesktop
                            .asMap()
                            .entries
                            .map((entry) =>
                            Chip(label: Text(
                                'تصویر ${entry.key + 1}'),
                              deleteIcon: inventoryController
                                  .uploadStatusesDesktop[entry.key]
                                  ? Icon(Icons.check)
                                  : Icon(Icons.close),
                              onDeleted: () {},
                            ))
                            .toList(),
                      );
                    }),
                  ],
                ),
              )),
          // نمایش تصاویر
          DataCell(
            GestureDetector(
              onTap: () {
                if (inventory.inventoryDetails?.first.attachments == null ||
                    inventory.inventoryDetails!.first.attachments!.isEmpty) {
                  Get
                      .snackbar(
                      'پیغام',
                      'تصویری ثبت نشده است');
                  return;
                }

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      backgroundColor: AppColor
                          .backGroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius
                            .circular(
                            10),
                      ),
                      child: Container(
                        padding: EdgeInsets
                            .all(
                            8),
                        child: Column(
                          mainAxisSize: MainAxisSize
                              .min,
                          children: [
                            // نمایش اسلایدی عکس‌ها
                            SizedBox(
                              width: 500,
                              height: 500,
                              child: Stack(
                                children: [
                                  PageView.builder(
                                    controller: inventoryController
                                        .pageController,
                                    itemCount: inventory.inventoryDetails?.first
                                        .attachments!.length,
                                    onPageChanged: (index) =>
                                    inventoryController
                                        .currentImagePage
                                        .value =
                                        index,
                                    itemBuilder: (context,
                                        index) {
                                      final attachment = inventory
                                          .inventoryDetails
                                          ?.first.attachments![index];
                                      return Image
                                          .network(
                                        "${BaseUrl
                                            .baseUrl}Attachment/downloadAttachment?fileName=${attachment
                                            ?.guidId}",
                                        loadingBuilder: (context,
                                            child,
                                            loadingProgress) {
                                          if (loadingProgress ==
                                              null)
                                            return child;
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        },
                                        errorBuilder: (context,
                                            error,
                                            stackTrace) =>
                                            Icon(
                                                Icons
                                                    .error,
                                                color: Colors
                                                    .red),
                                        fit: BoxFit.contain,
                                      );
                                    },
                                  ),
                                  SizedBox(
                                    height: 2,),
                                  Obx(() {
                                    return Positioned(
                                        left: 10,
                                        top: 0,
                                        bottom: 0,
                                        child: Visibility(
                                          visible: inventoryController
                                              .currentImagePage.value > 0,
                                          child: IconButton(
                                            style: ButtonStyle(
                                              backgroundColor: WidgetStateProperty
                                                  .all(Colors.black54),
                                              shape: WidgetStateProperty.all(
                                                  CircleBorder()),
                                              padding: WidgetStateProperty.all(
                                                  EdgeInsets.all(8)),
                                            ),
                                            icon: Icon(Icons.chevron_left,
                                              color: Colors.white,
                                              size: 40,
                                              shadows: [
                                                Shadow(
                                                  blurRadius: 10,
                                                  color: Colors.black,
                                                  offset: Offset(0, 0),
                                                )
                                              ],
                                            ),
                                            onPressed: () {
                                              inventoryController.pageController
                                                  .previousPage(
                                                duration: Duration(
                                                    milliseconds: 300),
                                                curve: Curves.easeInOut,
                                              );
                                            },
                                          ),
                                        )
                                    );
                                  }),
                                  Obx(() {
                                    return Positioned(
                                        right: 10,
                                        top: 0,
                                        bottom: 0,
                                        child: Visibility(
                                          visible: inventoryController
                                              .currentImagePage.value <
                                              (inventory.inventoryDetails?.first
                                                  .attachments!.length ?? 1) -
                                                  1,
                                          child: IconButton(
                                            style: ButtonStyle(
                                              backgroundColor: WidgetStateProperty
                                                  .all(Colors.black54),
                                              shape: WidgetStateProperty.all(
                                                  CircleBorder()),
                                              padding: WidgetStateProperty.all(
                                                  EdgeInsets.all(8)),
                                            ),
                                            icon: Icon(Icons.chevron_right,
                                              color: Colors.white,
                                              size: 40,
                                              shadows: [
                                                Shadow(
                                                  blurRadius: 10,
                                                  color: Colors.black,
                                                  offset: Offset(0, 0),
                                                ),
                                              ],
                                            ),
                                            onPressed: () {
                                              inventoryController.pageController
                                                  .nextPage(
                                                duration: Duration(
                                                    milliseconds: 300),
                                                curve: Curves.easeInOut,
                                              );
                                            },
                                          ),
                                        )
                                    );
                                  }),
                                  SizedBox(
                                    height: 2,),
                                  // نمایش نقاط راهنما
                                  Obx(() =>
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .center,
                                        children: List
                                            .generate(
                                          inventory.inventoryDetails!.first
                                              .attachments!.length,
                                              (index) =>
                                              Container(
                                                width: 8,
                                                height: 8,
                                                margin: EdgeInsets
                                                    .symmetric(
                                                    horizontal: 4),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape
                                                      .circle,
                                                  color: inventoryController
                                                      .currentImagePage
                                                      .value ==
                                                      index
                                                      ? Colors
                                                      .blue
                                                      : Colors
                                                      .grey,
                                                ),
                                              ),
                                        ),
                                      )),
                                  SizedBox(
                                      height: 10),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () =>
                                  Get
                                      .back(),
                              child: Text(
                                "بستن",
                                style: AppTextStyle
                                    .bodyText,),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: SvgPicture
                        .asset(
                      'assets/svg/picture.svg',
                      colorFilter: ColorFilter
                          .mode(
                        AppColor
                            .iconViewColor,
                        BlendMode
                            .srcIn,
                      ),
                    ),
                  ),
                  SizedBox(width: 2,),
                  Text(
                    'عکس‌ها (${inventory.inventoryDetails?.first.attachments
                        ?.length ?? 0}) ',
                    style: AppTextStyle
                        .bodyText
                        .copyWith(
                        color: AppColor
                            .iconViewColor
                    ),
                  ),
                ],
              ),
            ),
          ),
          // آیکون های عملیات
          DataCell(
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //آیکون اضافه
                  GestureDetector(
                    onTap: () {
                      inventory.type==1 ?
                      Get.toNamed('/inventoryDetailInsertReceive', arguments: inventory ) :
                      Get.toNamed('/inventoryDetailInsertPayment', arguments: inventory );
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset(
                            'assets/svg/add.svg',
                            colorFilter: ColorFilter
                                .mode(AppColor
                                .buttonColor,
                              BlendMode.srcIn,)
                        ),
                        Text(' اضافه',
                          style: AppTextStyle
                              .labelText
                              .copyWith(
                              color: AppColor
                                  .buttonColor),),
                      ],
                    ),
                  ),
                  //آیکون حذف
                  GestureDetector(
                    onTap: () {
                      Get.defaultDialog(
                        backgroundColor: AppColor
                            .backGroundColor,
                        title: "حذف ",
                        titleStyle: AppTextStyle
                            .smallTitleText,
                        middleText: "آیا از حذف مطمئن هستید؟",
                        middleTextStyle: AppTextStyle
                            .bodyText,
                        confirm: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                                    AppColor.primaryColor)),
                            onPressed: () {
                              Get.back();
                              inventoryController.deleteInventory(
                                  inventory.id!, true);
                            },
                            child: Text(
                              'حذف', style: AppTextStyle.bodyText,
                            )
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset(
                            'assets/svg/trash-bin.svg',
                            colorFilter: ColorFilter
                                .mode(AppColor
                                .accentColor,
                              BlendMode.srcIn,)
                        ),
                        Text(' حذف',
                          style: AppTextStyle
                              .labelText
                              .copyWith(
                              color: AppColor
                                  .accentColor),),
                      ],
                    ),
                  ),
                  // آیکون ویرایش
                  GestureDetector(
                    onTap: () async{

                        inventoryController.fetchGetOneInventoryForUpdate(inventory.id ?? 0);

                    },
                    child: Row(
                      children: [
                        Container(
                          width: 25,
                          height: 25,
                          child: SvgPicture
                              .asset(
                              'assets/svg/edit.svg',
                              colorFilter: ColorFilter
                                  .mode(
                                AppColor
                                    .iconViewColor,
                                BlendMode
                                    .srcIn,)
                          ),
                        ),
                        Text('ویرایش  ', style: AppTextStyle.labelText.copyWith(
                            color: AppColor.iconViewColor),),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // نمایش کامل واریزی
          DataCell(
            Center(
              child: inventory.inventoryDetailsCount == 1 ?
              SizedBox(width: 100,)
                  :
              SizedBox(
                width: 130,
                child: TextButton(
                  child: Text(
                    'نمایش اطلاعات کامل', style: AppTextStyle.bodyText,),
                  onPressed: () {
                    showInventoryDetailsModal(inventory);
                    inventoryController.fetchGetOneInventory(inventory.id!);
                  },
                ),
              ),
            ),
          ),
          // مانده سکه
          DataCell(
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      inventory.balances!=null ?
                      Column(
                        children: inventory.balances!.map((e)=>
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(left: 2),
                                  child: e.unitName=="عدد"? Text( "${e.balance}",style:e.balance!>0 ?
                                  AppTextStyle.bodyText.copyWith(fontSize: 12,color: AppColor.primaryColor,fontWeight: FontWeight.bold) :
                                  AppTextStyle.bodyText.copyWith(fontSize: 12,color: AppColor.accentColor,fontWeight: FontWeight.bold),
                                    textDirection: TextDirection.ltr,
                                  ):SizedBox(),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 2),
                                  child: e.unitName=="عدد"? Text( "${e.unitName}",style:e.balance!>0 ?
                                  AppTextStyle.bodyText.copyWith(fontSize: 12,color: AppColor.primaryColor) :
                                  AppTextStyle.bodyText.copyWith(fontSize: 12,color: AppColor.accentColor),
                                    textDirection: TextDirection.ltr,
                                  ):SizedBox(),
                                ),
                                Container(
                                  child: e.unitName=="عدد"? Text( "${e.itemName}",style:e.balance!>0 ?
                                  AppTextStyle.bodyText.copyWith(fontSize: 12,color: AppColor.primaryColor) :
                                  AppTextStyle.bodyText.copyWith(fontSize: 12,color: AppColor.accentColor),
                                    textDirection: TextDirection.ltr,
                                  ):SizedBox(),
                                ),
                              ],
                            )).toList(),
                      ) : SizedBox.shrink(),

                    ],
                  ),
                ),
              )
          ),
          // مانده ریالی
          DataCell(
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Center(
                  child:
                      inventory.balances!=null ?
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:
                    inventory.balances!.map((e)=>
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 2),
                              child: e.unitName=="ریال"? Text( "${e.balance?.toInt().toString().seRagham(separator: ',')}",style:e.balance!>0 ?
                              AppTextStyle.bodyText.copyWith(fontSize: 12,color: AppColor.primaryColor,fontWeight: FontWeight.bold) :
                              AppTextStyle.bodyText.copyWith(fontSize: 12,color: AppColor.accentColor,fontWeight: FontWeight.bold),
                                textDirection: TextDirection.ltr,
                              ):SizedBox(),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 2),
                              child: e.unitName=="ریال"? Text( "${e.unitName}",style:e.balance!>0 ?
                              AppTextStyle.bodyText.copyWith(fontSize: 12,color: AppColor.primaryColor) :
                              AppTextStyle.bodyText.copyWith(fontSize: 12,color: AppColor.accentColor),
                                textDirection: TextDirection.ltr,
                              ):SizedBox(),
                            ),
                            Container(
                              child: e.unitName=="ریال"? Text( "${e.itemName}",style:e.balance!>0 ?
                              AppTextStyle.bodyText.copyWith(fontSize: 12,color: AppColor.primaryColor) :
                              AppTextStyle.bodyText.copyWith(fontSize: 12,color: AppColor.accentColor),
                                textDirection: TextDirection.ltr,
                              ):SizedBox(),
                            ),
                          ],
                        )).toList(),
                  ) : SizedBox.shrink(),
                ),
              )
          ),
          // مانده طلایی
          DataCell(
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Center(
                  child:
                      inventory.balances!=null ?
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: inventory.balances!.map((e)=>
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 2),
                              child: e.unitName=="گرم"? Text( "${e.balance}",style:e.balance!>0 ?
                              AppTextStyle.bodyText.copyWith(fontSize: 12,color: AppColor.primaryColor,fontWeight: FontWeight.bold) :
                              AppTextStyle.bodyText.copyWith(fontSize: 12,color: AppColor.accentColor,fontWeight: FontWeight.bold),
                                textDirection: TextDirection.ltr,
                              ):SizedBox(),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 2),
                              child: e.unitName=="گرم"? Text( "${e.unitName}",style:e.balance!>0 ?
                              AppTextStyle.bodyText.copyWith(fontSize: 12,color: AppColor.primaryColor) :
                              AppTextStyle.bodyText.copyWith(fontSize: 12,color: AppColor.accentColor),
                                textDirection: TextDirection.ltr,
                              ):SizedBox(),
                            ),
                            Container(
                              child: e.unitName=="گرم"? Text( "${e.itemName}",style:e.balance!>0 ?
                              AppTextStyle.bodyText.copyWith(fontSize: 12,color: AppColor.primaryColor) :
                              AppTextStyle.bodyText.copyWith(fontSize: 12,color: AppColor.accentColor),
                                textDirection: TextDirection.ltr,
                              ):SizedBox(),
                            ),
                          ],
                        )).toList(),
                  ) : SizedBox.shrink(),
                ),
              )
          ),
        ],
      );
    }).toList();
  }

  void showInventoryDetailsModal(InventoryModel inventory) {
    Get.dialog(
      Dialog(
        backgroundColor: AppColor.backGroundColor,
        insetPadding: EdgeInsets.all(20),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 800,
            maxHeight: Get.height * 0.9,
          ),
          child: Column(
            children: [
              buildInventoryDetail(inventory),
              Spacer(),
              TextButton(
                onPressed: () =>
                    Get.back(),
                child: Text("بستن", style: AppTextStyle.bodyText,),
              ),
              SizedBox(height: 15,),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInventoryDetail(InventoryModel inventory) {
    return Obx(() {
      if (inventoryController.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }
      return
        inventoryController.isLoading.value ?
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<
              Color>(
              AppColor.textColor),
        ) :
        // لیست deposit request مربوط به هر درخواست برداشت
        SizedBox(
          height: Get.height * 0.8, // تعیین ارتفاع ثابت
          width: Get.width * 0.8,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 12,),
                Text('لیست دریافت/پرداخت', style: AppTextStyle.smallTitleText),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: Get.height * 0.7,
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: inventoryController.getOneInventory.value?.inventoryDetails?.length,
                    itemBuilder: (context,
                        index) {
                      var getOneInventories = inventoryController.getOneInventory.value?.inventoryDetails?[index];
                      return ListTile(
                        title: Card(
                          elevation: 5,
                          color: AppColor
                              .backGroundColor,
                          child: Padding(
                            padding: const EdgeInsets
                                .only(
                                top: 8,
                                left: 12,
                                right: 12,
                                bottom: 8),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    Text(
                                      inventoryController.getOneInventory.value?.date?.toPersianDate(twoDigits: true, showTime: true, timeSeprator: '-') ?? 'نامشخص',
                                      style: AppTextStyle.bodyText,
                                    ),
                                    GestureDetector(
                                      onTap: () =>
                                          inventoryController
                                              .pickImageDesktop(
                                              getOneInventories!
                                                  .recId
                                                  .toString(),
                                              "image",
                                              "Inventory",
                                              inventoryId: inventory
                                                  .id!),
                                      child: Row(
                                        children: [
                                          Text(
                                            'الصاق تصویر  ',
                                            style: AppTextStyle.labelText.copyWith(color: AppColor.iconViewColor),),
                                          SvgPicture
                                                .asset(
                                              'assets/svg/camera.svg',
                                              width: 25,
                                              height: 25,
                                              colorFilter: ColorFilter
                                                  .mode(
                                                  AppColor
                                                      .iconViewColor,
                                                  BlendMode
                                                      .srcIn),),
                                        ],
                                      ),
                                    ),
                                    Obx(() {
                                      if (inventoryController
                                          .isUploadingDesktop
                                          .value) {
                                        return CircularProgressIndicator();
                                      }
                                      return Wrap(
                                        children: inventoryController
                                            .selectedImagesDesktop
                                            .asMap()
                                            .entries
                                            .map((entry) =>
                                            Chip(
                                              label: Text(
                                                  'تصویر ${entry
                                                      .key +
                                                      1}'),
                                              deleteIcon: inventoryController
                                                  .uploadStatusesDesktop[entry
                                                  .key]
                                                  ? Icon(
                                                  Icons
                                                      .check)
                                                  : Icon(
                                                  Icons
                                                      .close),
                                              onDeleted: () {},
                                            ))
                                            .toList(),
                                      );
                                    }),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,),
                                // آیتم- مقدار
                                Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                            ' آیتم: ',
                                            style: AppTextStyle
                                                .labelText),
                                        Text(
                                            getOneInventories
                                                ?.item
                                                ?.name ??
                                                "",
                                            style: AppTextStyle
                                                .bodyText),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 4,),
                                    Row(
                                      children: [
                                        Text(
                                            ' مقدار: ',
                                            style: AppTextStyle
                                                .bodyText
                                        ),
                                        Text(
                                            '${getOneInventories
                                                ?.quantity ??
                                                0} ${getOneInventories
                                                ?.itemUnit
                                                ?.name ??
                                                ""}',
                                            style: AppTextStyle
                                                .bodyText
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 8,),
                                // عیار - وزن750- ناخالصی
                                Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                            ' عیار: ',
                                            style: AppTextStyle
                                                .labelText),
                                        Text(
                                            '${getOneInventories
                                                ?.carat ??
                                                0}',
                                            style: AppTextStyle
                                                .bodyText),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                            ' وزن 750: ',
                                            style: AppTextStyle
                                                .labelText),
                                        Text(
                                            '${getOneInventories
                                                ?.weight750 ??
                                                0} گرم ',
                                            style: AppTextStyle
                                                .bodyText),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                            '  ناخالصی: ',
                                            style: AppTextStyle
                                                .labelText),
                                        Text(
                                            '${getOneInventories
                                                ?.impurity ??
                                                0} گرم ',
                                            style: AppTextStyle
                                                .bodyText),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 4,),
                                Divider(
                                  height: 1,
                                  color: AppColor
                                      .secondaryColor,),
                                SizedBox(
                                  height: 5,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    // نمایش عکس
                                    GestureDetector(
                                      onTap: () {
                                        if (getOneInventories
                                            ?.attachments ==
                                            null ||
                                            getOneInventories!
                                                .attachments!
                                                .isEmpty) {
                                          Get
                                              .snackbar(
                                              'پیغام',
                                              'تصویری ثبت نشده است');
                                          return;
                                        }
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Dialog(
                                              backgroundColor: AppColor
                                                  .backGroundColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius
                                                    .circular(
                                                    10),
                                              ),
                                              child: Container(
                                                padding: EdgeInsets
                                                    .all(
                                                    8),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize
                                                      .min,
                                                  children: [
                                                    // نمایش اسلایدی عکس‌ها
                                                    SizedBox(
                                                      width: 500,
                                                      height: 500,
                                                      child: Stack(
                                                        children: [
                                                          PageView
                                                              .builder(
                                                            controller: inventoryController
                                                                .pageController,
                                                            itemCount: getOneInventories
                                                                .attachments!
                                                                .length,
                                                            onPageChanged: (
                                                                index) =>
                                                            inventoryController
                                                                .currentImagePage
                                                                .value =
                                                                index,
                                                            itemBuilder: (
                                                                context,
                                                                index) {
                                                              final attachment = getOneInventories
                                                                  .attachments![index];
                                                              return Image.network(
                                                                "${BaseUrl
                                                                    .baseUrl}Attachment/downloadAttachment?fileName=${attachment
                                                                    .guidId}",
                                                                loadingBuilder: (
                                                                    context,
                                                                    child,
                                                                    loadingProgress) {
                                                                  if (loadingProgress ==
                                                                      null) {
                                                                    return child;
                                                                  }
                                                                  return Center(
                                                                    child: CircularProgressIndicator(),
                                                                  );
                                                                },
                                                                errorBuilder: (
                                                                    context,
                                                                    error,
                                                                    stackTrace) =>
                                                                    Icon(
                                                                        Icons
                                                                            .error,
                                                                        color: Colors
                                                                            .red),
                                                                fit: BoxFit.contain,
                                                              );
                                                            },
                                                          ),
                                                          SizedBox(
                                                            height: 2,),
                                                          Obx(() {
                                                            return Positioned(
                                                                left: 10,
                                                                top: 0,
                                                                bottom: 0,
                                                                child: Visibility(
                                                                  visible: inventoryController
                                                                      .currentImagePage
                                                                      .value >
                                                                      0,
                                                                  child: IconButton(
                                                                    style: ButtonStyle(
                                                                      backgroundColor: WidgetStateProperty
                                                                          .all(
                                                                          Colors
                                                                              .black54),
                                                                      shape: WidgetStateProperty
                                                                          .all(
                                                                          CircleBorder()),
                                                                      padding: WidgetStateProperty
                                                                          .all(
                                                                          EdgeInsets
                                                                              .all(
                                                                              8)),
                                                                    ),
                                                                    icon: Icon(
                                                                      Icons
                                                                          .chevron_left,
                                                                      color: Colors
                                                                          .white,
                                                                      size: 40,
                                                                      shadows: [
                                                                        Shadow(
                                                                          blurRadius: 10,
                                                                          color: Colors
                                                                              .black,
                                                                          offset: Offset(
                                                                              0,
                                                                              0),
                                                                        )
                                                                      ],
                                                                    ),
                                                                    onPressed: () {
                                                                      inventoryController
                                                                          .pageController
                                                                          .previousPage(
                                                                        duration: Duration(
                                                                            milliseconds: 300),
                                                                        curve: Curves
                                                                            .easeInOut,
                                                                      );
                                                                    },
                                                                  ),
                                                                )
                                                            );
                                                          }),
                                                          Obx(() {
                                                            return Positioned(
                                                                right: 10,
                                                                top: 0,
                                                                bottom: 0,
                                                                child: Visibility(
                                                                  visible: inventoryController.currentImagePage.value < (getOneInventories.attachments?.length ?? 1) - 1,
                                                                  child: IconButton(
                                                                    style: ButtonStyle(
                                                                      backgroundColor: WidgetStateProperty
                                                                          .all(
                                                                          Colors
                                                                              .black54),
                                                                      shape: WidgetStateProperty
                                                                          .all(
                                                                          CircleBorder()),
                                                                      padding: WidgetStateProperty
                                                                          .all(
                                                                          EdgeInsets
                                                                              .all(
                                                                              8)),
                                                                    ),
                                                                    icon: Icon(
                                                                      Icons
                                                                          .chevron_right,
                                                                      color: Colors
                                                                          .white,
                                                                      size: 40,
                                                                      shadows: [
                                                                        Shadow(
                                                                          blurRadius: 10,
                                                                          color: Colors
                                                                              .black,
                                                                          offset: Offset(
                                                                              0,
                                                                              0),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    onPressed: () {
                                                                      inventoryController
                                                                          .pageController
                                                                          .nextPage(
                                                                        duration: Duration(
                                                                            milliseconds: 300),
                                                                        curve: Curves
                                                                            .easeInOut,
                                                                      );
                                                                    },
                                                                  ),
                                                                )
                                                            );
                                                          }),
                                                          SizedBox(
                                                            height: 2,),
                                                          // نمایش نقاط راهنما
                                                          Obx(() =>
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment
                                                                    .center,
                                                                children: List
                                                                    .generate(
                                                                  getOneInventories
                                                                      .attachments!
                                                                      .length,
                                                                      (index) =>
                                                                      Container(
                                                                        width: 8,
                                                                        height: 8,
                                                                        margin: EdgeInsets
                                                                            .symmetric(
                                                                            horizontal: 4),
                                                                        decoration: BoxDecoration(
                                                                          shape: BoxShape
                                                                              .circle,
                                                                          color: inventoryController
                                                                              .currentImagePage
                                                                              .value ==
                                                                              index
                                                                              ? Colors
                                                                              .blue
                                                                              : Colors
                                                                              .grey,
                                                                        ),
                                                                      ),
                                                                ),
                                                              )),
                                                          SizedBox(
                                                              height: 10),
                                                        ],
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed: () =>
                                                          Get
                                                              .back(),
                                                      child: Text(
                                                        "بستن",
                                                        style: AppTextStyle
                                                            .bodyText,),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            'عکس‌ها (${getOneInventories
                                                ?.attachments
                                                ?.length ??
                                                0}) ',
                                            style: AppTextStyle
                                                .bodyText
                                                .copyWith(
                                                color: AppColor
                                                    .iconViewColor
                                            ),
                                          ),
                                          SizedBox(
                                            width: 25,
                                            height: 25,
                                            child: SvgPicture
                                                .asset(
                                              'assets/svg/picture.svg',
                                              colorFilter: ColorFilter
                                                  .mode(
                                                AppColor
                                                    .iconViewColor,
                                                BlendMode
                                                    .srcIn,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    //  آیکون ویرایش
                                    GestureDetector(
                                      onTap: () {
                                        getOneInventories?.type==1 ?
                                        Get.toNamed('/inventoryDetailUpdateReceive', arguments: getOneInventories):
                                        Get.toNamed('/inventoryDetailUpdatePayment', arguments: getOneInventories);
                                      },
                                      child: Row(
                                        children: [
                                          Text('ویرایش  ',
                                            style: AppTextStyle.bodyText
                                                .copyWith(color: AppColor
                                                .iconViewColor),),
                                          Container(
                                            width: 25,
                                            height: 25,
                                            child: SvgPicture
                                                .asset(
                                                'assets/svg/edit.svg',
                                                colorFilter: ColorFilter
                                                    .mode(
                                                  AppColor
                                                      .iconViewColor,
                                                  BlendMode
                                                      .srcIn,)
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // آیکون حذف
                                    GestureDetector(
                                      onTap: () {
                                        Get.defaultDialog(
                                            backgroundColor: AppColor
                                                .backGroundColor,
                                            title: "حذف",
                                            titleStyle: AppTextStyle
                                                .smallTitleText,
                                            middleText: "آیا از حذف مطمئن هستید؟",
                                            middleTextStyle: AppTextStyle
                                                .bodyText,
                                            confirm: ElevatedButton(
                                                style: ButtonStyle(
                                                    backgroundColor: WidgetStatePropertyAll(
                                                        AppColor.primaryColor)),
                                                onPressed: () {
                                                  Get.back();
                                                  getOneInventories?.type==1 ?
                                                  inventoryController.updateDeleteInventoryReceive(
                                                      inventory.id!,
                                                      getOneInventories!.id!, 3 ,1,
                                                      inventory.account!.id!,
                                                    getOneInventories.wallet!.id!,
                                                    getOneInventories.item!.id!,
                                                    getOneInventories.quantity!,
                                                  )
                                                      : inventoryController.updateDeleteInventoryPayment(
                                                      inventory.id!,
                                                      getOneInventories!.id!, 3 ,0,
                                                      inventory.account!.id!,
                                                    getOneInventories.wallet!.id!,
                                                    getOneInventories.item!.id!,
                                                    getOneInventories.quantity!,
                                                  );
                                                },
                                                child: Text(
                                                  'حذف',
                                                  style: AppTextStyle.bodyText,
                                                )));
                                      },
                                      child: Row(
                                        children: [
                                          Text('حذف  ',
                                            style: AppTextStyle.bodyText
                                                .copyWith(
                                                color: AppColor.accentColor),),
                                          Container(
                                            width: 25,
                                            height: 25,
                                            child: SvgPicture
                                                .asset(
                                                'assets/svg/trash-bin.svg',
                                                colorFilter: ColorFilter
                                                    .mode(
                                                  AppColor
                                                      .accentColor,
                                                  BlendMode
                                                      .srcIn,)
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

              ],
            ),
          ),
        );
    });
  }

  Widget buildPaginationControls() {
    return Obx(() =>
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.chevron_left),
                onPressed: inventoryController.currentPage.value > 1
                    ? inventoryController.previousPage
                    : null,
              ),
              Text(
                'صفحه ${inventoryController.currentPage.value}',
                style: AppTextStyle.bodyText,
              ),
              IconButton(
                icon: Icon(Icons.chevron_right),
                onPressed: inventoryController.hasMore.value
                    ? inventoryController.nextPage
                    : null,
              ),
            ],
          ),
        ));
  }
}
