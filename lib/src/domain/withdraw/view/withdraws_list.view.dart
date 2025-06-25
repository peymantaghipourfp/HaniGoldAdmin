
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:hanigold_admin/src/domain/withdraw/controller/withdraw.controller.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/withdraw.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/view/deposit_request_create.view.dart';
import 'package:hanigold_admin/src/widget/custom_appbar1.widget.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../config/const/app_color.dart';
import '../../../widget/app_drawer.widget.dart';
import '../../../widget/background_image_total.widget.dart';
import '../../../widget/empty.dart';
import '../../../widget/err_page.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import '../../../widget/pager_widget.dart';
import 'deposit_request_update.view.dart';

class WithdrawsListView extends StatefulWidget {
  WithdrawsListView({super.key});

  @override
  State<WithdrawsListView> createState() => _WithdrawsListViewState();
}

class _WithdrawsListViewState extends State<WithdrawsListView> {
  final WithdrawController withdrawController = Get.find<WithdrawController>();
  final GlobalKey _dataTableKey = GlobalKey();
  final Map<int, GlobalKey> _rowKeys = {};

  @override
  void initState() {
    super.initState();
    withdrawController.withdrawList.listen((list) {
      _prepareScreenshotKeys(list);
      if (mounted) {
        setState(() {});
      }
    });
    _prepareScreenshotKeys(withdrawController.withdrawList);
  }

  void _prepareScreenshotKeys(List<WithdrawModel> withdraws) {
    final newKeys = <int>{};
    for (var withdraw in withdraws) {
      if (withdraw.id != null) {
        newKeys.add(withdraw.id!);
        if (!_rowKeys.containsKey(withdraw.id)) {
          _rowKeys[withdraw.id!] = GlobalKey(debugLabel: 'row_${withdraw.id}');
        }
      }
    }
    _rowKeys.removeWhere((key, value) => !newKeys.contains(key));
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    return Scaffold(
      appBar: CustomAppbar1(title: 'لیست درخواست های برداشت',
        onBackTap: () => Get.offNamed('/home'),
      ),
      drawer: const AppDrawer(),
      body: Stack(
        children: [
          BackgroundImageTotal(),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: SizedBox(
                width: Get.width,
                height: Get.height,
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
                                controller: withdrawController.searchController,
                                style: AppTextStyle.labelText,
                                textInputAction: TextInputAction.search,
                                onFieldSubmitted: (value) async {
                                  if (value.isNotEmpty) {
                                    await withdrawController.searchAccounts(value);
                                    showSearchResults(context);
                                  } else {
                                    withdrawController.clearSearch();
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
                                        if (withdrawController.searchController.text
                                            .isNotEmpty) {
                                          await withdrawController.searchAccounts(
                                              withdrawController.searchController
                                                  .text
                                          );
                                          showSearchResults(context);
                                        } else {
                                          withdrawController.clearSearch();
                                        }
                                      },
                                      icon: Icon(
                                        Icons.search, color: AppColor.textColor,
                                        size: 30,)
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: withdrawController.clearSearch,
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
                          //فیلد جستجو
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 50,vertical: 10),
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  color: AppColor.appBarColor.withOpacity(0.5),
                                  alignment: Alignment.center,
                                  height: 80,
                                  child: TextFormField(
                                    controller: withdrawController.searchController,
                                    style: AppTextStyle.labelText,
                                    textInputAction: TextInputAction.search,
                                    onFieldSubmitted: (value) async {
                                      if (value.isNotEmpty) {
                                        await withdrawController.searchAccounts(value);
                                        showSearchResults(context);
                                      } else {
                                        withdrawController.clearSearch();
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
                                            if (withdrawController.searchController.text
                                                .isNotEmpty) {
                                              await withdrawController.searchAccounts(
                                                  withdrawController.searchController
                                                      .text
                                              );
                                              showSearchResults(context);
                                            } else {
                                              withdrawController.clearSearch();
                                            }
                                          },
                                          icon: Icon(
                                            Icons.search, color: AppColor.textColor,
                                            size: 30,)
                                      ),
                                      suffixIcon: IconButton(
                                        onPressed: withdrawController.clearSearch,
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
                                  //دکمه ایجاد درخواست برداشت جدید
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
                                      Get.toNamed('/withdrawCreate');
                                    },
                                    child: Text(
                                      'برداشت جدید',
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
                                                                      controller: withdrawController.dateStartController,
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
                                                                        withdrawController.startDateFilter.value =
                                                                        "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";

                                                                        withdrawController.dateStartController.text =
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
                                                                      controller: withdrawController.dateEndController,
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
                                                                        withdrawController.endDateFilter.value =
                                                                        "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";

                                                                        withdrawController.dateEndController.text =
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
                                                            withdrawController.exportToExcel();
                                                            Get.back();
                                                          },
                                                          child: withdrawController.isLoading.value?
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
                                                                      controller: withdrawController.dateStartController,
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
                                                                        withdrawController.startDateFilter.value =
                                                                        "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";

                                                                        withdrawController.dateStartController.text =
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
                                                                      controller: withdrawController.dateEndController,
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
                                                                        withdrawController.endDateFilter.value =
                                                                        "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";

                                                                        withdrawController.dateEndController.text =
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
                                                            withdrawController.exportToPdf();
                                                            Get.back();
                                                          },
                                                          child: withdrawController.isLoading.value?
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
                                              width:isDesktop?  Get.width * 0.2:Get.height * 0.5,
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
                                                                withdrawController.clearFilter();
                                                                withdrawController.getWithdrawListPager();
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
                                                                  controller: withdrawController.nameFilterController,
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
                                                                  controller: withdrawController.mobileFilterController,
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
                                                                    controller: withdrawController.dateStartController,
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
                                                                      withdrawController.startDateFilter.value =
                                                                      "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";

                                                                      withdrawController.dateStartController.text =
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
                                                                    controller: withdrawController.dateEndController,
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
                                                                      withdrawController.endDateFilter.value =
                                                                      "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";

                                                                      withdrawController.dateEndController.text =
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
                                                          withdrawController.getWithdrawListPager();
                                                          Get.back();

                                                        },
                                                        child: withdrawController.isLoading.value?
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
                                          withdrawController.nameFilterController.text!="" ||  withdrawController.mobileFilterController.text!="" || withdrawController.dateStartController.text!="" || withdrawController.dateEndController.text!="" ?AppColor.accentColor:  AppColor
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
                                              : 10,color:  withdrawController.nameFilterController.text!="" ||  withdrawController.mobileFilterController.text!="" || withdrawController.dateStartController.text!="" || withdrawController.dateEndController.text!="" ?AppColor.accentColor: AppColor.textColor),
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
                      if (withdrawController.state.value == PageState.loading) {
                      //  EasyLoading.show(status: 'دریافت اطلاعات از سرور...');
                        return Center(child: CircularProgressIndicator());
                      } else
                      if (withdrawController.state.value == PageState.empty) {
                       // EasyLoading.dismiss();
                        return EmptyPage(
                          title: 'درخواستی وجود ندارد',
                          callback: () {
                            withdrawController.getWithdrawListPager();
                          },
                        );
                      } else if (withdrawController.state.value == PageState.list) {
                       // EasyLoading.dismiss();
                        return isDesktop ?
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 60,vertical: 0),
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
                                            //دکمه ایجاد درخواست برداشت جدید
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
                                                Get.toNamed('/withdrawCreate');
                                              },
                                              child: Text(
                                                'ایجاد درخواست برداشت جدید',
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
                                                                                controller: withdrawController.dateStartController,
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
                                                                                  withdrawController.startDateFilter.value =
                                                                                  "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";

                                                                                  withdrawController.dateStartController.text =
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
                                                                                controller: withdrawController.dateEndController,
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
                                                                                  withdrawController.endDateFilter.value =
                                                                                  "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";

                                                                                  withdrawController.dateEndController.text =
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
                                                                      withdrawController.exportToExcel();
                                                                      Get.back();
                                                                    },
                                                                    child: withdrawController.isLoading.value?
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
                                                                                controller: withdrawController.dateStartController,
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
                                                                                  withdrawController.startDateFilter.value =
                                                                                  "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";

                                                                                  withdrawController.dateStartController.text =
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
                                                                                controller: withdrawController.dateEndController,
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
                                                                                  withdrawController.endDateFilter.value =
                                                                                  "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";

                                                                                  withdrawController.dateEndController.text =
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
                                                                      withdrawController.exportToPdf();
                                                                      Get.back();
                                                                    },
                                                                    child: withdrawController.isLoading.value?
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
                                                        width:isDesktop?  Get.width * 0.2:Get.height * 0.5,
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
                                                                          withdrawController.clearFilter();
                                                                          withdrawController.getWithdrawListPager();
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
                                                                            controller: withdrawController.nameFilterController,
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
                                                                            controller: withdrawController.mobileFilterController,
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
                                                                              controller: withdrawController.dateStartController,
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
                                                                                withdrawController.startDateFilter.value =
                                                                                "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";

                                                                                withdrawController.dateStartController.text =
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
                                                                              controller: withdrawController.dateEndController,
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
                                                                                withdrawController.endDateFilter.value =
                                                                                "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";

                                                                                withdrawController.dateEndController.text =
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
                                                                    withdrawController.getWithdrawListPager();
                                                                    Get.back();

                                                                  },
                                                                  child: withdrawController.isLoading.value?
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
                                                    withdrawController.nameFilterController.text!="" ||  withdrawController.mobileFilterController.text!="" || withdrawController.dateStartController.text!="" || withdrawController.dateEndController.text!="" ?AppColor.accentColor:  AppColor
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
                                                        : 10,color:  withdrawController.nameFilterController.text!="" ||  withdrawController.mobileFilterController.text!="" || withdrawController.dateStartController.text!="" || withdrawController.dateEndController.text!="" ?AppColor.accentColor: AppColor.textColor),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    child: SingleChildScrollView(
                                      controller: withdrawController.horizontalScrollController,
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                RepaintBoundary(
                                                  key: _dataTableKey,
                                                  child: DataTable(
                                                    sortColumnIndex: withdrawController.sortColumnIndex.value,
                                                    sortAscending: withdrawController.sortAscending.value,
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
                                                    columnSpacing: 40,
                                                    horizontalMargin: 6,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          ...withdrawController.withdrawList.map((
                                              withdraw) {
                                            return buildExpandedContent(withdraw);
                                          })
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
                            controller: withdrawController.scrollController,
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemCount: withdrawController.withdrawList.length +
                                (withdrawController.hasMore.value ? 1 : 0),
                            itemBuilder: (context, index) {
                              print(withdrawController.withdrawList.length);
                              if (index >= withdrawController.withdrawList.length) {
                                return withdrawController.hasMore.value
                                    ? Center(child: CircularProgressIndicator())
                                    : SizedBox.shrink();
                              }
                              var withdraws = withdrawController
                                  .withdrawList[index];
                              return
                                Obx(() {
                                  bool isExpanded = withdrawController
                                      .isItemExpanded(index);
                                  return Card(
                                    margin: EdgeInsets.all(isDesktop ? 12 : 4),
                                    color: AppColor.secondaryColor,
                                    elevation: 10,
                                    child: Padding(
                                      padding: EdgeInsets.all(isDesktop ? 16 : 8),
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
                                                      .center,
                                                  children: [
                                                    Text(withdraws.status == 0
                                                        ?
                                                    withdraws.requestDate
                                                        ?.toPersianDate(
                                                      twoDigits: true,
                                                      showTime: true,
                                                      timeSeprator: '-',) ??
                                                        'نامشخص'
                                                        :
                                                    withdraws.confirmDate
                                                        ?.toPersianDate(
                                                      twoDigits: true,
                                                      showTime: true,
                                                      timeSeprator: '-',) ??
                                                        'نامشخص'
                                                      ,
                                                      style:
                                                      AppTextStyle.bodyText,
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 5,),
                                                SizedBox(width: 100,
                                                  child: Divider(
                                                    height: 1, color: AppColor
                                                      .dividerColor,),),
                                                SizedBox(height: 8,),

                                                // نام کاربر و نام دارنده حساب
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text('نام کاربر: ',
                                                      style: AppTextStyle
                                                          .labelText,),
                                                    SizedBox(height: 2,),
                                                    Text(withdraws.wallet
                                                        ?.account?.name
                                                        ?? "",
                                                      style: AppTextStyle
                                                          .bodyText,),
                                                    /*Column(
                                                      crossAxisAlignment: CrossAxisAlignment
                                                          .center,
                                                      children: [
                                                        Text('نام دارنده حساب',
                                                          style: AppTextStyle
                                                              .labelText,),
                                                        SizedBox(height: 2,),
                                                        Text("${withdraws
                                                            .bankAccount
                                                            ?.ownerName ??
                                                            ""}""(${withdraws
                                                            .bankAccount?.bank
                                                            ?.name ?? ""})",
                                                          style: AppTextStyle
                                                              .bodyText,),
                                                      ],
                                                    ),*/
                                                  ],
                                                ),
                                                SizedBox(height: 6,),

                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .spaceEvenly,
                                                  children: [
                                                    //  مبلغ کل و مبلغ تایید نشده
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment
                                                          .center,
                                                      mainAxisAlignment: MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text('مبلغ کل: ',
                                                              style: AppTextStyle
                                                                  .labelText,),
                                                            SizedBox(width: 3,),
                                                            Text("${withdraws
                                                                .amount?.toInt()
                                                                .toString()
                                                                .seRagham(
                                                                separator: ',')} ریال",
                                                              style: AppTextStyle
                                                                  .bodyText,),
                                                          ],
                                                        ),
                                                        /*Row(
                                                          children: [
                                                            Text(
                                                              'مبلغ تایید نشده: ',
                                                              style: AppTextStyle
                                                                  .labelText,),
                                                            SizedBox(width: 3,),
                                                            Text("${withdraws
                                                                .notConfirmedAmount ==
                                                                null ? 0 :
                                                            withdraws
                                                                .notConfirmedAmount
                                                                ?.toInt()
                                                                .toString()
                                                                .seRagham(
                                                                separator: ',')} ریال",
                                                              style: AppTextStyle
                                                                  .bodyText,),
                                                          ],
                                                        ),*/
                                                      ],
                                                    ),
                                                    SizedBox(height: 4,),

                                                    // مبلغ مانده
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment
                                                          .center,
                                                      children: [
                                                        Text('مبلغ مانده: ',
                                                          style: AppTextStyle
                                                              .labelText,),
                                                        SizedBox(width: 3,),
                                                        Text("${withdraws
                                                            .undividedAmount ==
                                                            null ? 0 :
                                                        withdraws
                                                            .undividedAmount
                                                            ?.toInt()
                                                            .toString()
                                                            .seRagham(
                                                            separator: ',')} ریال",
                                                          style: AppTextStyle
                                                              .bodyText.copyWith(color: AppColor.accentColor),),
                                                      ],
                                                    ),
                                                    SizedBox(height: 4,),

                                                    // مبلغ واریز شده
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment
                                                          .center,
                                                      children: [
                                                        Text('مبلغ واریز شده: ',
                                                          style: AppTextStyle
                                                              .labelText,),
                                                        SizedBox(width: 3,),
                                                        Text("${withdraws
                                                            .paidAmount == null
                                                            ? 0
                                                            : withdraws
                                                            .paidAmount?.toInt()
                                                            .toString()
                                                            .seRagham(
                                                            separator: ',')} ریال",
                                                          style: AppTextStyle
                                                              .bodyText.copyWith(color: AppColor.primaryColor),),
                                                      ],
                                                    ),
                                                    SizedBox(height: 4,),
                                                    // دلیل رد
                                                    withdraws.status == 2 ?
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment
                                                          .center,
                                                      children: [
                                                        Text('دلیل رد: ',
                                                          style: AppTextStyle
                                                              .labelText,),
                                                        SizedBox(width: 3,),
                                                        Text("`${withdraws
                                                            .reasonRejection
                                                            ?.name}`" ?? "",
                                                          style: AppTextStyle
                                                              .bodyText,),
                                                      ],
                                                    ) : Text(""),
                                                  ],
                                                ),
                                                SizedBox(height: 4,),
                                                Divider(height: 1,),
                                                SizedBox(height: 5,),

                                                //  آیکون ها
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    // آیکون اضافه کردن درخواست deposit request
                                                    GestureDetector(
                                                      onTap: () {
                                                        if (withdraws.undividedAmount==0) {
                                                          Get.defaultDialog(
                                                            title: 'هشدار',
                                                            middleText: 'مبلغ باقیمانده برای تقسیم صفر است',
                                                            titleStyle: AppTextStyle
                                                                .smallTitleText,
                                                            middleTextStyle: AppTextStyle
                                                                .bodyText,
                                                            backgroundColor: AppColor
                                                                .backGroundColor,
                                                            textCancel: 'بستن',
                                                          );
                                                        } else {
                                                          withdrawController.balanceList.clear();
                                                          showModalBottomSheet(
                                                            enableDrag: true,
                                                            context: context,
                                                            backgroundColor: AppColor
                                                                .backGroundColor,
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius
                                                                  .vertical(top: Radius
                                                                  .circular(20)),
                                                            ),
                                                            builder: (context) {
                                                              return InsertDepositRequestWidget(id: withdraws.id!, walletId: withdraws
                                                                  .wallet!
                                                                  .id!,);
                                                            },
                                                          ).whenComplete(() {
                                                            withdrawController
                                                                .clearList();
                                                          }
                                                          );
                                                          withdrawController
                                                              .filterAccountListFunc(
                                                              withdraws.wallet!
                                                                  .account!.id!
                                                                  .toInt());
                                                        }
                                                      },
                                                      child: Row(
                                                        children: [
                                                          Text(' تقسیم',
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
                                                                BlendMode
                                                                    .srcIn,)
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    // آیکون حذف کردن
                                                    GestureDetector(
                                                      onTap: () {
                                                        if (withdraws
                                                            .depositRequestCount !=
                                                            0 || withdraws
                                                            .depositCount !=
                                                            0) {
                                                          Get.defaultDialog(
                                                            title: 'هشدار',
                                                            middleText: 'به دلیل داشتن زیر مجموعه قابل حذف نیست',
                                                            titleStyle: AppTextStyle
                                                                .smallTitleText,
                                                            middleTextStyle: AppTextStyle
                                                                .bodyText,
                                                            backgroundColor: AppColor
                                                                .backGroundColor,
                                                            textCancel: 'بستن',
                                                          );
                                                        } else {
                                                          Get.defaultDialog(
                                                              backgroundColor: AppColor
                                                                  .backGroundColor,
                                                              title: "حذف درخواست برداشت",
                                                              titleStyle: AppTextStyle
                                                                  .smallTitleText,
                                                              middleText: "آیا از حذف درخواست برداشت مطمئن هستید؟",
                                                              middleTextStyle: AppTextStyle
                                                                  .bodyText,
                                                              confirm: ElevatedButton(
                                                                  style: ButtonStyle(
                                                                      backgroundColor: WidgetStatePropertyAll(
                                                                          AppColor
                                                                              .primaryColor)),
                                                                  onPressed: () {
                                                                    Get
                                                                        .back();
                                                                    withdrawController
                                                                        .deleteWithdraw(
                                                                        withdraws
                                                                            .id!,
                                                                        true);
                                                                    //withdrawController.fetchWithdrawList();
                                                                  },
                                                                  child: Text(
                                                                    'حذف',
                                                                    style: AppTextStyle
                                                                        .bodyText,
                                                                  )));
                                                          //withdrawController.fetchWithdrawList();
                                                        }
                                                      },
                                                      child: Row(
                                                        children: [
                                                          Text(' حذف',
                                                            style: AppTextStyle
                                                                .labelText
                                                                .copyWith(
                                                                color: AppColor
                                                                    .accentColor),),
                                                          SvgPicture
                                                              .asset(
                                                              'assets/svg/trash-bin.svg',
                                                              colorFilter: ColorFilter
                                                                  .mode(AppColor
                                                                  .accentColor,
                                                                BlendMode
                                                                    .srcIn,)
                                                          ),

                                                        ],
                                                      ),
                                                    ),
                                                    // آیکون مشاهده
                                                    GestureDetector(
                                                      onTap: () {
                                                        Get.toNamed('/withdrawGetOne', parameters:{"id":withdraws.id.toString()});
                                                        //print(withdraws.id);
                                                      },
                                                      child: Row(
                                                        children: [
                                                          Text(' مشاهده',
                                                            style: AppTextStyle
                                                                .labelText
                                                                .copyWith(
                                                                color: AppColor
                                                                    .iconViewColor),),
                                                          SvgPicture.asset(
                                                              'assets/svg/eye1.svg',
                                                              colorFilter: ColorFilter
                                                                  .mode(AppColor
                                                                  .iconViewColor,
                                                                BlendMode
                                                                    .srcIn,)
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    // آیکون ویرایش
                                                    GestureDetector(
                                                      onTap: () {
                                                        /*if (withdraws.depositRequestCount != 0 || withdraws.depositCount != 0) {
                                                          Get.defaultDialog(
                                                            title: 'هشدار',
                                                            middleText: 'به دلیل داشتن زیر مجموعه قابل ویرایش نیست',
                                                            titleStyle: AppTextStyle
                                                                .smallTitleText,
                                                            middleTextStyle: AppTextStyle
                                                                .bodyText,
                                                            backgroundColor: AppColor
                                                                .backGroundColor,
                                                            textCancel: 'بستن',
                                                          );
                                                        } else {*/
                                                        Get.toNamed(
                                                            '/withdrawUpdate',parameters:{"id":withdraws.id.toString()});
                                                        // }
                                                      },
                                                      child: Row(
                                                        children: [
                                                          Text(' ویرایش',
                                                            style: AppTextStyle
                                                                .labelText
                                                                .copyWith(
                                                                color: AppColor
                                                                    .iconViewColor),),
                                                          SvgPicture
                                                              .asset(
                                                              'assets/svg/edit.svg',
                                                              colorFilter: ColorFilter
                                                                  .mode(AppColor
                                                                  .iconViewColor,
                                                                BlendMode
                                                                    .srcIn,)
                                                          ),

                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),

                                                // تعیین وضعیت
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    // وضعیت
                                                    Row(
                                                      children: [
                                                        Text('وضعیت: ',
                                                            style: AppTextStyle
                                                                .bodyText),
                                                        Text(
                                                          '${withdraws.status ==
                                                              0
                                                              ? 'نامشخص'
                                                              : withdraws
                                                              .status == 1
                                                              ? 'تایید شده'
                                                              : 'تایید نشده'} ',
                                                          style: AppTextStyle
                                                              .bodyText
                                                              .copyWith(
                                                            color: withdraws
                                                                .status == 1
                                                                ? AppColor
                                                                .primaryColor
                                                                : withdraws
                                                                .status == 2
                                                                ? AppColor
                                                                .accentColor
                                                                : AppColor
                                                                .textColor,
                                                          )
                                                          ,),
                                                      ],
                                                    ),

                                                    // دکمه نمایش لیست deposit request
                                                    IconButton(
                                                      onPressed: () {
                                                        withdrawController.fetchDepositRequestList(withdraws.id!);
                                                        withdrawController.toggleItemExpansion(index);
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

                                                    // Popup تعیین وضعیت
                                                    Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 0,
                                                          vertical: 0),
                                                      child: PopupMenuButton<
                                                          int>(
                                                        splashRadius: 10,
                                                        tooltip: 'تعیین وضعیت',
                                                        onSelected: (
                                                            value) async {
                                                          if (value == 2) {
                                                            await withdrawController
                                                                .showReasonRejectionDialog(
                                                                "WithdrawRequest");
                                                            if (withdrawController
                                                                .selectedReasonRejection
                                                                .value ==
                                                                null) {
                                                              return; // اگر کاربر دلیل را انتخاب نکرد، عملیات لغو شود
                                                            }
                                                            await withdrawController
                                                                .updateStatusWithdraw(
                                                              withdraws.id!,
                                                              value,
                                                              withdrawController
                                                                  .selectedReasonRejection
                                                                  .value!.id!,
                                                            );
                                                          } else {
                                                            await withdrawController
                                                                .updateStatusWithdraw(
                                                                withdraws.id!,
                                                                value, 0);
                                                          }
                                                          withdrawController
                                                              .getWithdrawListPager();
                                                        },
                                                        shape: const RoundedRectangleBorder(
                                                          borderRadius: BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  10.0)),
                                                        ),
                                                        color: AppColor
                                                            .backGroundColor,
                                                        constraints: BoxConstraints(
                                                          minWidth: 70,
                                                          maxWidth: 70,
                                                        ),
                                                        position: PopupMenuPosition
                                                            .under,
                                                        offset: const Offset(
                                                            0, 0),
                                                        itemBuilder: (
                                                            context) =>
                                                        [
                                                          PopupMenuItem<int>(height: 18,
                                                            labelTextStyle: WidgetStateProperty
                                                                .all(
                                                                AppTextStyle
                                                                    .madiumbodyText
                                                            ),
                                                            value: 1,
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment
                                                                  .center,
                                                              children: [
                                                                withdrawController
                                                                    .isLoading
                                                                    .value
                                                                    ?
                                                                CircularProgressIndicator(
                                                                  valueColor: AlwaysStoppedAnimation<
                                                                      Color>(
                                                                      AppColor
                                                                          .textColor),
                                                                ) :
                                                                Text('تایید',
                                                                  style: AppTextStyle
                                                                      .madiumbodyText
                                                                      .copyWith(
                                                                      color: AppColor
                                                                          .primaryColor,
                                                                      fontSize: 14),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          const PopupMenuDivider(),
                                                          PopupMenuItem<int>(height: 18,
                                                            value: 2,
                                                            labelTextStyle: WidgetStateProperty
                                                                .all(
                                                                AppTextStyle
                                                                    .madiumbodyText
                                                            ),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment
                                                                  .center,
                                                              children: [
                                                                withdrawController
                                                                    .isLoading
                                                                    .value
                                                                    ?
                                                                CircularProgressIndicator(
                                                                  valueColor: AlwaysStoppedAnimation<
                                                                      Color>(
                                                                      AppColor
                                                                          .textColor),
                                                                ) :
                                                                Text('رد',
                                                                  style: AppTextStyle
                                                                      .madiumbodyText
                                                                      .copyWith(
                                                                      color: AppColor
                                                                          .accentColor,
                                                                      fontSize: 14),
                                                                ),
                                                              ],
                                                            ),
                                                            onTap: () async {

                                                              /*if (withdrawController.selectedReasonRejection.value != null) {
                                                                      await withdrawController.updateStatusWithdraw(withdraws.id!, 2,withdrawController.selectedReasonRejection.value?.id ?? 0);
                                                                    }*/
                                                            },
                                                          ),
                                                        ],
                                                        child: Text(
                                                          'تعیین وضعیت',
                                                          style: AppTextStyle
                                                              .bodyText
                                                              .copyWith(
                                                              decoration: TextDecoration
                                                                  .underline,
                                                              decorationColor: AppColor
                                                                  .textColor
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                            minVerticalPadding: 5,
                                          ),

                                          // لیست deposit request
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
                                                      withdrawController
                                                          .isLoadingDepositRequestList
                                                          .value ?
                                                      CircularProgressIndicator(
                                                        valueColor: AlwaysStoppedAnimation<
                                                            Color>(
                                                            AppColor.textColor),
                                                      ) : withdrawController
                                                          .depositRequestList
                                                          .isEmpty
                                                          ?
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment
                                                            .spaceBetween,
                                                        children: [
                                                          Text(
                                                              'هیچ شخصی جهت واریز مشخص نشده است',
                                                              style: AppTextStyle
                                                                  .labelText),
                                                          SizedBox(width: 125,),
                                                          Container(
                                                            width: 25,
                                                            height: 25,
                                                            child: GestureDetector(

                                                              onTap: () {
                                                                showModalBottomSheet(
                                                                  enableDrag: true,
                                                                  context: context,
                                                                  backgroundColor: AppColor
                                                                      .backGroundColor,
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius
                                                                        .vertical(
                                                                        top: Radius
                                                                            .circular(
                                                                            20)),
                                                                  ),
                                                                  builder: (
                                                                      context) {
                                                                    return InsertDepositRequestWidget(
                                                                        id: withdraws
                                                                            .id!);
                                                                  },
                                                                )
                                                                    .whenComplete(() {
                                                                  withdrawController
                                                                      .clearList();
                                                                }
                                                                );
                                                                withdrawController
                                                                    .filterAccountListFunc(
                                                                    withdraws
                                                                        .wallet!
                                                                        .account!
                                                                        .id!
                                                                        .toInt());
                                                              },
                                                              child: SvgPicture
                                                                  .asset(
                                                                  'assets/svg/add.svg',
                                                                  colorFilter: ColorFilter
                                                                      .mode(
                                                                    AppColor
                                                                        .buttonColor,
                                                                    BlendMode
                                                                        .srcIn,)
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                          :
                                                      // لیست deposit request مربوط به هر درخواست برداشت
                                                      Expanded(
                                                        child: ListView.builder(
                                                          shrinkWrap: true,
                                                          physics: ClampingScrollPhysics(),
                                                          itemCount: withdrawController
                                                              .depositRequestList
                                                              .length,
                                                          itemBuilder: (context,
                                                              index) {
                                                            var depositRequests = withdrawController
                                                                .depositRequestList[index];
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

                                                                      // تاریخ و وضعیت
                                                                      /*Row(
                                                                        mainAxisAlignment: MainAxisAlignment
                                                                            .spaceBetween,
                                                                        children: [
                                                                          Row(
                                                                            children: [
                                                                              Text(
                                                                                  'تاریخ:',
                                                                                  style: AppTextStyle
                                                                                      .bodyText),
                                                                              SizedBox(
                                                                                width: 4,),
                                                                              Text(
                                                                                depositRequests
                                                                                    .status ==
                                                                                    0
                                                                                    ?
                                                                                depositRequests
                                                                                    .date
                                                                                    ?.toPersianDate(
                                                                                    showTime: true,
                                                                                    twoDigits: true,
                                                                                    timeSeprator: '-') ??
                                                                                    ""
                                                                                    : depositRequests
                                                                                    .confirmDate
                                                                                    ?.toPersianDate(
                                                                                    showTime: true,
                                                                                    twoDigits: true,
                                                                                    timeSeprator: '-') ??
                                                                                    "",
                                                                                style: AppTextStyle
                                                                                    .bodyText,
                                                                              ),
                                                                            ],
                                                                          ),

                                                                          // وضعیت
                                                                          Card(
                                                                            shape: RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius
                                                                                  .circular(
                                                                                  5),
                                                                            ),
                                                                            color: depositRequests
                                                                                .status ==
                                                                                2
                                                                                ? AppColor
                                                                                .accentColor
                                                                                : depositRequests
                                                                                .status ==
                                                                                1
                                                                                ? AppColor
                                                                                .primaryColor
                                                                                : AppColor
                                                                                .secondaryColor
                                                                            ,
                                                                            margin: EdgeInsets
                                                                                .symmetric(
                                                                                vertical: 0,
                                                                                horizontal: 5),
                                                                            child: Padding(
                                                                              padding: const EdgeInsets
                                                                                  .all(
                                                                                  2),
                                                                              child: Text(
                                                                                  depositRequests
                                                                                      .status ==
                                                                                      2
                                                                                      ? 'تایید نشده'
                                                                                      : depositRequests
                                                                                      .status ==
                                                                                      1
                                                                                      ? 'تایید شده'
                                                                                      : 'نامشخص',
                                                                                  style: AppTextStyle
                                                                                      .labelText,
                                                                                  textAlign: TextAlign
                                                                                      .center),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      SizedBox(height: 5,),*/
                                                                      // نام کاربر و مبلغ کل
                                                                      Column(crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            depositRequests
                                                                                .account!
                                                                                .name ??
                                                                                "",
                                                                            style: AppTextStyle
                                                                                .bodyText,),
                                                                          SizedBox(height: 5,),
                                                                          Row(
                                                                            mainAxisAlignment: MainAxisAlignment
                                                                                .start,
                                                                            children: [
                                                                              Text(
                                                                                  'مبلغ کل:',
                                                                                  style: AppTextStyle
                                                                                      .bodyText),
                                                                              SizedBox(
                                                                                width: 4,),
                                                                              Text(
                                                                                "${depositRequests
                                                                                    .amount
                                                                                    ?.toInt()
                                                                                    .toString()
                                                                                    .seRagham(
                                                                                    separator: ',')} ریال",
                                                                                style: AppTextStyle
                                                                                    .bodyText,),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),

                                                                      SizedBox(
                                                                        height: 4,),

                                                                      // مبلغ واریز شده
                                                                      Row(
                                                                        children: [
                                                                          Text(
                                                                              'مبلغ واریز شده:',
                                                                              style: AppTextStyle
                                                                                  .bodyText),
                                                                          SizedBox(
                                                                            width: 4,),
                                                                          Text(
                                                                            "${depositRequests
                                                                                .paidAmount
                                                                                ?.toInt()
                                                                                .toString()
                                                                                .seRagham(
                                                                                separator: ',')} ریال",
                                                                            style: AppTextStyle
                                                                                .bodyText.copyWith(color: AppColor.primaryColor),),
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        height: 4,),

                                                                      // دلیل رد
                                                                      /*depositRequests
                                                                          .status ==
                                                                          2 ?
                                                                      Row(
                                                                        crossAxisAlignment: CrossAxisAlignment
                                                                            .center,
                                                                        children: [
                                                                          Text(
                                                                            'دلیل رد: ',
                                                                            style: AppTextStyle
                                                                                .labelText,),
                                                                          SizedBox(
                                                                            width: 3,),
                                                                          Text(
                                                                            "`${depositRequests
                                                                                .reasonRejection
                                                                                ?.name}`" ??
                                                                                "",
                                                                            style: AppTextStyle
                                                                                .bodyText,),
                                                                        ],
                                                                      ) : Text(""),*/
                                                                      //  تعیین وضعیت
                                                                      /*Container(
                                                                        alignment: Alignment
                                                                            .centerLeft,
                                                                        padding: const EdgeInsets
                                                                            .symmetric(
                                                                            horizontal: 0,
                                                                            vertical: 0),
                                                                        child: PopupMenuButton<
                                                                            int>(
                                                                          splashRadius: 10,
                                                                          tooltip: 'تعیین وضعیت',
                                                                          onSelected: (
                                                                              value) async {
                                                                            if (value ==
                                                                                2) {
                                                                              await withdrawController
                                                                                  .showReasonRejectionDialog(
                                                                                  "DepositRequest");
                                                                              if (withdrawController
                                                                                  .selectedReasonRejection
                                                                                  .value ==
                                                                                  null) {
                                                                                return; // اگر کاربر دلیل را انتخاب نکرد، عملیات لغو شود
                                                                              }
                                                                              await withdrawController
                                                                                  .updateStatusDepositRequest(
                                                                                depositRequests
                                                                                    .id!,
                                                                                value,
                                                                                withdrawController
                                                                                    .selectedReasonRejection
                                                                                    .value!
                                                                                    .id!,
                                                                              );
                                                                            } else {
                                                                              await withdrawController
                                                                                  .updateStatusDepositRequest(
                                                                                  depositRequests
                                                                                      .id!,
                                                                                  value,
                                                                                  0);
                                                                            }
                                                                            withdrawController
                                                                                .fetchDepositRequestList(
                                                                                withdraws
                                                                                    .id!);
                                                                          },
                                                                          shape: const RoundedRectangleBorder(
                                                                            borderRadius: BorderRadius
                                                                                .all(
                                                                                Radius
                                                                                    .circular(
                                                                                    10.0)),
                                                                          ),
                                                                          color: AppColor
                                                                              .backGroundColor,
                                                                          constraints: BoxConstraints(
                                                                            minWidth: 70,
                                                                            maxWidth: 70,
                                                                          ),
                                                                          position: PopupMenuPosition
                                                                              .under,
                                                                          offset: const Offset(
                                                                              0,
                                                                              0),
                                                                          itemBuilder: (
                                                                              context) =>
                                                                          [
                                                                            PopupMenuItem<
                                                                                int>(height: 18,
                                                                              labelTextStyle: WidgetStateProperty
                                                                                  .all(
                                                                                  AppTextStyle
                                                                                      .madiumbodyText
                                                                              ),
                                                                              value: 1,
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment
                                                                                    .center,
                                                                                children: [
                                                                                  withdrawController
                                                                                      .isLoading
                                                                                      .value
                                                                                      ?
                                                                                  CircularProgressIndicator(
                                                                                    valueColor: AlwaysStoppedAnimation<
                                                                                        Color>(
                                                                                        AppColor
                                                                                            .textColor),
                                                                                  )
                                                                                      :
                                                                                  Text(
                                                                                    'تایید',
                                                                                    style: AppTextStyle
                                                                                        .madiumbodyText
                                                                                        .copyWith(
                                                                                        color: AppColor
                                                                                            .primaryColor,
                                                                                        fontSize: 14),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            const PopupMenuDivider(),
                                                                            PopupMenuItem<
                                                                                int>(height: 18,
                                                                              value: 2,
                                                                              labelTextStyle: WidgetStateProperty
                                                                                  .all(
                                                                                  AppTextStyle
                                                                                      .madiumbodyText
                                                                              ),
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment
                                                                                    .center,
                                                                                children: [
                                                                                  withdrawController
                                                                                      .isLoading
                                                                                      .value
                                                                                      ?
                                                                                  CircularProgressIndicator(
                                                                                    valueColor: AlwaysStoppedAnimation<
                                                                                        Color>(
                                                                                        AppColor
                                                                                            .textColor),
                                                                                  )
                                                                                      :
                                                                                  Text(
                                                                                    'رد',
                                                                                    style: AppTextStyle
                                                                                        .madiumbodyText
                                                                                        .copyWith(
                                                                                        color: AppColor
                                                                                            .accentColor,
                                                                                        fontSize: 14),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ],
                                                                          child: Text(
                                                                            'تعیین وضعیت',
                                                                            style: AppTextStyle
                                                                                .bodyText
                                                                                .copyWith(
                                                                                decoration: TextDecoration
                                                                                    .underline,
                                                                                decorationColor: AppColor
                                                                                    .textColor
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),*/

                                                                      SizedBox(
                                                                        height: 4,),
                                                                      Divider(
                                                                        height: 1,
                                                                        color: AppColor
                                                                            .secondaryColor,),
                                                                      SizedBox(
                                                                        height: 5,),

                                                                      // دکمه های مربوط به عملیات اضافه-حذف-مشاهده و ویرایش
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment
                                                                            .spaceBetween,
                                                                        children: [
                                                                          // آیکون اضافه کردن
                                                                          Container(
                                                                            width: 25,
                                                                            height: 25,
                                                                            child:
                                                                            GestureDetector(
                                                                              onTap: () {
                                                                                if ( depositRequests.paidAmount! < depositRequests.amount!) {
                                                                                  Get.toNamed(
                                                                                      '/depositCreate', arguments: depositRequests);
                                                                                } else {
                                                                                  Get
                                                                                      .defaultDialog(
                                                                                    title: 'هشدار',
                                                                                    middleText: 'مبلغ باقیمانده برای واریزی صفر است.',
                                                                                    titleStyle: AppTextStyle
                                                                                        .smallTitleText,
                                                                                    middleTextStyle: AppTextStyle
                                                                                        .bodyText,
                                                                                    backgroundColor: AppColor
                                                                                        .backGroundColor,
                                                                                    textCancel: 'بستن',
                                                                                  );
                                                                                }
                                                                              },
                                                                              child: SvgPicture
                                                                                  .asset(
                                                                                  'assets/svg/add.svg',
                                                                                  colorFilter: ColorFilter
                                                                                      .mode(
                                                                                    AppColor
                                                                                        .buttonColor,
                                                                                    BlendMode
                                                                                        .srcIn,)
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          // آیکون حذف کردن
                                                                          Container(
                                                                            width: 25,
                                                                            height: 25,
                                                                            child: GestureDetector(
                                                                              onTap: () {
                                                                                if (depositRequests.depositCount != 0) {
                                                                                  Get
                                                                                      .defaultDialog(
                                                                                    title: 'هشدار',
                                                                                    middleText: 'به دلیل داشتن زیر مجموعه قابل حذف نیست',
                                                                                    titleStyle: AppTextStyle
                                                                                        .smallTitleText,
                                                                                    middleTextStyle: AppTextStyle
                                                                                        .bodyText,
                                                                                    backgroundColor: AppColor
                                                                                        .backGroundColor,
                                                                                    textCancel: 'بستن',
                                                                                  );
                                                                                } else {
                                                                                  Get
                                                                                      .defaultDialog(
                                                                                      backgroundColor: AppColor
                                                                                          .backGroundColor,
                                                                                      title: "حذف درخواست واریزی",
                                                                                      titleStyle: AppTextStyle
                                                                                          .smallTitleText,
                                                                                      middleText: "آیا از حذف درخواست واریزی مطمئن هستید؟",
                                                                                      middleTextStyle: AppTextStyle
                                                                                          .bodyText,
                                                                                      confirm: ElevatedButton(
                                                                                          style: ButtonStyle(
                                                                                              backgroundColor: WidgetStatePropertyAll(
                                                                                                  AppColor
                                                                                                      .primaryColor)),
                                                                                          onPressed: () {
                                                                                            Get
                                                                                                .back();
                                                                                            withdrawController.deleteDepositRequest(withdraws.id!,depositRequests.id!, true);
                                                                                            //withdrawController.fetchWithdrawList();
                                                                                          },
                                                                                          child: Text(
                                                                                            'حذف',
                                                                                            style: AppTextStyle
                                                                                                .bodyText,
                                                                                          )));
                                                                                  //withdrawController.fetchWithdrawList();
                                                                                }
                                                                              },
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
                                                                          ),
                                                                          // آیکون مشاهده
                                                                          Container(
                                                                            width: 25,
                                                                            height: 25,
                                                                            child: GestureDetector(
                                                                              onTap: () {
                                                                                Get.toNamed('/depositRequestGetOne', parameters:{"id":depositRequests.id.toString()});
                                                                              },
                                                                              child: SvgPicture
                                                                                  .asset(
                                                                                  'assets/svg/eye1.svg',
                                                                                  colorFilter: ColorFilter
                                                                                      .mode(
                                                                                    AppColor
                                                                                        .iconViewColor,
                                                                                    BlendMode
                                                                                        .srcIn,)
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          // آیکون ویرایش
                                                                          Container(
                                                                            width: 25,
                                                                            height: 25,
                                                                            child: GestureDetector(
                                                                              onTap: () {
                                                                                /*if (withdraws.depositCount != 0) {
                                                                                  Get
                                                                                      .defaultDialog(
                                                                                    title: 'هشدار',
                                                                                    middleText: 'به دلیل داشتن زیر مجموعه قابل ویرایش نیست',
                                                                                    titleStyle: AppTextStyle
                                                                                        .smallTitleText,
                                                                                    middleTextStyle: AppTextStyle
                                                                                        .bodyText,
                                                                                    backgroundColor: AppColor
                                                                                        .backGroundColor,
                                                                                    textCancel: 'بستن',
                                                                                  );
                                                                                } else {*/
                                                                                withdrawController.setDepositRequestDetail(depositRequests);
                                                                                showModalBottomSheet(
                                                                                  enableDrag: true,
                                                                                  context: context,
                                                                                  backgroundColor: AppColor
                                                                                      .backGroundColor,
                                                                                  shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius
                                                                                        .vertical(
                                                                                        top: Radius
                                                                                            .circular(
                                                                                            20)),
                                                                                  ),
                                                                                  builder: (
                                                                                      context) {
                                                                                    return UpdateDepositRequestWidget(
                                                                                      withdrawId: withdraws
                                                                                          .id!,
                                                                                      depositRequest: depositRequests,
                                                                                    );
                                                                                  },
                                                                                )
                                                                                    .whenComplete(() {
                                                                                  withdrawController
                                                                                      .clearList();
                                                                                });
                                                                                // }
                                                                              },
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
                                                ],
                                              ),
                                            )
                                                : SizedBox.shrink(),
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
                          withdrawController.clearFilter();
                          withdrawController.getWithdrawListPager();
                        },
                        title: "خطا در دریافت لیست درخواست ها",
                        des: 'برای دریافت درخواست ها مجددا تلاش کنید',
                      );
                    },
                    )
                  ],
                ),
              ),
            ),
          ),
          Obx(()=>Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              withdrawController.paginated.value!=null?   Container(
                  height: 70,
                  margin: EdgeInsets.symmetric(horizontal: 70,vertical: 10),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  color: AppColor.appBarColor.withOpacity(0.5),
                  alignment: Alignment.bottomCenter,
                  child:PagerWidget(countPage: withdrawController.paginated.value?.totalCount??0, callBack: (int index) {
                    withdrawController.isChangePage(index);
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
                itemCount: withdrawController.searchedAccounts.length,
                itemBuilder: (context, index) {
                  final account = withdrawController.searchedAccounts[index];
                  return ListTile(
                    title: Text(account.name ?? '',
                      style: AppTextStyle.bodyText.copyWith(fontSize: 15),),
                    onTap: () => withdrawController.selectAccount(account),
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
          child: Text('تاریخ تراکنش', style: AppTextStyle.labelText)),
          headingRowAlignment:MainAxisAlignment.center,
        onSort: (columnIndex, ascending) {
          withdrawController.onSort(columnIndex, ascending);
        },
      ),
      /*DataColumn(label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
          child: Text('تاریخ', style: AppTextStyle.labelText)),headingRowAlignment:MainAxisAlignment.center ),*/
      DataColumn(label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
          child: Text('نام کاربر', style: AppTextStyle.labelText)),headingRowAlignment:MainAxisAlignment.center ),
      DataColumn(label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
          child: Text('دارنده حساب', style: AppTextStyle.labelText)),headingRowAlignment:MainAxisAlignment.center ),
      DataColumn(label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
          child: Text('مبلغ کل', style: AppTextStyle.labelText)),headingRowAlignment:MainAxisAlignment.center ),
      DataColumn(label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
          child: Text('مبلغ مانده', style: AppTextStyle.labelText)),headingRowAlignment:MainAxisAlignment.center ),
      DataColumn(label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
          child: Text('مبلغ واریز شده', style: AppTextStyle.labelText)),headingRowAlignment:MainAxisAlignment.center ),
      /*DataColumn(label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
          child: Text('مبلغ تایید نشده', style: AppTextStyle.labelText)),headingRowAlignment:MainAxisAlignment.center ),*/
      DataColumn(label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
          child: Text('وضعیت', style: AppTextStyle.labelText)),headingRowAlignment:MainAxisAlignment.center ),
      DataColumn(label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
          child: Text('درخواست ها', style: AppTextStyle.labelText)),headingRowAlignment:MainAxisAlignment.center ),
      DataColumn(label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
          child: Text('عملیات', style: AppTextStyle.labelText)),headingRowAlignment:MainAxisAlignment.center ),
    ];
  }

  List<DataRow> buildDataRows(BuildContext context) {
    final groupedWithdraws = groupWithdrawsByDate(withdrawController.withdrawList);
    final rows = <DataRow>[];
    groupedWithdraws.forEach((date, withdraws) {
      rows.add(
        DataRow(
          color: WidgetStatePropertyAll(AppColor.primaryColor.withOpacity(0.2)),
          cells: [
            DataCell(SizedBox.shrink()),
            DataCell(
              Column(
                children: [
                  Center(
                    child: Column(
                      children: [
                        Text(date,
                          style: AppTextStyle.bodyText.copyWith(
                            color: AppColor.dividerColor,
                          ),
                        ),
                        Text(withdraws.first.dateMiladiToString ?? "",
                          style: AppTextStyle.bodyText.copyWith(
                            color: AppColor.dividerColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            DataCell(
                Text("( ${withdraws.first.totalAmountPerDay.toString().seRagham(separator: ',')} )",
                  style: AppTextStyle.bodyText.copyWith(color: AppColor.accentColor,fontWeight: FontWeight.bold),
                ),
            ),
            DataCell(
              Text("( ${withdraws.first.totalPaidAmountPerDay.toString().seRagham(separator: ',')} )",
                style: AppTextStyle.bodyText.copyWith(color: AppColor.primaryColor,fontWeight: FontWeight.bold),
              ),
            ),
            DataCell(SizedBox.shrink()),
            DataCell(SizedBox.shrink()),
            DataCell(SizedBox.shrink()),
            DataCell(SizedBox.shrink()),
            DataCell(SizedBox.shrink()),
            DataCell(SizedBox.shrink()),
          ],
        ),
      );
      for (final withdraw in withdraws) {
        final index=withdrawController.withdrawList.indexOf(withdraw);
        final isExpanded = withdrawController.isItemExpanded(index);
        rows.add(
          DataRow(
            color: WidgetStatePropertyAll(
                isExpanded
                    ? AppColor.backGroundColor1.withOpacity(0.5)
                    : AppColor.appBarColor.withOpacity(0.5)
            ),

            cells: [
              // ردیف
              DataCell(
                  Center(
                    child: Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            withdrawController.captureRowScreenshot(withdraw, _dataTableKey, _rowKeys);
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
                        Text(
                          "${withdraw.rowNum}",
                          style: AppTextStyle.labelText,
                        ),
                      ],
                    ),
                  )),
              // تاریخ تراکنش
              DataCell(
                  Center(
                    child: Row(
                      children: [
                        Text(
                          //withdraw.status == 0 ?
                               withdraw.requestDate?.toPersianDate(twoDigits: true, showTime: true, timeSeprator: '-') ?? 'نامشخص',
                              //: withdraw.confirmDate?.toPersianDate(twoDigits: true, showTime: true, timeSeprator: '-') ?? 'نامشخص',
                          style: AppTextStyle.bodyText,
                        ),
                        SizedBox(width: 8,),
                        GestureDetector(
                          onTap: () {
                            withdrawController.updateRequestDateWithdraw(withdraw.id ?? 0);
                          },
                            child: SvgPicture.asset('assets/svg/arrow.svg',colorFilter: ColorFilter.mode(AppColor.dividerColor, BlendMode.srcIn),),
                        ),
                      ],
                    ),
                  )),
              // تاریخ
              /*DataCell(
                  Center(
                    child: Text(
                      withdraw.status == 0
                          ? withdraw.requestDate?.toPersianDate(twoDigits: true, showTime: true, timeSeprator: '-') ?? 'نامشخص'
                          : withdraw.confirmDate?.toPersianDate(twoDigits: true, showTime: true, timeSeprator: '-') ?? 'نامشخص',
                      style: AppTextStyle.bodyText,
                    ),
                  )),*/
              // نام کاربر
              DataCell(
                  Center(
                    child: Text(withdraw.wallet?.account?.name ?? "",
                        style: AppTextStyle.bodyText),
                  )),
              // دارنده حساب
              DataCell(
                  Center(
                    child: Text(
                        "${withdraw.ownerName ?? ""} (${withdraw.bank?.name ?? ""})", style: AppTextStyle.bodyText),
                  )),
              // مبلغ کل
              DataCell(
                  Center(
                    child: Text(
                        "${withdraw.amount?.toInt().toString().seRagham(separator: ',')} ریال",
                        style: AppTextStyle.bodyText
                    ),
                  )),
              // مبلغ مانده
              DataCell(
                  Center(
                    child: Text(
                      "${withdraw.undividedAmount?.toInt().toString().seRagham(separator: ',')} ریال",
                      style: AppTextStyle.bodyText,),
                  )),
              // مبلغ واریز شده
              DataCell(
                  Center(
                    child: Text(
                      "${withdraw.paidAmount?.toInt().toString().seRagham(separator: ',')} ریال",
                      style: AppTextStyle.bodyText,),
                  )),
              // مبلغ تایید نشده
              /*DataCell(
              Center(
                child: Text(
                "${withdraw.notConfirmedAmount?.toInt().toString().seRagham(separator: ',')} ریال",
                style: AppTextStyle.bodyText
                          ),
              )),*/
              // وضعیت
              DataCell(
                Center(
                  child: Column(
                    key: _rowKeys[withdraw.id],
                    children: [
                      SizedBox(height: 5,),
                      Text(
                        '${withdraw.status == 0 ? 'نامشخص' : withdraw.status == 1
                            ? 'تایید شده'
                            : 'تایید نشده'} ',
                        style: AppTextStyle
                            .bodyText.copyWith(
                          color: withdraw.status == 1
                              ? AppColor.primaryColor
                              : withdraw.status == 2
                              ? AppColor.accentColor
                              : AppColor.textColor,
                        ),
                      ),
                      SizedBox(height: 6,),
                      Container(
                        padding: const EdgeInsets
                            .symmetric(
                            horizontal: 0,
                            vertical: 0),
                        child: PopupMenuButton<
                            int>(
                          splashRadius: 10,
                          tooltip: 'تعیین وضعیت',
                          onSelected: (
                              value) async {
                            if (value == 2) {
                              await withdrawController
                                  .showReasonRejectionDialog(
                                  "WithdrawRequest");
                              if (withdrawController
                                  .selectedReasonRejection
                                  .value ==
                                  null) {
                                return; // اگر کاربر دلیل را انتخاب نکرد، عملیات لغو شود
                              }
                              await withdrawController
                                  .updateStatusWithdraw(
                                withdraw.id!,
                                value,
                                withdrawController
                                    .selectedReasonRejection
                                    .value!.id!,
                              );
                            } else {
                              await withdrawController
                                  .updateStatusWithdraw(
                                  withdraw.id!,
                                  value, 0);
                            }
                            withdrawController
                                .getWithdrawListPager();
                          },
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius
                                .all(
                                Radius.circular(
                                    10.0)),
                          ),
                          color: AppColor
                              .backGroundColor,
                          constraints: BoxConstraints(
                            minWidth: 70,
                            maxWidth: 70,
                          ),
                          position: PopupMenuPosition
                              .under,
                          offset: const Offset(
                              0, 0),
                          itemBuilder: (
                              context) =>
                          [
                            PopupMenuItem<int>(height: 18,
                              labelTextStyle: WidgetStateProperty
                                  .all(
                                  AppTextStyle
                                      .madiumbodyText
                              ),
                              value: 1,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .center,
                                children: [
                                  withdrawController
                                      .isLoading
                                      .value
                                      ?
                                  CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<
                                        Color>(
                                        AppColor
                                            .textColor),
                                  ) :
                                  Text('تایید',
                                    style: AppTextStyle
                                        .madiumbodyText
                                        .copyWith(
                                        color: AppColor
                                            .primaryColor,
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                            const PopupMenuDivider(),
                            PopupMenuItem<int>(height: 18,
                              value: 2,
                              labelTextStyle: WidgetStateProperty
                                  .all(
                                  AppTextStyle
                                      .madiumbodyText
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .center,
                                children: [
                                  withdrawController
                                      .isLoading
                                      .value
                                      ?
                                  CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<
                                        Color>(
                                        AppColor
                                            .textColor),
                                  ) :
                                  Text('رد',
                                    style: AppTextStyle
                                        .madiumbodyText
                                        .copyWith(
                                        color: AppColor
                                            .accentColor,
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                              onTap: () async {

                                /*if (withdrawController.selectedReasonRejection.value != null) {
                                                                        await withdrawController.updateStatusWithdraw(withdraws.id!, 2,withdrawController.selectedReasonRejection.value?.id ?? 0);
                                                                      }*/
                              },
                            ),
                          ],
                          child: Text(
                            'تعیین وضعیت',
                            style: AppTextStyle
                                .bodyText
                                .copyWith(
                                decoration: TextDecoration
                                    .underline,
                                decorationColor: AppColor
                                    .textColor
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 6,),
                      withdraw.status == 2 ?
                      Wrap(
                        children: [
                          Text('به دلیل ',
                            style: AppTextStyle
                                .labelText,),
                          Text("`${withdraw
                              .reasonRejection
                              ?.name}`",
                            style: AppTextStyle
                                .bodyText,),
                          Text('رد شد.',
                            style: AppTextStyle
                                .labelText,),
                        ],
                      ) : Text(""),
                    ],
                  ),
                ),
              ),
              // نمایش درخواست های واریزی
              DataCell(
                Center(
                  child: IconButton(
                    icon: Icon(
                        isExpanded ? Icons.expand_less : Icons.expand_more),
                    color: isExpanded ? AppColor.accentColor : AppColor.primaryColor,
                    onPressed: () {
                      final index = withdrawController.withdrawList.indexOf(withdraw);
                      withdrawController.expandAndScrollHorizontal(index, withdraw.id!);
                    },
                  ),
                ),
              ),
              // آیکون های عملیات
              DataCell(
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: Column(
                   // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // آیکون تقسیم و حذف
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // آیکون تقسیم
                          GestureDetector(
                            onTap: () {
                              if (withdraw.undividedAmount==0) {
                                Get.defaultDialog(
                                  title: 'هشدار',
                                  middleText: 'مبلغ باقیمانده برای تقسیم صفر است',
                                  titleStyle: AppTextStyle
                                      .smallTitleText,
                                  middleTextStyle: AppTextStyle
                                      .bodyText,
                                  backgroundColor: AppColor
                                      .backGroundColor,
                                  textCancel: 'بستن',
                                );
                              } else {
                                withdrawController.balanceList.clear();
                                showModalBottomSheet(
                                  enableDrag: true,
                                  context: context,
                                  backgroundColor: AppColor
                                      .backGroundColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius
                                        .vertical(top: Radius
                                        .circular(20)),
                                  ),
                                  builder: (context) {
                                    return InsertDepositRequestWidget(id: withdraw.id!, walletId: withdraw
                                        .wallet!
                                        .id!,);
                                  },
                                ).whenComplete(() {
                                  withdrawController
                                      .clearList();
                                }
                                );
                                withdrawController
                                    .filterAccountListFunc(
                                    withdraw.wallet!
                                        .account!.id!
                                        .toInt());
                              }
                            },
                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SvgPicture.asset(
                                    'assets/svg/add.svg',width: 20,height: 20,
                                    colorFilter: ColorFilter
                                        .mode(AppColor
                                        .buttonColor,
                                      BlendMode
                                          .srcIn,)
                                ),
                                Text(' تقسیم',
                                  style: AppTextStyle
                                      .bodyText
                                      .copyWith(
                                      color: AppColor
                                          .buttonColor,fontSize: 12),),
                              ],
                            ),
                          ),
                          // آیکون حذف کردن
                          GestureDetector(
                            onTap: () {
                              if (withdraw.depositRequestCount != 0 || withdraw.depositCount != 0) {
                                Get.defaultDialog(
                                  title: 'هشدار',
                                  middleText: 'به دلیل داشتن زیر مجموعه قابل حذف نیست',
                                  titleStyle: AppTextStyle
                                      .smallTitleText,
                                  middleTextStyle: AppTextStyle
                                      .bodyText,
                                  backgroundColor: AppColor
                                      .backGroundColor,
                                  textCancel: 'بستن',
                                );
                              } else {
                                Get.defaultDialog(
                                    backgroundColor: AppColor
                                        .backGroundColor,
                                    title: "حذف درخواست برداشت",
                                    titleStyle: AppTextStyle
                                        .smallTitleText,
                                    middleText: "آیا از حذف درخواست برداشت مطمئن هستید؟",
                                    middleTextStyle: AppTextStyle
                                        .bodyText,
                                    confirm: ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor: WidgetStatePropertyAll(
                                                AppColor
                                                    .primaryColor)),
                                        onPressed: () {
                                          Get.back();
                                          withdrawController.deleteWithdraw(withdraw.id!, true);
                                        },
                                        child: Text(
                                          'حذف',
                                          style: AppTextStyle
                                              .bodyText,
                                        )));
                                //withdrawController.fetchWithdrawList();
                              }
                            },
                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SvgPicture.asset(
                                    'assets/svg/trash-bin.svg',width: 20,height: 20,
                                    colorFilter: ColorFilter
                                        .mode(AppColor
                                        .accentColor,
                                      BlendMode
                                          .srcIn,)
                                ),
                                Text(' حذف',
                                  style: AppTextStyle
                                      .bodyText
                                      .copyWith(
                                      color: AppColor
                                          .accentColor,fontSize: 12),),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 10,),
                      // آیکون مشاهده و ویرایش
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // آیکون مشاهده
                          GestureDetector(
                            onTap: () {
                              Get.toNamed('/withdrawGetOne', parameters:{"id":withdraw.id.toString()});
                              //print(withdraws.id);
                            },
                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SvgPicture.asset(
                                    'assets/svg/eye1.svg',width: 20,height: 20,
                                    colorFilter: ColorFilter
                                        .mode(AppColor
                                        .iconViewColor,
                                      BlendMode
                                          .srcIn,)
                                ),
                                Text(' مشاهده',
                                  style: AppTextStyle
                                      .bodyText
                                      .copyWith(
                                      color: AppColor
                                          .iconViewColor,fontSize: 12),),
                              ],
                            ),
                          ),
                          SizedBox(width: 10,),
                          // آیکون ویرایش
                          GestureDetector(
                            onTap: () {
                              /*if (withdraw.depositRequestCount != 0 || withdraw.depositCount != 0) {
                            Get.defaultDialog(
                              title: 'هشدار',
                              middleText: 'به دلیل داشتن زیر مجموعه قابل ویرایش نیست',
                              titleStyle: AppTextStyle
                                  .smallTitleText,
                              middleTextStyle: AppTextStyle
                                  .bodyText,
                              backgroundColor: AppColor
                                  .backGroundColor,
                              textCancel: 'بستن',
                            );
                          } else {*/
                              Get.toNamed('/withdrawUpdate',parameters:{"id":withdraw.id.toString()});
                              //}
                            },
                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SvgPicture.asset(
                                    'assets/svg/edit.svg',width: 20,height: 20,
                                    colorFilter: ColorFilter
                                        .mode(AppColor
                                        .iconViewColor,
                                      BlendMode
                                          .srcIn,)
                                ),
                                Text(' ویرایش',
                                  style: AppTextStyle
                                      .bodyText
                                      .copyWith(
                                      color: AppColor
                                          .iconViewColor,fontSize: 12),),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }
    }
    );
    return rows;
  }

  Widget buildExpandedContent(WithdrawModel withdraw) {
    return Obx(() {
      return AnimatedSize(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: withdrawController.isItemExpanded(
            withdrawController.withdrawList.indexOf(withdraw))
            ? buildDepositRequestsTable(withdraw)
            : SizedBox.shrink(),
      );
    });
  }

  Widget buildDepositRequestsTable(WithdrawModel withdraw) {
    return Obx(() {
      if (withdrawController.isLoadingDepositRequestList.value) {
        return SizedBox(width: 300,
            child: Center(child: CircularProgressIndicator()));
      }
      return
        withdrawController.isLoadingDepositRequestList.value ?
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<
              Color>(
              AppColor.textColor),
        ) :
        withdrawController.depositRequestList.isEmpty ?
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment
                .spaceBetween,
            children: [
              Text(
                  'هیچ شخصی جهت واریز مشخص نشده است', style: AppTextStyle.smallTitleText),
              SizedBox(width: 125,),
            ],
          ),
        ) :
        // لیست deposit request مربوط به هر درخواست برداشت
        SingleChildScrollView(
          child: Column(
            children: [
              Text('لیست درخواست‌های واریز', style: AppTextStyle.smallTitleText),
              SizedBox(
                width: Get.width*0.2,
                height: Get.height,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: withdrawController
                      .depositRequestList
                      .length,
                  itemBuilder: (context,
                      index) {
                    var depositRequests = withdrawController
                        .depositRequestList[index];
                    return
                      ListTile(
                        title: Card(
                          color: AppColor.backGroundColor1,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 5, left: 12, right: 12,bottom: 5),
                            child: Column(
                              children: [

                                // تاریخ و وضعیت
                                /*Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                            'تاریخ:',
                                            style: AppTextStyle
                                                .bodyText),
                                        SizedBox(
                                          width: 4,),
                                        Text(
                                          depositRequests
                                              .status ==
                                              0
                                              ?
                                          depositRequests
                                              .date
                                              ?.toPersianDate(
                                              showTime: true,
                                              twoDigits: true,
                                              timeSeprator: '-') ??
                                              ""
                                              : depositRequests
                                              .confirmDate
                                              ?.toPersianDate(
                                              showTime: true,
                                              twoDigits: true,
                                              timeSeprator: '-') ??
                                              "",
                                          style: AppTextStyle
                                              .bodyText,
                                        ),
                                      ],
                                    ),

                                    // وضعیت
                                    Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius
                                            .circular(
                                            5),
                                      ),
                                      color: depositRequests
                                          .status ==
                                          2
                                          ? AppColor
                                          .accentColor
                                          : depositRequests
                                          .status ==
                                          1
                                          ? AppColor
                                          .primaryColor
                                          : AppColor
                                          .secondaryColor
                                      ,
                                      margin: EdgeInsets
                                          .symmetric(
                                          vertical: 0,
                                          horizontal: 5),
                                      child: Padding(
                                        padding: const EdgeInsets
                                            .all(
                                            2),
                                        child: Text(
                                            depositRequests
                                                .status ==
                                                2
                                                ? 'تایید نشده'
                                                : depositRequests
                                                .status ==
                                                1
                                                ? 'تایید شده'
                                                : 'نامشخص',
                                            style: AppTextStyle
                                                .labelText,
                                            textAlign: TextAlign
                                                .center),
                                      ),
                                    ),
                                  ],
                                ),*/
                                SizedBox(
                                  height: 5,),
                                // نام کاربر
                                Row(
                                  children: [
                                    Text(
                                      depositRequests
                                          .account!
                                          .name ??
                                          "",
                                      style: AppTextStyle
                                          .bodyText,),
                                  ],
                                ),

                                SizedBox(
                                  height: 4,),
                                // مبلغ کل
                                Row(
                                  children: [
                                    Text(
                                        'مبلغ کل:',
                                        style: AppTextStyle
                                            .bodyText),
                                    SizedBox(
                                      width: 4,),

                                    Text(
                                      "${depositRequests
                                          .amount
                                          ?.toInt()
                                          .toString()
                                          .seRagham(
                                          separator: ',')} ریال",
                                      style: AppTextStyle
                                          .bodyText,),
                                  ],
                                ),
                                SizedBox(height: 4,),
                                // مبلغ مانده
                                Row(
                                  children: [
                                    Text(
                                        'مبلغ مانده:',
                                        style: AppTextStyle
                                            .bodyText),
                                    SizedBox(
                                      width: 4,),

                                    Text(
                                      "${depositRequests.notPaidAmount
                                          ?.toInt()
                                          .toString()
                                          .seRagham(
                                          separator: ',')} ریال",
                                      style: AppTextStyle
                                          .bodyText.copyWith(color: AppColor.accentColor),),
                                  ],
                                ),
                                SizedBox(height: 4,),
                                // مبلغ واریز شده
                                Row(
                                  children: [
                                    Text(
                                        'مبلغ واریز شده:',
                                        style: AppTextStyle
                                            .bodyText),
                                    SizedBox(
                                      width: 4,),
                                    Text(
                                      "${depositRequests
                                          .paidAmount
                                          ?.toInt()
                                          .toString()
                                          .seRagham(
                                          separator: ',')} ریال",
                                      style: AppTextStyle
                                          .bodyText.copyWith(color: AppColor.primaryColor),),
                                  ],
                                ),
                                SizedBox(height: 4,),

                                // دلیل رد
                                /* depositRequests
                                    .status ==
                                    2 ?
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment
                                      .center,
                                  children: [
                                    Text(
                                      'دلیل رد: ',
                                      style: AppTextStyle
                                          .labelText,),
                                    SizedBox(
                                      width: 3,),
                                    Text(
                                      "`${depositRequests
                                          .reasonRejection
                                          ?.name}`" ??
                                          "",
                                      style: AppTextStyle
                                          .bodyText,),
                                  ],
                                ) :
                                Text(""),*/
                                //  تعیین وضعیت
                                /*Container(
                                  alignment: Alignment
                                      .centerLeft,
                                  padding: const EdgeInsets
                                      .symmetric(
                                      horizontal: 0,
                                      vertical: 0),
                                  child: PopupMenuButton<
                                      int>(
                                    splashRadius: 10,
                                    tooltip: 'تعیین وضعیت',
                                    onSelected: (
                                        value) async {
                                      if (value ==
                                          2) {
                                        await withdrawController
                                            .showReasonRejectionDialog(
                                            "DepositRequest");
                                        if (withdrawController
                                            .selectedReasonRejection
                                            .value ==
                                            null) {
                                          return; // اگر کاربر دلیل را انتخاب نکرد، عملیات لغو شود
                                        }
                                        await withdrawController
                                            .updateStatusDepositRequest(
                                          depositRequests
                                              .id!,
                                          value,
                                          withdrawController
                                              .selectedReasonRejection
                                              .value!
                                              .id!,
                                        );
                                      } else {
                                        await withdrawController
                                            .updateStatusDepositRequest(
                                            depositRequests
                                                .id!,
                                            value,
                                            0);
                                      }
                                      withdrawController
                                          .fetchDepositRequestList(
                                          withdraw
                                              .id!);
                                    },
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius
                                          .all(
                                          Radius
                                              .circular(
                                              10.0)),
                                    ),
                                    color: AppColor
                                        .backGroundColor,
                                    constraints: BoxConstraints(
                                      minWidth: 70,
                                      maxWidth: 70,
                                    ),
                                    position: PopupMenuPosition
                                        .under,
                                    offset: const Offset(
                                        0,
                                        0),
                                    itemBuilder: (
                                        context) =>
                                    [
                                      PopupMenuItem<
                                          int>(height: 18,
                                        labelTextStyle: WidgetStateProperty
                                            .all(
                                            AppTextStyle
                                                .madiumbodyText
                                        ),
                                        value: 1,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .center,
                                          children: [
                                            withdrawController
                                                .isLoading
                                                .value
                                                ?
                                            CircularProgressIndicator(
                                              valueColor: AlwaysStoppedAnimation<
                                                  Color>(
                                                  AppColor
                                                      .textColor),
                                            )
                                                :
                                            Text(
                                              'تایید',
                                              style: AppTextStyle
                                                  .madiumbodyText
                                                  .copyWith(
                                                  color: AppColor
                                                      .primaryColor,
                                                  fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const PopupMenuDivider(),
                                      PopupMenuItem<
                                          int>(height: 18,
                                        value: 2,
                                        labelTextStyle: WidgetStateProperty
                                            .all(
                                            AppTextStyle
                                                .madiumbodyText
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .center,
                                          children: [
                                            withdrawController
                                                .isLoading
                                                .value
                                                ?
                                            CircularProgressIndicator(
                                              valueColor: AlwaysStoppedAnimation<
                                                  Color>(
                                                  AppColor
                                                      .textColor),
                                            )
                                                :
                                            Text(
                                              'رد',
                                              style: AppTextStyle
                                                  .madiumbodyText
                                                  .copyWith(
                                                  color: AppColor
                                                      .accentColor,
                                                  fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                    child: Text(
                                      'تعیین وضعیت',
                                      style: AppTextStyle
                                          .bodyText
                                          .copyWith(
                                          decoration: TextDecoration
                                              .underline,
                                          decorationColor: AppColor
                                              .textColor
                                      ),
                                    ),
                                  ),
                                ),*/

                                SizedBox(
                                  height: 4,),
                                Divider(
                                  height: 1,
                                  color: AppColor
                                      .secondaryColor,),
                                SizedBox(
                                  height: 5,),

                                // دکمه های مربوط به عملیات اضافه-حذف-مشاهده و ویرایش
                                Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    // آیکون اضافه کردن
                                    Container(
                                      width: 25,
                                      height: 25,
                                      child:
                                      GestureDetector(
                                        onTap: () {
                                          if ( depositRequests.paidAmount! < depositRequests.amount!) {
                                            Get.toNamed(
                                                '/depositCreate',
                                                arguments: depositRequests);
                                          } else {
                                            Get
                                                .defaultDialog(
                                              title: 'هشدار',
                                              middleText: 'مبلغ باقیمانده برای واریزی صفر است.',
                                              titleStyle: AppTextStyle
                                                  .smallTitleText,
                                              middleTextStyle: AppTextStyle
                                                  .bodyText,
                                              backgroundColor: AppColor
                                                  .backGroundColor,
                                              textCancel: 'بستن',
                                            );
                                          }
                                        },
                                        child: SvgPicture
                                            .asset(
                                            'assets/svg/add.svg',
                                            colorFilter: ColorFilter
                                                .mode(
                                              AppColor
                                                  .buttonColor,
                                              BlendMode
                                                  .srcIn,)
                                        ),
                                      ),
                                    ),
                                    // آیکون حذف کردن
                                    Container(
                                      width: 25,
                                      height: 25,
                                      child: GestureDetector(
                                        onTap: () {
                                          if (depositRequests.depositCount != 0) {
                                            Get
                                                .defaultDialog(
                                              title: 'هشدار',
                                              middleText: 'به دلیل داشتن زیر مجموعه قابل حذف نیست',
                                              titleStyle: AppTextStyle
                                                  .smallTitleText,
                                              middleTextStyle: AppTextStyle
                                                  .bodyText,
                                              backgroundColor: AppColor
                                                  .backGroundColor,
                                              textCancel: 'بستن',
                                            );
                                          } else {
                                            Get
                                                .defaultDialog(
                                                backgroundColor: AppColor
                                                    .backGroundColor,
                                                title: "حذف درخواست واریزی",
                                                titleStyle: AppTextStyle
                                                    .smallTitleText,
                                                middleText: "آیا از حذف درخواست واریزی مطمئن هستید؟",
                                                middleTextStyle: AppTextStyle
                                                    .bodyText,
                                                confirm: ElevatedButton(
                                                    style: ButtonStyle(
                                                        backgroundColor: WidgetStatePropertyAll(
                                                            AppColor
                                                                .primaryColor)),
                                                    onPressed: () {
                                                      Get
                                                          .back();
                                                      withdrawController.deleteDepositRequest(withdraw.id!,depositRequests.id!, true);
                                                      //withdrawController.fetchWithdrawList();
                                                    },
                                                    child: Text(
                                                      'حذف',
                                                      style: AppTextStyle
                                                          .bodyText,
                                                    )));
                                            //withdrawController.fetchWithdrawList();
                                          }
                                        },
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
                                    ),
                                    // آیکون مشاهده
                                    Container(
                                      width: 25,
                                      height: 25,
                                      child: GestureDetector(
                                        onTap: () {
                                          Get.toNamed('/depositRequestGetOne', parameters:{"id":depositRequests.id.toString()});
                                        },
                                        child: SvgPicture
                                            .asset(
                                            'assets/svg/eye1.svg',
                                            colorFilter: ColorFilter
                                                .mode(
                                              AppColor
                                                  .iconViewColor,
                                              BlendMode
                                                  .srcIn,)
                                        ),
                                      ),
                                    ),
                                    // آیکون ویرایش
                                    Container(
                                      width: 25,
                                      height: 25,
                                      child: GestureDetector(
                                        onTap: () {
                                          /*if (depositRequests.depositCount != 0) {
                                            Get.defaultDialog(
                                              title: 'هشدار',
                                              middleText: 'به دلیل داشتن زیر مجموعه قابل ویرایش نیست',
                                              titleStyle: AppTextStyle
                                                  .smallTitleText,
                                              middleTextStyle: AppTextStyle
                                                  .bodyText,
                                              backgroundColor: AppColor
                                                  .backGroundColor,
                                              textCancel: 'بستن',
                                            );
                                          } else {*/
                                          withdrawController.setDepositRequestDetail(depositRequests);
                                          showModalBottomSheet(
                                            enableDrag: true,
                                            context: context,
                                            backgroundColor: AppColor
                                                .backGroundColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius
                                                  .vertical(
                                                  top: Radius
                                                      .circular(
                                                      20)),
                                            ),
                                            builder: (
                                                context) {
                                              return UpdateDepositRequestWidget(
                                                withdrawId: withdraw
                                                    .id!,
                                                depositRequest: depositRequests,
                                              );
                                            },
                                          )
                                              .whenComplete(() {
                                            withdrawController
                                                .clearList();
                                          });

                                        },
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
        );

    });
  }

  Map<String, List<WithdrawModel>> groupWithdrawsByDate(List<WithdrawModel> withdraws) {
    final grouped = <String, List<WithdrawModel>>{};

    for (final withdraw in withdraws) {
      final persianDateKey = withdraw.datePersianToString ?? 'بدون تاریخ';

      if (!grouped.containsKey(persianDateKey)) {
        grouped[persianDateKey] = [];
      }
      grouped[persianDateKey]!.add(withdraw);
    }
    return grouped;
  }
}

