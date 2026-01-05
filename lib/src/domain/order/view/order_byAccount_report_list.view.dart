import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/order/controller/order_byAccount_report.controller.dart';
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
import '../../home/widget/chat_dialog.widget.dart';

class OrderByAccountReportListView extends StatefulWidget {
  const OrderByAccountReportListView({super.key});

  @override
  State<OrderByAccountReportListView> createState() => _OrderByAccountReportListViewState();
}

class _OrderByAccountReportListViewState extends State<OrderByAccountReportListView> {
  final OrderByAccountReportController controller = Get.find<OrderByAccountReportController>();

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    return Obx(() => Scaffold(
      appBar: CustomAppbar1(
        title: 'گزارش لیست کارکرد',
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
                    isDesktop ?
                        SizedBox.shrink() :
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: isDesktop ? 30 : 15,vertical: 2 ),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      //color: AppColor.appBarColor.withOpacity(0.5),
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
                      margin: EdgeInsets.symmetric(horizontal:isDesktop ? 50 : 15,vertical:isDesktop ?  10 : 2),
                      padding: EdgeInsets.symmetric(horizontal:isDesktop ? 10 : 2,vertical:isDesktop ? 20 : 2),
                      decoration: BoxDecoration(
                        color: isDesktop ? AppColor.backGroundColor1 : AppColor.backGroundColor.withAlpha(130),
                        borderRadius: BorderRadius.circular(10),
                       // border: Border.all(color: const Color(0xFF64748B)),
                      ),
                      child: Column(
                        children: [
                          isDesktop ?
                          // Container(
                          //   padding: EdgeInsets.symmetric(horizontal: 10 ,vertical: 10),
                          //   margin: EdgeInsets.symmetric(
                          //       horizontal:  30 , vertical: 4),
                          //   decoration: BoxDecoration(
                          //     color: AppColor.appBarColor.withAlpha(30),
                          //     borderRadius: BorderRadius.circular(10),
                          //     //border: Border.all(color: const Color(0xFF64748B)),
                          //   ),
                          //   child:
                          //   Row(
                          //     mainAxisAlignment: MainAxisAlignment.start,
                          //     children: [
                          //       // فیلتر
                          //       OutlinedButton.icon(
                          //           onPressed: () async {
                          //             showGeneralDialog(
                          //                 context: context,
                          //                 barrierDismissible: true,
                          //                 barrierLabel: MaterialLocalizations.of(context)
                          //                     .modalBarrierDismissLabel,
                          //                 barrierColor: Colors.black45,
                          //                 transitionDuration: const Duration(milliseconds: 200),
                          //                 pageBuilder: (BuildContext buildContext,
                          //                     Animation animation,
                          //                     Animation secondaryAnimation) {
                          //                   return Center(
                          //                     child: Material(
                          //                       color: Colors.transparent,
                          //                       child: Container(
                          //                         decoration: BoxDecoration(
                          //                             borderRadius: BorderRadius.circular(8),
                          //                             color: AppColor.backGroundColor
                          //                         ),
                          //                         width:isDesktop?  Get.width * 0.2:Get.width * 0.65,
                          //                         height:isDesktop?  Get.height * 0.5:Get.height * 0.7,
                          //                         padding: EdgeInsets.all(20),
                          //                         child: SingleChildScrollView(
                          //                           child: Column(
                          //                             children: [
                          //                               Padding(
                          //                                 padding: const EdgeInsets.all(8.0),
                          //                                 child: Row(
                          //                                   mainAxisAlignment: MainAxisAlignment.end,
                          //                                   children: [
                          //                                     Expanded(
                          //                                       child: Center(
                          //                                         child: Text(
                          //                                           'فیلتر',
                          //                                           style: AppTextStyle.labelText.copyWith(
                          //                                             fontSize: 15,
                          //                                             fontWeight: FontWeight.normal,
                          //                                           ),
                          //                                         ),
                          //                                       ),
                          //                                     ),
                          //                                     SizedBox(
                          //                                       width: 50,height: 27,
                          //                                       child: ElevatedButton(
                          //                                         style: ButtonStyle(
                          //                                             padding: WidgetStatePropertyAll(
                          //                                                 EdgeInsets.symmetric(horizontal: 2,vertical: 1)),
                          //                                             // elevation: WidgetStatePropertyAll(5),
                          //                                             backgroundColor:
                          //                                             WidgetStatePropertyAll(AppColor.accentColor.withOpacity(0.5)),
                          //                                             shape: WidgetStatePropertyAll(RoundedRectangleBorder(side: BorderSide(color: AppColor.textColor),
                          //                                                 borderRadius: BorderRadius.circular(5)))),
                          //                                         onPressed: () async {
                          //                                           controller.clearFilter();
                          //                                           controller.getOrderByAccountReportPager();
                          //                                           Get.back();
                          //                                         },
                          //                                         child: Text(
                          //                                           'حذف فیلتر',
                          //                                           style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 9 : 8),
                          //                                         ),
                          //                                       ),
                          //                                     ),
                          //                                   ],
                          //                                 ),
                          //                               ),
                          //                               Container(
                          //                                 color: AppColor.textColor,height: 0.2,
                          //                               ),
                          //                               Padding(
                          //                                 padding: const EdgeInsets.symmetric(horizontal: 10),
                          //                                 child: Column(
                          //                                   children: [
                          //                                     SizedBox(height: 8,),
                          //                                     Column(
                          //                                       crossAxisAlignment:
                          //                                       CrossAxisAlignment.start,
                          //                                       children: [
                          //                                         Text(
                          //                                           'نام',
                          //                                           style: AppTextStyle.labelText.copyWith(
                          //                                               fontSize: 11,
                          //                                               fontWeight: FontWeight.normal,
                          //                                               color: AppColor.textColor),
                          //                                         ),
                          //                                         SizedBox(height: 10,),
                          //                                         IntrinsicHeight(
                          //                                           child: TextFormField(
                          //                                             autovalidateMode: AutovalidateMode
                          //                                                 .onUserInteraction,
                          //                                             controller: controller.nameController,
                          //                                             style: AppTextStyle.labelText.copyWith(fontSize: 15),
                          //                                             textAlign: TextAlign.start,
                          //                                             keyboardType:TextInputType.text,
                          //                                             decoration: InputDecoration(
                          //                                               contentPadding:
                          //                                               const EdgeInsets.symmetric(
                          //                                                   vertical: 11,horizontal: 15
                          //                                               ),
                          //                                               isDense: true,
                          //                                               border: OutlineInputBorder(
                          //                                                 borderRadius:
                          //                                                 BorderRadius.circular(6),
                          //                                               ),
                          //                                               filled: true,
                          //                                               fillColor: AppColor.textFieldColor,
                          //                                               errorMaxLines: 1,
                          //                                             ),
                          //                                           ),
                          //                                         ),
                          //                                       ],
                          //                                     ),
                          //                                     SizedBox(height: 8,),
                          //                                     Column(
                          //                                       crossAxisAlignment: CrossAxisAlignment.start,
                          //                                       children: [
                          //                                         Text(
                          //                                           'از تاریخ',
                          //                                           style: AppTextStyle.labelText.copyWith(fontSize: 13,
                          //                                               fontWeight: FontWeight.normal,color: AppColor.textColor ),
                          //                                         ),
                          //                                         Container(
                          //                                           //height: 50,
                          //                                           padding: EdgeInsets.only(bottom: 5),
                          //                                           child: IntrinsicHeight(
                          //                                             child: TextFormField(
                          //                                               validator: (value){
                          //                                                 if(value==null || value.isEmpty){
                          //                                                   return 'لطفا تاریخ را انتخاب کنید';
                          //                                                 }
                          //                                                 return null;
                          //                                               },
                          //                                               controller: controller.dateStartController,
                          //                                               readOnly: true,
                          //                                               style: AppTextStyle.labelText,
                          //                                               decoration: InputDecoration(
                          //                                                 suffixIcon: Icon(Icons.calendar_month, color: AppColor.textColor),
                          //                                                 border: OutlineInputBorder(
                          //                                                   borderRadius: BorderRadius.circular(10),
                          //                                                 ),
                          //                                                 filled: true,
                          //                                                 fillColor: AppColor.textFieldColor,
                          //                                                 errorMaxLines: 1,
                          //                                               ),
                          //                                               onTap: () async {
                          //                                                 Jalali? pickedDate = await showPersianDatePicker(
                          //                                                   context: context,
                          //                                                   initialDate: Jalali.now(),
                          //                                                   firstDate: Jalali(1400,1,1),
                          //                                                   lastDate: Jalali(1450,12,29),
                          //                                                   initialEntryMode: PersianDatePickerEntryMode.calendar,
                          //                                                   initialDatePickerMode: PersianDatePickerMode.day,
                          //                                                   locale: Locale("fa","IR"),
                          //                                                 );
                          //                                                 Gregorian gregorian= pickedDate!.toGregorian();
                          //                                                 controller.startDateFilter.value =
                          //                                                 "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";
                          //
                          //                                                 controller.dateStartController.text =
                          //                                                 "${pickedDate.year}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.day.toString().padLeft(2, '0')}";
                          //
                          //                                               },
                          //                                             ),
                          //                                           ),
                          //                                         ),
                          //                                       ],
                          //                                     ),
                          //                                     SizedBox(height: 8),
                          //                                     Column(
                          //                                       crossAxisAlignment: CrossAxisAlignment.start,
                          //                                       children: [
                          //                                         Text(
                          //                                           'تا تاریخ',
                          //                                           style: AppTextStyle.labelText.copyWith(fontSize: 13,
                          //                                               fontWeight: FontWeight.normal,color: AppColor.textColor ),
                          //                                         ),
                          //                                         Container(
                          //                                           //height: 50,
                          //                                           padding: EdgeInsets.only(bottom: 5),
                          //                                           child: IntrinsicHeight(
                          //                                             child: TextFormField(
                          //                                               validator: (value){
                          //                                                 if(value==null || value.isEmpty){
                          //                                                   return 'لطفا تاریخ را انتخاب کنید';
                          //                                                 }
                          //                                                 return null;
                          //                                               },
                          //                                               controller: controller.dateEndController,
                          //                                               readOnly: true,
                          //                                               style: AppTextStyle.labelText,
                          //                                               decoration: InputDecoration(
                          //                                                 suffixIcon: Icon(Icons.calendar_month, color: AppColor.textColor),
                          //                                                 border: OutlineInputBorder(
                          //                                                   borderRadius: BorderRadius.circular(10),
                          //                                                 ),
                          //                                                 filled: true,
                          //                                                 fillColor: AppColor.textFieldColor,
                          //                                                 errorMaxLines: 1,
                          //                                               ),
                          //                                               onTap: () async {
                          //                                                 Jalali? pickedDate = await showPersianDatePicker(
                          //                                                   context: context,
                          //                                                   initialDate: Jalali.now(),
                          //                                                   firstDate: Jalali(1400,1,1),
                          //                                                   lastDate: Jalali(1450,12,29),
                          //                                                   initialEntryMode: PersianDatePickerEntryMode.calendar,
                          //                                                   initialDatePickerMode: PersianDatePickerMode.day,
                          //                                                   locale: Locale("fa","IR"),
                          //                                                 );
                          //                                                 // DateTime date=DateTime.now();
                          //                                                 Gregorian gregorian= pickedDate!.toGregorian();
                          //                                                 controller.endDateFilter.value =
                          //                                                 "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";
                          //
                          //                                                 controller.dateEndController.text =
                          //                                                 "${pickedDate.year}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.day.toString().padLeft(2, '0')}";
                          //
                          //                                               },
                          //                                             ),
                          //                                           ),
                          //                                         ),
                          //                                       ],
                          //                                     ),
                          //
                          //                                   ],
                          //                                 ),
                          //                               ),
                          //                               //Spacer(),
                          //                               Container(
                          //                                 margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                          //                                 width: double.infinity,
                          //                                 height: 40,
                          //                                 child: ElevatedButton(
                          //                                   style: ButtonStyle(
                          //                                       padding: WidgetStatePropertyAll(
                          //                                           EdgeInsets.symmetric(horizontal: 23,vertical: 19)),
                          //                                       // elevation: WidgetStatePropertyAll(5),
                          //                                       backgroundColor:
                          //                                       WidgetStatePropertyAll(AppColor.appBarColor),
                          //                                       shape: WidgetStatePropertyAll(RoundedRectangleBorder(side: BorderSide(color: AppColor.textColor),
                          //                                           borderRadius: BorderRadius.circular(5)))),
                          //                                   onPressed: () async {
                          //                                     controller.getOrderByAccountReportPager();
                          //                                     Get.back();
                          //
                          //                                   },
                          //                                   child: controller.isLoading.value?
                          //                                   CircularProgressIndicator(
                          //                                     valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor),
                          //                                   ) :
                          //                                   Text(
                          //                                     'فیلتر',
                          //                                     style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10),
                          //                                   ),
                          //                                 ),
                          //                               ),
                          //                             ],
                          //                           ),
                          //                         ),
                          //                       ),
                          //                     ),
                          //                   );
                          //                 });
                          //           },
                          //           label: Text(
                          //             'فیلتر',
                          //             style: AppTextStyle
                          //                 .labelText
                          //                 .copyWith(
                          //                 fontSize: isDesktop
                          //                     ? 12
                          //                     : 10,color: controller.nameController.text!="" || controller.dateStartController.text!="" || controller.dateEndController.text!="" ?AppColor.accentColor: AppColor.textColor),
                          //           ),
                          //         icon: SvgPicture.asset(
                          //             'assets/svg/filter3.svg',
                          //             height: 17,
                          //             colorFilter:
                          //             ColorFilter
                          //                 .mode(
                          //               controller.nameController.text!="" ||  controller.dateStartController.text!="" || controller.dateEndController.text!="" ?AppColor.accentColor:  AppColor
                          //                   .textColor,
                          //               BlendMode
                          //                   .srcIn,
                          //             )),
                          //       ),
                          //       /*ElevatedButton(
                          //         style: ButtonStyle(
                          //             padding: WidgetStatePropertyAll(
                          //                 EdgeInsets.symmetric(horizontal: 23,vertical: 19)),
                          //             // elevation: WidgetStatePropertyAll(5),
                          //             backgroundColor:
                          //             WidgetStatePropertyAll(AppColor.appBarColor.withOpacity(0.5)),
                          //             shape: WidgetStatePropertyAll(RoundedRectangleBorder(side: BorderSide(color: AppColor.textColor),
                          //                 borderRadius: BorderRadius.circular(5)))),
                          //         onPressed: () async {
                          //           showGeneralDialog(
                          //               context: context,
                          //               barrierDismissible: true,
                          //               barrierLabel: MaterialLocalizations.of(context)
                          //                   .modalBarrierDismissLabel,
                          //               barrierColor: Colors.black45,
                          //               transitionDuration: const Duration(milliseconds: 200),
                          //               pageBuilder: (BuildContext buildContext,
                          //                   Animation animation,
                          //                   Animation secondaryAnimation) {
                          //                 return Center(
                          //                   child: Material(
                          //                     color: Colors.transparent,
                          //                     child: Container(
                          //                       decoration: BoxDecoration(
                          //                           borderRadius: BorderRadius.circular(8),
                          //                           color: AppColor.backGroundColor
                          //                       ),
                          //                       width:isDesktop?  Get.width * 0.2:Get.width * 0.65,
                          //                       height:isDesktop?  Get.height * 0.5:Get.height * 0.7,
                          //                       padding: EdgeInsets.all(20),
                          //                       child: SingleChildScrollView(
                          //                         child: Column(
                          //                           children: [
                          //                             Padding(
                          //                               padding: const EdgeInsets.all(8.0),
                          //                               child: Row(
                          //                                 mainAxisAlignment: MainAxisAlignment.end,
                          //                                 children: [
                          //                                   Expanded(
                          //                                     child: Center(
                          //                                       child: Text(
                          //                                         'فیلتر',
                          //                                         style: AppTextStyle.labelText.copyWith(
                          //                                           fontSize: 15,
                          //                                           fontWeight: FontWeight.normal,
                          //                                         ),
                          //                                       ),
                          //                                     ),
                          //                                   ),
                          //                                   SizedBox(
                          //                                     width: 50,height: 27,
                          //                                     child: ElevatedButton(
                          //                                       style: ButtonStyle(
                          //                                           padding: WidgetStatePropertyAll(
                          //                                               EdgeInsets.symmetric(horizontal: 2,vertical: 1)),
                          //                                           // elevation: WidgetStatePropertyAll(5),
                          //                                           backgroundColor:
                          //                                           WidgetStatePropertyAll(AppColor.accentColor.withOpacity(0.5)),
                          //                                           shape: WidgetStatePropertyAll(RoundedRectangleBorder(side: BorderSide(color: AppColor.textColor),
                          //                                               borderRadius: BorderRadius.circular(5)))),
                          //                                       onPressed: () async {
                          //                                         controller.clearFilter();
                          //                                         controller.getOrderByAccountReportPager();
                          //                                         Get.back();
                          //                                       },
                          //                                       child: Text(
                          //                                         'حذف فیلتر',
                          //                                         style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 9 : 8),
                          //                                       ),
                          //                                     ),
                          //                                   ),
                          //                                 ],
                          //                               ),
                          //                             ),
                          //                             Container(
                          //                               color: AppColor.textColor,height: 0.2,
                          //                             ),
                          //                             Padding(
                          //                               padding: const EdgeInsets.symmetric(horizontal: 10),
                          //                               child: Column(
                          //                                 children: [
                          //                                   SizedBox(height: 8,),
                          //                                   Column(
                          //                                     crossAxisAlignment:
                          //                                     CrossAxisAlignment.start,
                          //                                     children: [
                          //                                       Text(
                          //                                         'نام',
                          //                                         style: AppTextStyle.labelText.copyWith(
                          //                                             fontSize: 11,
                          //                                             fontWeight: FontWeight.normal,
                          //                                             color: AppColor.textColor),
                          //                                       ),
                          //                                       SizedBox(height: 10,),
                          //                                       IntrinsicHeight(
                          //                                         child: TextFormField(
                          //                                           autovalidateMode: AutovalidateMode
                          //                                               .onUserInteraction,
                          //                                           controller: controller.nameController,
                          //                                           style: AppTextStyle.labelText.copyWith(fontSize: 15),
                          //                                           textAlign: TextAlign.start,
                          //                                           keyboardType:TextInputType.text,
                          //                                           decoration: InputDecoration(
                          //                                             contentPadding:
                          //                                             const EdgeInsets.symmetric(
                          //                                                 vertical: 11,horizontal: 15
                          //                                             ),
                          //                                             isDense: true,
                          //                                             border: OutlineInputBorder(
                          //                                               borderRadius:
                          //                                               BorderRadius.circular(6),
                          //                                             ),
                          //                                             filled: true,
                          //                                             fillColor: AppColor.textFieldColor,
                          //                                             errorMaxLines: 1,
                          //                                           ),
                          //                                         ),
                          //                                       ),
                          //                                     ],
                          //                                   ),
                          //                                   SizedBox(height: 8,),
                          //                                   Column(
                          //                                     crossAxisAlignment: CrossAxisAlignment.start,
                          //                                     children: [
                          //                                       Text(
                          //                                         'از تاریخ',
                          //                                         style: AppTextStyle.labelText.copyWith(fontSize: 13,
                          //                                             fontWeight: FontWeight.normal,color: AppColor.textColor ),
                          //                                       ),
                          //                                       Container(
                          //                                         //height: 50,
                          //                                         padding: EdgeInsets.only(bottom: 5),
                          //                                         child: IntrinsicHeight(
                          //                                           child: TextFormField(
                          //                                             validator: (value){
                          //                                               if(value==null || value.isEmpty){
                          //                                                 return 'لطفا تاریخ را انتخاب کنید';
                          //                                               }
                          //                                               return null;
                          //                                             },
                          //                                             controller: controller.dateStartController,
                          //                                             readOnly: true,
                          //                                             style: AppTextStyle.labelText,
                          //                                             decoration: InputDecoration(
                          //                                               suffixIcon: Icon(Icons.calendar_month, color: AppColor.textColor),
                          //                                               border: OutlineInputBorder(
                          //                                                 borderRadius: BorderRadius.circular(10),
                          //                                               ),
                          //                                               filled: true,
                          //                                               fillColor: AppColor.textFieldColor,
                          //                                               errorMaxLines: 1,
                          //                                             ),
                          //                                             onTap: () async {
                          //                                               Jalali? pickedDate = await showPersianDatePicker(
                          //                                                 context: context,
                          //                                                 initialDate: Jalali.now(),
                          //                                                 firstDate: Jalali(1400,1,1),
                          //                                                 lastDate: Jalali(1450,12,29),
                          //                                                 initialEntryMode: PersianDatePickerEntryMode.calendar,
                          //                                                 initialDatePickerMode: PersianDatePickerMode.day,
                          //                                                 locale: Locale("fa","IR"),
                          //                                               );
                          //                                               Gregorian gregorian= pickedDate!.toGregorian();
                          //                                               controller.startDateFilter.value =
                          //                                               "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";
                          //
                          //                                               controller.dateStartController.text =
                          //                                               "${pickedDate.year}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.day.toString().padLeft(2, '0')}";
                          //
                          //                                             },
                          //                                           ),
                          //                                         ),
                          //                                       ),
                          //                                     ],
                          //                                   ),
                          //                                   SizedBox(height: 8),
                          //                                   Column(
                          //                                     crossAxisAlignment: CrossAxisAlignment.start,
                          //                                     children: [
                          //                                       Text(
                          //                                         'تا تاریخ',
                          //                                         style: AppTextStyle.labelText.copyWith(fontSize: 13,
                          //                                             fontWeight: FontWeight.normal,color: AppColor.textColor ),
                          //                                       ),
                          //                                       Container(
                          //                                         //height: 50,
                          //                                         padding: EdgeInsets.only(bottom: 5),
                          //                                         child: IntrinsicHeight(
                          //                                           child: TextFormField(
                          //                                             validator: (value){
                          //                                               if(value==null || value.isEmpty){
                          //                                                 return 'لطفا تاریخ را انتخاب کنید';
                          //                                               }
                          //                                               return null;
                          //                                             },
                          //                                             controller: controller.dateEndController,
                          //                                             readOnly: true,
                          //                                             style: AppTextStyle.labelText,
                          //                                             decoration: InputDecoration(
                          //                                               suffixIcon: Icon(Icons.calendar_month, color: AppColor.textColor),
                          //                                               border: OutlineInputBorder(
                          //                                                 borderRadius: BorderRadius.circular(10),
                          //                                               ),
                          //                                               filled: true,
                          //                                               fillColor: AppColor.textFieldColor,
                          //                                               errorMaxLines: 1,
                          //                                             ),
                          //                                             onTap: () async {
                          //                                               Jalali? pickedDate = await showPersianDatePicker(
                          //                                                 context: context,
                          //                                                 initialDate: Jalali.now(),
                          //                                                 firstDate: Jalali(1400,1,1),
                          //                                                 lastDate: Jalali(1450,12,29),
                          //                                                 initialEntryMode: PersianDatePickerEntryMode.calendar,
                          //                                                 initialDatePickerMode: PersianDatePickerMode.day,
                          //                                                 locale: Locale("fa","IR"),
                          //                                               );
                          //                                               // DateTime date=DateTime.now();
                          //                                               Gregorian gregorian= pickedDate!.toGregorian();
                          //                                               controller.endDateFilter.value =
                          //                                               "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";
                          //
                          //                                               controller.dateEndController.text =
                          //                                               "${pickedDate.year}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.day.toString().padLeft(2, '0')}";
                          //
                          //                                             },
                          //                                           ),
                          //                                         ),
                          //                                       ),
                          //                                     ],
                          //                                   ),
                          //
                          //                                 ],
                          //                               ),
                          //                             ),
                          //                             //Spacer(),
                          //                             Container(
                          //                               margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                          //                               width: double.infinity,
                          //                               height: 40,
                          //                               child: ElevatedButton(
                          //                                 style: ButtonStyle(
                          //                                     padding: WidgetStatePropertyAll(
                          //                                         EdgeInsets.symmetric(horizontal: 23,vertical: 19)),
                          //                                     // elevation: WidgetStatePropertyAll(5),
                          //                                     backgroundColor:
                          //                                     WidgetStatePropertyAll(AppColor.appBarColor),
                          //                                     shape: WidgetStatePropertyAll(RoundedRectangleBorder(side: BorderSide(color: AppColor.textColor),
                          //                                         borderRadius: BorderRadius.circular(5)))),
                          //                                 onPressed: () async {
                          //                                   controller.getOrderByAccountReportPager();
                          //                                   Get.back();
                          //
                          //                                 },
                          //                                 child: controller.isLoading.value?
                          //                                 CircularProgressIndicator(
                          //                                   valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor),
                          //                                 ) :
                          //                                 Text(
                          //                                   'فیلتر',
                          //                                   style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10),
                          //                                 ),
                          //                               ),
                          //                             ),
                          //                           ],
                          //                         ),
                          //                       ),
                          //                     ),
                          //                   ),
                          //                 );
                          //               });
                          //         },
                          //         child: Row(
                          //           children: [
                          //             SvgPicture.asset(
                          //                 'assets/svg/filter3.svg',
                          //                 height: 17,
                          //                 colorFilter:
                          //                 ColorFilter
                          //                     .mode(
                          //                   controller.nameController.text!="" ||  controller.dateStartController.text!="" || controller.dateEndController.text!="" ?AppColor.accentColor:  AppColor
                          //                       .textColor,
                          //                   BlendMode
                          //                       .srcIn,
                          //                 )),
                          //             SizedBox(
                          //               width: 10,
                          //             ),
                          //             Text(
                          //               'فیلتر',
                          //               style: AppTextStyle
                          //                   .labelText
                          //                   .copyWith(
                          //                   fontSize: isDesktop
                          //                       ? 12
                          //                       : 10,color: controller.nameController.text!="" || controller.dateStartController.text!="" || controller.dateEndController.text!="" ?AppColor.accentColor: AppColor.textColor),
                          //             ),
                          //           ],
                          //         ),
                          //       ),*/
                          //       SizedBox(width: 20,),
                          //       // خروجی pdf
                          //       OutlinedButton.icon(
                          //           onPressed: () {
                          //             showGeneralDialog(
                          //                 context: context,
                          //                 barrierDismissible: true,
                          //                 barrierLabel: MaterialLocalizations.of(context)
                          //                     .modalBarrierDismissLabel,
                          //                 barrierColor: Colors.black45,
                          //                 transitionDuration: const Duration(milliseconds: 200),
                          //                 pageBuilder: (BuildContext buildContext,
                          //                     Animation animation,
                          //                     Animation secondaryAnimation) {
                          //                   return Center(
                          //                     child: Material(
                          //                       color: Colors.transparent,
                          //                       child: Container(
                          //                         decoration: BoxDecoration(
                          //                             borderRadius: BorderRadius.circular(8),
                          //                             color: AppColor.backGroundColor
                          //                         ),
                          //                         width:isDesktop?  Get.width * 0.2:Get.height * 0.5,
                          //                         height:isDesktop?  Get.height * 0.5:Get.height * 0.7,
                          //                         padding: EdgeInsets.all(20),
                          //                         child: Column(
                          //                           children: [
                          //                             Padding(
                          //                               padding: const EdgeInsets.all(8.0),
                          //                               child: Row(
                          //                                 mainAxisAlignment: MainAxisAlignment.center,
                          //                                 children: [
                          //                                   Text(
                          //                                     'خروجی pdf',
                          //                                     style: AppTextStyle.labelText.copyWith(
                          //                                       fontSize: 15,
                          //                                       fontWeight: FontWeight.normal,
                          //                                     ),
                          //                                   ),
                          //                                 ],
                          //                               ),
                          //                             ),
                          //                             Container(
                          //                               color: AppColor.textColor,height: 0.2,
                          //                             ),
                          //                             Padding(
                          //                               padding: const EdgeInsets.symmetric(horizontal: 10),
                          //                               child: Column(
                          //                                 children: [
                          //                                   SizedBox(height: 8,),
                          //                                   Column(
                          //                                     crossAxisAlignment:
                          //                                     CrossAxisAlignment.start,
                          //                                     children: [
                          //                                       Text(
                          //                                         'نام',
                          //                                         style: AppTextStyle.labelText.copyWith(
                          //                                             fontSize: 11,
                          //                                             fontWeight: FontWeight.normal,
                          //                                             color: AppColor.textColor),
                          //                                       ),
                          //                                       SizedBox(height: 10,),
                          //                                       IntrinsicHeight(
                          //                                         child: TextFormField(
                          //                                           autovalidateMode: AutovalidateMode
                          //                                               .onUserInteraction,
                          //                                           controller: controller.nameController,
                          //                                           style: AppTextStyle.labelText.copyWith(fontSize: 15),
                          //                                           textAlign: TextAlign.start,
                          //                                           keyboardType:TextInputType.text,
                          //                                           decoration: InputDecoration(
                          //                                             contentPadding:
                          //                                             const EdgeInsets.symmetric(
                          //                                                 vertical: 11,horizontal: 15
                          //                                             ),
                          //                                             isDense: true,
                          //                                             border: OutlineInputBorder(
                          //                                               borderRadius:
                          //                                               BorderRadius.circular(6),
                          //                                             ),
                          //                                             filled: true,
                          //                                             fillColor: AppColor.textFieldColor,
                          //                                             errorMaxLines: 1,
                          //                                           ),
                          //                                         ),
                          //                                       ),
                          //                                     ],
                          //                                   ),
                          //                                   SizedBox(height: 8),
                          //                                   Column(
                          //                                     crossAxisAlignment: CrossAxisAlignment.start,
                          //                                     children: [
                          //                                       Text(
                          //                                         'از تاریخ',
                          //                                         style: AppTextStyle.labelText.copyWith(fontSize: 13,
                          //                                             fontWeight: FontWeight.normal,color: AppColor.textColor ),
                          //                                       ),
                          //                                       Container(
                          //                                         //height: 50,
                          //                                         padding: EdgeInsets.only(bottom: 5),
                          //                                         child: IntrinsicHeight(
                          //                                           child: TextFormField(
                          //                                             validator: (value){
                          //                                               if(value==null || value.isEmpty){
                          //                                                 return 'لطفا تاریخ را انتخاب کنید';
                          //                                               }
                          //                                               return null;
                          //                                             },
                          //                                             controller: controller.dateStartController,
                          //                                             readOnly: true,
                          //                                             style: AppTextStyle.labelText,
                          //                                             decoration: InputDecoration(
                          //                                               suffixIcon: Icon(Icons.calendar_month, color: AppColor.textColor),
                          //                                               border: OutlineInputBorder(
                          //                                                 borderRadius: BorderRadius.circular(10),
                          //                                               ),
                          //                                               filled: true,
                          //                                               fillColor: AppColor.textFieldColor,
                          //                                               errorMaxLines: 1,
                          //                                             ),
                          //                                             onTap: () async {
                          //                                               Jalali? pickedDate = await showPersianDatePicker(
                          //                                                 context: context,
                          //                                                 initialDate: Jalali.now(),
                          //                                                 firstDate: Jalali(1400,1,1),
                          //                                                 lastDate: Jalali(1450,12,29),
                          //                                                 initialEntryMode: PersianDatePickerEntryMode.calendar,
                          //                                                 initialDatePickerMode: PersianDatePickerMode.day,
                          //                                                 locale: Locale("fa","IR"),
                          //                                               );
                          //                                               Gregorian gregorian= pickedDate!.toGregorian();
                          //                                               controller.startDateFilter.value =
                          //                                               "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";
                          //
                          //                                               controller.dateStartController.text =
                          //                                               "${pickedDate.year}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.day.toString().padLeft(2, '0')}";
                          //
                          //                                             },
                          //                                           ),
                          //                                         ),
                          //                                       ),
                          //                                     ],
                          //                                   ),
                          //                                   SizedBox(height: 8),
                          //                                   Column(
                          //                                     crossAxisAlignment: CrossAxisAlignment.start,
                          //                                     children: [
                          //                                       Text(
                          //                                         'تا تاریخ',
                          //                                         style: AppTextStyle.labelText.copyWith(fontSize: 13,
                          //                                             fontWeight: FontWeight.normal,color: AppColor.textColor ),
                          //                                       ),
                          //                                       Container(
                          //                                         //height: 50,
                          //                                         padding: EdgeInsets.only(bottom: 5),
                          //                                         child: IntrinsicHeight(
                          //                                           child: TextFormField(
                          //                                             validator: (value){
                          //                                               if(value==null || value.isEmpty){
                          //                                                 return 'لطفا تاریخ را انتخاب کنید';
                          //                                               }
                          //                                               return null;
                          //                                             },
                          //                                             controller: controller.dateEndController,
                          //                                             readOnly: true,
                          //                                             style: AppTextStyle.labelText,
                          //                                             decoration: InputDecoration(
                          //                                               suffixIcon: Icon(Icons.calendar_month, color: AppColor.textColor),
                          //                                               border: OutlineInputBorder(
                          //                                                 borderRadius: BorderRadius.circular(10),
                          //                                               ),
                          //                                               filled: true,
                          //                                               fillColor: AppColor.textFieldColor,
                          //                                               errorMaxLines: 1,
                          //                                             ),
                          //                                             onTap: () async {
                          //                                               Jalali? pickedDate = await showPersianDatePicker(
                          //                                                 context: context,
                          //                                                 initialDate: Jalali.now(),
                          //                                                 firstDate: Jalali(1400,1,1),
                          //                                                 lastDate: Jalali(1450,12,29),
                          //                                                 initialEntryMode: PersianDatePickerEntryMode.calendar,
                          //                                                 initialDatePickerMode: PersianDatePickerMode.day,
                          //                                                 locale: Locale("fa","IR"),
                          //                                               );
                          //                                               // DateTime date=DateTime.now();
                          //                                               Gregorian gregorian= pickedDate!.toGregorian();
                          //                                               controller.endDateFilter.value =
                          //                                               "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";
                          //
                          //                                               controller.dateEndController.text =
                          //                                               "${pickedDate.year}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.day.toString().padLeft(2, '0')}";
                          //
                          //                                             },
                          //                                           ),
                          //                                         ),
                          //                                       ),
                          //                                     ],
                          //                                   ),
                          //
                          //                                 ],
                          //                               ),
                          //                             ),
                          //                             Spacer(),
                          //                             Container(
                          //                               margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                          //                               width: double.infinity,
                          //                               height: 40,
                          //                               child: ElevatedButton(
                          //                                 style: ButtonStyle(
                          //                                     padding: WidgetStatePropertyAll(
                          //                                         EdgeInsets.symmetric(horizontal: 23,vertical: 19)),
                          //                                     // elevation: WidgetStatePropertyAll(5),
                          //                                     backgroundColor:
                          //                                     WidgetStatePropertyAll(AppColor.appBarColor),
                          //                                     shape: WidgetStatePropertyAll(RoundedRectangleBorder(side: BorderSide(color: AppColor.textColor),
                          //                                         borderRadius: BorderRadius.circular(5)))),
                          //                                 onPressed: () async {
                          //                                   controller.getOrderByAccountReportPdf();
                          //                                   Get.back();
                          //                                 },
                          //                                 child: controller.isLoading.value?
                          //                                 CircularProgressIndicator(
                          //                                   valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor),
                          //                                 ) :
                          //                                 Text(
                          //                                   'ثبت',
                          //                                   style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10),
                          //                                 ),
                          //                               ),
                          //                             ),
                          //                           ],
                          //                         ),
                          //                       ),
                          //                     ),
                          //                   );
                          //                 });
                          //
                          //           },
                          //           label: Text(
                          //             'خروجی pdf',
                          //             style: AppTextStyle.labelText.copyWith(color: AppColor.textAccentColor,fontSize: 12),
                          //           ),
                          //         icon: SvgPicture.asset(
                          //           'assets/svg/pdf.svg',
                          //           height: 24,
                          //         ),
                          //       ),
                          //       /*ElevatedButton(
                          //         style: ButtonStyle(
                          //             padding: WidgetStatePropertyAll(
                          //               EdgeInsets.symmetric(
                          //                   horizontal: 23,vertical: 19
                          //               ),
                          //             ),
                          //             elevation: WidgetStatePropertyAll(5),
                          //             //fixedSize: WidgetStatePropertyAll(Size(100,30)),
                          //             backgroundColor:
                          //             WidgetStatePropertyAll(AppColor.secondary3Color),
                          //             shape: WidgetStatePropertyAll(
                          //                 RoundedRectangleBorder(
                          //                     borderRadius: BorderRadius.circular(5)))),
                          //         onPressed: () {
                          //           showGeneralDialog(
                          //               context: context,
                          //               barrierDismissible: true,
                          //               barrierLabel: MaterialLocalizations.of(context)
                          //                   .modalBarrierDismissLabel,
                          //               barrierColor: Colors.black45,
                          //               transitionDuration: const Duration(milliseconds: 200),
                          //               pageBuilder: (BuildContext buildContext,
                          //                   Animation animation,
                          //                   Animation secondaryAnimation) {
                          //                 return Center(
                          //                   child: Material(
                          //                     color: Colors.transparent,
                          //                     child: Container(
                          //                       decoration: BoxDecoration(
                          //                           borderRadius: BorderRadius.circular(8),
                          //                           color: AppColor.backGroundColor
                          //                       ),
                          //                       width:isDesktop?  Get.width * 0.2:Get.height * 0.5,
                          //                       height:isDesktop?  Get.height * 0.5:Get.height * 0.7,
                          //                       padding: EdgeInsets.all(20),
                          //                       child: Column(
                          //                         children: [
                          //                           Padding(
                          //                             padding: const EdgeInsets.all(8.0),
                          //                             child: Row(
                          //                               mainAxisAlignment: MainAxisAlignment.center,
                          //                               children: [
                          //                                 Text(
                          //                                   'خروجی pdf',
                          //                                   style: AppTextStyle.labelText.copyWith(
                          //                                     fontSize: 15,
                          //                                     fontWeight: FontWeight.normal,
                          //                                   ),
                          //                                 ),
                          //                               ],
                          //                             ),
                          //                           ),
                          //                           Container(
                          //                             color: AppColor.textColor,height: 0.2,
                          //                           ),
                          //                           Padding(
                          //                             padding: const EdgeInsets.symmetric(horizontal: 10),
                          //                             child: Column(
                          //                               children: [
                          //                                 SizedBox(height: 8,),
                          //                                 Column(
                          //                                   crossAxisAlignment:
                          //                                   CrossAxisAlignment.start,
                          //                                   children: [
                          //                                     Text(
                          //                                       'نام',
                          //                                       style: AppTextStyle.labelText.copyWith(
                          //                                           fontSize: 11,
                          //                                           fontWeight: FontWeight.normal,
                          //                                           color: AppColor.textColor),
                          //                                     ),
                          //                                     SizedBox(height: 10,),
                          //                                     IntrinsicHeight(
                          //                                       child: TextFormField(
                          //                                         autovalidateMode: AutovalidateMode
                          //                                             .onUserInteraction,
                          //                                         controller: controller.nameController,
                          //                                         style: AppTextStyle.labelText.copyWith(fontSize: 15),
                          //                                         textAlign: TextAlign.start,
                          //                                         keyboardType:TextInputType.text,
                          //                                         decoration: InputDecoration(
                          //                                           contentPadding:
                          //                                           const EdgeInsets.symmetric(
                          //                                               vertical: 11,horizontal: 15
                          //                                           ),
                          //                                           isDense: true,
                          //                                           border: OutlineInputBorder(
                          //                                             borderRadius:
                          //                                             BorderRadius.circular(6),
                          //                                           ),
                          //                                           filled: true,
                          //                                           fillColor: AppColor.textFieldColor,
                          //                                           errorMaxLines: 1,
                          //                                         ),
                          //                                       ),
                          //                                     ),
                          //                                   ],
                          //                                 ),
                          //                                 SizedBox(height: 8),
                          //                                 Column(
                          //                                   crossAxisAlignment: CrossAxisAlignment.start,
                          //                                   children: [
                          //                                     Text(
                          //                                       'از تاریخ',
                          //                                       style: AppTextStyle.labelText.copyWith(fontSize: 13,
                          //                                           fontWeight: FontWeight.normal,color: AppColor.textColor ),
                          //                                     ),
                          //                                     Container(
                          //                                       //height: 50,
                          //                                       padding: EdgeInsets.only(bottom: 5),
                          //                                       child: IntrinsicHeight(
                          //                                         child: TextFormField(
                          //                                           validator: (value){
                          //                                             if(value==null || value.isEmpty){
                          //                                               return 'لطفا تاریخ را انتخاب کنید';
                          //                                             }
                          //                                             return null;
                          //                                           },
                          //                                           controller: controller.dateStartController,
                          //                                           readOnly: true,
                          //                                           style: AppTextStyle.labelText,
                          //                                           decoration: InputDecoration(
                          //                                             suffixIcon: Icon(Icons.calendar_month, color: AppColor.textColor),
                          //                                             border: OutlineInputBorder(
                          //                                               borderRadius: BorderRadius.circular(10),
                          //                                             ),
                          //                                             filled: true,
                          //                                             fillColor: AppColor.textFieldColor,
                          //                                             errorMaxLines: 1,
                          //                                           ),
                          //                                           onTap: () async {
                          //                                             Jalali? pickedDate = await showPersianDatePicker(
                          //                                               context: context,
                          //                                               initialDate: Jalali.now(),
                          //                                               firstDate: Jalali(1400,1,1),
                          //                                               lastDate: Jalali(1450,12,29),
                          //                                               initialEntryMode: PersianDatePickerEntryMode.calendar,
                          //                                               initialDatePickerMode: PersianDatePickerMode.day,
                          //                                               locale: Locale("fa","IR"),
                          //                                             );
                          //                                             Gregorian gregorian= pickedDate!.toGregorian();
                          //                                             controller.startDateFilter.value =
                          //                                             "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";
                          //
                          //                                             controller.dateStartController.text =
                          //                                             "${pickedDate.year}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.day.toString().padLeft(2, '0')}";
                          //
                          //                                           },
                          //                                         ),
                          //                                       ),
                          //                                     ),
                          //                                   ],
                          //                                 ),
                          //                                 SizedBox(height: 8),
                          //                                 Column(
                          //                                   crossAxisAlignment: CrossAxisAlignment.start,
                          //                                   children: [
                          //                                     Text(
                          //                                       'تا تاریخ',
                          //                                       style: AppTextStyle.labelText.copyWith(fontSize: 13,
                          //                                           fontWeight: FontWeight.normal,color: AppColor.textColor ),
                          //                                     ),
                          //                                     Container(
                          //                                       //height: 50,
                          //                                       padding: EdgeInsets.only(bottom: 5),
                          //                                       child: IntrinsicHeight(
                          //                                         child: TextFormField(
                          //                                           validator: (value){
                          //                                             if(value==null || value.isEmpty){
                          //                                               return 'لطفا تاریخ را انتخاب کنید';
                          //                                             }
                          //                                             return null;
                          //                                           },
                          //                                           controller: controller.dateEndController,
                          //                                           readOnly: true,
                          //                                           style: AppTextStyle.labelText,
                          //                                           decoration: InputDecoration(
                          //                                             suffixIcon: Icon(Icons.calendar_month, color: AppColor.textColor),
                          //                                             border: OutlineInputBorder(
                          //                                               borderRadius: BorderRadius.circular(10),
                          //                                             ),
                          //                                             filled: true,
                          //                                             fillColor: AppColor.textFieldColor,
                          //                                             errorMaxLines: 1,
                          //                                           ),
                          //                                           onTap: () async {
                          //                                             Jalali? pickedDate = await showPersianDatePicker(
                          //                                               context: context,
                          //                                               initialDate: Jalali.now(),
                          //                                               firstDate: Jalali(1400,1,1),
                          //                                               lastDate: Jalali(1450,12,29),
                          //                                               initialEntryMode: PersianDatePickerEntryMode.calendar,
                          //                                               initialDatePickerMode: PersianDatePickerMode.day,
                          //                                               locale: Locale("fa","IR"),
                          //                                             );
                          //                                             // DateTime date=DateTime.now();
                          //                                             Gregorian gregorian= pickedDate!.toGregorian();
                          //                                             controller.endDateFilter.value =
                          //                                             "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";
                          //
                          //                                             controller.dateEndController.text =
                          //                                             "${pickedDate.year}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.day.toString().padLeft(2, '0')}";
                          //
                          //                                           },
                          //                                         ),
                          //                                       ),
                          //                                     ),
                          //                                   ],
                          //                                 ),
                          //
                          //                               ],
                          //                             ),
                          //                           ),
                          //                           Spacer(),
                          //                           Container(
                          //                             margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                          //                             width: double.infinity,
                          //                             height: 40,
                          //                             child: ElevatedButton(
                          //                               style: ButtonStyle(
                          //                                   padding: WidgetStatePropertyAll(
                          //                                       EdgeInsets.symmetric(horizontal: 23,vertical: 19)),
                          //                                   // elevation: WidgetStatePropertyAll(5),
                          //                                   backgroundColor:
                          //                                   WidgetStatePropertyAll(AppColor.appBarColor),
                          //                                   shape: WidgetStatePropertyAll(RoundedRectangleBorder(side: BorderSide(color: AppColor.textColor),
                          //                                       borderRadius: BorderRadius.circular(5)))),
                          //                               onPressed: () async {
                          //                                 controller.getOrderByAccountReportPdf();
                          //                                 Get.back();
                          //                               },
                          //                               child: controller.isLoading.value?
                          //                               CircularProgressIndicator(
                          //                                 valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor),
                          //                               ) :
                          //                               Text(
                          //                                 'ثبت',
                          //                                 style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10),
                          //                               ),
                          //                             ),
                          //                           ),
                          //                         ],
                          //                       ),
                          //                     ),
                          //                   ),
                          //                 );
                          //               });
                          //
                          //         },
                          //         child: Text(
                          //           'خروجی pdf',
                          //           style: AppTextStyle.labelText,
                          //         ),
                          //       ),*/
                          //     ],
                          //
                          //   ),
                          // )
                              SizedBox.shrink() :
                           Container(
                             margin: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                             padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                             decoration: BoxDecoration(
                               color: AppColor.appBarColor.withAlpha(30),
                               borderRadius: BorderRadius.circular(10),
                               border: Border.all(color: const Color(0xFF64748B)),
                             ),
                             child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // خروجی pdf
                                  GestureDetector(
                                    onTap: () {
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
                                                            controller.getOrderByAccountReportPdf();
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
                                    child: SvgPicture.asset(
                                      'assets/svg/pdf.svg',
                                      height: 30,
                                    ),
                                  ),
                                  // فیلتر
                                  GestureDetector(
                                    onTap: () async {
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
                                                  width:isDesktop?  Get.width * 0.2:Get.width * 0.65,
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
                                                                    controller.currentPage.value=1;
                                                                    controller.itemsPerPage.value=25;
                                                                    controller.clearFilter();
                                                                    controller.getOrderByAccountReportPager();
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
                                                              controller.currentPage.value=1;
                                                              controller.itemsPerPage.value=25;
                                                              controller.getOrderByAccountReportPager();
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
                                    child: SvgPicture.asset(
                                        'assets/svg/filter3.svg',
                                        height: 26,
                                        colorFilter:
                                        ColorFilter.mode(
                                          controller.nameController.text!="" ||  controller.dateStartController.text!="" || controller.dateEndController.text!="" ?
                                          AppColor.filterColor:  AppColor.textColor,
                                          BlendMode.srcIn,
                                        )
                                    ),
                                  ),
                                ],

                              ),
                           ),

                          isDesktop ?
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
                                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: 400,
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
                                            Row(
                                              children: [
                                                SizedBox(width: 10,),
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
                                                                          controller.getOrderByAccountReportPdf();
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
                                                SizedBox(width: 10,),
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
                                                                width:isDesktop?  Get.width * 0.2:Get.width * 0.65,
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
                                                                                  controller.getOrderByAccountReportPager();
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
                                                                            controller.getOrderByAccountReportPager();
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
                                                  label: Text(
                                                    'فیلتر',
                                                    style: AppTextStyle
                                                        .labelText
                                                        .copyWith(
                                                        fontSize: isDesktop
                                                            ? 12
                                                            : 10,color: controller.nameController.text!="" || controller.dateStartController.text!="" || controller.dateEndController.text!="" ?AppColor.accentColor: AppColor.textColor),
                                                  ),
                                                  icon: SvgPicture.asset(
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
                                                ),
                                              ],

                                            ),
                                          ],
                                        ),
                                      ),
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
                                        //dataRowMaxHeight: 60,
                                        //dataRowColor: WidgetStatePropertyAll(AppColor.secondaryColor),
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
                          )
                          :Container(
                            margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                            child:
                            Column(
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: controller.orderByAccountReportList.length,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    final orderByAccounts = controller.orderByAccountReportList[index];
                                    return  Container(
                                      margin: const EdgeInsets.only(bottom: 12),
                                      padding: const EdgeInsets.only(top: 5,right: 15,left: 15,bottom: 12),
                                      decoration: BoxDecoration(
                                        color: AppColor.secondaryColor.withAlpha(180),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: const Color(0xFF64748B)),
                                      ),
                                      child:
                                      Column(crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // تاریخ سفارش
                                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    "${orderByAccounts.rowNum ?? 0}",
                                                    style: AppTextStyle.bodyText.copyWith(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              funcOrderDetail(
                                                  '',
                                                  orderByAccounts.reportDate?.toPersianDate() ??
                                                      "",size: 11

                                              ),
                                              funcOrderDetail(
                                                  'کاربر:',
                                                  (orderByAccounts.accountName?.length ?? 0) > 25 ?
                                                  "${orderByAccounts.accountName?.substring(0 , 25)}..." :
                                                  orderByAccounts.accountName ?? "", size: 11
                                              ),

                                            ],
                                          ),
                                          SizedBox(height: 5,),
                                          Divider(color: AppColor.iconViewColor, height: 2,),
                                          SizedBox(height: 5,),
                                          // جمع خرید و فروش
                                          Container(
                                            margin: const EdgeInsets.all(5),
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              color:AppColor.secondary2Color.withAlpha(50),
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(color: const Color(0xFF64748B)),
                                            ),
                                            child: Row(crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: funcOrderDetail(
                                                      'جمع فروش:',
                                                      orderByAccounts.totalSaleAmount?.toStringAsFixed(0).seRagham(separator: ",") ??
                                                          "",color: AppColor.accentColor,size: 13
                                                  ),
                                                ),
                                                Expanded(
                                                  child: funcOrderDetail(
                                                      'جمع خرید:',
                                                      orderByAccounts.totalBuyAmount?.toStringAsFixed(0).seRagham(separator: ",") ?? "",
                                                      color: AppColor.primaryColor,size: 13
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // مانده و تراز کل
                                          Container(
                                            margin: const EdgeInsets.all(5),
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              color: AppColor.dividerColor.withAlpha(50),
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(color: const Color(0xFF64748B)),
                                            ),
                                            child: Column(mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                    //مانده
                                                     Row(crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            "مانده: ", style: AppTextStyle.labelText.copyWith(
                                                            color: const Color(0xFF94A3B8),
                                                            fontSize: 10,
                                                          ),
                                                          ),
                                                          (orderByAccounts.balanceAmount ?? 0 ) < 0 ?
                                                          Text(
                                                            "-${orderByAccounts.balanceAmount?.abs().toStringAsFixed(0).seRagham()}", style: AppTextStyle.bodyText.copyWith(fontSize: 14,color: AppColor.accentColor,fontWeight: FontWeight.bold),
                                                            textDirection: TextDirection.ltr,
                                                          ):
                                                          Text(
                                                            "${orderByAccounts.balanceAmount?.toStringAsFixed(0).seRagham()}", style: AppTextStyle.bodyText.copyWith(fontSize: 14,color: AppColor.primaryColor,fontWeight: FontWeight.bold),
                                                            textDirection: TextDirection.ltr,
                                                          ),
                                                          Text(
                                                            " ریال ", style:  AppTextStyle.bodyText.copyWith(fontSize: 12,),
                                                          ),
                                                        ],
                                                      ),
                                                    SizedBox(height: 7,),
                                                    //تراز کل
                                                     Row(crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            "تراز کل: ", style: AppTextStyle.labelText.copyWith(
                                                            color: const Color(0xFF94A3B8),
                                                            fontSize: 10,
                                                          ),
                                                          ),
                                                          (orderByAccounts.currencyValue ?? 0 ) < 0 ?
                                                          Text(
                                                            "-${orderByAccounts.currencyValue?.abs().toStringAsFixed(0).seRagham()}", style: AppTextStyle.bodyText.copyWith(fontSize: 14,color: AppColor.accentColor,fontWeight: FontWeight.bold),
                                                            textDirection: TextDirection.ltr,
                                                          ):
                                                          Text(
                                                            "${orderByAccounts.currencyValue?.toStringAsFixed(0).seRagham()}", style: AppTextStyle.bodyText.copyWith(fontSize: 14,color: AppColor.primaryColor,fontWeight: FontWeight.bold),
                                                            textDirection: TextDirection.ltr,
                                                          ),
                                                          Text(
                                                            " ریال ", style:  AppTextStyle.bodyText.copyWith(fontSize: 12,),
                                                          ),
                                                        ],
                                                      ),

                                              ],
                                            ),
                                          ),

                                        ],
                                      ),
                                    );
                                  },
                                ),
                                Obx(() {
                                  if (controller.isLoading.value && controller.orderByAccountReportList.isNotEmpty) {
                                    return Container(
                                      padding: EdgeInsets.all(16),
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  }

                                  if (!controller.hasMore.value && controller.orderByAccountReportList.isNotEmpty) {
                                    return Container(
                                      padding: EdgeInsets.all(16),
                                      child: Text(
                                        "همه تراکنش‌ها نمایش داده شد",
                                        textAlign: TextAlign.center,
                                        style: AppTextStyle.bodyText.copyWith(
                                          color: AppColor.textColor.withOpacity(0.7),
                                        ),
                                      ),
                                    );
                                  }
                                  return SizedBox.shrink();
                                }),
                                SizedBox(height: 15),
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
                controller.getOrderByAccountReportPager();
              },
              title: "خطا در دریافت لیست انتقال ها",
              des: 'برای دریافت لیست انتقال ها مجددا تلاش کنید',
            ),
          ),
          isDesktop ?
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              controller.paginated!=null?   Container(
                  height: 70,
                  margin: EdgeInsets.symmetric(horizontal: 50,vertical: 10),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  //color: AppColor.appBarColor.withAlpha(50),
                  alignment: Alignment.bottomCenter,
                  child:PagerWidget(countPage: controller.paginated!.totalCount??0, callBack: (int index) {
                    controller.isChangePage(index);
                  },)):SizedBox(),
            ],
          ) : SizedBox.shrink(),
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

  Widget funcOrderDetail( String label, String value, {Color color = AppColor.textColor, double? size}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: AppTextStyle.labelText.copyWith(
            color: const Color(0xFF94A3B8),
            fontSize: 10,
          ),
        ),
        SizedBox(width: 3),
        Text(value,
            style: AppTextStyle.bodyText.copyWith(
                color: color, fontSize: size,fontWeight: FontWeight.w600)),
      ],
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
          child: Text('ردیف', style: AppTextStyle.labelText.copyWith(fontSize: 12))),headingRowAlignment:MainAxisAlignment.center ),
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
            child: Text('نام مشتری',
                style: AppTextStyle.labelText.copyWith(fontSize: 12))),
        headingRowAlignment: MainAxisAlignment.center,
        /*onSort: (columnIndex, ascending) {
            controller.onSort(columnIndex, ascending);
          }*/
      ),
      DataColumn(
        label: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 80),
            child: Text('جمع فروش',
                style: AppTextStyle.labelText.copyWith(fontSize: 12))),
        headingRowAlignment: MainAxisAlignment.center,
        onSort: (columnIndex, ascending){
          controller.onSort(columnIndex, ascending);
        },
      ),
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 80),
              child: Text('جمع خرید',
                  style: AppTextStyle.labelText.copyWith(fontSize: 12))),
          headingRowAlignment: MainAxisAlignment.center,
        onSort: (columnIndex, ascending){
          controller.onSort(columnIndex, ascending);
        },
      ),
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 80),
              child: Text('مانده',
                  style: AppTextStyle.labelText.copyWith(fontSize: 12))),
          headingRowAlignment: MainAxisAlignment.center,
        onSort: (columnIndex, ascending){
          controller.onSort(columnIndex, ascending);
        },
      ),
      DataColumn(
        label: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 80),
            child: Text('تراز کل',
                style: AppTextStyle.labelText.copyWith(fontSize: 12))),
        headingRowAlignment: MainAxisAlignment.center,
        onSort: (columnIndex, ascending){
          controller.onSort(columnIndex, ascending);
        },
      ),
    ];
  }

  List<DataRow> buildDataRows(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    return controller.orderByAccountReportList.asMap().entries.map((entry) {
      final index = entry.key;
      final orderReportList = entry.value;
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
              Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("${orderReportList.rowNum}",
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
              orderReportList.reportDate?.toPersianDate() ?? 'نامشخص',
              style: AppTextStyle.bodyText.copyWith(fontSize: 10),
              textDirection: TextDirection.ltr,
            ),
          )),
          // نام
          DataCell(Center(
            child: Text(
              orderReportList.accountName ?? 'نامشخص',
              style: AppTextStyle.bodyText.copyWith(fontSize: 11),
            ),
          )),
          // جمع فروش
          DataCell(Center(
            child:
            Text("${orderReportList.totalSaleAmount?.toStringAsFixed(0).seRagham() ?? 'نامشخص'} ",
                style: AppTextStyle.bodyText
                    .copyWith(color: AppColor.accentColor, fontSize: 13,fontWeight: FontWeight.bold)),

          )),
          // جمع خرید
          DataCell(Center(
            child:
            Text("${orderReportList.totalBuyAmount?.toStringAsFixed(0).seRagham() ?? 'نامشخص'} ",
                style: AppTextStyle.bodyText
                    .copyWith(color: AppColor.primaryColor, fontSize: 13,fontWeight: FontWeight.bold)),

          )),
          // بالانس
          DataCell(Center(
            child:
            Row(
              children: [
                (orderReportList.balanceAmount ?? 0 ) < 0 ?
                Text(
                  "-${orderReportList.balanceAmount?.abs().toStringAsFixed(0).seRagham()}", style: AppTextStyle.bodyText.copyWith(fontSize: 14,color: AppColor.accentColor,fontWeight: FontWeight.bold),
                  textDirection: TextDirection.ltr,
                ):
                Text(
                  "${orderReportList.balanceAmount?.toStringAsFixed(0).seRagham()}", style: AppTextStyle.bodyText.copyWith(fontSize: 14,color: AppColor.primaryColor,fontWeight: FontWeight.bold),
                  textDirection: TextDirection.ltr,
                ),
                Text(
                  " ریال ", style:  AppTextStyle.bodyText.copyWith(fontSize: 12,),
                ),
              ],
            ),
          )),
          // تراز کل
          DataCell(Center(
            child:
            Row(
              children: [
                (orderReportList.currencyValue ?? 0 ) < 0 ?
                Text(
                  "-${orderReportList.currencyValue?.abs().toStringAsFixed(0).seRagham()}", style: AppTextStyle.bodyText.copyWith(fontSize: 14,color: AppColor.accentColor,fontWeight: FontWeight.bold),
                  textDirection: TextDirection.ltr,
                ):
                Text(
                  "${orderReportList.currencyValue?.toStringAsFixed(0).seRagham()}", style: AppTextStyle.bodyText.copyWith(fontSize: 14,color: AppColor.primaryColor,fontWeight: FontWeight.bold),
                  textDirection: TextDirection.ltr,
                ),
                Text(
                  " ریال ", style:  AppTextStyle.bodyText.copyWith(fontSize: 12,),
                ),
              ],
            ),
          )),
        ],
      );
    }).toList();
  }
}
