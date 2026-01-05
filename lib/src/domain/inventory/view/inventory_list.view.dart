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
import '../../../config/repository/user_info_transaction.repository.dart';
import '../../../widget/app_drawer.widget.dart';
import '../../../widget/background_image_total.widget.dart';
import '../../../widget/custom_appbar.widget.dart';
import '../../../widget/custom_dropdown.widget.dart';
import '../../../widget/empty.dart';
import '../../../widget/err_page.dart';
import '../../../widget/pager_widget.dart';
import '../../home/widget/chat_dialog.widget.dart';
import '../../product/model/item.model.dart';
import '../../transaction/widgets/balance_dialog.widget.dart';
import '../../users/model/balance_item.model.dart';
import '../service/invoice_generation.service.dart';

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
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;

    return Scaffold(
      appBar: CustomAppbar1(title: 'لیست دریافت/پرداخت',
        onBackTap: () => Get.offNamed('/home'),
      ),
      drawer: const AppDrawer(),
      body: Stack(
        children: [
          BackgroundImageTotal(),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(isMobile ? 4.0 : 8.0),
              child: SizedBox(
                height: Get.height,
                width: Get.width,
                child: Column(
                  children: [
                    isDesktop?
                    SizedBox.shrink() :
                    Padding(
                      padding: EdgeInsets.all(isMobile ? 4.0 : 8.0),
                      child: Column(
                        children: [
                          // فیلد جستجو
                          Row(
                            children: [
                              //فیلد جستجو
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: isMobile ? 8.0 : 50.0,
                                      vertical: isMobile ? 5.0 : 10.0
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: isMobile ? 12.0 : 20.0
                                  ),
                                  color: AppColor.appBarColor.withAlpha(130),
                                  alignment: Alignment.center,
                                  height: isMobile ? 60.0 : 80.0,
                                  child: TextFormField(
                                    controller: inventoryController.searchController,
                                    style: AppTextStyle.labelText.copyWith(
                                        fontSize: isMobile ? 12.0 : null
                                    ),
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
                                      hintStyle: AppTextStyle.labelText.copyWith(
                                          fontSize: isMobile ? 12.0 : null
                                      ),
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
                                            size: isMobile ? 20.0 : 30.0,)
                                      ),
                                      suffixIcon: IconButton(
                                        onPressed: inventoryController.clearSearch,
                                        icon: Icon(
                                            Icons.close, color: AppColor.textColor, size: isMobile ? 20.0 : null),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Responsive button layout
                          isMobile ?
                          Column(
                            children: [
                              // Create button - full width on mobile
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      padding: WidgetStatePropertyAll(
                                          EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
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
                                    style: AppTextStyle.labelText.copyWith(fontSize: 12),
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              // Action buttons row
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildMobileActionButton(
                                    'خروجی اکسل',
                                    AppColor.secondary3Color,
                                        () => _showExportDialog(context, 'excel'),
                                  ),
                                  _buildMobileActionButton(
                                    'خروجی PDF',
                                    AppColor.secondary3Color,
                                        () => _showExportDialog(context, 'pdf'),
                                  ),
                                  // فیلتر
                                  ElevatedButton(
                                    style: ButtonStyle(
                                        padding: WidgetStatePropertyAll(
                                            EdgeInsets.symmetric(horizontal:isDesktop ? 23 : 30,vertical: isDesktop ? 19 : 15)),
                                        // elevation: WidgetStatePropertyAll(5),
                                        backgroundColor:
                                        WidgetStatePropertyAll(AppColor.appBarColor.withAlpha(130)),
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
                                                  width:isDesktop?  Get.width * 0.4:Get.width * 0.6,
                                                  height:isDesktop?  Get.height * 0.75:Get.height * 0.75,
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
                                                                      WidgetStatePropertyAll(AppColor.accentColor.withAlpha(130)),
                                                                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(side: BorderSide(color: AppColor.textColor),
                                                                          borderRadius: BorderRadius.circular(5)))),
                                                                  onPressed: () async {
                                                                    inventoryController.currentPage.value=1;
                                                                    inventoryController.itemsPerPage.value=25;
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
                                                                    'شماره انگ',
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
                                                                      controller: inventoryController.receiptNumberController,
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
                                                              SizedBox(height: 8),
                                                              // مقدار (Quantity) Filter
                                                              Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    'مقدار',
                                                                    style: AppTextStyle.labelText.copyWith(
                                                                      fontSize: 11,
                                                                      fontWeight: FontWeight.normal,
                                                                      color: AppColor.textColor,
                                                                    ),
                                                                  ),
                                                                  SizedBox(height: 10),
                                                                  IntrinsicHeight(
                                                                    child: TextFormField(
                                                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                                                      controller: inventoryController.quantityFilterController,
                                                                      style: AppTextStyle.labelText.copyWith(fontSize: 15),
                                                                      textAlign: TextAlign.start,
                                                                      keyboardType: TextInputType.number,
                                                                      decoration: InputDecoration(
                                                                        contentPadding: const EdgeInsets.symmetric(
                                                                          vertical: 11,
                                                                          horizontal: 15,
                                                                        ),
                                                                        isDense: true,
                                                                        border: OutlineInputBorder(
                                                                          borderRadius: BorderRadius.circular(6),
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
                                                              // محصول (Product/Item) Filter
                                                              Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    'محصول',
                                                                    style: AppTextStyle.labelText.copyWith(
                                                                      fontSize: 11,
                                                                      fontWeight: FontWeight.normal,
                                                                      color: AppColor.textColor,
                                                                    ),
                                                                  ),
                                                                  SizedBox(height: 10),
                                                                  Obx(() => DropdownButtonFormField<ItemModel>(
                                                                    value: inventoryController.selectedItemFilter.value,
                                                                    dropdownColor: AppColor.backGroundColor1,
                                                                    decoration: InputDecoration(
                                                                      contentPadding: const EdgeInsets.only(
                                                                        top: 11,
                                                                        bottom: 11,
                                                                        right: 5,
                                                                        //horizontal: 15,
                                                                      ),

                                                                      isDense: true,
                                                                      border: OutlineInputBorder(
                                                                        borderRadius: BorderRadius.circular(6),
                                                                      ),
                                                                      filled: true,
                                                                      fillColor: AppColor.textFieldColor,
                                                                      errorMaxLines: 1,
                                                                    ),
                                                                    hint: Text(
                                                                      'انتخاب',
                                                                      style: AppTextStyle.labelText.copyWith(fontSize: 15),
                                                                    ),
                                                                    items: inventoryController.itemList.map((ItemModel item) {
                                                                      return DropdownMenuItem<ItemModel>(
                                                                        value: item,
                                                                        child: Text(
                                                                          item.name ?? '',
                                                                          style: AppTextStyle.labelText.copyWith(fontSize: 15,),
                                                                        ),
                                                                      );
                                                                    }).toList(),
                                                                    onChanged: (ItemModel? newValue) {
                                                                      inventoryController.changeSelectedItemFilter(newValue);
                                                                    },
                                                                  )),
                                                                ],
                                                              ),
                                                              SizedBox(height: 8),
                                                              Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    'نوع دریافت/پرداخت',
                                                                    style: AppTextStyle.labelText.copyWith(
                                                                      fontSize: 11,
                                                                      fontWeight: FontWeight.normal,
                                                                      color: AppColor.textColor,
                                                                    ),
                                                                  ),
                                                                  SizedBox(height: 8),
                                                                  Container(
                                                                    padding: EdgeInsets.only(bottom: 5),
                                                                    child: Obx(() {
                                                                      return CustomDropdownWidget(
                                                                        validator: (value) {
                                                                          if (value == 'انتخاب کنید' || value == null || value.isEmpty) {
                                                                            return 'نوع را انتخاب کنید';
                                                                          }
                                                                          return null;
                                                                        },
                                                                        items: [
                                                                          'انتخاب کنید',
                                                                          'دریافت',
                                                                          'پرداخت',
                                                                        ],
                                                                        selectedValue: inventoryController.typeFilter.value ?? '',
                                                                        onChanged: (String? newValue) {
                                                                          inventoryController.changeSelectedType(newValue!);
                                                                        },
                                                                        backgroundColor: AppColor.textFieldColor,
                                                                        borderRadius: 7,
                                                                        borderColor: AppColor.secondaryColor,
                                                                        hideUnderline: true,
                                                                      );
                                                                    }),
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
                                                          margin: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
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
                                                              inventoryController.currentPage.value=1;
                                                              inventoryController.itemsPerPage.value=25;
                                                              inventoryController.getInventoryListPager();
                                                              Get.back();

                                                            },
                                                            child:
                                                            inventoryController.isLoading.value?
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
                                              inventoryController.nameFilterController.text!="" ||
                                                  inventoryController.receiptNumberController.text!="" ||
                                                  inventoryController.dateStartController.text!="" ||
                                                  inventoryController.dateEndController.text!="" ||
                                                  inventoryController.quantityFilterController.text!="" ||
                                                  inventoryController.selectedItemFilter.value != null ||
                                                  (inventoryController.typeFilter.value != null && inventoryController.typeFilter.value != '')
                                                  ?AppColor.accentColor:  AppColor
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
                                                  : 10,color:  inventoryController.nameFilterController.text!="" ||
                                              inventoryController.receiptNumberController.text!="" ||
                                              inventoryController.dateStartController.text!="" ||
                                              inventoryController.dateEndController.text!="" ||
                                              inventoryController.quantityFilterController.text!="" ||
                                              inventoryController.selectedItemFilter.value != null ||
                                              (inventoryController.typeFilter.value != null && inventoryController.typeFilter.value != '')
                                              ?AppColor.accentColor: AppColor.textColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ) :
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
                                    WidgetStatePropertyAll(AppColor.appBarColor.withAlpha(130)),
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
                                              width:isDesktop?  Get.width * 0.3:Get.width * 0.6,
                                              height:isDesktop?  Get.height * 0.75:Get.height * 0.7,
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
                                                                  WidgetStatePropertyAll(AppColor.accentColor.withAlpha(130)),
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
                                                                'شماره انگ',
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
                                                                  controller: inventoryController.receiptNumberController,
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
                                                          SizedBox(height: 8),
                                                          // مقدار (Quantity) Filter
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                'مقدار',
                                                                style: AppTextStyle.labelText.copyWith(
                                                                  fontSize: 11,
                                                                  fontWeight: FontWeight.normal,
                                                                  color: AppColor.textColor,
                                                                ),
                                                              ),
                                                              SizedBox(height: 10),
                                                              IntrinsicHeight(
                                                                child: TextFormField(
                                                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                                                  controller: inventoryController.quantityFilterController,
                                                                  style: AppTextStyle.labelText.copyWith(fontSize: 15),
                                                                  textAlign: TextAlign.start,
                                                                  keyboardType: TextInputType.number,
                                                                  decoration: InputDecoration(
                                                                    contentPadding: const EdgeInsets.symmetric(
                                                                      vertical: 11,
                                                                      horizontal: 15,
                                                                    ),
                                                                    isDense: true,
                                                                    border: OutlineInputBorder(
                                                                      borderRadius: BorderRadius.circular(6),
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
                                                          // محصول (Product/Item) Filter
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                'محصول',
                                                                style: AppTextStyle.labelText.copyWith(
                                                                  fontSize: 11,
                                                                  fontWeight: FontWeight.normal,
                                                                  color: AppColor.textColor,
                                                                ),
                                                              ),
                                                              SizedBox(height: 10),
                                                              Obx(() => DropdownButtonFormField<ItemModel>(
                                                                value: inventoryController.selectedItemFilter.value,
                                                                dropdownColor: AppColor.backGroundColor1,
                                                                decoration: InputDecoration(
                                                                  contentPadding: const EdgeInsets.symmetric(
                                                                    vertical: 11,
                                                                    horizontal: 15,
                                                                  ),
                                                                  isDense: true,
                                                                  border: OutlineInputBorder(
                                                                    borderRadius: BorderRadius.circular(6),
                                                                  ),
                                                                  filled: true,
                                                                  fillColor: AppColor.textFieldColor,
                                                                  errorMaxLines: 1,
                                                                ),
                                                                hint: Text(
                                                                  'انتخاب محصول',
                                                                  style: AppTextStyle.labelText.copyWith(fontSize: 15),
                                                                ),
                                                                items: inventoryController.itemList.map((ItemModel item) {
                                                                  return DropdownMenuItem<ItemModel>(
                                                                    value: item,
                                                                    child: Text(
                                                                      item.name ?? '',
                                                                      style: AppTextStyle.labelText.copyWith(fontSize: 15,),
                                                                    ),
                                                                  );
                                                                }).toList(),
                                                                onChanged: (ItemModel? newValue) {
                                                                  inventoryController.changeSelectedItemFilter(newValue);
                                                                },
                                                              )),
                                                            ],
                                                          ),
                                                          SizedBox(height: 8),
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                'نوع دریافت/پرداخت',
                                                                style: AppTextStyle.labelText.copyWith(
                                                                  fontSize: 11,
                                                                  fontWeight: FontWeight.normal,
                                                                  color: AppColor.textColor,
                                                                ),
                                                              ),
                                                              SizedBox(height: 8),
                                                              Container(
                                                                padding: EdgeInsets.only(bottom: 5),
                                                                child: Obx(() {
                                                                  return CustomDropdownWidget(
                                                                    validator: (value) {
                                                                      if (value == 'انتخاب کنید' || value == null || value.isEmpty) {
                                                                        return 'نوع را انتخاب کنید';
                                                                      }
                                                                      return null;
                                                                    },
                                                                    items: [
                                                                      'انتخاب کنید',
                                                                      'دریافت',
                                                                      'پرداخت',
                                                                    ],
                                                                    selectedValue: inventoryController.typeFilter.value ?? '',
                                                                    onChanged: (String? newValue) {
                                                                      inventoryController.changeSelectedType(newValue!);
                                                                    },
                                                                    backgroundColor: AppColor.textFieldColor,
                                                                    borderRadius: 7,
                                                                    borderColor: AppColor.secondaryColor,
                                                                    hideUnderline: true,
                                                                  );
                                                                }),
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
                                          inventoryController.nameFilterController.text!="" ||
                                              inventoryController.receiptNumberController.text!="" ||
                                              inventoryController.dateStartController.text!="" ||
                                              inventoryController.dateEndController.text!="" ||
                                              inventoryController.quantityFilterController.text!="" ||
                                              inventoryController.selectedItemFilter.value != null ||
                                              (inventoryController.typeFilter.value != null && inventoryController.typeFilter.value != '')
                                              ?AppColor.accentColor:  AppColor
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
                                              : 10,color:  inventoryController.nameFilterController.text!="" ||
                                          inventoryController.receiptNumberController.text!="" ||
                                          inventoryController.dateStartController.text!="" ||
                                          inventoryController.dateEndController.text!="" ||
                                          inventoryController.quantityFilterController.text!="" ||
                                          inventoryController.selectedItemFilter.value != null ||
                                          (inventoryController.typeFilter.value != null && inventoryController.typeFilter.value != '')
                                          ?AppColor.accentColor: AppColor.textColor),
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
                              margin: EdgeInsets.symmetric(horizontal: 5,vertical: 15),
                              padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                              color: AppColor.backGroundColor1.withAlpha(150),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            SingleChildScrollView(
                                              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.symmetric( vertical: 5),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width: 400,
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
                                                        SizedBox(width: 10,),
                                                        Row(
                                                          children: [
                                                            //دکمه ایجاد دریافت/پرداخت
                                                            TextButton.icon(
                                                              onPressed: () {
                                                                Get.toNamed('/inventoryCreate');
                                                              },
                                                              icon: SvgPicture.asset(
                                                                'assets/svg/add-plus.svg',
                                                                height: 24,
                                                              ),
                                                                label: Text(
                                                                  'ایجاد دریافت/پرداخت جدید',
                                                                  style: AppTextStyle.labelText.copyWith(fontSize: 12),
                                                                ),
                                                            ),
                                                            SizedBox(width: 5,),
                                                            // خروجی اکسل
                                                            OutlinedButton.icon(
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
                                                            SizedBox(width: 5,),
                                                            // خروجی pdf
                                                            OutlinedButton.icon(
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
                                                              label: Text(
                                                                'خروجی pdf',
                                                                style: AppTextStyle.labelText.copyWith(color: AppColor.textAccentColor,fontSize: 12),
                                                              ),
                                                              icon: SvgPicture.asset(
                                                                'assets/svg/pdf.svg',
                                                                height: 24,
                                                              ),
                                                            ),
                                                            SizedBox(width: 5,),
                                                            // فیلتر
                                                            OutlinedButton.icon(
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
                                                                            height:isDesktop?  Get.height * 0.75:Get.height * 0.7,
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
                                                                                                WidgetStatePropertyAll(AppColor.accentColor.withAlpha(130)),
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
                                                                                              'شماره انگ',
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
                                                                                                controller: inventoryController.receiptNumberController,
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
                                                                                        SizedBox(height: 8),
                                                                                        // مقدار (Quantity) Filter
                                                                                        Column(
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            Text(
                                                                                              'مقدار',
                                                                                              style: AppTextStyle.labelText.copyWith(
                                                                                                fontSize: 11,
                                                                                                fontWeight: FontWeight.normal,
                                                                                                color: AppColor.textColor,
                                                                                              ),
                                                                                            ),
                                                                                            SizedBox(height: 10),
                                                                                            IntrinsicHeight(
                                                                                              child: TextFormField(
                                                                                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                                                                                controller: inventoryController.quantityFilterController,
                                                                                                style: AppTextStyle.labelText.copyWith(fontSize: 15),
                                                                                                textAlign: TextAlign.start,
                                                                                                keyboardType: TextInputType.number,
                                                                                                decoration: InputDecoration(
                                                                                                  contentPadding: const EdgeInsets.symmetric(
                                                                                                    vertical: 11,
                                                                                                    horizontal: 15,
                                                                                                  ),
                                                                                                  isDense: true,
                                                                                                  border: OutlineInputBorder(
                                                                                                    borderRadius: BorderRadius.circular(6),
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
                                                                                        // محصول (Product/Item) Filter
                                                                                        Column(
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            Text(
                                                                                              'محصول',
                                                                                              style: AppTextStyle.labelText.copyWith(
                                                                                                fontSize: 11,
                                                                                                fontWeight: FontWeight.normal,
                                                                                                color: AppColor.textColor,
                                                                                              ),
                                                                                            ),
                                                                                            SizedBox(height: 10),
                                                                                            Obx(() => DropdownButtonFormField<ItemModel>(
                                                                                              value: inventoryController.selectedItemFilter.value,
                                                                                              dropdownColor: AppColor.backGroundColor1,
                                                                                              decoration: InputDecoration(
                                                                                                contentPadding: const EdgeInsets.symmetric(
                                                                                                  vertical: 11,
                                                                                                  horizontal: 15,
                                                                                                ),
                                                                                                isDense: true,
                                                                                                border: OutlineInputBorder(
                                                                                                  borderRadius: BorderRadius.circular(6),
                                                                                                ),
                                                                                                filled: true,
                                                                                                fillColor: AppColor.textFieldColor,
                                                                                                errorMaxLines: 1,
                                                                                              ),
                                                                                              hint: Text(
                                                                                                'انتخاب محصول',
                                                                                                style: AppTextStyle.labelText.copyWith(fontSize: 15),
                                                                                              ),
                                                                                              items: inventoryController.itemList.map((ItemModel item) {
                                                                                                return DropdownMenuItem<ItemModel>(
                                                                                                  value: item,
                                                                                                  child: Text(
                                                                                                    item.name ?? '',
                                                                                                    style: AppTextStyle.labelText.copyWith(fontSize: 15,),
                                                                                                  ),
                                                                                                );
                                                                                              }).toList(),
                                                                                              onChanged: (ItemModel? newValue) {
                                                                                                inventoryController.changeSelectedItemFilter(newValue);
                                                                                              },
                                                                                            )),
                                                                                          ],
                                                                                        ),
                                                                                        SizedBox(height: 8),
                                                                                        Column(
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            Text(
                                                                                              'نوع دریافت/پرداخت',
                                                                                              style: AppTextStyle.labelText.copyWith(
                                                                                                fontSize: 11,
                                                                                                fontWeight: FontWeight.normal,
                                                                                                color: AppColor.textColor,
                                                                                              ),
                                                                                            ),
                                                                                            SizedBox(height: 8),
                                                                                            Container(
                                                                                              padding: EdgeInsets.only(bottom: 5),
                                                                                              child: Obx(() {
                                                                                                return CustomDropdownWidget(
                                                                                                  validator: (value) {
                                                                                                    if (value == 'انتخاب کنید' || value == null || value.isEmpty) {
                                                                                                      return 'نوع را انتخاب کنید';
                                                                                                    }
                                                                                                    return null;
                                                                                                  },
                                                                                                  items: [
                                                                                                    'انتخاب کنید',
                                                                                                    'دریافت',
                                                                                                    'پرداخت',
                                                                                                  ],
                                                                                                  selectedValue: inventoryController.typeFilter.value ?? '',
                                                                                                  onChanged: (String? newValue) {
                                                                                                    inventoryController.changeSelectedType(newValue!);
                                                                                                  },
                                                                                                  backgroundColor: AppColor.textFieldColor,
                                                                                                  borderRadius: 7,
                                                                                                  borderColor: AppColor.secondaryColor,
                                                                                                  hideUnderline: true,
                                                                                                );
                                                                                              }),
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
                                                                label: Text(
                                                                  'فیلتر',
                                                                  style: AppTextStyle
                                                                      .labelText
                                                                      .copyWith(
                                                                      fontSize: isDesktop
                                                                          ? 12
                                                                          : 10,color:  inventoryController.nameFilterController.text!="" ||
                                                                      inventoryController.receiptNumberController.text!="" ||
                                                                      inventoryController.dateStartController.text!="" ||
                                                                      inventoryController.dateEndController.text!="" ||
                                                                      inventoryController.quantityFilterController.text!="" ||
                                                                      inventoryController.selectedItemFilter.value != null ||
                                                                      (inventoryController.typeFilter.value != null && inventoryController.typeFilter.value != '')
                                                                      ?AppColor.accentColor: AppColor.textColor),
                                                                ),
                                                              icon: SvgPicture.asset(
                                                                  'assets/svg/filter3.svg',
                                                                  height: 17,
                                                                  colorFilter:
                                                                  ColorFilter
                                                                      .mode(
                                                                    inventoryController.nameFilterController.text!="" ||
                                                                        inventoryController.receiptNumberController.text!="" ||
                                                                        inventoryController.dateStartController.text!="" ||
                                                                        inventoryController.dateEndController.text!="" ||
                                                                        inventoryController.quantityFilterController.text!="" ||
                                                                        inventoryController.selectedItemFilter.value != null ||
                                                                        (inventoryController.typeFilter.value != null && inventoryController.typeFilter.value != '')
                                                                        ?AppColor.accentColor:  AppColor
                                                                        .textColor,
                                                                    BlendMode
                                                                        .srcIn,
                                                                  )),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
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
                                                      headingRowColor: WidgetStatePropertyAll(AppColor.buttonColor.withAlpha(40)),
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
                                    margin: EdgeInsets.all(isMobile ? 4.0 : 8.0),
                                    color: AppColor.secondaryColor,
                                    elevation: isMobile ? 5 : 10,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(isMobile ? 8 : 12),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(isMobile ? 12.0 : 8.0),
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
                                                        style: AppTextStyle.bodyText.copyWith(
                                                          fontSize: isMobile ? 11.0 : null,
                                                        ),
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                     // نام کاربر
                                                     Text(inventories.account!.name!.length > 25
                                                         ? '${inventories.account?.name?.substring(0, 25) ?? ""}...'
                                                         : inventories.account?.name ?? "",
                                                        style: AppTextStyle
                                                            .bodyText.copyWith(fontSize: 12,color: AppColor.dividerColor),),
                                                    Card(
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius
                                                            .circular(5),
                                                      ),
                                                      color: inventories.type == 0
                                                          ? AppColor.primaryColor
                                                          : AppColor.accentColor,
                                                      margin: EdgeInsets
                                                          .symmetric(
                                                          vertical: 0,
                                                          horizontal: isMobile ? 2 : 5),
                                                      child: Padding(
                                                        padding: EdgeInsets.all(isMobile ? 4 : 2),
                                                        child: Text(
                                                            inventories.type == 0
                                                                ? 'دریافت'
                                                                : 'پرداخت',
                                                            style: AppTextStyle
                                                                .labelText.copyWith(
                                                              fontSize: isMobile ? 10.0 : null,
                                                            ),
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
                                                // نام محصول
                                                isMobile ?
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text('محصول:  ',
                                                          style: AppTextStyle
                                                              .labelText.copyWith(fontSize: 11),),
                                                        Expanded(
                                                          child: Text(inventories.item?.name ?? "",
                                                            style: AppTextStyle
                                                                .bodyText.copyWith(fontSize: 12,color: AppColor.secondary2Color,fontWeight: FontWeight.w600),),
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                                ' مقدار: ',
                                                                style: AppTextStyle
                                                                    .bodyText.copyWith(fontSize: 11)
                                                            ),
                                                            Text(
                                                                '${inventories.totalQuantity.toString().seRagham() ?? 0} ${inventories.item?.itemUnit?.name ?? ""}',
                                                                style: AppTextStyle
                                                                    .bodyText.copyWith(fontSize: 12,fontWeight: FontWeight.bold,color: inventories.type == 0 ?AppColor.primaryColor :AppColor.accentColor)
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 4),
                                                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text('ضمانت کاربر: ',style: AppTextStyle.labelText.copyWith(fontSize: 11),),
                                                            Center(
                                                              child:
                                                              inventories.type==0 ? Text('ندارد',style: AppTextStyle.labelText.copyWith(fontSize: 11),) :
                                                              inventories.confirmByAdmin==true ?
                                                              SvgPicture.asset('assets/svg/check-mark-circle.svg',
                                                                  width: 16, height: 16,
                                                                  colorFilter: ColorFilter.mode(
                                                                    AppColor.primaryColor,
                                                                    BlendMode.srcIn,
                                                                  )) :
                                                              SvgPicture.asset('assets/svg/close-circle1.svg',
                                                                  width: 16, height: 16,
                                                                  colorFilter: ColorFilter.mode(
                                                                    AppColor.accentColor,
                                                                    BlendMode.srcIn,
                                                                  )),
                                                            ),
                                                          ],
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
                                                  ],
                                                ) :
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text('محصول:  ',
                                                          style: AppTextStyle
                                                              .labelText.copyWith(fontSize: 11),),
                                                        Expanded(
                                                          child: Text(inventories.item?.name ?? "",
                                                            style: AppTextStyle
                                                                .bodyText.copyWith(fontSize: 11),),
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                                ' مقدار: ',
                                                                style: AppTextStyle
                                                                    .bodyText.copyWith(fontSize: 11)
                                                            ),
                                                            Text(
                                                                '${inventories.totalQuantity.toString().seRagham() ?? 0} ${inventories.item?.itemUnit?.name ?? ""}',
                                                                style: AppTextStyle
                                                                    .bodyText.copyWith(fontSize: 11,color: inventories.type == 0 ?AppColor.primaryColor :AppColor.accentColor)
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 4),
                                                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text('ضمانت کاربر: ',style: AppTextStyle.labelText.copyWith(fontSize: 11),),
                                                            Center(
                                                              child:
                                                              inventories.type==0 ? Text('ندارد',style: AppTextStyle.labelText.copyWith(fontSize: 11),) :
                                                              inventories.confirmByAdmin==true ?
                                                              SvgPicture.asset('assets/svg/check-mark-circle.svg',
                                                                  width: 16, height: 16,
                                                                  colorFilter: ColorFilter.mode(
                                                                    AppColor.primaryColor,
                                                                    BlendMode.srcIn,
                                                                  )) :
                                                              SvgPicture.asset('assets/svg/close-circle1.svg',
                                                                  width: 16, height: 16,
                                                                  colorFilter: ColorFilter.mode(
                                                                    AppColor.accentColor,
                                                                    BlendMode.srcIn,
                                                                  )),
                                                            ),
                                                          ],
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
                                                  ],
                                                ),
                                                //SizedBox(height: 12,),
                                                // آیکون ها
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    //آیکون اضافه
                                                    /*GestureDetector(
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
                                                  ),*/
                                                    //آیکون حذف
                                                    /*GestureDetector(
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
                                                  ),*/
                                                  ],
                                                ),
                                                // فلش نمایش ایتم های دریافت/پرداخت
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .center,
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: (isExpanded ? AppColor.accentColor : AppColor.primaryColor).withAlpha(25),
                                                        borderRadius: BorderRadius.circular(20),
                                                      ),
                                                      child: IconButton(
                                                        onPressed: () async {
                                                          await inventoryController
                                                              .fetchGetInventoryDetail(
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
                                                          size: isMobile ? 20 : 24,
                                                        ),
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
                                                    vertical: isMobile ? 8 : 3),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .start,
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .spaceEvenly,
                                                  children: [
                                                    SizedBox(height: isMobile ? 12 : 8,),
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
                                                            : inventoryController.getInventoryDetail.value==null ?
                                                        Text(
                                                            'اطلاعاتی موجود نیست',
                                                            style: AppTextStyle
                                                                .labelText):
                                                        Expanded(
                                                          child: ListView.builder(
                                                            shrinkWrap: true,
                                                            physics: NeverScrollableScrollPhysics(),
                                                            itemCount: inventoryController.getInventoryDetail.length,
                                                            itemBuilder: (context,
                                                                index) {
                                                              var getInventoryDetails = inventoryController.getInventoryDetail[index];
                                                              return ListTile(
                                                                title: Card(
                                                                  color: AppColor
                                                                      .backGroundColor,
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(isMobile ? 8 : 12),
                                                                  ),
                                                                  child: Padding(
                                                                    padding: EdgeInsets.all(isMobile ? 12 : 8),
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
                                                                                    getInventoryDetails!
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
                                                                        isMobile ?
                                                                        Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Row(
                                                                              children: [
                                                                                Text(
                                                                                    ' آیتم: ',
                                                                                    style: AppTextStyle
                                                                                        .labelText.copyWith(fontSize: 11)),
                                                                                Expanded(
                                                                                  child: Text(
                                                                                    getInventoryDetails
                                                                                        ?.item
                                                                                        ?.name ??
                                                                                        "",
                                                                                    style: AppTextStyle
                                                                                        .bodyText.copyWith(fontSize: 11),
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                  ),
                                                                                ),
                                                                                Row(
                                                                                  children: [
                                                                                    Text(
                                                                                        ' مقدار: ',
                                                                                        style: AppTextStyle
                                                                                            .bodyText.copyWith(fontSize: 11)
                                                                                    ),
                                                                                    Text(
                                                                                        '${getInventoryDetails.weight.toString().seRagham() ?? 0} ${getInventoryDetails.item?.itemUnit?.name ?? ""}',
                                                                                        style: AppTextStyle
                                                                                            .bodyText.copyWith(fontSize: 11)
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            SizedBox(
                                                                              height: 5,),
                                                                            Row(
                                                                              children: [
                                                                                Text(
                                                                                    ' شناسه دریافت: ',
                                                                                    style: AppTextStyle
                                                                                        .bodyText
                                                                                ),
                                                                                Text(
                                                                                    '${getInventoryDetails.id.toString() ?? 0}',
                                                                                    style: AppTextStyle
                                                                                        .bodyText
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        ) :
                                                                        Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Row(
                                                                              children: [
                                                                                Text(
                                                                                    ' آیتم: ',
                                                                                    style: AppTextStyle
                                                                                        .labelText.copyWith(fontSize: 11)),
                                                                                Expanded(
                                                                                  child: Text(
                                                                                    getInventoryDetails
                                                                                        ?.item
                                                                                        ?.name ??
                                                                                        "",
                                                                                    style: AppTextStyle
                                                                                        .bodyText.copyWith(fontSize: 11),
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                  ),
                                                                                ),
                                                                                Row(
                                                                                  children: [
                                                                                    Text(
                                                                                        ' مقدار: ',
                                                                                        style: AppTextStyle
                                                                                            .bodyText.copyWith(fontSize: 11)
                                                                                    ),
                                                                                    Text(
                                                                                        '${getInventoryDetails.weight.toString().seRagham() ?? 0} ${getInventoryDetails.item?.itemUnit?.name ?? ""}',
                                                                                        style: AppTextStyle
                                                                                            .bodyText.copyWith(fontSize: 11)
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            SizedBox(
                                                                              height: 5,),
                                                                            Row(
                                                                              children: [
                                                                                Text(
                                                                                    ' شناسه دریافت: ',
                                                                                    style: AppTextStyle
                                                                                        .bodyText
                                                                                ),
                                                                                Text(
                                                                                    '${getInventoryDetails.id.toString() ?? 0}',
                                                                                    style: AppTextStyle
                                                                                        .bodyText
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                          height: 5,),
                                                                        //  عیار - وزن750- ناخالصی شماره قبض آزمایشگاه ش آز
                                                                        isMobile && getInventoryDetails.item?.id == 1 ?
                                                                        Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Row(
                                                                                  children: [
                                                                                    Text(
                                                                                        ' عیار: ',
                                                                                        style: AppTextStyle
                                                                                            .labelText.copyWith(fontSize: 11)),
                                                                                    Text(
                                                                                        '${getInventoryDetails
                                                                                            ?.carat ??
                                                                                            0}',
                                                                                        style: AppTextStyle
                                                                                            .bodyText.copyWith(fontSize: 11)),
                                                                                  ],
                                                                                ),
                                                                                SizedBox(height: 4),
                                                                                Row(
                                                                                  children: [
                                                                                    Text(
                                                                                        ' وزن 750: ',
                                                                                        style: AppTextStyle
                                                                                            .labelText.copyWith(fontSize: 11)),
                                                                                    Text(
                                                                                        '${getInventoryDetails
                                                                                            ?.weight750 ??
                                                                                            0} گرم ',
                                                                                        style: AppTextStyle
                                                                                            .bodyText.copyWith(fontSize: 11)),
                                                                                  ],
                                                                                ),
                                                                                SizedBox(height: 4),
                                                                                Row(
                                                                                  children: [
                                                                                    Text(
                                                                                        '  ناخالصی: ',
                                                                                        style: AppTextStyle
                                                                                            .labelText.copyWith(fontSize: 11)),
                                                                                    Text(
                                                                                        '${getInventoryDetails
                                                                                            ?.impurity ??
                                                                                            0} گرم ',
                                                                                        style: AppTextStyle
                                                                                            .bodyText.copyWith(fontSize: 11)),
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Row(
                                                                                  children: [
                                                                                    Text(
                                                                                        ' ش ق: ',
                                                                                        style: AppTextStyle
                                                                                            .labelText.copyWith(fontSize: 11)),
                                                                                    Text(
                                                                                        '${getInventoryDetails.receiptNumber ?? 0}',
                                                                                        style: AppTextStyle
                                                                                            .bodyText.copyWith(fontSize: 11)),
                                                                                  ],
                                                                                ),
                                                                                SizedBox(height: 4),
                                                                                Row(
                                                                                  children: [
                                                                                    Text(
                                                                                        ' آز: ',
                                                                                        style: AppTextStyle
                                                                                            .labelText.copyWith(fontSize: 11)),
                                                                                    Text(
                                                                                        '${getInventoryDetails.laboratory?.name}',
                                                                                        style: AppTextStyle
                                                                                            .bodyText.copyWith(fontSize: 11)),
                                                                                  ],
                                                                                ),
                                                                                SizedBox(height: 4),
                                                                                Row(
                                                                                  children: [
                                                                                    Text(
                                                                                        '  ش آز: ',
                                                                                        style: AppTextStyle
                                                                                            .labelText.copyWith(fontSize: 11)),
                                                                                    Text(
                                                                                        '${getInventoryDetails.laboratory?.id ?? 0}',
                                                                                        style: AppTextStyle
                                                                                            .bodyText.copyWith(fontSize: 11)),
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        ) : isTablet && getInventoryDetails.item?.id == 1 ?
                                                                        Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Row(
                                                                                  children: [
                                                                                    Text(
                                                                                        ' عیار: ',
                                                                                        style: AppTextStyle
                                                                                            .labelText.copyWith(fontSize: 11)),
                                                                                    Text(
                                                                                        '${getInventoryDetails
                                                                                            ?.carat ??
                                                                                            0}',
                                                                                        style: AppTextStyle
                                                                                            .bodyText.copyWith(fontSize: 11)),
                                                                                  ],
                                                                                ),
                                                                                SizedBox(height: 4),
                                                                                Row(
                                                                                  children: [
                                                                                    Text(
                                                                                        ' وزن 750: ',
                                                                                        style: AppTextStyle
                                                                                            .labelText.copyWith(fontSize: 11)),
                                                                                    Text(
                                                                                        '${getInventoryDetails
                                                                                            ?.weight750 ??
                                                                                            0} گرم ',
                                                                                        style: AppTextStyle
                                                                                            .bodyText.copyWith(fontSize: 11)),
                                                                                  ],
                                                                                ),
                                                                                SizedBox(height: 4),
                                                                                Row(
                                                                                  children: [
                                                                                    Text(
                                                                                        '  ناخالصی: ',
                                                                                        style: AppTextStyle
                                                                                            .labelText.copyWith(fontSize: 11)),
                                                                                    Text(
                                                                                        '${getInventoryDetails
                                                                                            ?.impurity ??
                                                                                            0} گرم ',
                                                                                        style: AppTextStyle
                                                                                            .bodyText.copyWith(fontSize: 11)),
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Row(
                                                                                  children: [
                                                                                    Text(
                                                                                        ' ش ق: ',
                                                                                        style: AppTextStyle
                                                                                            .labelText.copyWith(fontSize: 11)),
                                                                                    Text(
                                                                                        '${getInventoryDetails.receiptNumber ?? 0}',
                                                                                        style: AppTextStyle
                                                                                            .bodyText.copyWith(fontSize: 11)),
                                                                                  ],
                                                                                ),
                                                                                SizedBox(height: 4),
                                                                                Row(
                                                                                  children: [
                                                                                    Text(
                                                                                        ' آز: ',
                                                                                        style: AppTextStyle
                                                                                            .labelText.copyWith(fontSize: 11)),
                                                                                    Text(
                                                                                        '${getInventoryDetails.laboratory?.name}',
                                                                                        style: AppTextStyle
                                                                                            .bodyText.copyWith(fontSize: 11)),
                                                                                  ],
                                                                                ),
                                                                                SizedBox(height: 4),
                                                                                Row(
                                                                                  children: [
                                                                                    Text(
                                                                                        '  ش آز: ',
                                                                                        style: AppTextStyle
                                                                                            .labelText.copyWith(fontSize: 11)),
                                                                                    Text(
                                                                                        '${getInventoryDetails.laboratory?.id ?? 0}',
                                                                                        style: AppTextStyle
                                                                                            .bodyText.copyWith(fontSize: 11)),
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        )
                                                                            : isMobile && getInventoryDetails.item?.itemUnit?.id == 2 && getInventoryDetails.item?.id != 1 ?
                                                                            Column(
                                                                                  children: [
                                                                                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      children: [
                                                                                        Row(
                                                                                          children: [
                                                                                            Text(
                                                                                                ' عیار: ',
                                                                                                style: AppTextStyle
                                                                                                    .labelText.copyWith(fontSize: 11)),
                                                                                            Text(
                                                                                                '${getInventoryDetails
                                                                                                    ?.carat ??
                                                                                                    0}',
                                                                                                style: AppTextStyle
                                                                                                    .bodyText.copyWith(fontSize: 11)),
                                                                                          ],
                                                                                        ),
                                                                                        SizedBox(height: 4),
                                                                                        Row(
                                                                                          children: [
                                                                                            Text(
                                                                                                ' وزن 750: ',
                                                                                                style: AppTextStyle
                                                                                                    .labelText.copyWith(fontSize: 11)),
                                                                                            Text(
                                                                                                '${getInventoryDetails
                                                                                                    ?.weight750 ??
                                                                                                    0} گرم ',
                                                                                                style: AppTextStyle
                                                                                                    .bodyText.copyWith(fontSize: 11)),
                                                                                          ],
                                                                                        ),
                                                                                        SizedBox(height: 4),
                                                                                        Row(
                                                                                          children: [
                                                                                            Text(
                                                                                                '  ناخالصی: ',
                                                                                                style: AppTextStyle
                                                                                                    .labelText.copyWith(fontSize: 11)),
                                                                                            Text(
                                                                                                '${getInventoryDetails
                                                                                                    ?.impurity ??
                                                                                                    0} گرم ',
                                                                                                style: AppTextStyle
                                                                                                    .bodyText.copyWith(fontSize: 11)),
                                                                                          ],
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                              ],
                                                                            ) : isTablet && getInventoryDetails.item?.itemUnit?.id == 2 && getInventoryDetails.item?.id != 1 ?
                                                                        Column(
                                                                          children: [
                                                                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Row(
                                                                                  children: [
                                                                                    Text(
                                                                                        ' عیار: ',
                                                                                        style: AppTextStyle
                                                                                            .labelText.copyWith(fontSize: 11)),
                                                                                    Text(
                                                                                        '${getInventoryDetails
                                                                                            ?.carat ??
                                                                                            0}',
                                                                                        style: AppTextStyle
                                                                                            .bodyText.copyWith(fontSize: 11)),
                                                                                  ],
                                                                                ),
                                                                                SizedBox(height: 4),
                                                                                Row(
                                                                                  children: [
                                                                                    Text(
                                                                                        ' وزن 750: ',
                                                                                        style: AppTextStyle
                                                                                            .labelText.copyWith(fontSize: 11)),
                                                                                    Text(
                                                                                        '${getInventoryDetails
                                                                                            ?.weight750 ??
                                                                                            0} گرم ',
                                                                                        style: AppTextStyle
                                                                                            .bodyText.copyWith(fontSize: 11)),
                                                                                  ],
                                                                                ),
                                                                                SizedBox(height: 4),
                                                                                Row(
                                                                                  children: [
                                                                                    Text(
                                                                                        '  ناخالصی: ',
                                                                                        style: AppTextStyle
                                                                                            .labelText.copyWith(fontSize: 11)),
                                                                                    Text(
                                                                                        '${getInventoryDetails
                                                                                            ?.impurity ??
                                                                                            0} گرم ',
                                                                                        style: AppTextStyle
                                                                                            .bodyText.copyWith(fontSize: 11)),
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        )
                                                                            :
                                                                            SizedBox.shrink(),
                                                                        /*Row(
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
                                                                                    '${getInventoryDetails
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
                                                                                    '${getInventoryDetails
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
                                                                                    '${getInventoryDetails
                                                                                        ?.impurity ??
                                                                                        0} گرم ',
                                                                                    style: AppTextStyle
                                                                                        .bodyText),
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        ),*/
                                                                        SizedBox(
                                                                          height: 4,),
                                                                        Row(
                                                                          children: [
                                                                            Text(
                                                                                ' توضیحات: ',
                                                                                style: AppTextStyle
                                                                                    .labelText.copyWith(fontSize: isMobile ? 11 : null)),
                                                                            Expanded(
                                                                              child: Text(
                                                                                getInventoryDetails
                                                                                    ?.description ?? '',
                                                                                style: AppTextStyle
                                                                                    .bodyText.copyWith(fontSize: isMobile ? 11 : null),
                                                                                overflow: TextOverflow.ellipsis,
                                                                              ),
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
                                                                        isMobile ?
                                                                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            // نمایش عکس
                                                                            _buildActionButton(
                                                                              icon: 'assets/svg/picture.svg',
                                                                              label: 'عکس‌ها (${inventoryController.getImageCount(getInventoryDetails.recId ?? "")})',
                                                                              onTap: () async {
                                                                                await inventoryController.getImage(
                                                                                    getInventoryDetails.recId ?? "",
                                                                                    "InventoryDetail"
                                                                                );
                                                                                _showImageGallery(context);
                                                                              },
                                                                              color: inventoryController.getImageCount(getInventoryDetails.recId ?? "") > 0
                                                                                  ? AppColor.primaryColor
                                                                                  : AppColor.iconViewColor,
                                                                            ),
                                                                            // Edit
                                                                            _buildActionButton(
                                                                              icon: 'assets/svg/edit.svg',
                                                                              label: 'ویرایش',
                                                                              color: AppColor.iconViewColor,
                                                                              onTap: () {
                                                                                getInventoryDetails.type == 0
                                                                                    ? Get.toNamed('/inventoryDetailUpdateReceive',
                                                                                    parameters: {
                                                                                      "id": getInventoryDetails.inventoryId.toString(),
                                                                                      "index": index.toString(),
                                                                                    })
                                                                                    :
                                                                                //Get.snackbar("هشدار", "فعلا امکان ویرایش وجود ندارد");
                                                                                Get.toNamed('/inventoryDetailUpdatePayment',
                                                                                    parameters: {
                                                                                      "id": getInventoryDetails.inventoryId.toString(),
                                                                                      "index": index.toString(),
                                                                                    });
                                                                              },
                                                                            ),

                                                                            // Delete
                                                                            _buildActionButton(
                                                                              icon: 'assets/svg/trash-bin.svg',
                                                                              label: 'حذف',
                                                                              color: AppColor.accentColor,
                                                                              onTap: () => _showDeleteConfirmation(getInventoryDetails.id ?? 0,),
                                                                            ),
                                                                          ],
                                                                        ) :
                                                                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            // نمایش عکس
                                                                            _buildActionButton(
                                                                              icon: 'assets/svg/picture.svg',
                                                                              label: 'عکس‌ها (${inventoryController.getImageCount(getInventoryDetails.recId ?? "")})',
                                                                              onTap: () async {
                                                                                await inventoryController.getImage(
                                                                                    getInventoryDetails.recId ?? "",
                                                                                    "InventoryDetail"
                                                                                );
                                                                                _showImageGallery(context);
                                                                              },
                                                                              color: inventoryController.getImageCount(getInventoryDetails.recId ?? "") > 0
                                                                                  ? AppColor.primaryColor
                                                                                  : AppColor.iconViewColor,
                                                                            ),
                                                                            // Edit
                                                                            _buildActionButton(
                                                                              icon: 'assets/svg/edit.svg',
                                                                              label: 'ویرایش',
                                                                              color: AppColor.iconViewColor,
                                                                              onTap: () {
                                                                                getInventoryDetails.type == 0
                                                                                    ? Get.toNamed('/inventoryDetailUpdateReceive',
                                                                                    parameters: {
                                                                                      "id": getInventoryDetails.inventoryId.toString(),
                                                                                      "index": index.toString(),
                                                                                    })
                                                                                    :
                                                                                //Get.snackbar("هشدار", "فعلا امکان ویرایش وجود ندارد");
                                                                                Get.toNamed('/inventoryDetailUpdatePayment',
                                                                                    parameters: {
                                                                                      "id": getInventoryDetails.inventoryId.toString(),
                                                                                      "index": index.toString(),
                                                                                    });
                                                                              },
                                                                            ),

                                                                            // Delete
                                                                            _buildActionButton(
                                                                              icon: 'assets/svg/trash-bin.svg',
                                                                              label: 'حذف',
                                                                              color: AppColor.accentColor,
                                                                              onTap: () => _showDeleteConfirmation(getInventoryDetails.id ?? 0,),
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
          isMobile ? SizedBox.shrink() :
          Obx(()=>Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              inventoryController.paginated.value!=null?   Container(
                  height: isMobile ? 60 : 70,
                  margin: EdgeInsets.symmetric(
                      horizontal: isMobile ? 8 : 70,
                      vertical: isMobile ? 5 : 10
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 8 : 20
                  ),
                  //color: AppColor.appBarColor.withAlpha(130),
                  alignment: Alignment.bottomCenter,
                  child:PagerWidget(
                    countPage: inventoryController.paginated.value?.totalCount??0,
                    callBack: (int index) {
                      inventoryController.isChangePage(index);
                    },
                  )):SizedBox(),
            ],
          ),)
        ],
      ),
      floatingActionButton:isMobile ? SizedBox.shrink() :  FloatingActionButton(
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
              child: Text('نام کاربر', style: AppTextStyle.labelText)),
          headingRowAlignment: MainAxisAlignment.center,
          onSort: (columnIndex, ascending) {
            inventoryController.onSort(columnIndex, ascending);
          }
      ),
      DataColumn(
          label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
              child: Text('نام تحویل گیرنده', style: AppTextStyle.labelText)),
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
      /*DataColumn(
          label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
              child: Text('شرح', style: AppTextStyle.labelText)),
          headingRowAlignment: MainAxisAlignment.center),*/
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
              child: Text('ضمانت کاربر', style: AppTextStyle.labelText)),
          headingRowAlignment: MainAxisAlignment.center),
      /*DataColumn(
          label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
              child: Text('نمایش تصاویر', style: AppTextStyle.labelText)),
          headingRowAlignment: MainAxisAlignment.center),*/
      DataColumn(label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
          child: Text('مانده', style: AppTextStyle.labelText)),headingRowAlignment:MainAxisAlignment.center ),
      DataColumn(
          label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
              child: Text('صدور فاکتور', style: AppTextStyle.labelText)),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
              child: Text('عملیات', style: AppTextStyle.labelText)),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
              child: Text('اطلاعات کامل', style: AppTextStyle.labelText)),
          headingRowAlignment: MainAxisAlignment.center),

      /*DataColumn(label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
          child: Text('مانده سکه', style: AppTextStyle.labelText)),headingRowAlignment:MainAxisAlignment.center ),*/
      /*DataColumn(label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
          child: Text('مانده ریالی', style: AppTextStyle.labelText)),headingRowAlignment:MainAxisAlignment.center ),*/
      /*DataColumn(label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
          child: Text('مانده طلایی', style: AppTextStyle.labelText)),headingRowAlignment:MainAxisAlignment.center ),*/
    ];
  }

  List<DataRow> buildDataRows(BuildContext context) {
    return inventoryController.inventoryList.asMap().entries.map((entry) {
      final index = entry.key;
      final inventory = entry.value;
      final rowColor = index.isEven
          ? AppColor.backGroundColor
          : AppColor.secondaryColor.withAlpha(100);
      return DataRow(
        color: WidgetStateProperty.all(rowColor),
        cells: [
          // ردیف
          DataCell(
              Center(
                child: Row(
                  key: _rowKeys[inventory.id],
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
                child: Text(inventory.createdBy?.name ?? "",
                    style: AppTextStyle.bodyText.copyWith(color: AppColor.textColor,fontWeight: FontWeight.normal,fontSize: 11)

                ),
              )),
          // نام کاربر
          DataCell(
              Center(
                child: Text(inventory.account?.name ?? "",
                    style: AppTextStyle.bodyText.copyWith(color: AppColor.textColor,fontWeight: FontWeight.normal,fontSize: 11)

                ),
              )),
          // نام تحویل گیرنده
          DataCell(
              Center(
                child: Text(inventory.recipient ?? "",
                    style: AppTextStyle.bodyText.copyWith(color: AppColor.textColor,fontWeight: FontWeight.normal,fontSize: 11)
                ),
              )),
          // محصول
          DataCell(
              Center(
                child: Row(
                  children: [
                    inventory.item?.id!=null?
                    Image.network('${BaseUrl.baseUrl}Attachment/downloadResource?fileName=${inventory.item?.icon}',
                      width: 25,
                      height: 25,):SizedBox(),
                    SizedBox(width: 5,),
                    Text(
                        inventory.item?.id != null
                            ? inventory.item?.name ?? ""
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
                    inventory.id !=null
                        ? '${inventory.totalQuantity.toString().seRagham() ?? 0} ${inventory.item?.itemUnit?.name ?? ""}'
                        : "",
                    style: AppTextStyle.bodyText.copyWith(color: AppColor.primaryColor,fontWeight: FontWeight.bold)
                ),
              )
          ),
          // شرح
          /*DataCell(
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
              )),*/
          // دریافت/پرداخت
          DataCell(
              Center(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius
                        .circular(5),
                  ),
                  color: inventory.type == 0
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
                      inventory.type == 0
                          ? 'دریافت'
                          : 'پرداخت',
                      style: AppTextStyle
                          .labelText,
                      textAlign: TextAlign
                          .center,),
                  ),
                ),
              )),
          // ضمانت کاربر
          DataCell(
              Center(
                child:
                inventory.type==0 ? Text('ندارد',style: AppTextStyle.labelText,) :
                inventory.confirmByAdmin==true ?
                SvgPicture.asset('assets/svg/check-mark-circle.svg',
                    colorFilter: ColorFilter.mode(
                      AppColor.primaryColor,
                      BlendMode.srcIn,
                    )) :
                SvgPicture.asset('assets/svg/close-circle1.svg',
                    colorFilter: ColorFilter.mode(
                      AppColor.accentColor,
                      BlendMode.srcIn,
                    )),
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
          /*DataCell(
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
                                    Get.back(),
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
          ),*/
          // مانده
          DataCell(
              Center(
                child:
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return BalanceDialog(
                            entityId: inventory.recordId ?? 0,
                            entityType: inventory.type == 0 ? 'receive' : 'payment',
                            entityName: inventory.account?.name ?? 'نامشخص',
                            isDesktop: ResponsiveBreakpoints.of(context).largerThan(TABLET),
                          );
                        },
                      );
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.account_balance_wallet,
                          size: 20,
                          color: AppColor.buttonColor,
                        ),
                        Text(' مانده',
                          style: AppTextStyle
                              .labelText
                              .copyWith(
                              color: AppColor.buttonColor, fontSize: 11,fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ),
                ),
              )
          ),
          // صدور فاکتور
          DataCell(
            Center(
              child: SizedBox(
                width: 70,
                height: 30,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.secondary2Color.withGreen(130),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    textStyle: TextStyle(fontSize: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                    fixedSize: Size(20, 15)
                  ),
                  child: Text('صدور فاکتور'),
                  onPressed: () async {
                    await inventoryController.generateInvoice(inventory);
                  },
                ),
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
                  /*GestureDetector(
                    onTap: () {
                      inventory.type==0 ?
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
                  SizedBox(height: 5,),*/
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
                  /*GestureDetector(
                    onTap: () async{
                      inventory.type==1 ?
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
                  SizedBox(height: 3,),*/
                ],
              ),
            ),
          ),
          // نمایش کامل واریزی
          DataCell(
            Center(
              child:
              /*inventory.inventoryDetailsCount == 1 ?
              SizedBox(width: 100,)
                  :*/
              SizedBox(
                width: 130,
                child: TextButton(
                  child: Text(
                      'نمایش اطلاعات کامل',  style: AppTextStyle
                      .bodyText.copyWith(
                      color: AppColor.textColor,fontSize: 11)),
                  onPressed: () {
                    showInventoryDetailsModal(inventory);
                    inventoryController.fetchGetInventoryDetail(inventory.id!);
                  },
                ),
              ),
            ),
          ),
          // مانده سکه
          /*DataCell(
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
          ),*/
          // مانده ریالی
          /*DataCell(
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
          ),*/
          // مانده طلایی
          /*DataCell(
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
          ),*/
        ],
      );
    }).toList();
  }

  void showInventoryDetailsModal(InventoryModel inventory) {
    Get.dialog(
      Dialog(
        backgroundColor: AppColor.backGroundColor,
        elevation: 10,
        insetPadding: EdgeInsets.all(20),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 800,
            maxHeight: Get.height * 0.8,
          ),
          child: Column(
            children: [
              Expanded(child: buildInventoryDetail(inventory)),
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
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor),
              ),
              SizedBox(height: 16),
              Text(
                'در حال بارگذاری اطلاعات...',
                style: AppTextStyle.bodyText.copyWith(color: AppColor.textColor),
              ),
            ],
          ),
        );
      }

      if (inventoryController.getInventoryDetail.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.inventory_2_outlined,
                size: 64,
                color: AppColor.textColor.withOpacity(0.5),
              ),
              SizedBox(height: 16),
              Text(
                'اطلاعاتی موجود نیست',
                style: AppTextStyle.labelText.copyWith(
                  color: AppColor.textColor.withOpacity(0.7),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        );
      }

      return Container(
        height: Get.height * 0.75,
        width: Get.width * 0.75,
        decoration: BoxDecoration(
          color: AppColor.backGroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColor.appBarColor.withOpacity(0.1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.inventory_2,
                    color: AppColor.primaryColor,
                    size: 24,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'لیست دریافت/پرداخت',
                      style: AppTextStyle.smallTitleText.copyWith(
                        color: AppColor.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColor.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${inventoryController.getInventoryDetail.length} مورد',
                      style: AppTextStyle.labelText.copyWith(
                        color: AppColor.primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: inventoryController.getInventoryDetail.length,
                itemBuilder: (context, index) {
                  var getInventoryDetails = inventoryController.getInventoryDetail[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: AppColor.textFieldColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Header section with date and type
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColor.appBarColor.withOpacity(0.05),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                color: AppColor.textColor.withOpacity(0.7),
                                size: 18,
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  getInventoryDetails.date?.toPersianDate(
                                      twoDigits: true,
                                      showTime: true,
                                      timeSeprator: '-'
                                  ) ?? 'نامشخص',
                                  style: AppTextStyle.bodyText.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: getInventoryDetails.type == 0
                                      ? AppColor.primaryColor.withOpacity(0.1)
                                      : AppColor.accentColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  getInventoryDetails.type == 0 ? 'دریافت' : 'پرداخت',
                                  style: AppTextStyle.labelText.copyWith(
                                    color: getInventoryDetails.type == 0
                                        ? AppColor.primaryColor
                                        : AppColor.accentColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Content section
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Item and Quantity row
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildInfoCard(
                                      icon: Icons.inventory,
                                      label: 'آیتم',
                                      value: getInventoryDetails.item?.name ?? 'نامشخص',
                                      color: AppColor.primaryColor,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: _buildInfoCard(
                                      icon: Icons.scale,
                                      label: 'مقدار',
                                      value: '${getInventoryDetails.weight.toString().seRagham() ?? 0} ${getInventoryDetails.item?.itemUnit?.name ?? ""}',
                                      color: AppColor.buttonColor,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child:getInventoryDetails.type == 0 ?
                                    _buildInfoCard(
                                      icon: Icons.numbers,
                                      label: 'شناسه دریافت',
                                      value: '${getInventoryDetails.id.toString() ?? 0}',
                                      color: AppColor.dividerColor,
                                    ):
                                    _buildInfoCard(
                                      icon: Icons.numbers,
                                      label: 'شناسه پرداخت',
                                      value: '${getInventoryDetails.id.toString() ?? 0}',
                                      color: AppColor.dividerColor,
                                    )
                                    ,
                                  ),
                                ],
                              ),

                              // Gold-specific details (only for gold items)
                              if (getInventoryDetails.item?.id == 1) ...[
                                SizedBox(height: 12),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _buildInfoCard(
                                            icon: Icons.diamond,
                                            label: 'عیار',
                                            value: '${getInventoryDetails.carat ?? 0}',
                                            color: AppColor.accentColor,
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        Expanded(
                                          child: _buildInfoCard(
                                            icon: Icons.monitor_weight,
                                            label: 'وزن 750',
                                            value: '${getInventoryDetails.weight750 ?? 0} گرم',
                                            color: AppColor.secondary3Color,
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        Expanded(
                                          child: _buildInfoCard(
                                            icon: Icons.remove_circle_outline,
                                            label: 'ناخالصی',
                                            value: '${getInventoryDetails.impurity ?? 0} گرم',
                                            color: AppColor.textColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8,),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _buildInfoCard(
                                            icon: Icons.numbers,
                                            label: 'شماره قبض',
                                            value: '${getInventoryDetails.receiptNumber ?? 0}',
                                            color: AppColor.dividerColor,
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        Expanded(
                                          child: _buildInfoCard(
                                            icon: Icons.liquor_sharp,
                                            label: 'نام آزمایشگاه',
                                            value: '${getInventoryDetails.laboratory?.name}',
                                            color: AppColor.dividerColor,
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        Expanded(
                                          child: _buildInfoCard(
                                            icon: Icons.numbers,
                                            label: 'شماره آزمایشگاه',
                                            value: '${getInventoryDetails.laboratory?.id ?? 0}',
                                            color: AppColor.dividerColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],

                              // Gold-specific details (only for gold items)
                              if (getInventoryDetails.item?.itemUnit?.id == 2 && getInventoryDetails.item?.id != 1) ...[
                                SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildInfoCard(
                                        icon: Icons.diamond,
                                        label: 'عیار',
                                        value: '${getInventoryDetails.carat ?? 0}',
                                        color: AppColor.accentColor,
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: _buildInfoCard(
                                        icon: Icons.monitor_weight,
                                        label: 'وزن 750',
                                        value: '${getInventoryDetails.weight750 ?? 0} گرم',
                                        color: AppColor.secondary3Color,
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: _buildInfoCard(
                                        icon: Icons.remove_circle_outline,
                                        label: 'ناخالصی',
                                        value: '${getInventoryDetails.impurity ?? 0} گرم',
                                        color: AppColor.textColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],

                              // Description
                              if (getInventoryDetails.description?.isNotEmpty == true) ...[
                                SizedBox(height: 12),
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppColor.backGroundColor,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: AppColor.textColor.withOpacity(0.2),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.description,
                                            color: AppColor.textColor.withOpacity(0.7),
                                            size: 16,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'توضیحات',
                                            style: AppTextStyle.labelText.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        getInventoryDetails.description ?? "",
                                        style: AppTextStyle.bodyText.copyWith(
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),

                        // Actions section
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColor.appBarColor.withOpacity(0.05),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // View Images
                              _buildActionButton(
                                icon: 'assets/svg/picture.svg',
                                label: 'عکس‌ها (${inventoryController.getImageCount(getInventoryDetails.recId ?? "")})',
                                onTap: () async {
                                  await inventoryController.getImage(
                                      getInventoryDetails.recId ?? "",
                                      "InventoryDetail"
                                  );
                                  _showImageGallery(context);
                                },
                                color: inventoryController.getImageCount(getInventoryDetails.recId ?? "") > 0
                                    ? AppColor.primaryColor
                                    : AppColor.iconViewColor,
                              ),

                              // Edit
                              _buildActionButton(
                                icon: 'assets/svg/edit.svg',
                                label: 'ویرایش',
                                color: AppColor.iconViewColor,
                                onTap: () {
                                  getInventoryDetails.type == 0
                                      ? Get.toNamed('/inventoryDetailUpdateReceive',
                                      parameters: {
                                        "id": getInventoryDetails.inventoryId.toString(),
                                        "index": index.toString(),
                                      })
                                      :
                                  //Get.snackbar("هشدار", "فعلا امکان ویرایش وجود ندارد");
                                  Get.toNamed('/inventoryDetailUpdatePayment',
                                      parameters: {
                                        "id": getInventoryDetails.inventoryId.toString(),
                                        "index": index.toString(),
                                      });
                                },
                              ),

                              // Delete
                              _buildActionButton(
                                icon: 'assets/svg/trash-bin.svg',
                                label: 'حذف',
                                color: AppColor.accentColor,
                                onTap: () => _showDeleteConfirmation(getInventoryDetails.id ?? 0,),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: color,
                size: 16,
              ),
              SizedBox(width: 6),
              Text(
                label,
                style: AppTextStyle.labelText.copyWith(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 6),
          Text(
            value,
            style: AppTextStyle.bodyText.copyWith(
              color: AppColor.textColor,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return
      GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: color.withOpacity(0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                icon,
                height: 16,
                colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
              ),
              SizedBox(width: 6),
              Text(
                label,
                style: AppTextStyle.labelText.copyWith(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
  }

  void _showImageGallery(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 200), () {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: AppColor.backGroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Row(
                    children: [
                      Icon(
                        Icons.photo_library,
                        color: AppColor.primaryColor,
                        size: 24,
                      ),
                      SizedBox(width: 12),
                      Text(
                        'گالری تصاویر',
                        style: AppTextStyle.smallTitleText.copyWith(
                          color: AppColor.primaryColor,
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: Icon(Icons.close, color: AppColor.textColor),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Image viewer
                  SizedBox(
                    width: 500,
                    height: 500,
                    child: Stack(
                      children: [
                        PageView.builder(
                          controller: inventoryController.pageController,
                          itemCount: inventoryController.imageList.length,
                          onPageChanged: (index) =>
                          inventoryController.currentImagePage.value = index,
                          itemBuilder: (context, index) {
                            final attachment = inventoryController.imageList[index];
                            return Column(
                              children: [
                                kIsWeb ?
                                  Padding(
                                    padding: const EdgeInsets.only(right: 50),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.download, color: AppColor.dividerColor),
                                          onPressed: () => inventoryController.downloadImage(attachment),
                                        ),
                                      ],
                                    ),
                                  ):
                                Padding(
                                  padding: const EdgeInsets.only(right: 30),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.download, color: AppColor.dividerColor),
                                        onPressed: () => inventoryController.downloadImage(attachment),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Image.network(
                                    "${BaseUrl.baseUrl}Attachment/downloadAttachment?fileName=$attachment",
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(child: CircularProgressIndicator());
                                    },
                                    errorBuilder: (context, error, stackTrace) =>
                                        Icon(Icons.error, color: Colors.red),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),

                        // Navigation arrows
                        Obx(() => Positioned(
                          left: 10,
                          top: 0,
                          bottom: 0,
                          child: Visibility(
                            visible: inventoryController.currentImagePage.value > 0,
                            child: IconButton(
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(Colors.black54),
                                shape: WidgetStateProperty.all(CircleBorder()),
                                padding: WidgetStateProperty.all(EdgeInsets.all(8)),
                              ),
                              icon: Icon(Icons.chevron_left, color: Colors.white, size: 40),
                              onPressed: () {
                                inventoryController.pageController.previousPage(
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                            ),
                          ),
                        )),

                        Obx(() => Positioned(
                          right: 10,
                          top: 0,
                          bottom: 0,
                          child: Visibility(
                            visible: inventoryController.currentImagePage.value <
                                (inventoryController.imageList.length - 1),
                            child: IconButton(
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(Colors.black54),
                                shape: WidgetStateProperty.all(CircleBorder()),
                                padding: WidgetStateProperty.all(EdgeInsets.all(8)),
                              ),
                              icon: Icon(Icons.chevron_right, color: Colors.white, size: 40),
                              onPressed: () {
                                inventoryController.pageController.nextPage(
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                            ),
                          ),
                        )),
                      ],
                    ),
                  ),

                  // Page indicators
                  SizedBox(height: 16),
                  Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      inventoryController.imageList.length,
                          (index) => Container(
                        width: 8,
                        height: 8,
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: inventoryController.currentImagePage.value == index
                              ? AppColor.primaryColor
                              : Colors.grey,
                        ),
                      ),
                    ),
                  )),
                  SizedBox(height: 16),
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text("بستن", style: AppTextStyle.bodyText),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  void _showDeleteConfirmation(int id,) {
    Get.defaultDialog(
      backgroundColor: AppColor.backGroundColor,
      title: "حذف آیتم",
      titleStyle: AppTextStyle.smallTitleText.copyWith(color: AppColor.accentColor),
      middleText: "آیا از حذف این آیتم مطمئن هستید؟",
      middleTextStyle: AppTextStyle.bodyText,
      confirm: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(AppColor.accentColor),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        onPressed: () {
          inventoryController.deleteInventoryDetail(
            id,
          );
          if (Get.isDialogOpen!) Get.back();
          inventoryController.getInventoryListPager();
          Get.back();
        },
        child: Text('حذف', style: AppTextStyle.bodyText.copyWith(color: Colors.white)),
      ),
      cancel: TextButton(
        onPressed: () => Get.back(),
        child: Text('انصراف', style: AppTextStyle.bodyText),
      ),
    );
  }

  // Helper method for mobile action buttons
  Widget _buildMobileActionButton(String text, Color color, VoidCallback onPressed) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 2),
        child: ElevatedButton(
          style: ButtonStyle(
            padding: WidgetStatePropertyAll(
                EdgeInsets.symmetric(horizontal: 8, vertical: 6)
            ),
            elevation: WidgetStatePropertyAll(3),
            backgroundColor: WidgetStatePropertyAll(color),
            shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)
                )
            ),
          ),
          onPressed: onPressed,
          child: Text(
            text,
            style: AppTextStyle.labelText.copyWith(fontSize: 10),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  // Helper method for export dialog
  void _showExportDialog(BuildContext context, String type) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation, Animation secondaryAnimation) {
          return Center(
            child: Material(
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColor.backGroundColor
                ),
                width: isDesktop ? Get.width * 0.2 : Get.width * 0.9,
                height: isDesktop ? Get.height * 0.5 : Get.height * 0.6,
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            type == 'excel' ? 'خروجی اکسل' : 'خروجی PDF',
                            style: AppTextStyle.labelText.copyWith(
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(color: AppColor.textColor, height: 0.2),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          SizedBox(height: 8),
                          _buildDateField('از تاریخ', inventoryController.dateStartController, inventoryController.startDateFilter),
                          SizedBox(height: 8),
                          _buildDateField('تا تاریخ', inventoryController.dateEndController, inventoryController.endDateFilter),
                        ],
                      ),
                    ),
                    Spacer(),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      width: double.infinity,
                      height: 40,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            padding: WidgetStatePropertyAll(
                                EdgeInsets.symmetric(horizontal: 23, vertical: 19)
                            ),
                            backgroundColor: WidgetStatePropertyAll(AppColor.appBarColor),
                            shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                    side: BorderSide(color: AppColor.textColor),
                                    borderRadius: BorderRadius.circular(5)
                                )
                            )
                        ),
                        onPressed: () async {
                          if (type == 'excel') {
                            inventoryController.exportToExcel();
                          } else {
                            inventoryController.exportToPdf();
                          }
                          Get.back();
                        },
                        child: inventoryController.isLoading.value ?
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor),
                        ) :
                        Text(
                          'ثبت',
                          style: AppTextStyle.labelText.copyWith(
                              fontSize: isDesktop ? 12 : 10
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
    );
  }

  // Helper method for date field
  Widget _buildDateField(String label, TextEditingController controller, RxString filterValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyle.labelText.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.normal,
              color: AppColor.textColor
          ),
        ),
        Container(
          padding: EdgeInsets.only(bottom: 5),
          child: IntrinsicHeight(
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'لطفا تاریخ را انتخاب کنید';
                }
                return null;
              },
              controller: controller,
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
                  firstDate: Jalali(1400, 1, 1),
                  lastDate: Jalali(1450, 12, 29),
                  initialEntryMode: PersianDatePickerEntryMode.calendar,
                  initialDatePickerMode: PersianDatePickerMode.day,
                  locale: Locale("fa", "IR"),
                );
                Gregorian gregorian = pickedDate!.toGregorian();
                filterValue.value = "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";
                controller.text = "${pickedDate.year}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.day.toString().padLeft(2, '0')}";
              },
            ),
          ),
        ),
      ],
    );
  }

  // Helper method for filter dialog
  void _showFilterDialog(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation, Animation secondaryAnimation) {
          return Center(
            child: Material(
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColor.backGroundColor
                ),
                width: isDesktop ? Get.width * 0.3 : Get.width * 0.9,
                height: isDesktop ? Get.height * 0.5 : Get.height * 0.7,
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
                              width: 50,
                              height: 27,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    padding: WidgetStatePropertyAll(
                                        EdgeInsets.symmetric(horizontal: 2, vertical: 1)
                                    ),
                                    backgroundColor: WidgetStatePropertyAll(AppColor.accentColor.withOpacity(0.5)),
                                    shape: WidgetStatePropertyAll(
                                        RoundedRectangleBorder(
                                            side: BorderSide(color: AppColor.textColor),
                                            borderRadius: BorderRadius.circular(5)
                                        )
                                    )
                                ),
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
                            ),
                          ],
                        ),
                      ),
                      Container(color: AppColor.textColor, height: 0.2),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            SizedBox(height: 8),
                            _buildFilterField('نام', inventoryController.nameFilterController),
                            SizedBox(height: 8),
                            _buildFilterField('شماره انگ', inventoryController.receiptNumberController),
                            SizedBox(height: 8),
                            _buildDateField('از تاریخ', inventoryController.dateStartController, inventoryController.startDateFilter),
                            SizedBox(height: 8),
                            _buildDateField('تا تاریخ', inventoryController.dateEndController, inventoryController.endDateFilter),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        width: double.infinity,
                        height: 40,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              padding: WidgetStatePropertyAll(
                                  EdgeInsets.symmetric(horizontal: 23, vertical: 19)
                              ),
                              backgroundColor: WidgetStatePropertyAll(AppColor.appBarColor),
                              shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                      side: BorderSide(color: AppColor.textColor),
                                      borderRadius: BorderRadius.circular(5)
                                  )
                              )
                          ),
                          onPressed: () async {
                            inventoryController.getInventoryListPager();
                            Get.back();
                          },
                          child: inventoryController.isLoading.value ?
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
        }
    );
  }

  // Helper method for filter field
  Widget _buildFilterField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyle.labelText.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.normal,
              color: AppColor.textColor
          ),
        ),
        SizedBox(height: 10),
        IntrinsicHeight(
          child: TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: controller,
            style: AppTextStyle.labelText.copyWith(fontSize: 15),
            textAlign: TextAlign.start,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 11, horizontal: 15),
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              filled: true,
              fillColor: AppColor.textFieldColor,
              errorMaxLines: 1,
            ),
          ),
        ),
      ],
    );
  }
}
