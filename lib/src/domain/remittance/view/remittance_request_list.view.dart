import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/remittance/controller/remittance_request.controller.dart';
import 'package:hanigold_admin/src/widget/custom_appbar1.widget.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../config/repository/url/base_url.dart';
import '../../../widget/app_drawer.widget.dart';
import '../../../widget/background_image_total.widget.dart';
import '../../../widget/custom_appbar.widget.dart';
import '../../../widget/err_page.dart';
import '../../../widget/pager_widget.dart';
import '../../home/widget/chat_dialog.widget.dart';

class RemittanceRequestListView extends StatefulWidget {
  const RemittanceRequestListView({super.key});

  @override
  State<RemittanceRequestListView> createState() => _RemittanceRequestListViewState();
}

class _RemittanceRequestListViewState extends State<RemittanceRequestListView> {
  final RemittanceRequestController controller = Get.find<RemittanceRequestController>();

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    return Obx(() => Scaffold(
      appBar: CustomAppbar1(
        title: 'لیست حواله های درخواستی',
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
                                if (controller.searchController.text.isNotEmpty) {
                                  await controller.searchAccounts(
                                      controller.searchController.text
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
                                        Get.toNamed('/remittancesRequestList');
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

                                    Row(
                                      children: [
                                        // خروجی اکسل
                                        /*ElevatedButton(
                                          style: ButtonStyle(
                                              padding:isDesktop ? WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 23,vertical: 19)) :
                                              WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 21,vertical: 17)),
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
                                          child: Text(
                                            'خروجی اکسل',
                                            style: AppTextStyle.labelText,
                                          ),
                                        ),*/
                                        SizedBox(width: 5,),
                                        // خروجی pdf
                                        /*ElevatedButton(
                                          style: ButtonStyle(
                                              padding:isDesktop ? WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 23,vertical: 19)):
                                              WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 21,vertical: 17)),
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
                                        ),*/
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
                                                                  controller.clearFilter();
                                                                  controller.getRemittanceRequestListPager();
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
                                                                    controller: controller.nameController,
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
                                                            controller.getRemittanceRequestListPager();
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
                                            controller.nameController.text!="" ||  controller.dateStartController.text!="" || controller.dateEndController.text!="" ?AppColor.accentColor:  AppColor
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
                                                : 10,color: controller.nameController.text!="" || controller.dateStartController.text!="" || controller.dateEndController.text!="" ?AppColor.accentColor: AppColor.textColor),
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
                                       DataTable(
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
                                          dataRowMaxHeight: 100,
                                          //dataRowColor: WidgetStatePropertyAll(AppColor.secondaryColor),
                                          //headingRowColor: WidgetStatePropertyAll(AppColor.primaryColor.withOpacity(0.2)),
                                          headingRowHeight: 50,
                                          columnSpacing: 20,
                                          horizontalMargin: 10,
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
                controller.clearSearch();
                controller.getRemittanceRequestListPager();
              },
              title: "خطا در دریافت لیست حواله",
              des: 'برای دریافت لیست حواله ها مجددا تلاش کنید',
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
      builder: (context) => AlertDialog(backgroundColor: AppColor.backGroundColor,
        title: Text('انتخاب کنید',style: AppTextStyle.smallTitleText,),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: controller.searchedAccounts.length,
            itemBuilder: (context, index) {
              final account = controller.searchedAccounts[index];
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
          /*onSort: (columnIndex, ascending) {
            controller.onSort(columnIndex, ascending);
          }*/
      ),
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 80),
              child: Text('بابت',
                  style: AppTextStyle.labelText.copyWith(fontSize: 12))),
          headingRowAlignment: MainAxisAlignment.center,
          onSort: (columnIndex, ascending) {
            controller.onSort(columnIndex, ascending);
          }
      ),
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 80),
              child: Text('طرف مقابل',
                  style: AppTextStyle.labelText.copyWith(fontSize: 12))),
          headingRowAlignment: MainAxisAlignment.center,
          onSort: (columnIndex, ascending) {
            controller.onSort(columnIndex, ascending);
          }
      ),
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
              child: Text('عملیات',
                  style: AppTextStyle.labelText.copyWith(fontSize: 12))),
          headingRowAlignment: MainAxisAlignment.center),
    ];
  }

  List<DataRow> buildDataRows(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    return controller.remittanceRequestList.map((remittanceRequest) {
      return DataRow(
        cells: [
          // ردیف
          DataCell(
            Center(
              child:
              Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("${remittanceRequest.rowNum}",
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
              remittanceRequest.date?.toPersianDate() ?? 'نامشخص',
              style: AppTextStyle.bodyText.copyWith(fontSize: 10),
              textDirection: TextDirection.ltr,
            ),
          )),
          // نام ثبت کننده
          DataCell(Center(
            child: Text(
              remittanceRequest.account?.name ?? 'نامشخص',
              style: AppTextStyle.bodyText.copyWith(fontSize: 11),
            ),
          )),
          // بابت
          DataCell(Center(
            child:
                Text("${remittanceRequest.description ?? 'نامشخص'} ",
                    style: AppTextStyle.bodyText
                        .copyWith(color: AppColor.primaryColor, fontSize: 13)),

          )),
          // طرف مقابل
          DataCell(Center(
            child:
            Text("${remittanceRequest.toDescription ?? 'نامشخص'} ",
                style: AppTextStyle.bodyText
                    .copyWith(color: AppColor.dividerColor, fontSize: 13)),

          )),
          // محصول
          DataCell(Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network('${BaseUrl.baseUrl}Attachment/downloadResource?fileName=${remittanceRequest.wallet?.item?.icon}',
                  width: 25,
                  height: 25,),
                SizedBox(width: 5,),
                Text(
                  remittanceRequest.wallet?.item?.name ?? 'نامشخص',
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
              remittanceRequest.wallet?.item?.itemUnit?.id == 1
                  ? "${remittanceRequest.quantity} عدد "
                  : remittanceRequest.wallet?.item?.itemUnit?.id == 2
                  ? "${remittanceRequest.quantity} گرم "
                  : "${remittanceRequest.quantity.toString().seRagham()} ریال ",
              style: AppTextStyle.bodyText.copyWith(fontSize: 12),
            ),
          )),
          // وضعیت
          DataCell(
            Center(
              child: Column(
                children: [
                  SizedBox(height: 5,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    decoration: BoxDecoration(
                        color: remittanceRequest.status == 0
                            ? AppColor.textFieldColor
                            : remittanceRequest.status == 1
                            ? AppColor.secondary2Color
                            : AppColor.accentColor,
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(
                      remittanceRequest.status == 0 ? 'در انتظار'
                          : remittanceRequest.status == 1
                          ? 'تایید شده'
                          : 'تایید نشده',
                      style: AppTextStyle.bodyText
                          .copyWith(color: AppColor.textColor, fontSize: 10),
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
                      onSelected: (value) async {
                        if(value==2){
                          await controller.showReasonRejectionDialog("RemittanceRequest");
                          if (controller.selectedReasonRejection.value == null) {
                            return; // اگر کاربر دلیل را انتخاب نکرد، عملیات لغو شود
                          }
                          await controller.updateStatusRemittanceRequest(
                            remittanceRequest.id!,
                            value,
                            controller.selectedReasonRejection.value!.id!,
                          );
                        }else {
                          await controller.updateStatusRemittanceRequest(
                              remittanceRequest.id!,
                              value, 0);
                        }
                        controller.getRemittanceRequestListPager();
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
                  ),
                  SizedBox(height: 6,),
                  remittanceRequest.status==2 ?
                  Wrap(
                    children: [
                      Text('به دلیل ',
                        style: AppTextStyle
                            .labelText,),
                      Text("`${remittanceRequest.reasonRejection?.name}`",
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
          // عملیات
          DataCell(
              Center(
                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                                  controller.deleteRemittanceRequest(remittanceRequest.id!, true);
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
}
