import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/deposit/controller/deposit.controller.dart';
import 'package:hanigold_admin/src/domain/deposit/model/deposit.model.dart';
import 'package:hanigold_admin/src/widget/background_image_total.widget.dart';
import 'package:hanigold_admin/src/widget/custom_appbar1.widget.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../widget/empty.dart';
import '../../../widget/err_page.dart';
import '../../../widget/pager_widget.dart';

class DepositsListView extends StatelessWidget {
  DepositsListView({super.key});

  final DepositController depositController = Get.find<DepositController>();

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    return Scaffold(
      appBar: CustomAppbar1(
        title: 'واریزی ها',
        onBackTap: () => Get.offNamed('/home'),
      ),
      body: Stack(
        children: [
          BackgroundImageTotal(),
          SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: Get.width,
                  height: Get.height,
                  child:
                      Column(
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
                                      controller: depositController.searchController,
                                      style: AppTextStyle.labelText,
                                      textInputAction: TextInputAction.search,
                                      onFieldSubmitted: (value) async {
                                      if (value.isNotEmpty) {
                                        await depositController.searchAccounts(value);
                                        showSearchResults(context);
                                      } else {
                                    depositController.clearSearch();
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
                                              if (depositController.searchController.text.isNotEmpty) {
                                          await depositController.searchAccounts(
                                              depositController.searchController.text
                                          );
                                          showSearchResults(context);
                                          }else {
                                                depositController.clearSearch();
                                              }
                                            },
                                            icon: Icon(Icons.search,color: AppColor.textColor,size: 30,)
                                        ),
                                        suffixIcon: IconButton(
                                    onPressed: depositController.clearSearch,
                                    icon: Icon(Icons.close, color: AppColor.textColor),
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
                                          controller: depositController.searchController,
                                          style: AppTextStyle.labelText,
                                          textInputAction: TextInputAction.search,
                                          onFieldSubmitted: (value) async {
                                            if (value.isNotEmpty) {
                                              await depositController.searchAccounts(value);
                                              showSearchResults(context);
                                            } else {
                                              depositController.clearSearch();
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
                                                  if (depositController.searchController.text.isNotEmpty) {
                                                    await depositController.searchAccounts(
                                                        depositController.searchController.text
                                                    );
                                                    showSearchResults(context);
                                                  }else {
                                                    depositController.clearSearch();
                                                  }
                                                },
                                                icon: Icon(Icons.search,color: AppColor.textColor,size: 30,)
                                            ),
                                            suffixIcon: IconButton(
                                              onPressed: depositController.clearSearch,
                                              icon: Icon(Icons.close, color: AppColor.textColor),
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
                                        // خروجی اکسل
                                        ElevatedButton(
                                          style: ButtonStyle(
                                              padding: WidgetStatePropertyAll(
                                                EdgeInsets.symmetric(
                                                    horizontal: 15,vertical: 7
                                                ),
                                              ),
                                              elevation: WidgetStatePropertyAll(5),
                                              backgroundColor:
                                              WidgetStatePropertyAll(AppColor.secondary3Color),
                                              shape: WidgetStatePropertyAll(
                                                  RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(
                                                          5)))),
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
                                                                            controller: depositController.dateStartController,
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
                                                                              depositController.startDateFilter.value =
                                                                              "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";

                                                                              depositController.dateStartController.text =
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
                                                                            controller: depositController.dateEndController,
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
                                                                              depositController.endDateFilter.value =
                                                                              "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";

                                                                              depositController.dateEndController.text =
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
                                                                  depositController.exportToExcel();
                                                                  Get.back();
                                                                },
                                                                child: depositController.isLoading.value?
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
                                              backgroundColor:
                                              WidgetStatePropertyAll(AppColor.secondary3Color),
                                              shape: WidgetStatePropertyAll(
                                                  RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(
                                                          5)))),
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
                                                                            controller: depositController.dateStartController,
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
                                                                              depositController.startDateFilter.value =
                                                                              "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";

                                                                              depositController.dateStartController.text =
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
                                                                            controller: depositController.dateEndController,
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
                                                                              depositController.endDateFilter.value =
                                                                              "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";

                                                                              depositController.dateEndController.text =
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
                                                                  depositController.exportToPdf();
                                                                  Get.back();
                                                                },
                                                                child: depositController.isLoading.value?
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
                                                    height:Get.height * 0.6,
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
                                                                      depositController.clearFilter();
                                                                      depositController.getDepositListPager();
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
                                                                        controller: depositController.nameDepositFilterController,
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
                                                                      'بابت',
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
                                                                        controller: depositController.nameRequestFilterController,
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
                                                                        controller: depositController.mobileFilterController,
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
                                                                          controller: depositController.dateStartController,
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
                                                                            depositController.startDateFilter.value =
                                                                            "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";

                                                                            depositController.dateStartController.text =
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
                                                                          controller: depositController.dateEndController,
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
                                                                            depositController.endDateFilter.value =
                                                                            "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";

                                                                            depositController.dateEndController.text =
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
                                                                depositController.getDepositListPager();
                                                                Get.back();

                                                              },
                                                              child: depositController.isLoading.value?
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
                                                depositController.nameDepositFilterController.text!="" ||  depositController.mobileFilterController.text!="" || depositController.nameRequestFilterController.text!="" || depositController.dateStartController.text!="" || depositController.dateEndController.text!=""  ?AppColor.accentColor:  AppColor
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
                                                    : 10,color:  depositController.nameDepositFilterController.text!="" ||  depositController.mobileFilterController.text!="" || depositController.nameRequestFilterController.text!="" || depositController.dateStartController.text!="" || depositController.dateEndController.text!="" ?AppColor.accentColor: AppColor.textColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // لیست واریزی ها
                          Obx(() {
                            if (depositController.state.value == PageState.loading) {
                             // EasyLoading.show(status: 'لطفا منتظر بمانید...');
                              return Center(child: CircularProgressIndicator());
                            } else if (depositController.state.value == PageState.empty) {
                             // EasyLoading.dismiss();
                              return EmptyPage(
                                title: 'واریزی وجود ندارد',
                                callback: () {
                                  depositController.getDepositListPager();
                                },
                              );
                            } else if (depositController.state.value == PageState.list) {
                            //  EasyLoading.dismiss();
                              // لیست واریزی ها
                              return
                                  isDesktop ?
                                  Expanded(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Container(
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
                                                            // خروجی اکسل
                                                            ElevatedButton(
                                                              style: ButtonStyle(
                                                                  padding: WidgetStatePropertyAll(
                                                                    EdgeInsets.symmetric(
                                                                        horizontal: 15,vertical: 7
                                                                    ),
                                                                  ),
                                                                  elevation: WidgetStatePropertyAll(5),
                                                                  backgroundColor:
                                                                  WidgetStatePropertyAll(AppColor.secondary3Color),
                                                                  shape: WidgetStatePropertyAll(
                                                                      RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(
                                                                              5)))),
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
                                                                                                controller: depositController.dateStartController,
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
                                                                                                  depositController.startDateFilter.value =
                                                                                                  "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";
                                      
                                                                                                  depositController.dateStartController.text =
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
                                                                                                controller: depositController.dateEndController,
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
                                                                                                  depositController.endDateFilter.value =
                                                                                                  "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";
                                      
                                                                                                  depositController.dateEndController.text =
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
                                                                                      depositController.exportToExcel();
                                                                                      Get.back();
                                                                                    },
                                                                                    child: depositController.isLoading.value?
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
                                                                  backgroundColor:
                                                                  WidgetStatePropertyAll(AppColor.secondary3Color),
                                                                  shape: WidgetStatePropertyAll(
                                                                      RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(
                                                                              5)))),
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
                                                                                                controller: depositController.dateStartController,
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
                                                                                                  depositController.startDateFilter.value =
                                                                                                  "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";
                                      
                                                                                                  depositController.dateStartController.text =
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
                                                                                                controller: depositController.dateEndController,
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
                                                                                                  depositController.endDateFilter.value =
                                                                                                  "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";
                                      
                                                                                                  depositController.dateEndController.text =
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
                                                                                      depositController.exportToPdf();
                                                                                      Get.back();
                                                                                    },
                                                                                    child: depositController.isLoading.value?
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
                                                                        height:Get.height * 0.6,
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
                                                                                          depositController.clearFilter();
                                                                                          depositController.getDepositListPager();
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
                                                                                            controller: depositController.nameDepositFilterController,
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
                                                                                          'بابت',
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
                                                                                            controller: depositController.nameRequestFilterController,
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
                                                                                            controller: depositController.mobileFilterController,
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
                                                                                              controller: depositController.dateStartController,
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
                                                                                                depositController.startDateFilter.value =
                                                                                                "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";
                                      
                                                                                                depositController.dateStartController.text =
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
                                                                                              controller: depositController.dateEndController,
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
                                                                                                depositController.endDateFilter.value =
                                                                                                "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";
                                      
                                                                                                depositController.dateEndController.text =
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
                                                                                    depositController.getDepositListPager();
                                                                                    Get.back();
                                      
                                                                                  },
                                                                                  child: depositController.isLoading.value?
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
                                                                    depositController.nameDepositFilterController.text!="" ||  depositController.mobileFilterController.text!="" || depositController.nameRequestFilterController.text!="" || depositController.dateStartController.text!="" || depositController.dateEndController.text!=""  ?AppColor.accentColor:  AppColor
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
                                                                        : 10,color:  depositController.nameDepositFilterController.text!="" ||  depositController.mobileFilterController.text!="" || depositController.nameRequestFilterController.text!="" || depositController.dateStartController.text!="" || depositController.dateEndController.text!="" ?AppColor.accentColor: AppColor.textColor),
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
                                                                  horizontalMargin: 6,
                                                                ),
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
                                      
                                        ],
                                      ),
                                    ),
                                  ) :
                                  Expanded(
                                    child: GridView.builder(
                                        controller: depositController.scrollController,
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount:  1,
                                        mainAxisSpacing: 10,
                                        crossAxisSpacing: 10,
                                        mainAxisExtent:  190,
                                      ),
                                        itemCount: depositController.depositList.length +
                                      (depositController.hasMore.value ? 1 : 0),
                                        itemBuilder: (context, index) {
                                          print(depositController.depositList.length);
                                          if (index >= depositController.depositList.length) {
                                            return depositController.hasMore.value
                                                ? Center(child: CircularProgressIndicator())
                                                : SizedBox.shrink();
                                          }
                                          var deposits = depositController.depositList[index];
                                          return Card(
                                            //margin: EdgeInsets.all( 8),
                                            color: AppColor.secondaryColor,
                                            elevation: 10,
                                            child: Padding(
                                              padding: EdgeInsets.all( 5),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  ListTile(
                                                    title: Column(
                                                      children: [
                                                        Column(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            //تاریخ درخواست
                                                            Row(mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                Text(
                                                                  'تاریخ درخواست: ',
                                                                  style:
                                                                  AppTextStyle.labelText,
                                                                ),
                                                                SizedBox(
                                                                  height: 2,
                                                                ),
                                                                Text(
                                                                  deposits.date != null
                                                                      ? deposits.date!
                                                                      .toPersianDate(
                                                                      twoDigits: true,
                                                                      showTime: true,
                                                                      timeSeprator:
                                                                      '-')
                                                                      : 'تاریخ نامشخص',
                                                                  style:
                                                                  AppTextStyle.bodyText,
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(height: 8,),
                                                            //نام کاربر
                                                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment.center,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                      'نام کاربر: ',
                                                                      style:
                                                                          AppTextStyle.labelText,
                                                                    ),
                                                                    SizedBox(
                                                                      height: 2,
                                                                    ),
                                                                    Text(
                                                                      deposits.wallet?.account?.name ?? "",
                                                                      style:
                                                                          AppTextStyle.bodyText,
                                                                    ),
                                                                  ],
                                                                ),
                                                                /*Row(
                                                                  children: [
                                                                    Text('الصاق تصویر ',style: AppTextStyle.labelText,),
                                                                    GestureDetector(
                                                                      *//*onTap: () =>
                                                                        depositController.pickImage(deposits.recId.toString(), "image", "Deposit"),*//*
                                                                      child: SvgPicture.asset('assets/svg/camera.svg',
                                                                        width: 25,
                                                                        height: 25,
                                                                        colorFilter: ColorFilter.mode(AppColor.iconViewColor, BlendMode.srcIn),),
                                                                    )
                                                                  ],
                                                                )*/
                                                              ],
                                                            ),

                                                          ],
                                                        ),
                                                        SizedBox(height: 6,),
                                                        //  ردیف دوم
                                                        Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment.spaceEvenly,
                                                          children: [
                                                            SizedBox(
                                                              height: 4,
                                                            ),
                                                            // مبلغ و مشاهده درخواست
                                                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment.center,
                                                              children: [

                                                                // مبلغ
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                      'مبلغ: ',
                                                                      style:
                                                                          AppTextStyle.labelText,
                                                                    ),
                                                                    SizedBox(
                                                                      width: 3,
                                                                    ),
                                                                    Text(
                                                                      "${deposits.amount == null ? 0 : deposits.amount?.toInt().toString().seRagham(separator: ',')} ریال",
                                                                      style:
                                                                          AppTextStyle.bodyText,
                                                                    ),
                                                                  ],
                                                                ),

                                                                // آیکون مشاهده
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    Get.toNamed('/depositRequestGetOne',parameters:{"id":deposits.depositRequest!.id.toString()});
                                                                  },
                                                                  child: Row(
                                                                    children: [
                                                                      Text('مشاهده درخواست ',style: AppTextStyle.labelText.copyWith(color: AppColor.iconViewColor),),
                                                                      Container(
                                                                        width: 20,
                                                                        height: 20,
                                                                        child: SvgPicture.asset(
                                                                              'assets/svg/eye1.svg',
                                                                              colorFilter:
                                                                              ColorFilter.mode(
                                                                                AppColor.iconViewColor,
                                                                                BlendMode.srcIn,
                                                                              ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(height: 4,),
                                                            // دلیل رد
                                                            /*deposits.status==2 ?
                                                            Row(
                                                              crossAxisAlignment: CrossAxisAlignment
                                                                  .center,
                                                              children: [
                                                                Text('دلیل رد: ',
                                                                  style: AppTextStyle
                                                                      .labelText,),
                                                                SizedBox(width: 3,),
                                                                Text("`${deposits.reasonRejection?.name}`" ?? "",
                                                                  style: AppTextStyle
                                                                      .bodyText,),
                                                              ],
                                                            ) : Text(""),*/
                                                          ],
                                                        ),
                                                        SizedBox(height: 6,),
                                                        // کد رهگیری
                                                        Row(
                                                          children: [
                                                            Text('کد رهگیری: ', style: AppTextStyle.labelText,
                                                            ),
                                                            SizedBox(width: 3,),
                                                            Text("${deposits.trackingNumber ?? 0}",
                                                              style: AppTextStyle.bodyText,
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Divider(
                                                          height: 1,
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),

                                                        // تعیین وضعیت
                                                        /*Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Text('وضعیت: ',style: AppTextStyle
                                                                    .bodyText),
                                                                Text(
                                                                  '${deposits.status == 0 ? 'نامشخص' : deposits.status == 1 ? 'تایید شده' : 'تایید نشده'} ',
                                                                  style: AppTextStyle
                                                                      .bodyText.copyWith(
                                                                    color: deposits.status == 1
                                                                        ? AppColor.primaryColor
                                                                        : deposits.status == 2
                                                                        ? AppColor.accentColor
                                                                        : AppColor.textColor,
                                                                  )
                                                                  ,),
                                                              ],
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
                                                                onSelected: (value) async {
                                                                  if(value==2){
                                                                    await depositController.showReasonRejectionDialog("Deposit");
                                                                    if (depositController.selectedReasonRejection.value == null) {
                                                                      return; // اگر کاربر دلیل را انتخاب نکرد، عملیات لغو شود
                                                                    }
                                                                    await depositController.updateStatusDeposit(
                                                                      deposits.id!,
                                                                      value,
                                                                      depositController.selectedReasonRejection.value!.id!,
                                                                    );
                                                                  }else {
                                                                    await depositController.updateStatusDeposit(
                                                                        deposits.id!,
                                                                        value, 0);
                                                                  }
                                                                  depositController.fetchDepositList();
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
                                                                  PopupMenuItem<int>(height: 20,
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
                                                                        depositController.isLoading.value
                                                                            ?
                                                                        CircularProgressIndicator(
                                                                          valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor),
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
                                                                  PopupMenuItem<int>(height: 20,
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
                                                                        depositController.isLoading.value
                                                                            ?
                                                                        CircularProgressIndicator(
                                                                          valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor),
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
                                                        ),
                                                        SizedBox(height: 8,),*/
                                                        Row(mainAxisAlignment: MainAxisAlignment
                                                            .spaceBetween,
                                                          children: [
                                                            // رجیستر
                                                            Checkbox(
                                                              value: deposits.registered ?? false,
                                                              onChanged: (value) async{
                                                                if (value != null) {
                                                                  //EasyLoading.show(status: 'لطفا منتظر بمانید');
                                                                  await depositController.updateRegistered(
                                                                      deposits.id!,
                                                                      value
                                                                  );
                                                                }
                                                                depositController.getDepositListPager();
                                                                //EasyLoading.dismiss();
                                                              },
                                                            ),
                                                            // آیکون ویرایش
                                                            GestureDetector(
                                                              onTap: () {
                                                                /*if (deposits.status==1){
                                                                  Get.defaultDialog(
                                                                    title: 'هشدار',
                                                                    middleText: 'به دلیل تایید واریزی قابل ویرایش نیست',
                                                                    titleStyle: AppTextStyle
                                                                        .smallTitleText,
                                                                    middleTextStyle: AppTextStyle
                                                                        .bodyText,
                                                                    backgroundColor: AppColor
                                                                        .backGroundColor,
                                                                    textCancel: 'بستن',
                                                                  );
                                                                }else {*/
                                                                  Get.toNamed('/depositUpdate', parameters:{"id":deposits.id.toString()});
                                                                //}
                                                              },
                                                              child: Row(
                                                                children: [
                                                                  Text(' ویرایش',style: AppTextStyle.labelText.copyWith(color: AppColor.iconViewColor),),
                                                                  SvgPicture.asset(
                                                                      'assets/svg/edit.svg',
                                                                      colorFilter: ColorFilter
                                                                          .mode(AppColor
                                                                          .iconViewColor,
                                                                        BlendMode.srcIn,)
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            // آیکون حذف کردن
                                                            GestureDetector(
                                                              onTap: () {
                                                                /*if (deposits.status==1){
                                                                  Get.defaultDialog(
                                                                    title: 'هشدار',
                                                                    middleText: 'به دلیل تایید واریزی قابل حذف نیست',
                                                                    titleStyle: AppTextStyle
                                                                        .smallTitleText,
                                                                    middleTextStyle: AppTextStyle
                                                                        .bodyText,
                                                                    backgroundColor: AppColor
                                                                        .backGroundColor,
                                                                    textCancel: 'بستن',
                                                                  );
                                                                }else {*/
                                                                  Get.defaultDialog(
                                                                      backgroundColor: AppColor.backGroundColor,
                                                                      title: "حذف واریزی",
                                                                      titleStyle: AppTextStyle.smallTitleText,
                                                                      middleText: "آیا از حذف واریزی مطمئن هستید؟",
                                                                      middleTextStyle: AppTextStyle.bodyText,
                                                                      confirm: ElevatedButton(
                                                                          style: ButtonStyle(
                                                                              backgroundColor: WidgetStatePropertyAll(
                                                                                  AppColor.primaryColor)),
                                                                          onPressed: () {
                                                                            Get.back();
                                                                            depositController.deleteDeposit(
                                                                                deposits.id!, true);
                                                                          },
                                                                          child: Text(
                                                                            'حذف',
                                                                            style: AppTextStyle.bodyText,
                                                                          )));
                                                                //}
                                                              },
                                                              child: Row(
                                                                children: [
                                                                  Text(' حذف',style: AppTextStyle.labelText.copyWith(color: AppColor.accentColor),),
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
                                                        )

                                                      ],
                                                    ),
                                                    minVerticalPadding: 5,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                  );

                            }
                           // EasyLoading.dismiss();
                            return ErrPage(
                              callback: () {
                                depositController.clearFilter();
                                depositController.getDepositListPager();
                              },
                              title: "خطا در دریافت واریزی ها",
                              des: 'برای دریافت لیست واریزی ها مجددا تلاش کنید',
                            );
                          }),
                        ],
                      ),

                ),
              ),
            ),
          Obx(()=>Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              depositController.paginated.value!=null?   Container(
                  height: 70,
                  margin: EdgeInsets.symmetric(horizontal: 70,vertical: 10),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  color: AppColor.appBarColor.withOpacity(0.5),
                  alignment: Alignment.bottomCenter,
                  child:PagerWidget(countPage: depositController.paginated.value?.totalCount??0, callBack: (int index) {
                    depositController.isChangePage(index);
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
      builder: (context) => AlertDialog(backgroundColor: AppColor.backGroundColor,
        title: Text('انتخاب کنید',style: AppTextStyle.smallTitleText,),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: depositController.searchedAccounts.length,
            itemBuilder: (context, index) {
              final account = depositController.searchedAccounts[index];
              return ListTile(
                title: Text(account.name ?? '',style: AppTextStyle.bodyText.copyWith(fontSize: 15),),
                onTap: () => depositController.selectAccount(account),
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
      DataColumn(label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
          child: Text('تاریخ', style: AppTextStyle.labelText)),headingRowAlignment:MainAxisAlignment.center ),
      DataColumn(label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
          child: Text('نام کاربر', style: AppTextStyle.labelText)),headingRowAlignment:MainAxisAlignment.center ),
      DataColumn(label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
          child: Text('بابت', style: AppTextStyle.labelText)),headingRowAlignment:MainAxisAlignment.center ),
      DataColumn(label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
          child: Text('مبلغ', style: AppTextStyle.labelText)),headingRowAlignment:MainAxisAlignment.center ),
      DataColumn(label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
          child: Text('کد رهگیری', style: AppTextStyle.labelText)),headingRowAlignment:MainAxisAlignment.center ),
      DataColumn(label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
          child: Text('مشاهده در خواست', style: AppTextStyle.labelText)),headingRowAlignment:MainAxisAlignment.center ),
      DataColumn(label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
          child: Text('وضعیت', style: AppTextStyle.labelText)),headingRowAlignment:MainAxisAlignment.center ),
      /*DataColumn(label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
          child: Text('الصاق تصویر', style: AppTextStyle.labelText)),headingRowAlignment:MainAxisAlignment.center ),*/
      DataColumn(label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
          child: Text('عملیات', style: AppTextStyle.labelText)),headingRowAlignment:MainAxisAlignment.center ),
    ];
  }

  List<DataRow> buildDataRows(BuildContext context) {
    return depositController.depositList.map((deposit) {
      return DataRow(

        cells: [
          // ردیف
          DataCell(
              Center(
                child: Row(
                  children: [
                    // رجیستر
                    Checkbox(
                      value: deposit.registered ?? false,
                      onChanged: (value) async{
                        if (value != null) {
                          //EasyLoading.show(status: 'لطفا منتظر بمانید');
                          await depositController.updateRegistered(
                              deposit.id!,
                              value
                          );
                        }
                        depositController.getDepositListPager();
                        //EasyLoading.dismiss();
                      },
                    ),
                    SizedBox(width: 5,),
                    Text(
                      "${deposit.rowNum}",
                      style: AppTextStyle.labelText,
                    ),
                  ],
                ),
              )),
          // تاریخ
          DataCell(
              Center(
                child: Text(
                  deposit.date != null
                      ? deposit.date?.toPersianDate(
                      twoDigits: true,
                      showTime: true,
                      timeSeprator:
                      '-') ?? ''
                      : 'تاریخ نامشخص',
                  style:
                  AppTextStyle.bodyText,
                ),
              )),
          // نام کاربر
          DataCell(
              Center(
                child: Text(
                  deposit.wallet?.account?.name ?? "",
                  style:
                  AppTextStyle.bodyText,
                ),
              )),
          // بابت
          DataCell(
              Center(
                child: Text(
                  deposit.walletWithdraw?.account?.name ?? "",
                  style:
                  AppTextStyle.bodyText,
                ),
              )),
          // مبلغ
          DataCell(
              Center(
                child: Text(
                  "${deposit.amount == null ? 0 : deposit.amount?.toInt().toString().seRagham(separator: ',')} ریال",
                  style:
                  AppTextStyle.bodyText,
                ),
              )),
          // کد رهگیری
          DataCell(
              Center(
                child: Text(
                  deposit.trackingNumber ?? "",
                  style:
                  AppTextStyle.bodyText,
                ),
              )),
          // مشاهده درخواست
          DataCell(
              Center(
                child: GestureDetector(
                  onTap: () {
                    Get.toNamed('/depositRequestGetOne',parameters:{"id":deposit.depositRequest!.id.toString()});
                  },
                  child: Row(
                    children: [
                      Text('مشاهده درخواست ',style: AppTextStyle.labelText.copyWith(color: AppColor.iconViewColor),),
                      Container(
                        width: 20,
                        height: 20,
                        child: SvgPicture.asset(
                          'assets/svg/eye1.svg',
                          colorFilter:
                          ColorFilter.mode(
                            AppColor.iconViewColor,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
          // وضعیت
          DataCell(
            Center(
              child: Column(
                children: [
                  SizedBox(height: 5,),
                  Text(
                    '${deposit.status == 0 ? 'نامشخص' : deposit.status == 1
                        ? 'تایید شده'
                        : 'تایید نشده'} ',
                    style: AppTextStyle
                        .bodyText.copyWith(
                      color: deposit.status == 1
                          ? AppColor.primaryColor
                          : deposit.status == 2
                          ? AppColor.accentColor
                          : AppColor.textColor,
                    ),
                  ),
                  /*SizedBox(height: 6,),
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
                          await depositController.showReasonRejectionDialog("Deposit");
                          if (depositController.selectedReasonRejection.value == null) {
                            return; // اگر کاربر دلیل را انتخاب نکرد، عملیات لغو شود
                          }
                          await depositController.updateStatusDeposit(
                            deposit.id!,
                            value,
                            depositController.selectedReasonRejection.value!.id!,
                          );
                        }else {
                          await depositController.updateStatusDeposit(
                              deposit.id!,
                              value, 0);
                        }
                        depositController.fetchDepositList();
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
                              depositController.isLoading.value
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
                              depositController.isLoading.value
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
                  deposit.status==2 ?
                  Wrap(
                    children: [
                      Text('به دلیل ',
                        style: AppTextStyle
                            .labelText,),
                      Text("`${deposit
                          .reasonRejection
                          ?.name}`",
                        style: AppTextStyle
                            .bodyText,),
                      Text('رد شد.',
                        style: AppTextStyle
                            .labelText,),
                    ],
                  ) : Text(""),*/
                ],
              ),
            ),
          ),
          //الصاق تصویر
          /*DataCell(
            Center(
              child: GestureDetector(
                *//*onTap: () =>
                    depositController.pickImageDesktop(deposit.recId.toString(), "image", "Deposit"),*//*
                child: SvgPicture.asset('assets/svg/camera.svg',
                  width: 25,
                  height: 25,
                  colorFilter: ColorFilter.mode(AppColor.iconViewColor, BlendMode.srcIn),),
              )
            ),
          ),*/
          // آیکون های عملیات
          DataCell(
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // آیکون ویرایش
                  GestureDetector(
                    onTap: () {
                      /*if (deposit.status==1){
                        Get.defaultDialog(
                          title: 'هشدار',
                          middleText: 'به دلیل تایید واریزی قابل ویرایش نیست',
                          titleStyle: AppTextStyle
                              .smallTitleText,
                          middleTextStyle: AppTextStyle
                              .bodyText,
                          backgroundColor: AppColor
                              .backGroundColor,
                          textCancel: 'بستن',
                        );
                      }else {*/
                        Get.toNamed('/depositUpdate', parameters:{"id":deposit.id.toString()});
                        print("depositId:::::${deposit.id}");
                      //}
                    },
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(' ویرایش',style: AppTextStyle.labelText.copyWith(color: AppColor.textColor),),
                        SvgPicture.asset(
                            'assets/svg/edit.svg',height: 20,
                            colorFilter: ColorFilter
                                .mode(AppColor
                                .textColor,
                              BlendMode.srcIn,)
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10,),
                  // آیکون حذف کردن
                  GestureDetector(
                    onTap: () {
                      /*if (deposit.status==1){
                        Get.defaultDialog(
                          title: 'هشدار',
                          middleText: 'به دلیل تایید واریزی قابل حذف نیست',
                          titleStyle: AppTextStyle
                              .smallTitleText,
                          middleTextStyle: AppTextStyle
                              .bodyText,
                          backgroundColor: AppColor
                              .backGroundColor,
                          textCancel: 'بستن',
                        );
                      }else {*/
                        Get.defaultDialog(
                            backgroundColor: AppColor.backGroundColor,
                            title: "حذف واریزی",
                            titleStyle: AppTextStyle.smallTitleText,
                            middleText: "آیا از حذف واریزی مطمئن هستید؟",
                            middleTextStyle: AppTextStyle.bodyText,
                            confirm: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: WidgetStatePropertyAll(
                                        AppColor.primaryColor)),
                                onPressed: () {
                                  Get.back();
                                  depositController.deleteDeposit(
                                      deposit.id!, true);
                                },
                                child: Text(
                                  'حذف',
                                  style: AppTextStyle.bodyText,
                                )));
                      //}
                    },
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(' حذف',style: AppTextStyle.labelText.copyWith(color: AppColor.textColor),),
                        SvgPicture.asset(
                            'assets/svg/trash-bin.svg',height: 20,
                            colorFilter: ColorFilter
                                .mode(AppColor
                                .textColor,
                              BlendMode.srcIn,)
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10,),
                ],
              ),
            ),
          ),
        ],
      );
    }).toList();
  }


}
