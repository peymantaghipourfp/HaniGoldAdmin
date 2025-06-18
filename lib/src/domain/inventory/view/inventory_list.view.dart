import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/inventory/controller/inventory.controller.dart';
import 'package:hanigold_admin/src/domain/inventory/model/inventory.model.dart';
import 'package:hanigold_admin/src/widget/custom_appbar1.widget.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../config/repository/url/base_url.dart';
import '../../../widget/background_image_total.widget.dart';
import '../../../widget/custom_appbar.widget.dart';
import '../../../widget/empty.dart';
import '../../../widget/err_page.dart';
import '../../../widget/pager_widget.dart';

class InventoryListView extends StatefulWidget {
  InventoryListView({super.key});

  @override
  State<InventoryListView> createState() => _InventoryListViewState();
}

class _InventoryListViewState extends State<InventoryListView> {
  final InventoryController inventoryController = Get.find<InventoryController>();
  final GlobalKey _dataTableKey = GlobalKey();
  final Map<int, GlobalKey> _rowKeys = {};

  @override
  void initState() {
    super.initState();
    inventoryController.inventoryList.listen((list) {
      _prepareScreenshotKeys(list);
      if (mounted) {
        setState(() {});
      }
    });
    _prepareScreenshotKeys(inventoryController.inventoryList);
  }

  void _prepareScreenshotKeys(List<InventoryModel> inventories) {
    final newKeys = <int>{};
    for (var inventory in inventories) {
      if (inventory.id != null) {
        newKeys.add(inventory.id!);
        if (!_rowKeys.containsKey(inventory.id)) {
          _rowKeys[inventory.id!] = GlobalKey(debugLabel: 'row_${inventory.id}');
        }
      }
    }
    _rowKeys.removeWhere((key, value) => !newKeys.contains(key));
  }

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
                              margin: EdgeInsets.symmetric(horizontal: 50,vertical: 0),
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
                                  suffixIcon:IconButton(
                                    onPressed: inventoryController.clearSearch,
                                    icon: Icon(
                                        Icons.close, color: AppColor.textColor),
                                  ),
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
                                      suffixIcon: IconButton(
                                        onPressed: inventoryController.clearSearch,
                                        icon: Icon(
                                            Icons.close, color: AppColor.textColor),
                                      ),
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
                                      showGeneralDialog(
                                          context: context,
                                          barrierDismissible: true,
                                          barrierLabel: MaterialLocalizations.of(context)
                                              .modalBarrierDismissLabel,
                                          barrierColor: Colors.black45,
                                          transitionDuration: const Duration(milliseconds: 200),
                                          pageBuilder: (BuildContext buildContext,
                                              Animation animation,
                                              Animation secondaryAnimation) {
                                            return Center(
                                              child: Material(
                                                color: Colors.transparent,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(8),
                                                      color: AppColor.backGroundColor
                                                  ),
                                                  width:isDesktop?  Get.width * 0.2:Get.height * 0.5,
                                                  height:isDesktop?  Get.height * 0.5:Get.height * 0.7,
                                                  padding: EdgeInsets.all(20),
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Text(
                                                              'خروجی اکسل',
                                                              style: AppTextStyle.labelText.copyWith(
                                                                fontSize: 15,
                                                                fontWeight: FontWeight.normal,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        color: AppColor.textColor,height: 0.2,
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                                        child: Column(
                                                          children: [
                                                            SizedBox(height: 8),
                                                            Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  'از تاریخ',
                                                                  style: AppTextStyle.labelText.copyWith(fontSize: 13,
                                                                      fontWeight: FontWeight.normal,color: AppColor.textColor ),
                                                                ),
                                                                Container(
                                                                  //height: 50,
                                                                  padding: EdgeInsets.only(bottom: 5),
                                                                  child: IntrinsicHeight(
                                                                    child: TextFormField(
                                                                      validator: (value){
                                                                        if(value==null || value.isEmpty){
                                                                          return 'لطفا تاریخ را انتخاب کنید';
                                                                        }
                                                                        return null;
                                                                      },
                                                                      controller: inventoryController.dateStartController,
                                                                      readOnly: true,
                                                                      style: AppTextStyle.labelText,
                                                                      decoration: InputDecoration(
                                                                        suffixIcon: Icon(Icons.calendar_month, color: AppColor.textColor),
                                                                        border: OutlineInputBorder(
                                                                          borderRadius: BorderRadius.circular(10),
                                                                        ),
                                                                        filled: true,
                                                                        fillColor: AppColor.textFieldColor,
                                                                        errorMaxLines: 1,
                                                                      ),
                                                                      onTap: () async {
                                                                        Jalali? pickedDate = await showPersianDatePicker(
                                                                          context: context,
                                                                          initialDate: Jalali.now(),
                                                                          firstDate: Jalali(1400,1,1),
                                                                          lastDate: Jalali(1450,12,29),
                                                                          initialEntryMode: PersianDatePickerEntryMode.calendar,
                                                                          initialDatePickerMode: PersianDatePickerMode.day,
                                                                          locale: Locale("fa","IR"),
                                                                        );
                                                                        Gregorian gregorian= pickedDate!.toGregorian();
                                                                        inventoryController.startDateFilter.value =
                                                                        "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";

                                                                        inventoryController.dateStartController.text =
                                                                        "${pickedDate.year}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.day.toString().padLeft(2, '0')}";

                                                                      },
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(height: 8),
                                                            Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  'تا تاریخ',
                                                                  style: AppTextStyle.labelText.copyWith(fontSize: 13,
                                                                      fontWeight: FontWeight.normal,color: AppColor.textColor ),
                                                                ),
                                                                Container(
                                                                  //height: 50,
                                                                  padding: EdgeInsets.only(bottom: 5),
                                                                  child: IntrinsicHeight(
                                                                    child: TextFormField(
                                                                      validator: (value){
                                                                        if(value==null || value.isEmpty){
                                                                          return 'لطفا تاریخ را انتخاب کنید';
                                                                        }
                                                                        return null;
                                                                      },
                                                                      controller: inventoryController.dateEndController,
                                                                      readOnly: true,
                                                                      style: AppTextStyle.labelText,
                                                                      decoration: InputDecoration(
                                                                        suffixIcon: Icon(Icons.calendar_month, color: AppColor.textColor),
                                                                        border: OutlineInputBorder(
                                                                          borderRadius: BorderRadius.circular(10),
                                                                        ),
                                                                        filled: true,
                                                                        fillColor: AppColor.textFieldColor,
                                                                        errorMaxLines: 1,
                                                                      ),
                                                                      onTap: () async {
                                                                        Jalali? pickedDate = await showPersianDatePicker(
                                                                          context: context,
                                                                          initialDate: Jalali.now(),
                                                                          firstDate: Jalali(1400,1,1),
                                                                          lastDate: Jalali(1450,12,29),
                                                                          initialEntryMode: PersianDatePickerEntryMode.calendar,
                                                                          initialDatePickerMode: PersianDatePickerMode.day,
                                                                          locale: Locale("fa","IR"),
                                                                        );
                                                                        // DateTime date=DateTime.now();
                                                                        Gregorian gregorian= pickedDate!.toGregorian();
                                                                        inventoryController.endDateFilter.value =
                                                                        "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";

                                                                        inventoryController.dateEndController.text =
                                                                        "${pickedDate.year}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.day.toString().padLeft(2, '0')}";

                                                                      },
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),

                                                          ],
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      Container(
                                                        margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                                        width: double.infinity,
                                                        height: 40,
                                                        child: ElevatedButton(
                                                          style: ButtonStyle(
                                                              padding: WidgetStatePropertyAll(
                                                                  EdgeInsets.symmetric(horizontal: 23,vertical: 19)),
                                                              // elevation: WidgetStatePropertyAll(5),
                                                              backgroundColor:
                                                              WidgetStatePropertyAll(AppColor.appBarColor),
                                                              shape: WidgetStatePropertyAll(RoundedRectangleBorder(side: BorderSide(color: AppColor.textColor),
                                                                  borderRadius: BorderRadius.circular(5)))),
                                                          onPressed: () async {
                                                            inventoryController.exportToExcel();
                                                            Get.back();
                                                          },
                                                          child: inventoryController.isLoading.value?
                                                          CircularProgressIndicator(
                                                            valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor),
                                                          ) :
                                                          Text(
                                                            'ثبت',
                                                            style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          });

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
                                      showGeneralDialog(
                                          context: context,
                                          barrierDismissible: true,
                                          barrierLabel: MaterialLocalizations.of(context)
                                              .modalBarrierDismissLabel,
                                          barrierColor: Colors.black45,
                                          transitionDuration: const Duration(milliseconds: 200),
                                          pageBuilder: (BuildContext buildContext,
                                              Animation animation,
                                              Animation secondaryAnimation) {
                                            return Center(
                                              child: Material(
                                                color: Colors.transparent,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(8),
                                                      color: AppColor.backGroundColor
                                                  ),
                                                  width:isDesktop?  Get.width * 0.2:Get.height * 0.5,
                                                  height:isDesktop?  Get.height * 0.5:Get.height * 0.7,
                                                  padding: EdgeInsets.all(20),
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Text(
                                                              'خروجی pdf',
                                                              style: AppTextStyle.labelText.copyWith(
                                                                fontSize: 15,
                                                                fontWeight: FontWeight.normal,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        color: AppColor.textColor,height: 0.2,
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                                        child: Column(
                                                          children: [
                                                            SizedBox(height: 8),
                                                            Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  'از تاریخ',
                                                                  style: AppTextStyle.labelText.copyWith(fontSize: 13,
                                                                      fontWeight: FontWeight.normal,color: AppColor.textColor ),
                                                                ),
                                                                Container(
                                                                  //height: 50,
                                                                  padding: EdgeInsets.only(bottom: 5),
                                                                  child: IntrinsicHeight(
                                                                    child: TextFormField(
                                                                      validator: (value){
                                                                        if(value==null || value.isEmpty){
                                                                          return 'لطفا تاریخ را انتخاب کنید';
                                                                        }
                                                                        return null;
                                                                      },
                                                                      controller: inventoryController.dateStartController,
                                                                      readOnly: true,
                                                                      style: AppTextStyle.labelText,
                                                                      decoration: InputDecoration(
                                                                        suffixIcon: Icon(Icons.calendar_month, color: AppColor.textColor),
                                                                        border: OutlineInputBorder(
                                                                          borderRadius: BorderRadius.circular(10),
                                                                        ),
                                                                        filled: true,
                                                                        fillColor: AppColor.textFieldColor,
                                                                        errorMaxLines: 1,
                                                                      ),
                                                                      onTap: () async {
                                                                        Jalali? pickedDate = await showPersianDatePicker(
                                                                          context: context,
                                                                          initialDate: Jalali.now(),
                                                                          firstDate: Jalali(1400,1,1),
                                                                          lastDate: Jalali(1450,12,29),
                                                                          initialEntryMode: PersianDatePickerEntryMode.calendar,
                                                                          initialDatePickerMode: PersianDatePickerMode.day,
                                                                          locale: Locale("fa","IR"),
                                                                        );
                                                                        Gregorian gregorian= pickedDate!.toGregorian();
                                                                        inventoryController.startDateFilter.value =
                                                                        "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";

                                                                        inventoryController.dateStartController.text =
                                                                        "${pickedDate.year}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.day.toString().padLeft(2, '0')}";

                                                                      },
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(height: 8),
                                                            Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  'تا تاریخ',
                                                                  style: AppTextStyle.labelText.copyWith(fontSize: 13,
                                                                      fontWeight: FontWeight.normal,color: AppColor.textColor ),
                                                                ),
                                                                Container(
                                                                  //height: 50,
                                                                  padding: EdgeInsets.only(bottom: 5),
                                                                  child: IntrinsicHeight(
                                                                    child: TextFormField(
                                                                      validator: (value){
                                                                        if(value==null || value.isEmpty){
                                                                          return 'لطفا تاریخ را انتخاب کنید';
                                                                        }
                                                                        return null;
                                                                      },
                                                                      controller: inventoryController.dateEndController,
                                                                      readOnly: true,
                                                                      style: AppTextStyle.labelText,
                                                                      decoration: InputDecoration(
                                                                        suffixIcon: Icon(Icons.calendar_month, color: AppColor.textColor),
                                                                        border: OutlineInputBorder(
                                                                          borderRadius: BorderRadius.circular(10),
                                                                        ),
                                                                        filled: true,
                                                                        fillColor: AppColor.textFieldColor,
                                                                        errorMaxLines: 1,
                                                                      ),
                                                                      onTap: () async {
                                                                        Jalali? pickedDate = await showPersianDatePicker(
                                                                          context: context,
                                                                          initialDate: Jalali.now(),
                                                                          firstDate: Jalali(1400,1,1),
                                                                          lastDate: Jalali(1450,12,29),
                                                                          initialEntryMode: PersianDatePickerEntryMode.calendar,
                                                                          initialDatePickerMode: PersianDatePickerMode.day,
                                                                          locale: Locale("fa","IR"),
                                                                        );
                                                                        // DateTime date=DateTime.now();
                                                                        Gregorian gregorian= pickedDate!.toGregorian();
                                                                        inventoryController.endDateFilter.value =
                                                                        "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";

                                                                        inventoryController.dateEndController.text =
                                                                        "${pickedDate.year}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.day.toString().padLeft(2, '0')}";

                                                                      },
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),

                                                          ],
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      Container(
                                                        margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                                        width: double.infinity,
                                                        height: 40,
                                                        child: ElevatedButton(
                                                          style: ButtonStyle(
                                                              padding: WidgetStatePropertyAll(
                                                                  EdgeInsets.symmetric(horizontal: 23,vertical: 19)),
                                                              // elevation: WidgetStatePropertyAll(5),
                                                              backgroundColor:
                                                              WidgetStatePropertyAll(AppColor.appBarColor),
                                                              shape: WidgetStatePropertyAll(RoundedRectangleBorder(side: BorderSide(color: AppColor.textColor),
                                                                  borderRadius: BorderRadius.circular(5)))),
                                                          onPressed: () async {
                                                            inventoryController.exportToPdf();
                                                            Get.back();
                                                          },
                                                          child: inventoryController.isLoading.value?
                                                          CircularProgressIndicator(
                                                            valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor),
                                                          ) :
                                                          Text(
                                                            'ثبت',
                                                            style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          });

                                    },
                                    child: Text(
                                      'خروجی pdf',
                                      style: AppTextStyle.labelText,
                                    ),
                                  ),
                                ],
                              ),
                              ElevatedButton(
                                style: ButtonStyle(
                                    padding: WidgetStatePropertyAll(
                                        EdgeInsets.symmetric(horizontal: 23,vertical: 19)),
                                    // elevation: WidgetStatePropertyAll(5),
                                    backgroundColor:
                                    WidgetStatePropertyAll(AppColor.appBarColor.withOpacity(0.5)),
                                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(side: BorderSide(color: AppColor.textColor),
                                        borderRadius: BorderRadius.circular(5)))),
                                onPressed: () async {
                                  showGeneralDialog(
                                      context: context,
                                      barrierDismissible: true,
                                      barrierLabel: MaterialLocalizations.of(context)
                                          .modalBarrierDismissLabel,
                                      barrierColor: Colors.black45,
                                      transitionDuration: const Duration(milliseconds: 200),
                                      pageBuilder: (BuildContext buildContext,
                                          Animation animation,
                                          Animation secondaryAnimation) {
                                        return Center(
                                          child: Material(
                                            color: Colors.transparent,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(8),
                                                  color: AppColor.backGroundColor
                                              ),
                                              width:isDesktop?  Get.width * 0.3:Get.width * 0.5,
                                              height:isDesktop?  Get.height * 0.5:Get.height * 0.7,
                                              padding: EdgeInsets.all(20),
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        children: [
                                                          Expanded(
                                                            child: Center(
                                                              child: Text(
                                                                'فیلتر',
                                                                style: AppTextStyle.labelText.copyWith(
                                                                  fontSize: 15,
                                                                  fontWeight: FontWeight.normal,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 50,height: 27,
                                                            child: ElevatedButton(
                                                              style: ButtonStyle(
                                                                  padding: WidgetStatePropertyAll(
                                                                      EdgeInsets.symmetric(horizontal: 2,vertical: 1)),
                                                                  // elevation: WidgetStatePropertyAll(5),
                                                                  backgroundColor:
                                                                  WidgetStatePropertyAll(AppColor.accentColor.withOpacity(0.5)),
                                                                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(side: BorderSide(color: AppColor.textColor),
                                                                      borderRadius: BorderRadius.circular(5)))),
                                                              onPressed: () async {
                                                                inventoryController.clearFilter();
                                                                inventoryController.getInventoryListPager();
                                                                Get.back();
                                                              },
                                                              child: Text(
                                                                'حذف فیلتر',
                                                                style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 9 : 8),
                                                              ),
                                                            ),
                                                          ),                                                                  ],
                                                      ),
                                                    ),
                                                    Container(
                                                      color: AppColor.textColor,height: 0.2,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                                      child: Column(
                                                        children: [
                                                          SizedBox(height: 8,),
                                                          Column(
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                'نام',
                                                                style: AppTextStyle.labelText.copyWith(
                                                                    fontSize: 11,
                                                                    fontWeight: FontWeight.normal,
                                                                    color: AppColor.textColor),
                                                              ),
                                                              SizedBox(height: 10,),
                                                              IntrinsicHeight(
                                                                child: TextFormField(
                                                                  autovalidateMode: AutovalidateMode
                                                                      .onUserInteraction,
                                                                  controller: inventoryController.nameFilterController,
                                                                  style: AppTextStyle.labelText.copyWith(fontSize: 15),
                                                                  textAlign: TextAlign.start,
                                                                  keyboardType:TextInputType.text,
                                                                  decoration: InputDecoration(
                                                                    contentPadding:
                                                                    const EdgeInsets.symmetric(
                                                                        vertical: 11,horizontal: 15
                                                                    ),
                                                                    isDense: true,
                                                                    border: OutlineInputBorder(
                                                                      borderRadius:
                                                                      BorderRadius.circular(6),
                                                                    ),
                                                                    filled: true,
                                                                    fillColor: AppColor.textFieldColor,
                                                                    errorMaxLines: 1,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(height: 8,),
                                                          Column(
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                'شماره تماس',
                                                                style: AppTextStyle.labelText.copyWith(
                                                                    fontSize: 11,
                                                                    fontWeight: FontWeight.normal,
                                                                    color: AppColor.textColor),
                                                              ),
                                                              SizedBox(height: 10,),
                                                              IntrinsicHeight(
                                                                child: TextFormField(
                                                                  autovalidateMode: AutovalidateMode
                                                                      .onUserInteraction,
                                                                  controller: inventoryController.mobileFilterController,
                                                                  style: AppTextStyle.labelText.copyWith(fontSize: 15),
                                                                  textAlign: TextAlign.center,
                                                                  keyboardType:TextInputType.phone,
                                                                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^[\d٠-٩۰-۹]*\.?[\d٠-٩۰-۹]*$')),
                                                                    TextInputFormatter.withFunction((oldValue, newValue) {
                                                                      // تبدیل اعداد فارسی به انگلیسی برای پردازش راحت‌تر
                                                                      String newText = newValue.text
                                                                          .replaceAll('٠', '0')
                                                                          .replaceAll('١', '1')
                                                                          .replaceAll('٢', '2')
                                                                          .replaceAll('٣', '3')
                                                                          .replaceAll('٤', '4')
                                                                          .replaceAll('٥', '5')
                                                                          .replaceAll('٦', '6')
                                                                          .replaceAll('٧', '7')
                                                                          .replaceAll('٨', '8')
                                                                          .replaceAll('٩', '9');

                                                                      return newValue.copyWith(text: newText, selection: TextSelection.collapsed(offset: newText.length));
                                                                    }),
                                                                  ],
                                                                  decoration: InputDecoration(
                                                                    contentPadding:
                                                                    const EdgeInsets.symmetric(
                                                                        vertical: 11,horizontal: 15

                                                                    ),
                                                                    isDense: true,
                                                                    border: OutlineInputBorder(
                                                                      borderRadius:
                                                                      BorderRadius.circular(6),
                                                                    ),

                                                                    filled: true,
                                                                    fillColor: AppColor.textFieldColor,
                                                                    errorMaxLines: 1,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(height: 8),
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                'از تاریخ',
                                                                style: AppTextStyle.labelText.copyWith(fontSize: 13,
                                                                    fontWeight: FontWeight.normal,color: AppColor.textColor ),
                                                              ),
                                                              Container(
                                                                //height: 50,
                                                                padding: EdgeInsets.only(bottom: 5),
                                                                child: IntrinsicHeight(
                                                                  child: TextFormField(
                                                                    validator: (value){
                                                                      if(value==null || value.isEmpty){
                                                                        return 'لطفا تاریخ را انتخاب کنید';
                                                                      }
                                                                      return null;
                                                                    },
                                                                    controller: inventoryController.dateStartController,
                                                                    readOnly: true,
                                                                    style: AppTextStyle.labelText,
                                                                    decoration: InputDecoration(
                                                                      suffixIcon: Icon(Icons.calendar_month, color: AppColor.textColor),
                                                                      border: OutlineInputBorder(
                                                                        borderRadius: BorderRadius.circular(10),
                                                                      ),
                                                                      filled: true,
                                                                      fillColor: AppColor.textFieldColor,
                                                                      errorMaxLines: 1,
                                                                    ),
                                                                    onTap: () async {
                                                                      Jalali? pickedDate = await showPersianDatePicker(
                                                                        context: context,
                                                                        initialDate: Jalali.now(),
                                                                        firstDate: Jalali(1400,1,1),
                                                                        lastDate: Jalali(1450,12,29),
                                                                        initialEntryMode: PersianDatePickerEntryMode.calendar,
                                                                        initialDatePickerMode: PersianDatePickerMode.day,
                                                                        locale: Locale("fa","IR"),
                                                                      );
                                                                      Gregorian gregorian= pickedDate!.toGregorian();
                                                                      inventoryController.startDateFilter.value =
                                                                      "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";

                                                                      inventoryController.dateStartController.text =
                                                                      "${pickedDate.year}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.day.toString().padLeft(2, '0')}";

                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(height: 8),
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                'تا تاریخ',
                                                                style: AppTextStyle.labelText.copyWith(fontSize: 13,
                                                                    fontWeight: FontWeight.normal,color: AppColor.textColor ),
                                                              ),
                                                              Container(
                                                                //height: 50,
                                                                padding: EdgeInsets.only(bottom: 5),
                                                                child: IntrinsicHeight(
                                                                  child: TextFormField(
                                                                    validator: (value){
                                                                      if(value==null || value.isEmpty){
                                                                        return 'لطفا تاریخ را انتخاب کنید';
                                                                      }
                                                                      return null;
                                                                    },
                                                                    controller: inventoryController.dateEndController,
                                                                    readOnly: true,
                                                                    style: AppTextStyle.labelText,
                                                                    decoration: InputDecoration(
                                                                      suffixIcon: Icon(Icons.calendar_month, color: AppColor.textColor),
                                                                      border: OutlineInputBorder(
                                                                        borderRadius: BorderRadius.circular(10),
                                                                      ),
                                                                      filled: true,
                                                                      fillColor: AppColor.textFieldColor,
                                                                      errorMaxLines: 1,
                                                                    ),
                                                                    onTap: () async {
                                                                      Jalali? pickedDate = await showPersianDatePicker(
                                                                        context: context,
                                                                        initialDate: Jalali.now(),
                                                                        firstDate: Jalali(1400,1,1),
                                                                        lastDate: Jalali(1450,12,29),
                                                                        initialEntryMode: PersianDatePickerEntryMode.calendar,
                                                                        initialDatePickerMode: PersianDatePickerMode.day,
                                                                        locale: Locale("fa","IR"),
                                                                      );
                                                                      // DateTime date=DateTime.now();
                                                                      Gregorian gregorian= pickedDate!.toGregorian();
                                                                      inventoryController.endDateFilter.value =
                                                                      "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";

                                                                      inventoryController.dateEndController.text =
                                                                      "${pickedDate.year}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.day.toString().padLeft(2, '0')}";

                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),

                                                        ],
                                                      ),
                                                    ),
                                                    //   Spacer(),
                                                    Container(
                                                      margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                                      width: double.infinity,
                                                      height: 40,
                                                      child: ElevatedButton(
                                                        style: ButtonStyle(
                                                            padding: WidgetStatePropertyAll(
                                                                EdgeInsets.symmetric(horizontal: 23,vertical: 19)),
                                                            // elevation: WidgetStatePropertyAll(5),
                                                            backgroundColor:
                                                            WidgetStatePropertyAll(AppColor.appBarColor),
                                                            shape: WidgetStatePropertyAll(RoundedRectangleBorder(side: BorderSide(color: AppColor.textColor),
                                                                borderRadius: BorderRadius.circular(5)))),
                                                        onPressed: () async {
                                                          inventoryController.getInventoryListPager();
                                                          Get.back();

                                                        },
                                                        child: inventoryController.isLoading.value?
                                                        CircularProgressIndicator(
                                                          valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor),
                                                        ) :
                                                        Text(
                                                          'فیلتر',
                                                          style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      });
                                },
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                        'assets/svg/filter3.svg',
                                        height: 17,
                                        colorFilter:
                                        ColorFilter
                                            .mode(
                                          inventoryController.nameFilterController.text!="" ||  inventoryController.mobileFilterController.text!="" || inventoryController.dateStartController.text!="" || inventoryController.dateEndController.text!="" ?AppColor.accentColor:  AppColor
                                              .textColor,
                                          BlendMode
                                              .srcIn,
                                        )),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'فیلتر',
                                      style: AppTextStyle
                                          .labelText
                                          .copyWith(
                                          fontSize: isDesktop
                                              ? 12
                                              : 10,color:  inventoryController.nameFilterController.text!="" ||  inventoryController.mobileFilterController.text!="" || inventoryController.dateStartController.text!="" || inventoryController.dateEndController.text!="" ?AppColor.accentColor: AppColor.textColor),
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
                       // EasyLoading.show(status: 'دریافت اطلاعات از سرور...');
                        return Center(child: CircularProgressIndicator());
                      } else
                      if (inventoryController.state.value == PageState.empty) {
                        //EasyLoading.dismiss();
                        return EmptyPage(
                          title: 'دریافت/پرداختی وجود ندارد',
                          callback: () {
                            inventoryController.getInventoryListPager();
                          },
                        );
                      } else
                      if (inventoryController.state.value == PageState.list) {
                       /// EasyLoading.dismiss();
                        return
                          isDesktop ?
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 60,vertical: 0),
                            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                            color: AppColor.appBarColor.withOpacity(0.5),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 0,vertical: 10),
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
                                                showGeneralDialog(
                                                    context: context,
                                                    barrierDismissible: true,
                                                    barrierLabel: MaterialLocalizations.of(context)
                                                        .modalBarrierDismissLabel,
                                                    barrierColor: Colors.black45,
                                                    transitionDuration: const Duration(milliseconds: 200),
                                                    pageBuilder: (BuildContext buildContext,
                                                        Animation animation,
                                                        Animation secondaryAnimation) {
                                                      return Center(
                                                        child: Material(
                                                          color: Colors.transparent,
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(8),
                                                                color: AppColor.backGroundColor
                                                            ),
                                                            width:isDesktop?  Get.width * 0.2:Get.height * 0.5,
                                                            height:isDesktop?  Get.height * 0.5:Get.height * 0.7,
                                                            padding: EdgeInsets.all(20),
                                                            child: Column(
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets.all(8.0),
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    children: [
                                                                      Text(
                                                                        'خروجی اکسل',
                                                                        style: AppTextStyle.labelText.copyWith(
                                                                          fontSize: 15,
                                                                          fontWeight: FontWeight.normal,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Container(
                                                                  color: AppColor.textColor,height: 0.2,
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                                                  child: Column(
                                                                    children: [
                                                                      SizedBox(height: 8),
                                                                      Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            'از تاریخ',
                                                                            style: AppTextStyle.labelText.copyWith(fontSize: 13,
                                                                                fontWeight: FontWeight.normal,color: AppColor.textColor ),
                                                                          ),
                                                                          Container(
                                                                            //height: 50,
                                                                            padding: EdgeInsets.only(bottom: 5),
                                                                            child: IntrinsicHeight(
                                                                              child: TextFormField(
                                                                                validator: (value){
                                                                                  if(value==null || value.isEmpty){
                                                                                    return 'لطفا تاریخ را انتخاب کنید';
                                                                                  }
                                                                                  return null;
                                                                                },
                                                                                controller: inventoryController.dateStartController,
                                                                                readOnly: true,
                                                                                style: AppTextStyle.labelText,
                                                                                decoration: InputDecoration(
                                                                                  suffixIcon: Icon(Icons.calendar_month, color: AppColor.textColor),
                                                                                  border: OutlineInputBorder(
                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                  ),
                                                                                  filled: true,
                                                                                  fillColor: AppColor.textFieldColor,
                                                                                  errorMaxLines: 1,
                                                                                ),
                                                                                onTap: () async {
                                                                                  Jalali? pickedDate = await showPersianDatePicker(
                                                                                    context: context,
                                                                                    initialDate: Jalali.now(),
                                                                                    firstDate: Jalali(1400,1,1),
                                                                                    lastDate: Jalali(1450,12,29),
                                                                                    initialEntryMode: PersianDatePickerEntryMode.calendar,
                                                                                    initialDatePickerMode: PersianDatePickerMode.day,
                                                                                    locale: Locale("fa","IR"),
                                                                                  );
                                                                                  Gregorian gregorian= pickedDate!.toGregorian();
                                                                                  inventoryController.startDateFilter.value =
                                                                                  "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";

                                                                                  inventoryController.dateStartController.text =
                                                                                  "${pickedDate.year}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.day.toString().padLeft(2, '0')}";

                                                                                },
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      SizedBox(height: 8),
                                                                      Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            'تا تاریخ',
                                                                            style: AppTextStyle.labelText.copyWith(fontSize: 13,
                                                                                fontWeight: FontWeight.normal,color: AppColor.textColor ),
                                                                          ),
                                                                          Container(
                                                                            //height: 50,
                                                                            padding: EdgeInsets.only(bottom: 5),
                                                                            child: IntrinsicHeight(
                                                                              child: TextFormField(
                                                                                validator: (value){
                                                                                  if(value==null || value.isEmpty){
                                                                                    return 'لطفا تاریخ را انتخاب کنید';
                                                                                  }
                                                                                  return null;
                                                                                },
                                                                                controller: inventoryController.dateEndController,
                                                                                readOnly: true,
                                                                                style: AppTextStyle.labelText,
                                                                                decoration: InputDecoration(
                                                                                  suffixIcon: Icon(Icons.calendar_month, color: AppColor.textColor),
                                                                                  border: OutlineInputBorder(
                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                  ),
                                                                                  filled: true,
                                                                                  fillColor: AppColor.textFieldColor,
                                                                                  errorMaxLines: 1,
                                                                                ),
                                                                                onTap: () async {
                                                                                  Jalali? pickedDate = await showPersianDatePicker(
                                                                                    context: context,
                                                                                    initialDate: Jalali.now(),
                                                                                    firstDate: Jalali(1400,1,1),
                                                                                    lastDate: Jalali(1450,12,29),
                                                                                    initialEntryMode: PersianDatePickerEntryMode.calendar,
                                                                                    initialDatePickerMode: PersianDatePickerMode.day,
                                                                                    locale: Locale("fa","IR"),
                                                                                  );
                                                                                  // DateTime date=DateTime.now();
                                                                                  Gregorian gregorian= pickedDate!.toGregorian();
                                                                                  inventoryController.endDateFilter.value =
                                                                                  "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";

                                                                                  inventoryController.dateEndController.text =
                                                                                  "${pickedDate.year}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.day.toString().padLeft(2, '0')}";

                                                                                },
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),

                                                                    ],
                                                                  ),
                                                                ),
                                                                Spacer(),
                                                                Container(
                                                                  margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                                                  width: double.infinity,
                                                                  height: 40,
                                                                  child: ElevatedButton(
                                                                    style: ButtonStyle(
                                                                        padding: WidgetStatePropertyAll(
                                                                            EdgeInsets.symmetric(horizontal: 23,vertical: 19)),
                                                                        // elevation: WidgetStatePropertyAll(5),
                                                                        backgroundColor:
                                                                        WidgetStatePropertyAll(AppColor.appBarColor),
                                                                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(side: BorderSide(color: AppColor.textColor),
                                                                            borderRadius: BorderRadius.circular(5)))),
                                                                    onPressed: () async {
                                                                      inventoryController.exportToExcel();
                                                                      Get.back();
                                                                    },
                                                                    child: inventoryController.isLoading.value?
                                                                    CircularProgressIndicator(
                                                                      valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor),
                                                                    ) :
                                                                    Text(
                                                                      'ثبت',
                                                                      style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    });

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
                                                showGeneralDialog(
                                                    context: context,
                                                    barrierDismissible: true,
                                                    barrierLabel: MaterialLocalizations.of(context)
                                                        .modalBarrierDismissLabel,
                                                    barrierColor: Colors.black45,
                                                    transitionDuration: const Duration(milliseconds: 200),
                                                    pageBuilder: (BuildContext buildContext,
                                                        Animation animation,
                                                        Animation secondaryAnimation) {
                                                      return Center(
                                                        child: Material(
                                                          color: Colors.transparent,
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(8),
                                                                color: AppColor.backGroundColor
                                                            ),
                                                            width:isDesktop?  Get.width * 0.2:Get.height * 0.5,
                                                            height:isDesktop?  Get.height * 0.5:Get.height * 0.7,
                                                            padding: EdgeInsets.all(20),
                                                            child: Column(
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets.all(8.0),
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    children: [
                                                                      Text(
                                                                        'خروجی pdf',
                                                                        style: AppTextStyle.labelText.copyWith(
                                                                          fontSize: 15,
                                                                          fontWeight: FontWeight.normal,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Container(
                                                                  color: AppColor.textColor,height: 0.2,
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                                                  child: Column(
                                                                    children: [
                                                                      SizedBox(height: 8),
                                                                      Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            'از تاریخ',
                                                                            style: AppTextStyle.labelText.copyWith(fontSize: 13,
                                                                                fontWeight: FontWeight.normal,color: AppColor.textColor ),
                                                                          ),
                                                                          Container(
                                                                            //height: 50,
                                                                            padding: EdgeInsets.only(bottom: 5),
                                                                            child: IntrinsicHeight(
                                                                              child: TextFormField(
                                                                                validator: (value){
                                                                                  if(value==null || value.isEmpty){
                                                                                    return 'لطفا تاریخ را انتخاب کنید';
                                                                                  }
                                                                                  return null;
                                                                                },
                                                                                controller: inventoryController.dateStartController,
                                                                                readOnly: true,
                                                                                style: AppTextStyle.labelText,
                                                                                decoration: InputDecoration(
                                                                                  suffixIcon: Icon(Icons.calendar_month, color: AppColor.textColor),
                                                                                  border: OutlineInputBorder(
                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                  ),
                                                                                  filled: true,
                                                                                  fillColor: AppColor.textFieldColor,
                                                                                  errorMaxLines: 1,
                                                                                ),
                                                                                onTap: () async {
                                                                                  Jalali? pickedDate = await showPersianDatePicker(
                                                                                    context: context,
                                                                                    initialDate: Jalali.now(),
                                                                                    firstDate: Jalali(1400,1,1),
                                                                                    lastDate: Jalali(1450,12,29),
                                                                                    initialEntryMode: PersianDatePickerEntryMode.calendar,
                                                                                    initialDatePickerMode: PersianDatePickerMode.day,
                                                                                    locale: Locale("fa","IR"),
                                                                                  );
                                                                                  Gregorian gregorian= pickedDate!.toGregorian();
                                                                                  inventoryController.startDateFilter.value =
                                                                                  "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";

                                                                                  inventoryController.dateStartController.text =
                                                                                  "${pickedDate.year}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.day.toString().padLeft(2, '0')}";

                                                                                },
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      SizedBox(height: 8),
                                                                      Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            'تا تاریخ',
                                                                            style: AppTextStyle.labelText.copyWith(fontSize: 13,
                                                                                fontWeight: FontWeight.normal,color: AppColor.textColor ),
                                                                          ),
                                                                          Container(
                                                                            //height: 50,
                                                                            padding: EdgeInsets.only(bottom: 5),
                                                                            child: IntrinsicHeight(
                                                                              child: TextFormField(
                                                                                validator: (value){
                                                                                  if(value==null || value.isEmpty){
                                                                                    return 'لطفا تاریخ را انتخاب کنید';
                                                                                  }
                                                                                  return null;
                                                                                },
                                                                                controller: inventoryController.dateEndController,
                                                                                readOnly: true,
                                                                                style: AppTextStyle.labelText,
                                                                                decoration: InputDecoration(
                                                                                  suffixIcon: Icon(Icons.calendar_month, color: AppColor.textColor),
                                                                                  border: OutlineInputBorder(
                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                  ),
                                                                                  filled: true,
                                                                                  fillColor: AppColor.textFieldColor,
                                                                                  errorMaxLines: 1,
                                                                                ),
                                                                                onTap: () async {
                                                                                  Jalali? pickedDate = await showPersianDatePicker(
                                                                                    context: context,
                                                                                    initialDate: Jalali.now(),
                                                                                    firstDate: Jalali(1400,1,1),
                                                                                    lastDate: Jalali(1450,12,29),
                                                                                    initialEntryMode: PersianDatePickerEntryMode.calendar,
                                                                                    initialDatePickerMode: PersianDatePickerMode.day,
                                                                                    locale: Locale("fa","IR"),
                                                                                  );
                                                                                  // DateTime date=DateTime.now();
                                                                                  Gregorian gregorian= pickedDate!.toGregorian();
                                                                                  inventoryController.endDateFilter.value =
                                                                                  "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";

                                                                                  inventoryController.dateEndController.text =
                                                                                  "${pickedDate.year}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.day.toString().padLeft(2, '0')}";

                                                                                },
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),

                                                                    ],
                                                                  ),
                                                                ),
                                                                Spacer(),
                                                                Container(
                                                                  margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                                                  width: double.infinity,
                                                                  height: 40,
                                                                  child: ElevatedButton(
                                                                    style: ButtonStyle(
                                                                        padding: WidgetStatePropertyAll(
                                                                            EdgeInsets.symmetric(horizontal: 23,vertical: 19)),
                                                                        // elevation: WidgetStatePropertyAll(5),
                                                                        backgroundColor:
                                                                        WidgetStatePropertyAll(AppColor.appBarColor),
                                                                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(side: BorderSide(color: AppColor.textColor),
                                                                            borderRadius: BorderRadius.circular(5)))),
                                                                    onPressed: () async {
                                                                      inventoryController.exportToPdf();
                                                                      Get.back();
                                                                    },
                                                                    child: inventoryController.isLoading.value?
                                                                    CircularProgressIndicator(
                                                                      valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor),
                                                                    ) :
                                                                    Text(
                                                                      'ثبت',
                                                                      style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    });

                                              },
                                              child: Text(
                                                'خروجی pdf',
                                                style: AppTextStyle.labelText,
                                              ),
                                            ),
                                          ],
                                        ),
                                        ElevatedButton(
                                          style: ButtonStyle(
                                              padding: WidgetStatePropertyAll(
                                                  EdgeInsets.symmetric(horizontal: 23,vertical: 19)),
                                              // elevation: WidgetStatePropertyAll(5),
                                              backgroundColor:
                                              WidgetStatePropertyAll(AppColor.appBarColor.withOpacity(0.5)),
                                              shape: WidgetStatePropertyAll(RoundedRectangleBorder(side: BorderSide(color: AppColor.textColor),
                                                  borderRadius: BorderRadius.circular(5)))),
                                          onPressed: () async {
                                            showGeneralDialog(
                                                context: context,
                                                barrierDismissible: true,
                                                barrierLabel: MaterialLocalizations.of(context)
                                                    .modalBarrierDismissLabel,
                                                barrierColor: Colors.black45,
                                                transitionDuration: const Duration(milliseconds: 200),
                                                pageBuilder: (BuildContext buildContext,
                                                    Animation animation,
                                                    Animation secondaryAnimation) {
                                                  return Center(
                                                    child: Material(
                                                      color: Colors.transparent,
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(8),
                                                            color: AppColor.backGroundColor
                                                        ),
                                                        width:isDesktop?  Get.width * 0.2:Get.width * 0.5,
                                                        height:isDesktop?  Get.height * 0.5:Get.height * 0.7,
                                                        padding: EdgeInsets.all(20),
                                                        child: SingleChildScrollView(
                                                          child: Column(
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                                  children: [
                                                                    Expanded(
                                                                      child: Center(
                                                                        child: Text(
                                                                          'فیلتر',
                                                                          style: AppTextStyle.labelText.copyWith(
                                                                            fontSize: 15,
                                                                            fontWeight: FontWeight.normal,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 50,height: 27,
                                                                      child: ElevatedButton(
                                                                        style: ButtonStyle(
                                                                            padding: WidgetStatePropertyAll(
                                                                                EdgeInsets.symmetric(horizontal: 2,vertical: 1)),
                                                                            // elevation: WidgetStatePropertyAll(5),
                                                                            backgroundColor:
                                                                            WidgetStatePropertyAll(AppColor.accentColor.withOpacity(0.5)),
                                                                            shape: WidgetStatePropertyAll(RoundedRectangleBorder(side: BorderSide(color: AppColor.textColor),
                                                                                borderRadius: BorderRadius.circular(5)))),
                                                                        onPressed: () async {
                                                                          inventoryController.clearFilter();
                                                                          inventoryController.getInventoryListPager();
                                                                          Get.back();
                                                                        },
                                                                        child: Text(
                                                                          'حذف فیلتر',
                                                                          style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 9 : 8),
                                                                        ),
                                                                      ),
                                                                    ),                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                color: AppColor.textColor,height: 0.2,
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                                                child: Column(
                                                                  children: [
                                                                    SizedBox(height: 8,),
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                      CrossAxisAlignment.start,
                                                                      children: [
                                                                        Text(
                                                                          'نام',
                                                                          style: AppTextStyle.labelText.copyWith(
                                                                              fontSize: 11,
                                                                              fontWeight: FontWeight.normal,
                                                                              color: AppColor.textColor),
                                                                        ),
                                                                        SizedBox(height: 10,),
                                                                        IntrinsicHeight(
                                                                          child: TextFormField(
                                                                            autovalidateMode: AutovalidateMode
                                                                                .onUserInteraction,
                                                                            controller: inventoryController.nameFilterController,
                                                                            style: AppTextStyle.labelText.copyWith(fontSize: 15),
                                                                            textAlign: TextAlign.start,
                                                                            keyboardType:TextInputType.text,
                                                                            decoration: InputDecoration(
                                                                              contentPadding:
                                                                              const EdgeInsets.symmetric(
                                                                                  vertical: 11,horizontal: 15
                                                                              ),
                                                                              isDense: true,
                                                                              border: OutlineInputBorder(
                                                                                borderRadius:
                                                                                BorderRadius.circular(6),
                                                                              ),
                                                                              filled: true,
                                                                              fillColor: AppColor.textFieldColor,
                                                                              errorMaxLines: 1,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(height: 8,),
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                      CrossAxisAlignment.start,
                                                                      children: [
                                                                        Text(
                                                                          'شماره تماس',
                                                                          style: AppTextStyle.labelText.copyWith(
                                                                              fontSize: 11,
                                                                              fontWeight: FontWeight.normal,
                                                                              color: AppColor.textColor),
                                                                        ),
                                                                        SizedBox(height: 10,),
                                                                        IntrinsicHeight(
                                                                          child: TextFormField(
                                                                            autovalidateMode: AutovalidateMode
                                                                                .onUserInteraction,
                                                                            controller: inventoryController.mobileFilterController,
                                                                            style: AppTextStyle.labelText.copyWith(fontSize: 15),
                                                                            textAlign: TextAlign.center,
                                                                            keyboardType:TextInputType.phone,
                                                                            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^[\d٠-٩۰-۹]*\.?[\d٠-٩۰-۹]*$')),
                                                                              TextInputFormatter.withFunction((oldValue, newValue) {
                                                                                // تبدیل اعداد فارسی به انگلیسی برای پردازش راحت‌تر
                                                                                String newText = newValue.text
                                                                                    .replaceAll('٠', '0')
                                                                                    .replaceAll('١', '1')
                                                                                    .replaceAll('٢', '2')
                                                                                    .replaceAll('٣', '3')
                                                                                    .replaceAll('٤', '4')
                                                                                    .replaceAll('٥', '5')
                                                                                    .replaceAll('٦', '6')
                                                                                    .replaceAll('٧', '7')
                                                                                    .replaceAll('٨', '8')
                                                                                    .replaceAll('٩', '9');

                                                                                return newValue.copyWith(text: newText, selection: TextSelection.collapsed(offset: newText.length));
                                                                              }),
                                                                            ],
                                                                            decoration: InputDecoration(
                                                                              contentPadding:
                                                                              const EdgeInsets.symmetric(
                                                                                  vertical: 11,horizontal: 15

                                                                              ),
                                                                              isDense: true,
                                                                              border: OutlineInputBorder(
                                                                                borderRadius:
                                                                                BorderRadius.circular(6),
                                                                              ),

                                                                              filled: true,
                                                                              fillColor: AppColor.textFieldColor,
                                                                              errorMaxLines: 1,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(height: 8),
                                                                    Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Text(
                                                                          'از تاریخ',
                                                                          style: AppTextStyle.labelText.copyWith(fontSize: 13,
                                                                              fontWeight: FontWeight.normal,color: AppColor.textColor ),
                                                                        ),
                                                                        Container(
                                                                          //height: 50,
                                                                          padding: EdgeInsets.only(bottom: 5),
                                                                          child: IntrinsicHeight(
                                                                            child: TextFormField(
                                                                              validator: (value){
                                                                                if(value==null || value.isEmpty){
                                                                                  return 'لطفا تاریخ را انتخاب کنید';
                                                                                }
                                                                                return null;
                                                                              },
                                                                              controller: inventoryController.dateStartController,
                                                                              readOnly: true,
                                                                              style: AppTextStyle.labelText,
                                                                              decoration: InputDecoration(
                                                                                suffixIcon: Icon(Icons.calendar_month, color: AppColor.textColor),
                                                                                border: OutlineInputBorder(
                                                                                  borderRadius: BorderRadius.circular(10),
                                                                                ),
                                                                                filled: true,
                                                                                fillColor: AppColor.textFieldColor,
                                                                                errorMaxLines: 1,
                                                                              ),
                                                                              onTap: () async {
                                                                                Jalali? pickedDate = await showPersianDatePicker(
                                                                                  context: context,
                                                                                  initialDate: Jalali.now(),
                                                                                  firstDate: Jalali(1400,1,1),
                                                                                  lastDate: Jalali(1450,12,29),
                                                                                  initialEntryMode: PersianDatePickerEntryMode.calendar,
                                                                                  initialDatePickerMode: PersianDatePickerMode.day,
                                                                                  locale: Locale("fa","IR"),
                                                                                );
                                                                                Gregorian gregorian= pickedDate!.toGregorian();
                                                                                inventoryController.startDateFilter.value =
                                                                                "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";

                                                                                inventoryController.dateStartController.text =
                                                                                "${pickedDate.year}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.day.toString().padLeft(2, '0')}";

                                                                              },
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(height: 8),
                                                                    Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Text(
                                                                          'تا تاریخ',
                                                                          style: AppTextStyle.labelText.copyWith(fontSize: 13,
                                                                              fontWeight: FontWeight.normal,color: AppColor.textColor ),
                                                                        ),
                                                                        Container(
                                                                          //height: 50,
                                                                          padding: EdgeInsets.only(bottom: 5),
                                                                          child: IntrinsicHeight(
                                                                            child: TextFormField(
                                                                              validator: (value){
                                                                                if(value==null || value.isEmpty){
                                                                                  return 'لطفا تاریخ را انتخاب کنید';
                                                                                }
                                                                                return null;
                                                                              },
                                                                              controller: inventoryController.dateEndController,
                                                                              readOnly: true,
                                                                              style: AppTextStyle.labelText,
                                                                              decoration: InputDecoration(
                                                                                suffixIcon: Icon(Icons.calendar_month, color: AppColor.textColor),
                                                                                border: OutlineInputBorder(
                                                                                  borderRadius: BorderRadius.circular(10),
                                                                                ),
                                                                                filled: true,
                                                                                fillColor: AppColor.textFieldColor,
                                                                                errorMaxLines: 1,
                                                                              ),
                                                                              onTap: () async {
                                                                                Jalali? pickedDate = await showPersianDatePicker(
                                                                                  context: context,
                                                                                  initialDate: Jalali.now(),
                                                                                  firstDate: Jalali(1400,1,1),
                                                                                  lastDate: Jalali(1450,12,29),
                                                                                  initialEntryMode: PersianDatePickerEntryMode.calendar,
                                                                                  initialDatePickerMode: PersianDatePickerMode.day,
                                                                                  locale: Locale("fa","IR"),
                                                                                );
                                                                                // DateTime date=DateTime.now();
                                                                                Gregorian gregorian= pickedDate!.toGregorian();
                                                                                inventoryController.endDateFilter.value =
                                                                                "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";

                                                                                inventoryController.dateEndController.text =
                                                                                "${pickedDate.year}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.day.toString().padLeft(2, '0')}";

                                                                              },
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),

                                                                  ],
                                                                ),
                                                              ),
                                                              //   Spacer(),
                                                              Container(
                                                                margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                                                width: double.infinity,
                                                                height: 40,
                                                                child: ElevatedButton(
                                                                  style: ButtonStyle(
                                                                      padding: WidgetStatePropertyAll(
                                                                          EdgeInsets.symmetric(horizontal: 23,vertical: 19)),
                                                                      // elevation: WidgetStatePropertyAll(5),
                                                                      backgroundColor:
                                                                      WidgetStatePropertyAll(AppColor.appBarColor),
                                                                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(side: BorderSide(color: AppColor.textColor),
                                                                          borderRadius: BorderRadius.circular(5)))),
                                                                  onPressed: () async {
                                                                    inventoryController.getInventoryListPager();
                                                                    Get.back();

                                                                  },
                                                                  child: inventoryController.isLoading.value?
                                                                  CircularProgressIndicator(
                                                                    valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor),
                                                                  ) :
                                                                  Text(
                                                                    'فیلتر',
                                                                    style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                });
                                          },
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(
                                                  'assets/svg/filter3.svg',
                                                  height: 17,
                                                  colorFilter:
                                                  ColorFilter
                                                      .mode(
                                                    inventoryController.nameFilterController.text!="" ||  inventoryController.mobileFilterController.text!="" || inventoryController.dateStartController.text!="" || inventoryController.dateEndController.text!="" ?AppColor.accentColor:  AppColor
                                                        .textColor,
                                                    BlendMode
                                                        .srcIn,
                                                  )),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                'فیلتر',
                                                style: AppTextStyle
                                                    .labelText
                                                    .copyWith(
                                                    fontSize: isDesktop
                                                        ? 12
                                                        : 10,color:  inventoryController.nameFilterController.text!="" ||  inventoryController.mobileFilterController.text!="" || inventoryController.dateStartController.text!="" || inventoryController.dateEndController.text!="" ?AppColor.accentColor: AppColor.textColor),
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

                                                RepaintBoundary(
                                                  key: _dataTableKey,
                                                  child: DataTable(
                                                    sortColumnIndex: inventoryController.sortColumnIndex.value,
                                                    sortAscending: inventoryController.sortAscending.value,
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
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 50,)
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
                                                  // checkBox
                                                  Checkbox(
                                                    value: inventories.registered ?? false,
                                                    onChanged: (value) async{
                                                      if (value != null) {
                                                        //EasyLoading.show(status: 'لطفا منتظر بمانید');
                                                        await inventoryController.updateRegistered(
                                                            inventories.id!,
                                                            value
                                                        );
                                                      }
                                                    },
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
                                                                      // الصاق تصویر
                                                                      /*Row(
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
                                                                        ],
                                                                      ),*/
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
                                                                      Row(
                                                                        children: [
                                                                          Text(
                                                                              ' توضیحات: ',
                                                                              style: AppTextStyle
                                                                                  .labelText),
                                                                          Text(
                                                                              getOneInventories
                                                                                  ?.description ?? '',
                                                                              style: AppTextStyle
                                                                                  .bodyText),
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
                                                                              Get.toNamed('/inventoryDetailUpdateReceive', parameters: {"id":getOneInventories!.inventoryId.toString(),"index":index.toString()}):
                                                                              Get.toNamed('/inventoryDetailUpdatePayment', parameters: {"id":getOneInventories!.inventoryId.toString(),"index":index.toString()});
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
                                                                                  title: "حذف",
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
                                                                                        Gregorian date=getOneInventories!.date!.toGregorian();
                                                                                        Get.back();
                                                                                        getOneInventories.type==1 ?
                                                                                        inventoryController.updateDeleteInventoryReceive(
                                                                                          "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}T${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}",
                                                                                            inventories.id!,
                                                                                            getOneInventories.id!, 3,0,
                                                                                            inventories.account!.id!,
                                                                                          getOneInventories.wallet!.id!,
                                                                                            getOneInventories.item!.id!,
                                                                                          getOneInventories.quantity!,
                                                                                        )
                                                                                            : inventoryController.updateDeleteInventoryPayment(
                                                                                          "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}T${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}",
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
                          inventoryController.clearFilter();
                          inventoryController.getInventoryListPager();
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
          Obx(()=>Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              inventoryController.paginated.value!=null?   Container(
                  height: 70,
                  margin: EdgeInsets.symmetric(horizontal: 70,vertical: 10),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  color: AppColor.appBarColor.withOpacity(0.5),
                  alignment: Alignment.bottomCenter,
                  child:PagerWidget(countPage: inventoryController.paginated.value?.totalCount??0, callBack: (int index) {
                    inventoryController.isChangePage(index);
                  },)):SizedBox(),
            ],
          ),)
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

  List<DataColumn> buildDataColumns() {
    return [
      DataColumn(label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
          child: Text('ردیف', style: AppTextStyle.labelText)),headingRowAlignment:MainAxisAlignment.center ),
      DataColumn(
          label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
              child: Text('تاریخ', style: AppTextStyle.labelText)),
          headingRowAlignment: MainAxisAlignment.center,
        onSort: (columnIndex, ascending) {
          inventoryController.onSort(columnIndex, ascending);
        },
      ),
      DataColumn(
          label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
              child: Text('نام ثبت کننده', style: AppTextStyle.labelText)),
          headingRowAlignment: MainAxisAlignment.center,
          onSort: (columnIndex, ascending) {
            inventoryController.onSort(columnIndex, ascending);
          }
      ),
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
      /*DataColumn(
          label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
              child: Text('الصاق تصاویر', style: AppTextStyle.labelText)),
          headingRowAlignment: MainAxisAlignment.center),*/
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
                    GestureDetector(
                      onTap: () {
                        inventoryController.captureRowScreenshot(inventory, _dataTableKey, _rowKeys);
                      },
                      child: Row(
                        children: [
                          SvgPicture.asset(
                              'assets/svg/camera.svg',
                              height: 20,
                              colorFilter: ColorFilter.mode(
                                AppColor.iconViewColor,
                                BlendMode.srcIn,
                              )
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 5,),
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
                    style: AppTextStyle.bodyText.copyWith(color: AppColor.textColor,fontWeight: FontWeight.normal,fontSize: 10)
                ),
              )),
          // نام ثبت کننده
          DataCell(
              Center(
                child: Text(inventory.account?.name ?? "",
                    style: AppTextStyle.bodyText.copyWith(color: AppColor.textColor,fontWeight: FontWeight.normal,fontSize: 11)

                ),
              )),
          // محصول
          DataCell(
              Center(
                child: Row(
                  children: [
                    inventory.inventoryDetails!.isNotEmpty?
                    Image.network('${BaseUrl.baseUrl}Attachment/downloadResource?fileName=${inventory.inventoryDetails!.first.item?.icon}',
                      width: 25,
                      height: 25,):SizedBox(),
                    SizedBox(width: 5,),
                    Text(
                      inventory.inventoryDetails?.isNotEmpty == true
                          ? inventory.inventoryDetails!.first.item?.name ?? ""
                          : "",
                        style: AppTextStyle.bodyText.copyWith(color: AppColor.textColor,fontWeight: FontWeight.normal,fontSize: 11)
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  key: _rowKeys[inventory.id],
                  mainAxisAlignment: MainAxisAlignment
                      .spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                            color: AppColor.iconViewColor,fontSize: 11)),
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
                                            color: AppColor.iconViewColor,fontSize: 11)),
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
                                            color: AppColor.iconViewColor,fontSize: 11)),
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
                                        color: AppColor.iconViewColor,fontSize: 11)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(padding: EdgeInsets.only(bottom: 10,right: 10),
                      child: Row(mainAxisAlignment: MainAxisAlignment.start,
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
                                  color: AppColor.textColor,fontSize: 11)),
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
                      vertical: 5,
                      horizontal: 12),
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
                            .center,),
                  ),
                ),
              )),
          // الصاق تصاویر
          /*DataCell(
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () =>
                          inventoryController.pickImageDesktop(
                              inventory.inventoryDetails!.first.recId.toString(), "image", "Inventory",
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
                  ],
                ),
              )),*/
          // نمایش تصاویر
          DataCell(
            GestureDetector(
              onTap: () async{
                await inventoryController.getImage(inventory.recId??"", "Inventory");
                Future.delayed(const Duration(milliseconds: 200), () {
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
                                      itemCount: inventoryController.imageList.length,
                                      onPageChanged: (index) =>
                                      inventoryController
                                          .currentImagePage
                                          .value =
                                          index,
                                      itemBuilder: (context,
                                          index) {
                                        final attachment = inventoryController.imageList[index];
                                        return Column(
                                          children: [
                                            if (kIsWeb)
                                              Padding(
                                                padding: const EdgeInsets.only(right: 50),
                                                child: Row(mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    IconButton(
                                                      icon: Icon(Icons.download, color: AppColor.dividerColor),
                                                      onPressed: () => inventoryController.downloadImage(
                                                        attachment,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            SizedBox(
                                              width: 450,
                                              height: 450,
                                              child: Image.network(
                                                "${BaseUrl.baseUrl}Attachment/downloadAttachment?fileName=$attachment",
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
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                    /*Row(mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.download, color: AppColor.dividerColor),
                                          onPressed: () => inventoryController.downloadImage(attachment,),
                                        ),
                                      ],
                                    ),*/
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
                                                (inventoryController.imageList.length ?? 1) -
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
                                            inventoryController.imageList.length,
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

                });


              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/svg/picture.svg',height: 20,
                      colorFilter: ColorFilter.mode(

                        AppColor.textColor,

                        BlendMode.srcIn,
                      )),
                ],
              ),
            ),
          ),
          // آیکون های عملیات
          DataCell(
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(height: 3,),
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
                            'assets/svg/add.svg',height: 20,
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
                                  .buttonColor,fontSize: 11),),
                      ],
                    ),
                  ),
                  SizedBox(height: 5,),
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
                              'حذف', style: AppTextStyle
                                .labelText
                                .copyWith(
                                color: AppColor
                                    .accentColor,fontSize: 11),
                            )
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset(
                            'assets/svg/trash-bin.svg',height: 20,
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
                                  .accentColor,fontSize: 11),),
                      ],
                    ),
                  ),
                  SizedBox(height: 5,),
                  // آیکون ویرایش
                  GestureDetector(
                    onTap: () async{
                      inventory.type==0 ?
                      Get.toNamed('/inventoryDetailUpdatePayment', parameters: {"id":inventory.id.toString(),"index":""}):
                      Get.toNamed('/inventoryDetailUpdateReceive', parameters: {"id":inventory.id.toString(),"index":""});
                    },
                    child: Row(
                      children: [
                        Container(

                          child: SvgPicture
                              .asset(
                              'assets/svg/edit.svg',height: 20,
                              colorFilter: ColorFilter
                                  .mode(
                                AppColor
                                    .iconViewColor,
                                BlendMode
                                    .srcIn,)
                          ),
                        ),
                        Text('ویرایش  ', style: AppTextStyle.labelText.copyWith(
                            color: AppColor.iconViewColor,fontSize: 11),),
                      ],
                    ),
                  ),
                  SizedBox(height: 3,),
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
                    'نمایش اطلاعات کامل',  style: AppTextStyle
                      .bodyText.copyWith(
                      color: AppColor.textColor,fontSize: 11)),
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
                                  AppTextStyle.bodyText.copyWith(fontSize: 11,color: AppColor.primaryColor,fontWeight: FontWeight.bold) :
                                  AppTextStyle.bodyText.copyWith(fontSize: 11,color: AppColor.accentColor,fontWeight: FontWeight.bold),
                                    textDirection: TextDirection.ltr,
                                  ):SizedBox(),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 2),
                                  child: e.unitName=="عدد"? Text( "${e.unitName}",style:e.balance!>0 ?
                                  AppTextStyle.bodyText.copyWith(fontSize: 11,color: AppColor.primaryColor) :
                                  AppTextStyle.bodyText.copyWith(fontSize: 11,color: AppColor.accentColor),
                                    textDirection: TextDirection.ltr,
                                  ):SizedBox(),
                                ),
                                Container(
                                  child: e.unitName=="عدد"? Text( "${e.itemName}",style:e.balance!>0 ?
                                  AppTextStyle.bodyText.copyWith(fontSize: 11,color: AppColor.primaryColor) :
                                  AppTextStyle.bodyText.copyWith(fontSize: 11,color: AppColor.accentColor),
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
                              AppTextStyle.bodyText.copyWith(fontSize: 11,color: AppColor.primaryColor,fontWeight: FontWeight.bold) :
                              AppTextStyle.bodyText.copyWith(fontSize: 11,color: AppColor.accentColor,fontWeight: FontWeight.bold),
                                textDirection: TextDirection.ltr,
                              ):SizedBox(),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 2),
                              child: e.unitName=="ریال"? Text( "${e.unitName}",style:e.balance!>0 ?
                              AppTextStyle.bodyText.copyWith(fontSize: 11,color: AppColor.primaryColor) :
                              AppTextStyle.bodyText.copyWith(fontSize: 11,color: AppColor.accentColor),
                                textDirection: TextDirection.ltr,
                              ):SizedBox(),
                            ),
                            Container(
                              child: e.unitName=="ریال"? Text( "${e.itemName}",style:e.balance!>0 ?
                              AppTextStyle.bodyText.copyWith(fontSize: 11,color: AppColor.primaryColor) :
                              AppTextStyle.bodyText.copyWith(fontSize: 11,color: AppColor.accentColor),
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
                  child: inventory.balances!=null ?
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: inventory.balances!.map((e)=>
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 2),
                              child: e.unitName=="گرم"? Text( "${e.balance}",style:e.balance!>0 ?
                              AppTextStyle.bodyText.copyWith(fontSize: 11,color: AppColor.primaryColor,fontWeight: FontWeight.bold) :
                              AppTextStyle.bodyText.copyWith(fontSize: 11,color: AppColor.accentColor,fontWeight: FontWeight.bold),
                                textDirection: TextDirection.ltr,
                              ):SizedBox(),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 2),
                              child: e.unitName=="گرم"? Text( "${e.unitName}",style:e.balance!>0 ?
                              AppTextStyle.bodyText.copyWith(fontSize: 11,color: AppColor.primaryColor) :
                              AppTextStyle.bodyText.copyWith(fontSize: 11,color: AppColor.accentColor),
                                textDirection: TextDirection.ltr,
                              ):SizedBox(),
                            ),
                            Container(
                              child: e.unitName=="گرم"? Text( "${e.itemName}",style:e.balance!>0 ?
                              AppTextStyle.bodyText.copyWith(fontSize: 11,color: AppColor.primaryColor) :
                              AppTextStyle.bodyText.copyWith(fontSize: 11,color: AppColor.accentColor),
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
                                    /*GestureDetector(
                                      onTap: () =>
                                          inventoryController
                                              .pickImageDesktop(
                                              getOneInventories!
                                                  .recId
                                                  .toString(),
                                              "image",
                                              "Inventory",
                                              inventoryId: inventory.id!),
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
                                    ),*/
                                    /*Obx(() {
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
                                    }),*/
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
                                Row(
                                  children: [
                                    Text(
                                        ' توضیحات: ',
                                        style: AppTextStyle
                                            .labelText),
                                    Text(
                                        '${getOneInventories
                                            ?.description ??
                                            0}',
                                        style: AppTextStyle
                                            .bodyText),
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
                                      onTap: () async{
                                        await inventoryController.getImage(getOneInventories?.recId??"", "InventoryDetail");

                                        Future.delayed(const Duration(milliseconds: 200), () {
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
                                                              itemCount: inventoryController.imageList.length,
                                                              onPageChanged: (index) =>
                                                              inventoryController
                                                                  .currentImagePage
                                                                  .value =
                                                                  index,
                                                              itemBuilder: (context,
                                                                  index) {
                                                                final attachment = inventoryController.imageList[index];
                                                                return Column(
                                                                  children: [
                                                                    if (kIsWeb)
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(right: 50),
                                                                        child: Row(mainAxisAlignment: MainAxisAlignment.start,
                                                                          children: [
                                                                            IconButton(
                                                                              icon: Icon(Icons.download, color: AppColor.dividerColor),
                                                                              onPressed: () => inventoryController.downloadImage(
                                                                                attachment,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    SizedBox(
                                                                      width: 450,
                                                                      height: 450,
                                                                      child: Image.network(
                                                                        "${BaseUrl
                                                                            .baseUrl}Attachment/downloadAttachment?fileName=$attachment",
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
                                                                      ),
                                                                    ),
                                                                  ],
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
                                                                        (inventoryController.imageList.length ?? 1) -
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
                                                                    inventoryController.imageList.length,
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

                                        });


                                      },
                                      child: SvgPicture.asset('assets/svg/picture.svg',height: 20,
                                          colorFilter: ColorFilter.mode(

                                            AppColor.textColor,

                                            BlendMode.srcIn,
                                          )),
                                    ),
                                    //  آیکون ویرایش
                                    GestureDetector(
                                      onTap: () {
                                        getOneInventories?.type==1 ?
                                        Get.toNamed('/inventoryDetailUpdateReceive', parameters: {"id":getOneInventories!.inventoryId.toString(),"index":index.toString()}):
                                        Get.toNamed('/inventoryDetailUpdatePayment', parameters: {"id":getOneInventories!.inventoryId.toString(),"index":index.toString()});
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
                                                  Gregorian date=getOneInventories!.date!.toGregorian();
                                                  Get.back();
                                                  getOneInventories.type==1 ?
                                                  inventoryController.updateDeleteInventoryReceive(
                                                    "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}T${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}",
                                                      inventory.id!,
                                                      getOneInventories.id!, 3 ,1,
                                                      inventory.account!.id!,
                                                      getOneInventories.wallet!.id!,
                                                      getOneInventories.item!.id!,
                                                      getOneInventories.quantity!,
                                                  )
                                                      : inventoryController.updateDeleteInventoryPayment(
                                                    "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}T${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}",
                                                      inventory.id!,
                                                      getOneInventories.id!, 3 ,0,
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
}
