import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/utils/num_display.dart';
import 'package:hanigold_admin/src/widget/custom_appbar1.widget.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../config/repository/url/base_url.dart';
import '../../../widget/app_drawer.widget.dart';
import '../../../widget/background_image_total.widget.dart';
import '../../../widget/err_page.dart';
import '../../../widget/pager_widget.dart';
import '../../chat/widget/chat_dialog.widget.dart';
import '../../transaction/widgets/balance_date_dialog.widget.dart';
import '../../transaction/widgets/balance_dialog.widget.dart';
import '../controller/remittance.controller.dart';
import '../widget/remittance_filter_dialog.widget.dart';

class RemittanceView extends StatefulWidget {
  RemittanceView({super.key});

  @override
  State<RemittanceView> createState() => _RemittanceViewState();
}

class _RemittanceViewState extends State<RemittanceView> {
  final RemittanceController controller = Get.find<RemittanceController>();
  final GlobalKey _dataTableKey = GlobalKey();
  //final Map<int, GlobalKey> _rowKeys = {};

  @override
  void initState() {
    super.initState();
    /*_rowKeys.clear();

    controller.remittanceList.listen((list) {
      if (mounted) {
        _prepareScreenshotKeys(list);
        setState(() {});
      }
    });
    if (controller.remittanceList.isNotEmpty) {
      _prepareScreenshotKeys(controller.remittanceList);
    }*/
  }

  /*void _prepareScreenshotKeys(List<RemittanceModel> remittances) {
    try {
      // Clear all existing keys first to prevent duplicates
      _rowKeys.clear();

      // Only process if remittances list is not null and not empty
      if (remittances.isNotEmpty) {
        // Create new keys for current remittances
        for (var remittance in remittances) {
          if (remittance.id != null) {
            // Ensure we don't create duplicate keys
            if (!_rowKeys.containsKey(remittance.id)) {
              _rowKeys[remittance.id!] = GlobalKey(debugLabel: 'row_${remittance.id}');
            }
          }
        }
      }

      // Ensure we have the correct number of keys
      final expectedKeys = remittances.where((r) => r.id != null).map((r) => r.id!).toSet();
      final actualKeys = _rowKeys.keys.toSet();

      // Remove any extra keys that shouldn't be there
      final keysToRemove = actualKeys.difference(expectedKeys);
      for (final key in keysToRemove) {
        _rowKeys.remove(key);
      }
    } catch (e) {
      // If there's any error, clear the keys to prevent issues
      _rowKeys.clear();
      print('Error preparing screenshot keys: $e');
    }
  }

  @override
  void dispose() {
    _rowKeys.clear();
    super.dispose();
  }*/
  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    /*if (controller.remittanceList.isNotEmpty && _rowKeys.isEmpty) {
      _prepareScreenshotKeys(controller.remittanceList);
    }*/
    return Obx(() => Scaffold(
          appBar: CustomAppbar1(
            title: 'لیست حواله',
            onBackTap: () => Get.offNamed('/home'),
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
                          height: Get.height,width: Get.width,
                            child: SingleChildScrollView(
                              controller:isDesktop ? null : controller.scrollControllerMobile,
                              child: Column(
                                children: [
                                  //فیلد جستجو
                                  isDesktop ? SizedBox.shrink() :
                                  Container(
                                    margin: EdgeInsets.symmetric(horizontal:isDesktop ? 50 : 20,vertical: 10),
                                    padding: EdgeInsets.symmetric(horizontal: 20),
                                    color: AppColor.appBarColor.withAlpha(130),
                                    alignment: Alignment.center,
                                    height: 80,
                                    child: TextFormField(
                                      controller: controller.searchControllerRecipt,
                                      style: AppTextStyle.labelText,
                                      textInputAction: TextInputAction.search,
                                      onFieldSubmitted: (value) async {
                                        if (value.isNotEmpty) {
                                          await controller.searchAccountsRecipt(value);
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
                                        hintText: "جستجوی ثبت کننده ... ",
                                        hintStyle: AppTextStyle.labelText,
                                        prefixIcon: IconButton(
                                            onPressed: ()async{
                                              if (controller.searchControllerRecipt.text.isNotEmpty) {
                                                await controller.searchAccountsRecipt(
                                                    controller.searchControllerRecipt.text
                                                );
                                                showSearchResults(context);
                                              }else {
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
                                  isDesktop ? SizedBox.shrink() :
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            /*ElevatedButton(
                                              style: ButtonStyle(
                                                  padding: isDesktop ?
                                                  WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 12,vertical: 17)):
                                                  WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 10,vertical: 14)),
                                                  elevation: WidgetStatePropertyAll(5),
                                                  backgroundColor:
                                                  WidgetStatePropertyAll(AppColor.purpleColor),
                                                  shape: WidgetStatePropertyAll(
                                                      RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(5)))),
                                              onPressed: () {
                                                Get.toNamed('/remittancesPendingList');
                                              },
                                              child: Text(
                                                'حواله های در انتظار',
                                                style: AppTextStyle.labelText.copyWith(
                                                  fontSize:isDesktop ? 12 : 10,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ),*/
                                            //SizedBox(width: 5,),
                                            // ایجاد حواله
                                            ElevatedButton(
                                              style: ButtonStyle(
                                                  padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 12,vertical: 12)),
                                                  elevation: WidgetStatePropertyAll(5),
                                                  backgroundColor:
                                                  WidgetStatePropertyAll(AppColor.secondary3Color),
                                                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(5)))),
                                              onPressed: () async {
                                                controller.clearList();
                                                controller.balanceListRecipt.clear();
                                                controller.balanceListPayer.clear();
                                                Get.toNamed("/insertRemittance",);
                                              },
                                              child: Row(
                                                children: [
                                                  Text(
                                                    'ایجاد حواله',
                                                    style: AppTextStyle.labelText.copyWith(
                                                      fontSize:10,
                                                      fontWeight: FontWeight.normal,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width:8,),
                                            Row(
                                              children: [
                                                // خروجی اکسل
                                                ElevatedButton(
                                                  style: ButtonStyle(
                                                      padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 12,vertical: 12)),
                                                      // elevation: WidgetStatePropertyAll(5),
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
                                                                width:Get.height * 0.5,
                                                                height:Get.height * 0.7,
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
                                                                                EdgeInsets.symmetric(horizontal: 23)),
                                                                            // elevation: WidgetStatePropertyAll(5),
                                                                            backgroundColor:
                                                                            WidgetStatePropertyAll(AppColor.appBarColor),
                                                                            shape: WidgetStatePropertyAll(RoundedRectangleBorder(side: BorderSide(color: AppColor.textColor),
                                                                                borderRadius: BorderRadius.circular(5)))),
                                                                        onPressed: () async {
                                                                          controller.getRemittanceExcel();
                                                                          Get.back();
                                                                        },
                                                                        child: controller.isLoading.value?
                                                                        CircularProgressIndicator(
                                                                          valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor),
                                                                        ) :
                                                                        Text(
                                                                          'ثبت',
                                                                          style: AppTextStyle.labelText.copyWith(fontSize: 10),
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
                                                /*ElevatedButton(
                                                  style: ButtonStyle(
                                                      padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 21,vertical: 17)),
                                                      // elevation: WidgetStatePropertyAll(5),
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
                                                                width:Get.height * 0.5,
                                                                height:Get.height * 0.7,
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
                                                                                EdgeInsets.symmetric(horizontal: 23)),
                                                                            // elevation: WidgetStatePropertyAll(5),
                                                                            backgroundColor:
                                                                            WidgetStatePropertyAll(AppColor.appBarColor),
                                                                            shape: WidgetStatePropertyAll(RoundedRectangleBorder(side: BorderSide(color: AppColor.textColor),
                                                                                borderRadius: BorderRadius.circular(5)))),
                                                                        onPressed: () async {
                                                                          controller.exportToPdf();
                                                                          Get.back();
                                                                        },
                                                                        child: controller.isLoading.value?
                                                                        CircularProgressIndicator(
                                                                          valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor),
                                                                        ) :
                                                                        Text(
                                                                          'ثبت',
                                                                          style: AppTextStyle.labelText.copyWith(fontSize: 10),
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
                                                ),*/
                                              ],
                                            ),
                                          ],
                                        ),
                                        // فیلتر
                                        ElevatedButton(
                                          style: ButtonStyle(
                                              padding: WidgetStatePropertyAll(
                                                  EdgeInsets.symmetric(horizontal: 12,vertical: 12)),
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
                                                  return RemittanceFilterDialog(controller: controller);
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
                                                    controller.namePayerController.text!="" ||
                                                        controller.nameRecieptController.text!="" ||
                                                        controller.dateStartController.text!="" ||
                                                        controller.dateEndController.text!="" ||
                                                        controller.quantityFilterController.text!="" ||
                                                        controller.descriptionFilterController.text!="" ||
                                                        controller.selectedItemFilter.value != null
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
                                                    fontSize: 10,color:
                                                controller.namePayerController.text!="" ||
                                                    controller.nameRecieptController.text!="" ||
                                                    controller.dateStartController.text!="" ||
                                                    controller.dateEndController.text!="" ||
                                                    controller.quantityFilterController.text!="" ||
                                                    controller.descriptionFilterController.text!="" ||
                                                    controller.selectedItemFilter.value != null
                                                    ?AppColor.accentColor: AppColor.textColor),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],

                                    ),
                                  ),
                                  isDesktop ?
                                  Container(
                                    margin: EdgeInsets.symmetric(horizontal: 30,vertical: 15),
                                    padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                                    color: AppColor.backGroundColor1.withAlpha(150),
                                    child: Column(
                                      children: [
                                        SingleChildScrollView(
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
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            width: 400,
                                                            child: TextFormField(
                                                              controller: controller.searchControllerRecipt,
                                                              style: AppTextStyle.labelText,
                                                              textInputAction: TextInputAction.search,
                                                              onFieldSubmitted: (value) async {
                                                                if (value.isNotEmpty) {
                                                                  await controller.searchAccountsRecipt(value);
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
                                                                hintText: "جستجوی ثبت کننده ... ",
                                                                hintStyle: AppTextStyle.labelText,
                                                                prefixIcon: IconButton(
                                                                    onPressed: ()async{
                                                                      if (controller.searchControllerRecipt.text.isNotEmpty) {
                                                                        await controller.searchAccountsRecipt(
                                                                            controller.searchControllerRecipt.text
                                                                        );
                                                                        showSearchResults(context);
                                                                      }else {
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
                                                          SizedBox(width: 10,),
                                                          Row(
                                                            children: [
                                                              // ایجاد حواله
                                                              TextButton.icon(
                                                                onPressed: () async {
                                                                  controller.clearList();
                                                                  controller.balanceListRecipt.clear();
                                                                  controller.balanceListPayer.clear();
                                                                  Get.toNamed("/insertRemittance",);
                                                                },
                                                                  icon: SvgPicture.asset(
                                                                    'assets/svg/add-plus.svg',
                                                                    height: 24,
                                                                  ),
                                                                  label: Text(
                                                                    'ایجاد حواله',
                                                                    style: AppTextStyle.labelText.copyWith(
                                                                      fontSize:12,
                                                                    ),
                                                                  ),
                                                              ),
                                                              SizedBox(width: 5,),
                                                              // حواله های در انتظار
                                                              TextButton.icon(
                                                                onPressed: () {
                                                                  Get.toNamed('/remittancesPendingList');
                                                                },
                                                                  icon: SvgPicture.asset(
                                                                    'assets/svg/list-wait.svg',
                                                                    height: 24,
                                                                  ),
                                                                  label: Text(
                                                                    'حواله های در انتظار',
                                                                    style: AppTextStyle.labelText.copyWith(
                                                                      fontSize:12,
                                                                    ),
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
                                                                                              EdgeInsets.symmetric(horizontal: 23)),
                                                                                          // elevation: WidgetStatePropertyAll(5),
                                                                                          backgroundColor:
                                                                                          WidgetStatePropertyAll(AppColor.appBarColor),
                                                                                          shape: WidgetStatePropertyAll(RoundedRectangleBorder(side: BorderSide(color: AppColor.textColor),
                                                                                              borderRadius: BorderRadius.circular(5)))),
                                                                                      onPressed: () async {
                                                                                        controller.getRemittanceExcel();
                                                                                        Get.back();
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
                                                                                              EdgeInsets.symmetric(horizontal: 23)),
                                                                                          // elevation: WidgetStatePropertyAll(5),
                                                                                          backgroundColor:
                                                                                          WidgetStatePropertyAll(AppColor.appBarColor),
                                                                                          shape: WidgetStatePropertyAll(RoundedRectangleBorder(side: BorderSide(color: AppColor.textColor),
                                                                                              borderRadius: BorderRadius.circular(5)))),
                                                                                      onPressed: () async {
                                                                                        controller.exportToPdf();
                                                                                        Get.back();
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
                                                                        return RemittanceFilterDialog(controller: controller);
                                                                      });
                                                                },
                                                                  icon: SvgPicture.asset(
                                                                      'assets/svg/filter3.svg',
                                                                      height: 17,
                                                                      colorFilter:
                                                                      ColorFilter
                                                                          .mode(
                                                                        controller.namePayerController.text!="" ||
                                                                            controller.nameRecieptController.text!="" ||
                                                                            controller.dateStartController.text!="" ||
                                                                            controller.dateEndController.text!="" ||
                                                                            controller.quantityFilterController.text!="" ||
                                                                            controller.descriptionFilterController.text!="" ||
                                                                            controller.selectedItemFilter.value != null
                                                                            ?AppColor.accentColor:  AppColor
                                                                            .textColor,
                                                                        BlendMode
                                                                            .srcIn,
                                                                      )),
                                                                  label: Text(
                                                                    'فیلتر',
                                                                    style: AppTextStyle
                                                                        .labelText
                                                                        .copyWith(
                                                                        fontSize: isDesktop
                                                                            ? 12
                                                                            : 10,color:
                                                                    controller.namePayerController.text!="" ||
                                                                        controller.nameRecieptController.text!="" ||
                                                                        controller.dateStartController.text!="" ||
                                                                        controller.dateEndController.text!="" ||
                                                                        controller.quantityFilterController.text!="" ||
                                                                        controller.descriptionFilterController.text!="" ||
                                                                        controller.selectedItemFilter.value != null
                                                                        ?AppColor.accentColor: AppColor.textColor),
                                                                  ),
                                                              )
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    RepaintBoundary(
                                                      key: _dataTableKey,
                                                      child: DataTable(
                                                        sortColumnIndex: controller.sortColumnIndex.value,
                                                        sortAscending: controller.sortAscending.value,
                                                        columns: buildDataColumns(),
                                                        dividerThickness: 0.3,
                                                        rows: buildDataRows(context),
                                                        border: TableBorder.symmetric(
                                                            inside: BorderSide(color: AppColor.textColor,width: 0.3),
                                                            outside: BorderSide(color: AppColor.textColor,width: 0.3),
                                                            borderRadius: BorderRadius.circular(8)
                                                        ),
                                                        //dataRowMaxHeight: double.infinity,
                                                        dataRowMaxHeight: 80,
                                                        //dataRowColor: WidgetStatePropertyAll(AppColor.secondaryColor),
                                                        headingRowColor: WidgetStatePropertyAll(AppColor.buttonColor.withAlpha(40)),
                                                        headingRowHeight: 40,
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
                                  )
                                  : _buildMobileRemittanceCards(context),
                                  SizedBox(height: 60,),
                                ],
                              ),
                            ),
                          )
                        : ErrPage(
                          callback: () {
                            controller.clearFilter();
                            controller.getRemittanceListPager();
                          },
                  title: "خطا در دریافت لیست حواله",
                  des: 'برای دریافت لیست حواله ها مجددا تلاش کنید',
                ),
              ),
              isDesktop ?
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  controller.paginated.value!=null?   Container(
                      height: 70,
                      margin: EdgeInsets.symmetric(horizontal: 50,vertical: 10),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      //color: AppColor.appBarColor.withAlpha(130),
                      alignment: Alignment.bottomCenter,
                      child:PagerWidget(countPage: controller.paginated.value?.totalCount??0, callBack: (int index) {
                        controller.isChangePage(index);
                      },)):SizedBox(),
                ],
              ): SizedBox.shrink(),
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

  void showSearchResults(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(backgroundColor: AppColor.backGroundColor,
        title: Text('انتخاب کنید',style: AppTextStyle.smallTitleText,),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: controller.searchedAccountsRecipt.length,
            itemBuilder: (context, index) {
              final account = controller.searchedAccountsRecipt[index];
              return ListTile(
                title: Text(account.name ?? '',style: AppTextStyle.bodyText.copyWith(fontSize: 15),),
                onTap: () => controller.selectAccount(account),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('بستن',style: AppTextStyle.bodyText,),
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
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 80),
              child: Text('تاریخ',
                  style: AppTextStyle.labelText.copyWith(fontSize: 12))),
          headingRowAlignment: MainAxisAlignment.center,
        onSort: (columnIndex, ascending) {
          controller.onSort(columnIndex, ascending);
        },
      ),
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 80),
              child: Text('نام ثبت کننده',
                  style: AppTextStyle.labelText.copyWith(fontSize: 12))),
          headingRowAlignment: MainAxisAlignment.center,
          onSort: (columnIndex, ascending) {
            controller.onSort(columnIndex, ascending);
          }
      ),
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100),
              child: Row(
                children: [
                  Text('بدهکار ',
                      style: AppTextStyle.labelText
                          .copyWith(color: AppColor.accentColor, fontSize: 12,fontWeight: FontWeight.bold)),
                  SvgPicture.asset('assets/svg/refresh.svg',
                      height: 16,
                      colorFilter: ColorFilter.mode(
                        AppColor.textColor,
                        BlendMode.srcIn,
                      )),
                  Text(' بستانکار',
                      style: AppTextStyle.labelText.copyWith(
                          color: AppColor.primaryColor, fontSize: 12,fontWeight: FontWeight.bold)),
                ],
              )),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 80),
              child: Text('محصول',
                  style: AppTextStyle.labelText.copyWith(fontSize: 12))),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 80),
              child: Text('مقدار',
                  style: AppTextStyle.labelText.copyWith(fontSize: 12))),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 80),
              child: Text('وضعیت',
                  style: AppTextStyle.labelText.copyWith(fontSize: 12))),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 80),
              child: Text('شرح',
                  style: AppTextStyle.labelText.copyWith(fontSize: 12))),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 80),
              child: Text('مانده',
                  style: AppTextStyle.labelText.copyWith(fontSize: 12))),
          headingRowAlignment: MainAxisAlignment.center),
      /*DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 80),
              child: Text('مانده ریالی',
                  style: AppTextStyle.labelText.copyWith(fontSize: 12))),
          headingRowAlignment: MainAxisAlignment.center),*/
      /*DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 80),
              child: Text('مانده طلایی',
                  style: AppTextStyle.labelText.copyWith(fontSize: 12))),
          headingRowAlignment: MainAxisAlignment.center),*/
      /*DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 80),
              child: Text('مانده سکه',
                  style: AppTextStyle.labelText.copyWith(fontSize: 12))),
          headingRowAlignment: MainAxisAlignment.center),*/
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 80),
              child: Text('عملیات',
                  style: AppTextStyle.labelText.copyWith(fontSize: 12))),
          headingRowAlignment: MainAxisAlignment.center),
    ];
  }

  List<DataRow> buildDataRows(BuildContext context) {
    //final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    return controller.remittanceList.asMap().entries.map((entry) {
      final index = entry.key;
      final remittance = entry.value;
      final rowColor = index.isEven
          ? AppColor.backGroundColor
          : AppColor.secondaryColor.withAlpha(100);
      return DataRow(
        color: WidgetStateProperty.all(rowColor),
        cells: [
          // ردیف
          DataCell(
            Center(
              child:
              Row(
                children: [
                Tooltip(
                message: 'کلیک: تصویر ردیف | نگه داشتن: تصویر کل جدول',
                child: GestureDetector(
                  onTap: () {
                    if (remittance.id != null) {
                      controller.captureTableScreenshot(remittance, _dataTableKey);
                    }
                  },
                  onLongPress: () {
                    // Long press to capture entire table
                    controller.captureEntireTable(_dataTableKey);
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
                ),),
                SizedBox(width: 5,),
                // رجیستر
                Checkbox(
                  value: remittance.registered ?? false,
                  onChanged: (value) async{
                    if (value != null) {
                      //EasyLoading.show(status: 'لطفا منتظر بمانید');
                      await controller.updateRegistered(
                          remittance.id!,
                          value
                      );
                    }
                  },
                ),
                SizedBox(width: 5,),
                Text("${remittance.rowNum}",
                  style:
                  AppTextStyle.bodyText,
                ),
                ],
              ),
            ),
          ),
          // تاریخ
          DataCell(Center(
            child: Text(
              remittance.date?.toPersianDate(showTime: true) ?? 'نامشخص',
              style: AppTextStyle.bodyText.copyWith(fontSize: 10),
              textDirection: TextDirection.ltr,
            ),
          )),
          // نام ثبت کننده
          DataCell(Center(
            child: Text(
              remittance.createdBy?.name ?? 'نامشخص',
              style: AppTextStyle.bodyText.copyWith(fontSize: 11),
            ),
          )),
          // بدهکار,بستانکار
          DataCell(Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("${remittance.walletPayer?.account?.name ?? 'نامشخص'} ",
                    style: AppTextStyle.bodyText
                        .copyWith(color: AppColor.accentColor, fontSize: 11,fontWeight: FontWeight.bold)),
                SvgPicture.asset('assets/svg/refresh.svg',
                    height: 16,
                    colorFilter: ColorFilter.mode(
                      AppColor.textColor,
                      BlendMode.srcIn,
                    )),
                Text(" ${remittance.walletReciept?.account?.name ?? 'نامشخص'}",
                    style: AppTextStyle.bodyText
                        .copyWith(color: AppColor.primaryColor, fontSize: 11,fontWeight: FontWeight.bold)),
              ],
            ),
          )),
          // محصول
          DataCell(Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network('${BaseUrl.baseUrl}Attachment/downloadResource?fileName=${remittance.item?.icon}',
                  width: 25,
                  height: 25,),
                SizedBox(width: 5,),
                Text(
                  remittance.item?.name ?? 'نامشخص',
                  style: AppTextStyle.bodyText.copyWith(
                      color: AppColor.secondary2Color,
                      fontWeight: FontWeight.w500,
                      fontSize: 12),
                ),
              ],
            ),
          )),
          // مقدار
          DataCell(Center(
            child: Text(
              remittance.item?.itemUnit?.id == 1
                  ? "${remittance.quantity?.toDisplayString()} عدد "
                  : remittance.item?.itemUnit?.id == 2
                      ? "${remittance.quantity?.toDisplayString().seRagham()} گرم "
                      : "${remittance.quantity?.toDisplayString().seRagham()} ریال ",
              style: AppTextStyle.bodyText.copyWith(fontSize: 12),
            ),
          )),
          // وضعیت
          DataCell(
            Center(
              child: Column(
                children: [
                  /*Container(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    decoration: BoxDecoration(
                        color: remittance.status == 0
                            ? AppColor.textFieldColor
                            : remittance.status == 1
                            ? AppColor.secondary2Color
                            : AppColor.accentColor,
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(
                      remittance.status == 0 ? 'در انتظار'
                          : remittance.status == 1
                          ? 'تایید شده'
                          : 'تایید نشده',
                      style: AppTextStyle.bodyText
                          .copyWith(color: AppColor.textColor, fontSize: 10),
                    ),
                  ),*/
                  /*Container(
                    padding: const EdgeInsets
                        .symmetric(
                        horizontal: 0,
                        vertical: 0),
                    child: PopupMenuButton<
                        int>(
                      splashRadius: 10,
                      tooltip: 'تعیین وضعیت',
                      onSelected: (value) async {
                        if(value==2){
                          await controller.showReasonRejectionDialog("Remittance");
                          if (controller.selectedReasonRejection.value == null) {
                            return; // اگر کاربر دلیل را انتخاب نکرد، عملیات لغو شود
                          }
                          await controller.updateStatusRemittance(
                            remittance.id!,
                            value,
                            controller.selectedReasonRejection.value!.id!,
                          );
                        }else {
                          await controller.updateStatusRemittance(
                              remittance.id!,
                              value, 0);
                        }
                        //controller.getRemittanceListPager();
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
                        minWidth: 60,
                        maxWidth: 60,
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
                              controller.isLoading.value
                                  ?
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor),
                              ) :
                              Text('تایید',
                                style: AppTextStyle
                                    .bodyText
                                    .copyWith(
                                    color: AppColor
                                        .primaryColor,
                                    fontSize: 12),
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
                              controller.isLoading.value
                                  ?
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor),
                              ) :
                              Text('رد',
                                style: AppTextStyle
                                    .bodyText
                                    .copyWith(
                                    color: AppColor
                                        .accentColor,
                                    fontSize: 12),
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
                  Center(
                    child: Transform.scale(
                      scale: 0.70,
                      child: Switch(
                        value: remittance.status == 1,
                        onChanged: remittance.status == 0
                            ? null // Disable switch for pending status
                            : (value) async {
                          // پذیرش = 1، عدم پذیرش = 2
                          final newStatus = value ? 1 : 2;

                          if (newStatus == 2) {
                              // Reset rejection reason before showing dialog
                            controller.selectedReasonRejection.value = null;
                              // Show rejection reason dialog
                              await controller.showReasonRejectionDialog("Remittance");
                              // اگر کاربر دلیل رد را انتخاب نکرد، تغییر اعمال نشود
                              if (controller
                                  .selectedReasonRejection.value == null) {
                                return; // User cancelled or didn't select reason - no change applied
                              }
                              // Update status with rejection reason
                              await controller.updateStatusRemittance(
                                remittance.id!,
                                newStatus,
                                controller
                                    .selectedReasonRejection.value!.id!,
                              );
                            //controller.getRemittanceListPager();

                          } else {
                            // Acceptance flow: direct update
                            await controller.updateStatusRemittance(
                              remittance.id!,
                              newStatus,
                              0,
                            );
                            //controller.getRemittanceListPager();
                          }
                        },
                        thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
                          if (states.contains(WidgetState.disabled) ||
                              remittance.status == 0) {
                            return AppColor.dividerColor;
                          }
                          return remittance.status == 1
                              ? AppColor.successColor
                              : AppColor.accentColor;
                        }),
                        trackColor: WidgetStateProperty.resolveWith<Color>((states) {
                          if (states.contains(WidgetState.disabled) ||
                              remittance.status == 0) {
                            return AppColor.dividerColor.withAlpha(100);
                          }
                          return remittance.status == 1
                              ? AppColor.successColor.withAlpha(100)
                              : AppColor.accentColor.withAlpha(100);
                        }),
                      ),
                    ),
                  ),
                  SizedBox(height: 6,),
                  remittance.status==2 ?
                  Wrap(
                    children: [
                      Text('به دلیل ',
                        style: AppTextStyle
                            .labelText,),
                      Text("`${remittance.reasonRejection?.name}`",
                        style: AppTextStyle
                            .bodyText.copyWith(color: AppColor.dividerColor),),
                      Text('رد شد.',
                        style: AppTextStyle
                            .labelText,), 
                    ],
                  ) : SizedBox.shrink(),
                ],
              ),
            ),
          ),
          // شرح
          DataCell(Center(
            child: Column(
              //key: (remittance.id != null && _rowKeys.containsKey(remittance.id)) ? _rowKeys[remittance.id] : null,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      " از : ",
                      style: AppTextStyle.bodyText
                          .copyWith(color: AppColor.textColor, fontSize: 10),
                    ),
                    Text(
                      "${remittance.walletPayer?.account?.name??"نامشخص"} ",
                      style: AppTextStyle.bodyText
                          .copyWith(color: AppColor.accentColor, fontSize: 10,fontWeight: FontWeight.bold),
                    ),
                    Text(
                      " به : ",
                      style: AppTextStyle.bodyText
                          .copyWith(color: AppColor.textColor, fontSize: 10),
                    ),
                    Text(
                      "${remittance.walletReciept?.account?.name??"نامشخص"} ",
                      style: AppTextStyle.bodyText
                          .copyWith(color: AppColor.primaryColor, fontSize: 10,fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      remittance.item?.itemUnit?.id == 1
                          ? "${remittance.quantity?.toDisplayString()} عدد "
                          : remittance.item?.itemUnit?.id == 2
                              ? "${remittance.quantity?.toDisplayString().seRagham()} گرم "
                              : "${remittance.quantity?.toDisplayString().seRagham()} ریال ",
                      style: AppTextStyle.bodyText.copyWith(
                          color: AppColor.textColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 10),
                    ),
                    Text(
                      "  ",
                      style: AppTextStyle.bodyText.copyWith(
                          color: AppColor.secondary2Color,
                          fontWeight: FontWeight.w700,
                          fontSize: 10),
                    ),
                    Text(
                      remittance.item?.name ?? 'نامشخص',
                      style: AppTextStyle.bodyText.copyWith(
                          color: AppColor.secondary2Color,
                          fontWeight: FontWeight.w700,
                          fontSize: 10),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'توضیحات : ',
                      style: AppTextStyle.bodyText.copyWith(
                          color: AppColor.dividerColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 10),
                    ),
                    Text(remittance.description ?? 'نامشخص',
                        style: AppTextStyle.bodyText.copyWith(
                            color: AppColor.textColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 10)),
                  ],
                ),
                // SizedBox(
                //   height: 5,
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Text(
                //       remittance.date?.toPersianDate(showTime: true) ??
                //           'نامشخص',
                //       style: AppTextStyle.bodyText.copyWith(
                //           color: AppColor.iconViewColor,
                //           fontWeight: FontWeight.w700,
                //           fontSize: 10),
                //       textDirection: TextDirection.ltr,
                //     ),
                //   ],
                // ),
              ],
            ),
          )),
          // مانده
          DataCell(
              Center(
                child:
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          remittance.status==2 ?
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return BalanceDateDialog(
                                accountId: remittance.walletPayer?.account?.id ?? 0,
                                accountName: remittance.walletPayer?.account?.name ?? "",
                                initialDate: remittance.date.toString(),
                                isDesktop: ResponsiveBreakpoints.of(context).largerThan(TABLET),);
                            },
                          ):
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return BalanceDialog(
                                entityId: remittance.id ?? 0,
                                entityType:"issue",
                                entityName: remittance.walletPayer?.account?.name ?? 'نامشخص',
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
                      SizedBox(height: 3,),
                      GestureDetector(
                        onTap: () {
                          remittance.status==2 ?
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return BalanceDateDialog(
                                accountId: remittance.walletReciept?.account?.id ?? 0,
                                accountName: remittance.walletReciept?.account?.name ?? "",
                                initialDate: remittance.date.toString(),
                                isDesktop: ResponsiveBreakpoints.of(context).largerThan(TABLET),);
                            },
                          ):
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return BalanceDialog(
                                entityId: remittance.id ?? 0,
                                entityType:"reciept",
                                entityName: remittance.walletReciept?.account?.name ?? 'نامشخص',
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
                                  color: AppColor.primaryColor, fontSize: 11,fontWeight: FontWeight.bold),),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
          ),
          // مانده ریالی
          /*DataCell(Center(
              child: SizedBox(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                    remittance.balancePayer==null?SizedBox() :Column(
                      children: remittance.balancePayer!
                          .map((e) => Container(
                                child: e.unitName == "ریال"
                                    ? Row(
                                        children: [
                                          Text(
                                            " ${e.itemName} ",
                                            style: AppTextStyle.bodyText.copyWith(
                                                fontSize: 10,
                                                color: AppColor.accentColor),
                                          ),
                                          Text(
                                            e.balance.toString(),
                                            style: AppTextStyle.bodyText.copyWith(
                                                fontSize: 11,
                                                color: AppColor.accentColor),
                                            textDirection: TextDirection.ltr,
                                          ),
                                          Text(
                                            " ${e.unitName} ",
                                            style: AppTextStyle.bodyText.copyWith(
                                                fontSize: 10,
                                                color: AppColor.accentColor),
                                          //  textDirection: TextDirection.ltr,
                                          ),

                                        ],
                                      )
                                    : SizedBox(),
                              ))
                          .toList(),
                    ),
                    remittance.balanceReciept==null?SizedBox() : Column(
                      children: remittance.balanceReciept!
                          .map((e) => Container(
                        child: e.unitName == "ریال"
                            ? Row(
                          children: [
                            Text(
                              " ${e.itemName} ",
                              style: AppTextStyle.bodyText.copyWith(
                                  fontSize: 10,
                                  color: AppColor.primaryColor),
                            ),
                            Text(
                              e.balance.toString(),
                              style: AppTextStyle.bodyText.copyWith(
                                  fontSize: 11,
                                  color: AppColor.primaryColor),
                              textDirection: TextDirection.ltr,
                            ),
                            Text(
                              " ${e.unitName} ",
                              style: AppTextStyle.bodyText.copyWith(
                                  fontSize: 10,
                                  color: AppColor.primaryColor),
                              //  textDirection: TextDirection.ltr,
                            ),

                          ],
                        )
                            : SizedBox(),
                      ))
                          .toList(),
                    ),
                                ],
                              ),
                  ),
                ),
              ))),*/
          // مانده طلایی
          /*DataCell(Center(
              child: SizedBox(
                child: SingleChildScrollView(
                  clipBehavior: Clip.hardEdge,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                    remittance.balancePayer==null?SizedBox() : Column(
                      children: remittance.balancePayer!
                          .map((e) => Container(
                        child: e.unitName == "گرم"
                            ? Row(
                          children: [
                            Text(
                              " ${e.itemName} ",
                              style: AppTextStyle.bodyText.copyWith(
                                  fontSize: 10,
                                  color: AppColor.accentColor),
                            ),
                            Text(
                              e.balance.toString(),
                              style: AppTextStyle.bodyText.copyWith(
                                  fontSize: 11,
                                  color: AppColor.accentColor),
                              textDirection: TextDirection.ltr,
                            ),
                            Text(
                              " ${e.unitName} ",
                              style: AppTextStyle.bodyText.copyWith(
                                  fontSize: 10,
                                  color: AppColor.accentColor),
                              //  textDirection: TextDirection.ltr,
                            ),

                          ],
                        )
                            : SizedBox(),
                      ))
                          .toList(),
                    ),
                    remittance.balanceReciept==null?SizedBox() :  Column(
                      children: remittance.balanceReciept!
                          .map((e) => Container(
                        child: e.unitName == "گرم"
                            ? Row(
                          children: [
                            Text(
                              " ${e.itemName} ",
                              style: AppTextStyle.bodyText.copyWith(
                                  fontSize: 10,
                                  color: AppColor.primaryColor),
                            ),
                            Text(
                              e.balance.toString(),
                              style: AppTextStyle.bodyText.copyWith(
                                  fontSize: 11,
                                  color: AppColor.primaryColor),
                              textDirection: TextDirection.ltr,
                            ),
                            Text(
                              " ${e.unitName} ",
                              style: AppTextStyle.bodyText.copyWith(
                                  fontSize: 10,
                                  color: AppColor.primaryColor),
                              //  textDirection: TextDirection.ltr,
                            ),

                          ],
                        )
                            : SizedBox(),
                      ))
                          .toList(),
                    ),
                                ],
                              ),
                  ),
                ),
              ))),*/
          // مانده سکه
          /*DataCell(Center(
              child: SizedBox(
                child: Scrollbar(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                      remittance.balancePayer==null?SizedBox() :  Column(
                        children: remittance.balancePayer!
                            .map((e) => Container(
                          child: e.unitName == "عدد"
                              ? Row(
                            children: [
                              Text(
                                " ${e.itemName} ",
                                style: AppTextStyle.bodyText.copyWith(
                                    fontSize: 10,
                                    color: AppColor.accentColor),
                              ),
                              Text(
                                e.balance.toString(),
                                style: AppTextStyle.bodyText.copyWith(
                                    fontSize: 11,
                                    color: AppColor.accentColor),
                                textDirection: TextDirection.ltr,
                              ),
                              Text(
                                " ${e.unitName} ",
                                style: AppTextStyle.bodyText.copyWith(
                                    fontSize: 10,
                                    color: AppColor.accentColor),
                                //  textDirection: TextDirection.ltr,
                              ),

                            ],
                          )
                              : SizedBox(),
                        ))
                            .toList(),
                      ),
                      remittance.balanceReciept==null?SizedBox() : Column(
                        children: remittance.balanceReciept!
                            .map((e) => Container(
                          child: e.unitName == "عدد"
                              ? Row(
                            children: [
                              Text(
                                " ${e.itemName} ",
                                style: AppTextStyle.bodyText.copyWith(
                                    fontSize: 10,
                                    color: AppColor.primaryColor),
                              ),
                              Text(
                                e.balance.toString(),
                                style: AppTextStyle.bodyText.copyWith(
                                    fontSize: 11,
                                    color: AppColor.primaryColor),
                                textDirection: TextDirection.ltr,
                              ),
                              Text(
                                " ${e.unitName} ",
                                style: AppTextStyle.bodyText.copyWith(
                                    fontSize: 10,
                                    color: AppColor.primaryColor),
                                //  textDirection: TextDirection.ltr,
                              ),

                            ],
                          )
                              : SizedBox(),
                        ))
                            .toList(),
                      ),
                                  ],
                                ),
                    ),
                  ),
                ),
              ))),*/
          // عملیات
          DataCell(
              Center(
              child: Row(
            children: [
              SizedBox(
                width: 10,
              ),
             GestureDetector(
             onTap: () async{
              await controller.getImage(remittance.recId??"", "Remittance");

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
                                           //if (kIsWeb)
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
                                               (controller.imageList.length) -
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

               });


             },
             child: SvgPicture.asset('assets/svg/picture.svg',height: 20,
                    colorFilter: ColorFilter.mode(

                      AppColor.textColor,

                      BlendMode.srcIn,
                    )),
           ),
              SizedBox(
                width: 20,
              ),
              GestureDetector(
                onTap: (){
                  controller.getOneRemittance(remittance.id??0);
                },
                child: SvgPicture.asset('assets/svg/edit.svg',height: 20,
                    colorFilter: ColorFilter.mode(
                      AppColor.textColor,
                      BlendMode.srcIn,
                    )),
              ),
              SizedBox(
                width: 20,
              ),
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
                          controller.deleteRemittance(remittance.id!, true);
                        },
                        child: Text(
                          'حذف',
                          style: AppTextStyle
                              .bodyText,
                        )
                    ),
                  );
                },
                child: SvgPicture.asset('assets/svg/trash-bin.svg',height: 20,
                    colorFilter: ColorFilter.mode(
                      AppColor.textColor,
                      BlendMode.srcIn,
                    )),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ))),
        ],
      );
    }).toList();
  }

  Widget _buildMobileRemittanceCards(BuildContext context) {
    if (controller.remittanceList.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(40),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.inbox_outlined,
                size: 64,
                color: AppColor.textColor.withAlpha(130),
              ),
              const SizedBox(height: 16),
              Text(
                'هیچ حواله ای یافت نشد',
                style: AppTextStyle.labelText.copyWith(
                  fontSize: 16,
                  color: AppColor.textColor.withAlpha(175),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        children: [
          ListView.builder(
            itemCount: controller.remittanceList.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (ctx, index) {
              final remittance = controller.remittanceList[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.only(top: 10,right: 12,left: 12,bottom: 12),
                decoration: BoxDecoration(
                  color: remittance.registered == true
                      ? AppColor.backGroundColor.withAlpha(180)
                      : AppColor.secondaryColor.withAlpha(180),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF64748B)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header: row number, screenshot, register checkbox, date
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: remittance.registered ?? false,
                              onChanged: (value) async{
                                if (value != null && remittance.id!=null) {
                                  await controller.updateRegistered(remittance.id!, value);
                                }
                              },
                            ),
                            SizedBox(width: 6),
                            Text('${remittance.rowNum ?? ''}', style: AppTextStyle.bodyText),
                          ],
                        ),
                        Text(remittance.date?.toPersianDate(showTime: true) ?? 'نامشخص',
                          style: AppTextStyle.bodyText.copyWith(fontSize: 12), textDirection: TextDirection.ltr,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(remittance.createdBy?.name ?? 'نامشخص',
                              style: AppTextStyle.bodyText.copyWith(fontSize: 11),
                            ),
                          ],
                        )
                      ],
                    ),
                    Divider(color: AppColor.iconViewColor,height: 0.5),
                    SizedBox(height: 8),
                    // Parties and item
                    Container(
                      margin: const EdgeInsets.all(5),
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: AppColor.textAccentColor.withAlpha(30),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFF64748B)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                  Row(
                                      children: [
                                        Text('بدهکار: ', style: AppTextStyle.labelText.copyWith(fontSize: 10)),
                                        Flexible(child: Text(remittance.walletPayer?.account?.name ?? 'نامشخص',
                                          style: AppTextStyle.bodyText.copyWith(color: AppColor.accentColor, fontSize: 11,fontWeight: FontWeight.w700),
                                          overflow: TextOverflow.ellipsis,
                                        )),
                                      ],
                                    ),

                                SizedBox(height: 6),
                                Row(
                                      children: [
                                        Text('بستانکار: ', style: AppTextStyle.labelText.copyWith(fontSize: 10)),
                                        Flexible(child: Text(remittance.walletReciept?.account?.name ?? 'نامشخص',
                                          style: AppTextStyle.bodyText.copyWith(color: AppColor.primaryColor, fontSize: 11,fontWeight: FontWeight.w700),
                                          overflow: TextOverflow.ellipsis,
                                        )),
                                      ],
                                    ),


                              ],
                            ),
                          ),
                          // Status chip + rejection reason (if any)
                          Row(
                            children: [
                              Tooltip(
                                message: "تغییر وضعیت",
                                child: TextButton(
                                  style: ButtonStyle(fixedSize: WidgetStateProperty.all(Size(70, 30)),
                                      backgroundColor: WidgetStateProperty.all(remittance.status == 2 ?AppColor.accentColor.withAlpha(40) :
                                      remittance.status == 1 ? AppColor.primaryColor.withAlpha(40) : AppColor.appBarColor
                                      ),
                                      shape: WidgetStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          )
                                      )
                                  ),
                                  onPressed: () async{
                                    if (remittance.status == 1) {
                                      await controller.showReasonRejectionDialog("Remittance");
                                      if (controller.selectedReasonRejection.value == null) {
                                        return; // اگر کاربر دلیل را انتخاب نکرد، عملیات لغو شود
                                      }
                                      await controller.updateStatusRemittance(remittance.id!, 2,
                                        controller.selectedReasonRejection.value!.id!,
                                      );
                                      //controller.getRemittanceListPager();
                                    } else {
                                      await controller.updateStatusRemittance(remittance.id!, 1, 0);
                                      //controller.getRemittanceListPager();
                                    }
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.all(0),
                                    padding: const EdgeInsets.all(0),
                                    child: Text(
                                          remittance.status == 2
                                              ? 'تایید نشده'
                                              : remittance.status == 1
                                              ? 'تایید شده'
                                              : 'در انتظار',
                                          style: AppTextStyle.labelText.copyWith(color: remittance.status == 2 ? AppColor.accentColor
                                              : remittance.status == 1 ? AppColor.primaryColor
                                              : AppColor.secondaryColor,fontWeight: FontWeight.bold),
                                          textAlign: TextAlign
                                              .center),
                                  ),

                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(5),
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: AppColor.secondary2Color.withAlpha(30),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFF64748B)),
                      ),
                      child: Row(
                        children: [
                          Image.network(
                            '${BaseUrl.baseUrl}Attachment/downloadResource?fileName=${remittance.item?.icon}',
                            width: 24, height: 24,
                            errorBuilder: (c, e, s) => SizedBox(width: 24, height: 24),
                          ),
                          SizedBox(width: 6),
                          Expanded(child: Text(remittance.item?.name ?? 'نامشخص',
                            style: AppTextStyle.bodyText.copyWith(color: AppColor.secondary2Color, fontWeight: FontWeight.w600, fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                          )),
                          Expanded(
                            child: Row(
                              children: [
                                Text('مقدار: ', style: AppTextStyle.labelText.copyWith(fontSize: 10)),
                                Text(
                                  remittance.item?.itemUnit?.id == 1
                                      ? '${remittance.quantity?.toDisplayString()} عدد'
                                      : remittance.item?.itemUnit?.id == 2
                                      ? '${remittance.quantity?.toDisplayString().seRagham()} گرم'
                                      : '${remittance.quantity?.toDisplayString().seRagham()} ریال',
                                  style: AppTextStyle.bodyText.copyWith(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if ((remittance.status ?? 0) == 2)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                          children: [
                            Text('به دلیل ', style: AppTextStyle.labelText.copyWith(color: AppColor.dividerColor)),
                            Flexible(child: Text('${remittance.reasonRejection?.name ?? ''}', style: AppTextStyle.bodyText.copyWith(color: AppColor.dividerColor))),
                            Text(' رد شد.', style: AppTextStyle.labelText.copyWith(color: AppColor.dividerColor)),
                          ],
                        ),
                      ),
                    SizedBox(height: 6),
                    // Description
                    if ((remittance.description ?? '').isNotEmpty)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('توضیحات: ', style: AppTextStyle.labelText.copyWith(color: AppColor.dividerColor, fontSize: 10, fontWeight: FontWeight.w700)),
                          Expanded(child: Text(remittance.description ?? '', style: AppTextStyle.bodyText.copyWith(fontSize: 10))),
                        ],
                      ),
                    SizedBox(height: 8),
                    // Balance actions and operation row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Balance buttons
                        Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                remittance.status==2 ? showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return BalanceDateDialog(
                                      accountId: remittance.walletPayer?.account?.id ?? 0,
                                      accountName: remittance.walletPayer?.account?.name ?? '',
                                      initialDate: remittance.date.toString(),
                                      isDesktop: false,
                                    );
                                  },
                                ) : showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return BalanceDialog(
                                      entityId: remittance.id ?? 0,
                                      entityType: 'issue',
                                      entityName: remittance.walletPayer?.account?.name ?? 'نامشخص',
                                      isDesktop: false,
                                    );
                                  },
                                );
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.account_balance_wallet, size: 22, color: AppColor.accentColor),
                                  SizedBox(width: 4),
                                  Text('مانده بدهکار', style: AppTextStyle.labelText.copyWith(color: AppColor.accentColor, fontSize: 12, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            SizedBox(height: 6),
                            GestureDetector(
                              onTap: () {
                                remittance.status==2 ? showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return BalanceDateDialog(
                                      accountId: remittance.walletReciept?.account?.id ?? 0,
                                      accountName: remittance.walletReciept?.account?.name ?? '',
                                      initialDate: remittance.date.toString(),
                                      isDesktop: false,
                                    );
                                  },
                                ) : showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return BalanceDialog(
                                      entityId: remittance.id ?? 0,
                                      entityType: 'reciept',
                                      entityName: remittance.walletReciept?.account?.name ?? 'نامشخص',
                                      isDesktop: false,
                                    );
                                  },
                                );
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.account_balance_wallet, size: 22, color: AppColor.primaryColor),
                                  SizedBox(width: 4),
                                  Text('مانده بستانکار', style: AppTextStyle.labelText.copyWith(color: AppColor.primaryColor, fontSize: 12, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        // Operation icons: images, edit, delete
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 5,vertical: 3),
                              child: GestureDetector(
                                onTap: () async {
                                  await controller.getImage(remittance.recId??"", "Remittance");
                                  Future.delayed(
                                      const Duration(milliseconds: 200), () {
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
                                                        controller: controller
                                                            .pageController,
                                                        itemCount: controller
                                                            .imageList.length,
                                                        onPageChanged: (
                                                            index) =>
                                                        controller
                                                            .currentImagePage
                                                            .value =
                                                            index,
                                                        itemBuilder: (context,
                                                            index) {
                                                          final attachment = controller
                                                              .imageList[index];
                                                          return Column(
                                                            children: [
                                                              //if (kIsWeb)
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                      .only(
                                                                      right: 50),
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment
                                                                        .start,
                                                                    children: [
                                                                      IconButton(
                                                                        icon: Icon(
                                                                            Icons
                                                                                .download,
                                                                            color: AppColor
                                                                                .dividerColor),
                                                                        onPressed: () =>
                                                                            controller
                                                                                .downloadImage(
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
                                                                  fit: BoxFit
                                                                      .contain,
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
                                                                  .currentImagePage
                                                                  .value > 0,
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
                                                                  controller
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
                                                              visible: controller
                                                                  .currentImagePage
                                                                  .value <
                                                                  (controller
                                                                      .imageList
                                                                      .length) - 1,
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
                                                                  controller
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
                                                                controller
                                                                    .imageList
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
                                                            ),
                                                          ),
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
                                    SvgPicture.asset('assets/svg/picture.svg', height: 30, colorFilter: ColorFilter.mode(AppColor.buttonColor.withAlpha(200), BlendMode.srcIn)),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            GestureDetector(
                              onTap: () { controller.getOneRemittance(remittance.id??0); },
                              child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),color: AppColor.dividerColor.withAlpha(40)),
                                  padding: EdgeInsets.all(3),
                                  child: SvgPicture.asset('assets/svg/edit.svg', height: 30, colorFilter: ColorFilter.mode(AppColor.dividerColor.withAlpha(200), BlendMode.srcIn))),
                            ),
                            SizedBox(width: 20),
                            GestureDetector(
                              onTap: () {
                                Get.defaultDialog(
                                  backgroundColor: AppColor.backGroundColor,
                                  title: 'حذف ',
                                  titleStyle: AppTextStyle.smallTitleText,
                                  middleText: 'آیا از حذف مطمئن هستید؟',
                                  middleTextStyle: AppTextStyle.bodyText,
                                  confirm: ElevatedButton(
                                    style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(AppColor.primaryColor)),
                                    onPressed: () {
                                      Get.back();
                                      if (remittance.id!=null) { controller.deleteRemittance(remittance.id!, true); }
                                    },
                                    child: Text('حذف', style: AppTextStyle.bodyText),
                                  ),
                                );
                              },
                              child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),color: AppColor.accentColor.withAlpha(40)),
                                  padding: EdgeInsets.all(3),
                                  child: SvgPicture.asset('assets/svg/trash-bin.svg', height: 30, colorFilter: ColorFilter.mode(AppColor.accentColor.withAlpha(200), BlendMode.srcIn))),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          Obx(() {
            if (controller.isLoading.value && controller.remittanceList.isNotEmpty) {
              return Container(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            if (!controller.hasMore.value && controller.remittanceList.isNotEmpty) {
              return Container(
                padding: EdgeInsets.all(16),
                child: Text(
                  "همه تراکنش‌ها نمایش داده شد",
                  textAlign: TextAlign.center,
                  style: AppTextStyle.bodyText.copyWith(
                    color: AppColor.textColor.withAlpha(175),
                  ),
                ),
              );
            }
            return SizedBox.shrink();
          }),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
