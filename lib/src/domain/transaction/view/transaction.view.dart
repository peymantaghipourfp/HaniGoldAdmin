import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/order/widget/filter.widget.dart';
import 'package:hanigold_admin/src/domain/transaction/model/transaction_item.model.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../config/repository/url/base_url.dart';
import '../../../widget/app_drawer.widget.dart';
import '../../../widget/background_image_total.widget.dart';
import '../../../widget/custom_appbar1.widget.dart';
import '../../../widget/custom_dropdown.widget.dart';
import '../../../widget/err_page.dart';
import '../../../widget/pager_widget.dart';
import '../../home/widget/chat_dialog.widget.dart';
import '../controller/transaction.controller.dart';
import '../widgets/balance_dialog_id.widget.dart';

class TransactionView extends StatefulWidget {
  const TransactionView({super.key});

  @override
  State<TransactionView> createState() => _TransactionViewState();
}

class _TransactionViewState extends State<TransactionView> {
  final TransactionController controller = Get.find<TransactionController>();
  final GlobalKey _dataTableKey = GlobalKey();
  final Map<int, GlobalKey> _rowKeys = {};

  @override
  void initState() {
    super.initState();
    controller.transactionList.listen((list) {
      _prepareScreenshotKeys(list);
      if (mounted) {
        setState(() {});
      }
    });
    _prepareScreenshotKeys(controller.transactionList);
  }

  void _prepareScreenshotKeys(List<TransactionModel> transactions) {
    final newKeys = <int>{};
    for (var transaction in transactions) {
      if (transaction.id != null) {
        newKeys.add(transaction.id!);
        if (!_rowKeys.containsKey(transaction.id)) {
          _rowKeys[transaction.id!] = GlobalKey(debugLabel: 'row_${transaction.id}');
        }
      }
    }
    _rowKeys.removeWhere((key, value) => !newKeys.contains(key));
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    return Obx(()=>Scaffold(
      appBar: CustomAppbar1(
        title: 'لیست تراکنش های کاربران',
        onBackTap: () => Get.toNamed('/home'),
      ),
      drawer: const AppDrawer(),
      body:  Stack(
        children: [
          BackgroundImageTotal(),
          SafeArea(
            child: controller.state.value == PageStateTrans.loading
                ? Center(
              child: CircularProgressIndicator(),
            )
                : controller.state.value == PageStateTrans.list
                ? SizedBox(
              height: Get.height,width: Get.width,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    //فیلد جستجو
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 50,vertical: 10),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      color: AppColor.appBarColor.withOpacity(0.5),
                      alignment: Alignment.center,
                      height: 80,
                      child: TextFormField(
                        controller: controller.searchController,
                        style: AppTextStyle.labelText,
                        textInputAction: TextInputAction.search,
                        onFieldSubmitted: (value) async {
                          if (value.isNotEmpty) {
                             await controller.searchAccounts(value);
                             showSearchResults(context);
                          } else {
                            controller.clearSearch();
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
                              onPressed: ()async{
                                if (controller.searchController
                                    .text.isNotEmpty) {
                                  await controller.searchAccounts(
                                      controller.searchController
                                          .text
                                  );
                                  showSearchResults(context);
                                } else {
                                  controller.clearSearch();
                                }
                              },
                              icon: Icon(Icons.search,color: AppColor.textColor,size: 30,)
                          ),
                          suffixIcon: IconButton(
                            onPressed: controller.clearSearch,
                            icon: Icon(Icons.close, color: AppColor.textColor),
                          ),
                        ),
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 50,vertical: 10),
                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                      color: AppColor.appBarColor.withOpacity(0.5),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(width:isDesktop ? 15 : 5,),
                                    Row(
                                      children: [
                                        // خروجی اکسل
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
                                              shape: WidgetStatePropertyAll(RoundedRectangleBorder(
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
                                                                            controller: controller.dateStartController,
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
                                                                              controller.startDateFilter.value =
                                                                              "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";

                                                                              controller.dateStartController.text =
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
                                                                            controller: controller.dateEndController,
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
                                                                              controller.endDateFilter.value =
                                                                              "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";

                                                                              controller.dateEndController.text =
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
                                                                  controller.exportToExcel();
                                                                  Get.back();
                                                                  controller.clearFilter();
                                                                },
                                                                child: controller.isLoading.value?
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
                                                                            controller: controller.dateStartController,
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
                                                                              controller.startDateFilter.value =
                                                                              "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";

                                                                              controller.dateStartController.text =
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
                                                                            controller: controller.dateEndController,
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
                                                                              controller.endDateFilter.value =
                                                                              "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";

                                                                              controller.dateEndController.text =
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
                                                                  controller.exportToPdf();
                                                                  Get.back();
                                                                  controller.clearFilter();
                                                                },
                                                                child: controller.isLoading.value?
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
                                  ],
                                ),
                                // فیلتر
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
                                            child:
                                              FilterWidget(),
                                            /*Material(
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
                                                                  controller.clearFilter();
                                                                  controller.fetchTransactionList();
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
                                                                  'نام کاربر',
                                                                  style: AppTextStyle.labelText.copyWith(
                                                                      fontSize: 11,
                                                                      fontWeight: FontWeight.normal,
                                                                      color: AppColor.textColor),
                                                                ),
                                                                SizedBox(height: 8,),
                                                                IntrinsicHeight(
                                                                  child: TextFormField(
                                                                    autovalidateMode: AutovalidateMode
                                                                        .onUserInteraction,
                                                                    controller: controller.nameFilterController,
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
                                                            Column(crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  'نوع',
                                                                  style: AppTextStyle.labelText.copyWith(
                                                                      fontSize: 11,
                                                                      fontWeight: FontWeight.normal,
                                                                      color: AppColor.textColor),
                                                                ),
                                                                SizedBox(height: 8),
                                                                Container(
                                                                  padding: EdgeInsets.only(
                                                                      bottom: 5),
                                                                  child: CustomDropdownWidget(
                                                                    validator: (value) {
                                                                      if (value == 'انتخاب کنید' ||
                                                                          value == null ||
                                                                          value.isEmpty) {
                                                                        return 'نوع را انتخاب کنید';
                                                                      }
                                                                      return null;
                                                                    },
                                                                    items: [
                                                                      'انتخاب کنید',
                                                                      ...controller.typeList.where((type) =>
                                                                      type.type != null)
                                                                          .map((type) =>
                                                                      type.name ?? '')
                                                                    ].toList(),
                                                                    selectedValue: controller
                                                                        .typeFilter ?? '',
                                                                    onChanged: (String? newValue) {
                                                                      controller.changeSelectedType(newValue!);
                                                                      setState(() {

                                                                      });
                                                                    },
                                                                    backgroundColor: AppColor
                                                                        .textFieldColor,
                                                                    borderRadius: 7,
                                                                    borderColor: AppColor
                                                                        .secondaryColor,
                                                                    hideUnderline: true,
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
                                                                SizedBox(height: 8,),
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
                                                                      controller: controller.dateStartController,
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
                                                                        controller.startDateFilter.value =
                                                                        "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";

                                                                        controller.dateStartController.text =
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
                                                                SizedBox(height: 8,),
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
                                                                      controller: controller.dateEndController,
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
                                                                        controller.endDateFilter.value =
                                                                        "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";

                                                                        controller.dateEndController.text =
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
                                                      //Spacer(),
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
                                                            controller.fetchTransactionList();
                                                            Get.back();
                                                          },
                                                          child: controller.isLoading.value?
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
                                            ),*/
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
                                            controller.nameFilterController.text!="" || controller.dateStartController.text!="" || controller.dateEndController.text!=""|| controller.typeFilter1!="" ?AppColor.accentColor:  AppColor
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
                                                : 10,color:  controller.nameFilterController.text!="" || controller.dateStartController.text!="" || controller.dateEndController.text!=""|| controller.typeFilter1!="" ?AppColor.accentColor: AppColor.textColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ],

                            ),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            controller: controller.scrollController,
                            physics: ClampingScrollPhysics(),
                            child: Row(
                              children: [
                                SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      RepaintBoundary(
                                        key: _dataTableKey,
                                        child: DataTable(
                                          sortColumnIndex: controller.sortColumnIndex.value,
                                          sortAscending: controller.sortAscending.value,
                                          columns: buildDataColumns(),
                                          dividerThickness: 0.3,
                                          // rows: buildDataRows(context),
                                          rows: buildDataRows(context),
                                          border: TableBorder.symmetric(
                                              inside: BorderSide(color: AppColor.textColor,width: 0.3),
                                              outside: BorderSide(color: AppColor.textColor,width: 0.3),
                                              borderRadius: BorderRadius.circular(8)
                                          ),
                                          dataRowMinHeight: 100,
                                          dataRowMaxHeight: double.infinity,
                                          //dataRowColor: WidgetStatePropertyAll(AppColor.secondaryColor),
                                          //headingRowColor: WidgetStatePropertyAll(AppColor.primaryColor.withOpacity(0.2)),
                                          headingRowHeight: 50,
                                          columnSpacing: 20,
                                          horizontalMargin: 10,
                                        ),
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
                    SizedBox(height: 80,)
                  ],
                ),
              ),
            )
                : ErrPage(
              callback: () {
                controller.clearFilter();
                controller.fetchTransactionList();
              },
              title: "خطا در دریافت لیست تراکنش ها",
              des: 'برای دریافت لیست تراکنش ها مجددا تلاش کنید',
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              controller.paginated!=null?   Container(
                  height: 70,
                  margin: EdgeInsets.symmetric(horizontal: 50,vertical: 10),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  color: AppColor.appBarColor.withOpacity(0.5),
                  alignment: Alignment.bottomCenter,
                  child:PagerWidget(countPage: controller.paginated!.totalCount??0, callBack: (int index) {
                    controller.isChangePage(index);
                  },)):SizedBox(),
            ],
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
                itemCount: controller.searchedAccounts.length,
                itemBuilder: (context, index) {
                  final account = controller.searchedAccounts[index];
                  return ListTile(
                    title: Text(account.name ?? '',
                      style: AppTextStyle.bodyText.copyWith(fontSize: 15),),
                    onTap: () => controller.selectAccount(account),
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
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100),
              child: Text('نوع',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11))),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(

          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100),
              child: Text('ردیف',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11))),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          onSort: (columnIndex, ascending) {
            controller.onSort(columnIndex, ascending);
          },
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100),
              child: Text('تاریخ',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11))),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100),
              child: Text('کاربر',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11))),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100),
              child: Text('شرح',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11))),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          onSort: (columnIndex, ascending) {
            controller.onSort(columnIndex, ascending);
          },
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100),
              child: Text('مقدار',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11))),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100),
              child: Text('کارتخوان',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11))),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100),
              child: Text('مانده',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11))),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100),
              child: Text('مانده بستانکار',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11))),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100),
              child: Text('تصویر',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11))),
          headingRowAlignment: MainAxisAlignment.center),
      /*DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100),
              child: Text('مانده سکه',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11))),
          headingRowAlignment: MainAxisAlignment.center),*/

      /*DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100),
              child: Text('مانده ریالی بستانکار',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11))),
          headingRowAlignment: MainAxisAlignment.center),*/

      /*DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100),
              child: Text('مانده طلایی بستانکار',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11))),
          headingRowAlignment: MainAxisAlignment.center),*/

      /*DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100),
              child: Text('مانده سکه بستانکار',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11))),
          headingRowAlignment: MainAxisAlignment.center),*/

     /* DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100),
              child: Text('مستندات',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11))),
          headingRowAlignment: MainAxisAlignment.center),*/
    ];
  }

  List<DataRow> buildDataRows(BuildContext context) {
    return controller.transactionList
        .map((trans) => DataRow(
      cells: [
        // تاریخ
        DataCell(Center(
          child: RotatedBox(
            quarterTurns: 1,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
              // margin: EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(0),
                  color: trans.type == "receive" ||
                      trans.type == "issue" ||
                      trans.type == "buy"
                      ? AppColor.primaryColor
                      : AppColor.accentColor),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    trans.type == "issue"
                        ? ' حواله '
                        : trans.type == "payment"
                        ? ' پرداخت '
                        : trans.type == "receive"
                        ? ' دریافت '
                        : trans.type == "sales"
                        ? ' فروش '
                        : trans.type == "buy"
                        ? ' خرید '
                        : trans.type == "deposit"
                        ? ' واریز '
                        : trans.type == "reciept"
                        ? ' دریافت '
                        : trans.type == "TransferWallet"
                        ? ' انتقال ولت '
                       :
                      " ${trans.type ?? ""}",
                    style: AppTextStyle.bodyText.copyWith(
                        color: AppColor.textColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        )),
        DataCell(Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${trans.rowNum ?? 0}",
                style: AppTextStyle.bodyText,
              ),
              SizedBox(
                width: 5,
              ),
              GestureDetector(
                onTap: () {
                  controller.captureRowScreenshot(trans, _dataTableKey, _rowKeys);
                },
                child: SvgPicture.asset('assets/svg/camera.svg',
                  colorFilter: ColorFilter.mode(
                    AppColor.iconViewColor,
                    BlendMode.srcIn,
                  ),height: 18,),
              ),
              // SizedBox(
              //   width: 20,
              // ),
            ],
          ),
        )),
        DataCell(Center(
          child: Text(
            "${trans.date?.toPersianDate() ?? 'نامشخص'} ",
            style: AppTextStyle.bodyText
                .copyWith(color: AppColor.textColor, fontSize: 10),textDirection: TextDirection.ltr,),
        )),
        DataCell(Center(
          child:trans.toAccount!=null?
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("${trans.account?.name ?? 'نامشخص'} ",
                  style: AppTextStyle.bodyText
                      .copyWith(color: AppColor.accentColor, fontSize: 11)),
              SvgPicture.asset('assets/svg/refresh.svg',
                  height: 16,
                  colorFilter: ColorFilter.mode(
                    AppColor.textColor,
                    BlendMode.srcIn,
                  )),
              Text(" ${trans.toAccount?.name ?? 'نامشخص'}",
                  style: AppTextStyle.bodyText
                      .copyWith(color: AppColor.primaryColor, fontSize: 11)),
            ],
          ):
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("${trans.account?.name ?? 'نامشخص'} ",
                  style: AppTextStyle.bodyText
                      .copyWith(color: AppColor.secondary3Color, fontSize: 12)),
            ],
          )
          ,
        )),
        DataCell(Center(
          child: trans.details!.isEmpty
              ? Column(
            key: _rowKeys[trans.id],
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              trans.toWallet?.account?.name != null
                  ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    " از : ",
                    style: AppTextStyle.bodyText.copyWith(
                        color: AppColor.textColor,
                        fontSize: 10),
                  ),
                  Text(
                    " ${trans.wallet?.account?.name ?? ""} ",
                    style: AppTextStyle.bodyText.copyWith(
                        color: AppColor.accentColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    " به : ",
                    style: AppTextStyle.bodyText.copyWith(
                        color: AppColor.textColor,
                        fontSize: 10),
                  ),
                  Text(
                    " ${trans.toWallet?.account?.name ?? ""} ",
                    style: AppTextStyle.bodyText.copyWith(
                        color: AppColor.primaryColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )
                  : SizedBox(),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    trans.item?.itemUnit?.id == 1
                        ? " ${trans.amount} "
                        : trans.item?.itemUnit?.id == 2
                        ? "${trans.amount} "
                        : "${trans.amount.toString().seRagham()}  ",
                    style: AppTextStyle.bodyText.copyWith(
                        color: AppColor.textColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 10),
                    textDirection: TextDirection.ltr,
                  ),
                  Text(
                    trans.item?.itemUnit?.id == 1
                        ? " عدد "
                        : trans.item?.itemUnit?.id == 2
                        ? " گرم "
                        : " ریال ",
                    style: AppTextStyle.bodyText.copyWith(
                        color: AppColor.textColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 10),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    trans.item?.name ?? 'نامشخص',
                    style: AppTextStyle.bodyText.copyWith(
                        color: AppColor.secondary2Color,
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  ),
                  trans.toItem!=null ?
                  Text(
                    " به : ",
                    style: AppTextStyle.bodyText.copyWith(
                        color: AppColor.textColor,
                        fontSize: 10),
                  ) : SizedBox.shrink(),
                  trans.toItem!=null ?
                  Text(
                    trans.toItem?.name ?? 'نامشخص',
                    style: AppTextStyle.bodyText.copyWith(
                        color: AppColor.secondary2Color,
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  ) : SizedBox.shrink(),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  trans.price != null
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        ' قیمت واحد :  ',
                        style: AppTextStyle.bodyText.copyWith(
                            color: AppColor.iconViewColor,
                            fontWeight: FontWeight.normal,
                            fontSize: 10),
                      ),
                      Text("${trans.price ?? 0}".seRagham() + "  ریال  ",
                          style: AppTextStyle.bodyText.copyWith(
                              color: AppColor.textColor,
                              fontWeight: FontWeight.normal,
                              fontSize: 11)),
                    ],
                  )
                      : SizedBox(),
                  trans.totalPrice != null
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        ' قیمت کل :  ',
                        style: AppTextStyle.bodyText.copyWith(
                            color: AppColor.iconViewColor,
                            fontWeight: FontWeight.normal,
                            fontSize: 10),
                      ),
                      Text(
                          "${trans.totalPrice ?? 0}"
                              .seRagham() +
                              "  ریال  ",
                          style: AppTextStyle.bodyText.copyWith(
                              color: AppColor.textColor,
                              fontWeight: FontWeight.normal,
                              fontSize: 11)),
                    ],
                  )
                      : SizedBox(),
                ],
              ),
              Container(
                height: 0.6,
                color: AppColor.textColor,
                margin: EdgeInsets.symmetric(
                    vertical: 5, horizontal: 20),
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    trans.date?.toPersianDate() ??
                        'نامشخص',
                    style: AppTextStyle.bodyText.copyWith(
                        color: AppColor.iconViewColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 10),
                    textDirection: TextDirection.ltr,
                  ),
                ],
              ),
            ],
          )
              : Column(
            key: _rowKeys[trans.id],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: trans.details!
                .map((e) => Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 5, vertical: 3),
                  child: Container(
                                padding: EdgeInsets.symmetric(
                    horizontal: 5, vertical: 5),
                                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: AppColor.textColor),
                                child: Column(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  crossAxisAlignment:
                  CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            Text(
                              "عیار : ",
                              style: AppTextStyle.bodyText
                                  .copyWith(
                                  color: AppColor
                                      .appBarColor,
                                  fontSize: 11,
                                  fontWeight:
                                  FontWeight.bold),
                            ),
                            Text(
                              "${e.carat ?? 0} ",
                              style: AppTextStyle.bodyText
                                  .copyWith(
                                  color: AppColor
                                      .iconViewColor,
                                  fontSize: 11,
                                  fontWeight:
                                  FontWeight.bold),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "وزن : ",
                              style: AppTextStyle.bodyText
                                  .copyWith(
                                  color: AppColor
                                      .appBarColor,
                                  fontSize: 11,
                                  fontWeight:
                                  FontWeight.bold),
                            ),
                            Text(
                              "${e.quantity ?? 0} گرم ",
                              style: AppTextStyle.bodyText
                                  .copyWith(
                                  color: AppColor
                                      .iconViewColor,
                                  fontSize: 11,
                                  fontWeight:
                                  FontWeight.bold),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "ناخالصی : ",
                              style: AppTextStyle.bodyText
                                  .copyWith(
                                  color: AppColor
                                      .appBarColor,
                                  fontSize: 11,
                                  fontWeight:
                                  FontWeight.bold),
                            ),
                            Text(
                              "${e.impurity ?? 0} گرم ",
                              style: AppTextStyle.bodyText
                                  .copyWith(
                                  color: AppColor
                                      .iconViewColor,
                                  fontSize: 11,
                                  fontWeight:
                                  FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            Text(
                              "نام آزمایشگاه : ",
                              style: AppTextStyle.bodyText
                                  .copyWith(
                                  color: AppColor
                                      .appBarColor,
                                  fontSize: 11,
                                  fontWeight:
                                  FontWeight.bold),
                            ),
                            Text(
                              "${e.name ?? ""} ",
                              style: AppTextStyle.bodyText
                                  .copyWith(

                                  color: AppColor
                                      .iconViewColor,
                                  fontSize: 11,
                                  fontWeight:
                                  FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                                ),
                              ),
                ))
                .toList(),
          ),
        )),
        DataCell(Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                trans.item?.itemUnit?.id == 1
                    ? "${trans.amount} "
                    : trans.item?.itemUnit?.id == 2
                    ? "${trans.amount} "
                    : "${trans.amount.toString().seRagham()} ",
                style: AppTextStyle.bodyText.copyWith(
                    color: AppColor.buttonColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold),
                textDirection: TextDirection.ltr,
              ),
              Text(
                trans.item?.itemUnit?.id == 1
                    ? " عدد "
                    : trans.item?.itemUnit?.id == 2
                    ? " گرم "
                    : " ریال ",
                style: AppTextStyle.bodyText.copyWith(
                    color: AppColor.buttonColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold),
                textDirection: TextDirection.ltr,
              ),
            ],
          ),
        )),
        // کارتخوان
        DataCell(
            Center(
              child:
              trans.isCard==true ?
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
        // مانده
        DataCell(
            trans.toId!=0 && trans.fromId!=0 ?
            Center(
              child:
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return BalanceDialogId(
                          entityId:trans.fromId!=0 ? trans.fromId ?? 0 : trans.id ?? 0,
                          entityName:'نامشخص',
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
                        color: AppColor.accentColor,
                      ),
                      Text(' مانده بدهکار',
                        style: AppTextStyle
                            .labelText
                            .copyWith(
                            color: AppColor.accentColor, fontSize: 11,fontWeight: FontWeight.bold),),

                    ],
                  ),
                ),
              ),
            ) :
            Center(
              child:
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return BalanceDialogId(
                          entityId:trans.fromId!=0 ? trans.fromId ?? 0 : trans.id ?? 0,
                          entityName:'نامشخص',
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
                        color: AppColor.dividerColor,
                      ),
                      Text(' مانده',
                        style: AppTextStyle
                            .labelText
                            .copyWith(
                            color: AppColor.dividerColor, fontSize: 11,fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
              ),
            )
        ),
        // مانده بستانکار
        DataCell(
            trans.toId!=0 && trans.fromId!=0 ?
            Center(
              child:
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return BalanceDialogId(
                          entityId: trans.toId ?? 0,
                          entityName:'نامشخص',
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
                        color: AppColor.primaryColor,
                      ),
                      Text(' مانده بستانکار',
                        style: AppTextStyle
                            .labelText
                            .copyWith(
                            color: AppColor.primaryColor, fontSize: 11,fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ) :
                SizedBox.shrink(),
        ) ,
        // تصویر
        DataCell(Center(
          child:
          GestureDetector(
            onTap: () async{
              await controller.getImage(
                  trans.recId ?? "",trans.type == "payment" || trans.type == "receive" ? "Inventory" : trans.type == "issue" || trans.type == "reciept" ? "Remittance" :
              trans.type == "deposit" ? "Deposit" : "",
              );
              _showImageGallery(context);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColor.iconViewColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColor.iconViewColor.withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    'assets/svg/picture.svg',
                    height: 16,
                    colorFilter: ColorFilter.mode(AppColor.iconViewColor, BlendMode.srcIn),
                  ),
                  SizedBox(width: 6),
                  Text(
                    "تصاویر",
                    style: AppTextStyle.labelText.copyWith(
                      color: AppColor.iconViewColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        )),

        /*DataCell(Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                trans.balances == null
                    ? SizedBox()
                    : Column(
                  children: trans.balances!
                      .map((e) => Container(
                    child: e.unitName == "عدد"
                        ? Row(
                      children: [
                        Text(" ${e.itemName} ",
                            style: AppTextStyle
                                .bodyText
                                .copyWith(
                                fontSize: 9,
                                color: e.balance! >
                                    0
                                    ? AppColor
                                    .primaryColor
                                    : AppColor
                                    .accentColor,
                                fontWeight:
                                FontWeight
                                    .bold)),
                        Text(
                          e.balance.toString(),
                          style: AppTextStyle.bodyText
                              .copyWith(
                              fontSize: 10,
                              color: e.balance! > 0
                                  ? AppColor
                                  .primaryColor
                                  : AppColor
                                  .accentColor,
                              fontWeight:
                              FontWeight.bold),
                          textDirection:
                          TextDirection.ltr,
                        ),
                        Text(" ${e.unitName} ",
                            style: AppTextStyle
                                .bodyText
                                .copyWith(
                                fontSize: 9,
                                color: e.balance! >
                                    0
                                    ? AppColor
                                    .primaryColor
                                    : AppColor
                                    .accentColor,
                                fontWeight:
                                FontWeight.bold)
                          //  textDirection: TextDirection.ltr,
                        ),
                      ],
                    )
                        : SizedBox(),
                  ))
                      .toList(),
                ),
              ],
            ))),*/
        /*DataCell(Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                trans.tobalances == null
                    ? SizedBox()
                    : Column(
                  children: trans.tobalances!
                      .map((e) => Container(
                    child: e.unitName == "ریال"
                        ? Row(
                      children: [
                        Text(
                          " ${e.itemName} ",
                          style: AppTextStyle.bodyText
                              .copyWith(
                              fontSize: 9,
                              color: e.balance! > 0
                                  ? AppColor
                                  .primaryColor
                                  : AppColor
                                  .accentColor,
                              fontWeight:
                              FontWeight.bold),
                        ),
                        Text(
                          e.balance
                              .toString()
                              .seRagham(),
                          style: AppTextStyle.bodyText
                              .copyWith(
                              fontSize: 10,
                              color: e.balance! > 0
                                  ? AppColor
                                  .primaryColor
                                  : AppColor
                                  .accentColor,
                              fontWeight:
                              FontWeight.bold),
                          textDirection:
                          TextDirection.ltr,
                        ),
                        Text(" ${e.unitName} ",
                            style: AppTextStyle
                                .bodyText
                                .copyWith(
                                fontSize: 9,
                                color: e.balance! >
                                    0
                                    ? AppColor
                                    .primaryColor
                                    : AppColor
                                    .accentColor,
                                fontWeight:
                                FontWeight.bold)
                          //  textDirection: TextDirection.ltr,
                        ),
                      ],
                    )
                        : SizedBox(),
                  ))
                      .toList(),
                ),
              ],
            ))),*/
        /*DataCell(Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                trans.tobalances == null
                    ? SizedBox()
                    : Column(
                  children: trans.tobalances!
                      .map((e) => Container(
                    child: e.unitName == "گرم"
                        ? Row(
                      children: [
                        Text(" ${e.itemName} ",
                            style: AppTextStyle
                                .bodyText
                                .copyWith(
                                fontSize: 9,
                                color: e.balance! >
                                    0
                                    ? AppColor
                                    .primaryColor
                                    : AppColor
                                    .accentColor,
                                fontWeight:
                                FontWeight
                                    .bold)),
                        Text(
                          e.balance.toString(),
                          style: AppTextStyle.bodyText
                              .copyWith(
                              fontSize: 10,
                              color: e.balance! > 0
                                  ? AppColor
                                  .primaryColor
                                  : AppColor
                                  .accentColor,
                              fontWeight:
                              FontWeight.bold),
                          textDirection:
                          TextDirection.ltr,
                        ),
                        Text(" ${e.unitName} ",
                            style: AppTextStyle
                                .bodyText
                                .copyWith(
                                fontSize: 9,
                                color: e.balance! >
                                    0
                                    ? AppColor
                                    .primaryColor
                                    : AppColor
                                    .accentColor,
                                fontWeight:
                                FontWeight.bold)
                          //  textDirection: TextDirection.ltr,
                        ),
                      ],
                    )
                        : SizedBox(),
                  ))
                      .toList(),
                ),
              ],
            ))),*/
        /*DataCell(Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                trans.tobalances == null
                    ? SizedBox()
                    : Column(
                  children: trans.tobalances!
                      .map((e) => Container(
                    child: e.unitName == "عدد"
                        ? Row(
                      children: [
                        Text(" ${e.itemName} ",
                            style: AppTextStyle
                                .bodyText
                                .copyWith(
                                fontSize: 9,
                                color: e.balance! >
                                    0
                                    ? AppColor
                                    .primaryColor
                                    : AppColor
                                    .accentColor,
                                fontWeight:
                                FontWeight
                                    .bold)),
                        Text(
                          e.balance.toString(),
                          style: AppTextStyle.bodyText
                              .copyWith(
                              fontSize: 10,
                              color: e.balance! > 0
                                  ? AppColor
                                  .primaryColor
                                  : AppColor
                                  .accentColor,
                              fontWeight:
                              FontWeight.bold),
                          textDirection:
                          TextDirection.ltr,
                        ),
                        Text(" ${e.unitName} ",
                            style: AppTextStyle
                                .bodyText
                                .copyWith(
                                fontSize: 9,
                                color: e.balance! >
                                    0
                                    ? AppColor
                                    .primaryColor
                                    : AppColor
                                    .accentColor,
                                fontWeight:
                                FontWeight.bold)
                          //  textDirection: TextDirection.ltr,
                        ),
                      ],
                    )
                        : SizedBox(),
                  ))
                      .toList(),
                ),
              ],
            ))),*/
        /*DataCell(Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 20,
                ),
            trans.recId!=null && (trans.type=="issue" || trans.type=="deposit" || trans.type=="payment")? GestureDetector(
                  onTap: () async{
                    if(trans.type=="issue"){
                      await controller.getImage(trans.recId??"", "Remittance");
                      Future.delayed(const Duration(milliseconds: 200), () {
                        if(controller.imageList.isNotEmpty){
                          showDialog(
                            context:context,
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
                                              controller: controller
                                                  .pageController,
                                              itemCount: controller.imageList.length,
                                              onPageChanged: (index) =>
                                              controller
                                                  .currentImagePage
                                                  .value =
                                                  index,
                                              itemBuilder: (context,
                                                  index) {
                                                final attachment = controller.imageList[index];
                                                return Column(
                                                  children: [
                                                    if (kIsWeb)
                                                      Padding(
                                                        padding: const EdgeInsets.only(right: 50),
                                                        child: Row(mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            IconButton(
                                                              icon: Icon(Icons.download, color: AppColor.dividerColor),
                                                              onPressed: () => controller.downloadImage(
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
                                                              null) {
                                                            return child;
                                                          }
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
                                                    visible: controller
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
                                                        controller.pageController
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
                                                    visible: controller
                                                        .currentImagePage.value <
                                                        (controller.imageList.length ?? 1) -
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
                                                        controller.pageController
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
                                                    controller.imageList.length,
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
                                                            color: controller
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
                        }else{
                          Get.snackbar("نمایش عکس","مستنداتی برای نمایش وجود ندارد",
                             );
                        }


                      });
                    }else if(trans.type=="deposit"){
                      await controller.getImage(trans.recId??"", "Deposit");
                      Future.delayed(const Duration(milliseconds: 200), () {
                        if(controller.imageList.isNotEmpty){
                          showDialog(
                            context:context,
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
                                              controller: controller
                                                  .pageController,
                                              itemCount: controller.imageList.length,
                                              onPageChanged: (index) =>
                                              controller
                                                  .currentImagePage
                                                  .value =
                                                  index,
                                              itemBuilder: (context,
                                                  index) {
                                                final attachment = controller.imageList[index];
                                                return Column(
                                                  children: [
                                                    if (kIsWeb)
                                                      Padding(
                                                        padding: const EdgeInsets.only(right: 50),
                                                        child: Row(mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            IconButton(
                                                              icon: Icon(Icons.download, color: AppColor.dividerColor),
                                                              onPressed: () => controller.downloadImage(
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
                                                              null) {
                                                            return child;
                                                          }
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
                                                    visible: controller
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
                                                        controller.pageController
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
                                                    visible: controller
                                                        .currentImagePage.value <
                                                        (controller.imageList.length ?? 1) -
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
                                                        controller.pageController
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
                                                    controller.imageList.length,
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
                                                            color: controller
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
                        }else{
                          Get.snackbar("نمایش عکس","مستنداتی برای نمایش وجود ندارد",
                          );
                        }


                      });
                    }else if(trans.type=="payment" || trans.type=="receive"){
                      await controller.getImage(trans.recId??"", "Inventory");
                      Future.delayed(const Duration(milliseconds: 200), () {
                        if(controller.imageList.isNotEmpty){
                          showDialog(
                            context:context,
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
                                              controller: controller
                                                  .pageController,
                                              itemCount: controller.imageList.length,
                                              onPageChanged: (index) =>
                                              controller
                                                  .currentImagePage
                                                  .value =
                                                  index,
                                              itemBuilder: (context,
                                                  index) {
                                                final attachment = controller.imageList[index];
                                                return Column(
                                                  children: [
                                                    if (kIsWeb)
                                                      Padding(
                                                        padding: const EdgeInsets.only(right: 50),
                                                        child: Row(mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            IconButton(
                                                              icon: Icon(Icons.download, color: AppColor.dividerColor),
                                                              onPressed: () => controller.downloadImage(
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
                                                              null) {
                                                            return child;
                                                          }
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
                                                    visible: controller
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
                                                        controller.pageController
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
                                                    visible: controller
                                                        .currentImagePage.value <
                                                        (controller.imageList.length ?? 1) -
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
                                                        controller.pageController
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
                                                    controller.imageList.length,
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
                                                            color: controller
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
                        }else{
                          Get.snackbar("نمایش عکس","مستنداتی برای نمایش وجود ندارد",
                          );
                        }


                      });
                    }else{

                    }

                  },
                  child: SvgPicture.asset('assets/svg/picture.svg',height: 20,
                      colorFilter: ColorFilter.mode(

                        AppColor.textColor,

                        BlendMode.srcIn,
                      )),
                )
                :SizedBox(),
                SizedBox(
                  width: 20,
                ),
              ],
            ))),*/
      ],
    ))
        .toList();
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
                          controller: controller.pageController,
                          itemCount: controller.imageList.length,
                          onPageChanged: (index) =>
                          controller.currentImagePage.value = index,
                          itemBuilder: (context, index) {
                            final attachment = controller.imageList[index];
                            return Column(
                              children: [
                                if (kIsWeb)
                                  Padding(
                                    padding: const EdgeInsets.only(right: 50),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.download, color: AppColor.dividerColor),
                                          onPressed: () => controller.downloadImage(attachment),
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
                            visible: controller.currentImagePage.value > 0,
                            child: IconButton(
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(Colors.black54),
                                shape: WidgetStateProperty.all(CircleBorder()),
                                padding: WidgetStateProperty.all(EdgeInsets.all(8)),
                              ),
                              icon: Icon(Icons.chevron_left, color: Colors.white, size: 40),
                              onPressed: () {
                                controller.pageController.previousPage(
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
                            visible: controller.currentImagePage.value <
                                (controller.imageList.length - 1),
                            child: IconButton(
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(Colors.black54),
                                shape: WidgetStateProperty.all(CircleBorder()),
                                padding: WidgetStateProperty.all(EdgeInsets.all(8)),
                              ),
                              icon: Icon(Icons.chevron_right, color: Colors.white, size: 40),
                              onPressed: () {
                                controller.pageController.nextPage(
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
                      controller.imageList.length,
                          (index) => Container(
                        width: 8,
                        height: 8,
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: controller.currentImagePage.value == index
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
}
