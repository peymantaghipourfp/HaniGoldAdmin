
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/order/controller/order_edited_report.controller.dart';
import 'package:hanigold_admin/src/domain/order/widget/order_edited_filter.widget.dart';
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

class OrderEditedReportListView extends StatefulWidget {
  const OrderEditedReportListView({super.key});

  @override
  State<OrderEditedReportListView> createState() => _OrderEditedReportListViewState();
}

class _OrderEditedReportListViewState extends State<OrderEditedReportListView> {
  final OrderEditedReportController controller = Get.find<OrderEditedReportController>();

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    return Obx(() => Scaffold(
      appBar: CustomAppbar1(
        title: 'سفارش های ویرایش شده',
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
                      margin: EdgeInsets.symmetric(horizontal:isDesktop ? 30 : 15,vertical: 2),
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
                        //border: Border.all(color: const Color(0xFF64748B)),
                      ),
                      child: Column(
                        children: [
                          isDesktop ? SizedBox.shrink() :
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                            padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                            decoration: BoxDecoration(
                              color: AppColor.appBarColor.withAlpha(30),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: const Color(0xFF64748B)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                // فیلتر
                                GestureDetector(
                                    onTap: () async {
                                      showGeneralDialog(
                                          context: context,
                                          barrierDismissible: true,
                                          barrierLabel: MaterialLocalizations
                                              .of(context)
                                              .modalBarrierDismissLabel,
                                          barrierColor: Colors
                                              .black45,
                                          transitionDuration: const Duration(
                                              milliseconds: 200),
                                          pageBuilder: (
                                              BuildContext buildContext,
                                              Animation animation,
                                              Animation secondaryAnimation) {
                                            return Center(
                                              child: Material(
                                                color: Colors
                                                    .transparent,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(8),
                                                      color: AppColor.backGroundColor
                                                  ),
                                                  width:isDesktop?  Get.width * 0.2:Get.width * 0.85,
                                                  height:isDesktop?  Get.height * 0.5:Get.height * 0.75,
                                                  padding: EdgeInsets
                                                      .all(20),
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets
                                                              .all(
                                                              8.0),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment
                                                                .end,
                                                            children: [
                                                              Expanded(
                                                                child: Center(
                                                                  child: Text(
                                                                    'فیلتر',
                                                                    style: AppTextStyle
                                                                        .labelText
                                                                        .copyWith(
                                                                      fontSize: 15,
                                                                      fontWeight: FontWeight
                                                                          .normal,
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
                                                                          EdgeInsets
                                                                              .symmetric(
                                                                              horizontal: 2,
                                                                              vertical: 1)),
                                                                      // elevation: WidgetStatePropertyAll(5),
                                                                      backgroundColor:
                                                                      WidgetStatePropertyAll(
                                                                          AppColor
                                                                              .accentColor
                                                                              .withOpacity(
                                                                              0.5)),
                                                                      shape: WidgetStatePropertyAll(
                                                                          RoundedRectangleBorder(
                                                                              side: BorderSide(
                                                                                  color: AppColor
                                                                                      .textColor),
                                                                              borderRadius: BorderRadius
                                                                                  .circular(
                                                                                  5)))),
                                                                  onPressed: () async {
                                                                    controller.currentPage.value=1;
                                                                    controller.itemsPerPage.value=25;
                                                                    controller.clearFilter();
                                                                    controller.getOrderEditedReportPager();
                                                                    Get.back();
                                                                  },
                                                                  child: Text(
                                                                    'حذف فیلتر',
                                                                    style: AppTextStyle
                                                                        .labelText
                                                                        .copyWith(
                                                                        fontSize: isDesktop
                                                                            ? 9
                                                                            : 8),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          color: AppColor
                                                              .textColor,
                                                          height: 0.2,
                                                        ),
                                                        /*Padding(
                                                                      padding: const EdgeInsets
                                                                          .symmetric(
                                                                          horizontal: 10),
                                                                      child: Column(
                                                                        children: [
                                                                          SizedBox(height: 8),
                                                                          Column(
                                                                            crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                'فیلتر ادمین',
                                                                                style: AppTextStyle.labelText.copyWith(
                                                                                    fontSize: 11,
                                                                                    fontWeight: FontWeight.normal,
                                                                                    color: AppColor.textColor),
                                                                              ),
                                                                              SizedBox(height: 10,),
                                                                              Obx(() => Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                children: [
                                                                                  Row(
                                                                                    children: [
                                                                                      Radio<int?>(
                                                                                        value: 1,
                                                                                        groupValue: orderController.byAdmin.value,
                                                                                        onChanged: (value) {
                                                                                          orderController.checkByAdmin(value);
                                                                                        },
                                                                                        activeColor: AppColor.primaryColor,
                                                                                      ),
                                                                                      Text(
                                                                                        'ادمین',
                                                                                        style: AppTextStyle.labelText.copyWith(
                                                                                            fontSize: 11,
                                                                                            fontWeight: FontWeight.normal,
                                                                                            color: AppColor.textColor),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  Row(
                                                                                    children: [
                                                                                      Radio<int?>(
                                                                                        value: 0,
                                                                                        groupValue: orderController.byAdmin.value,
                                                                                        onChanged: (value) {
                                                                                          orderController.checkByAdmin(value);
                                                                                        },
                                                                                        activeColor: AppColor.primaryColor,
                                                                                      ),
                                                                                      Text(
                                                                                        'غیر ادمین',
                                                                                        style: AppTextStyle.labelText.copyWith(
                                                                                            fontSize: 11,
                                                                                            fontWeight: FontWeight.normal,
                                                                                            color: AppColor.textColor),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  Row(
                                                                                    children: [
                                                                                      Radio<int?>(
                                                                                        value: null,
                                                                                        groupValue: orderController.byAdmin.value,
                                                                                        onChanged: (value) {
                                                                                          orderController.checkByAdmin(value);
                                                                                        },
                                                                                        activeColor: AppColor.primaryColor,
                                                                                      ),
                                                                                      Text(
                                                                                        'همه',
                                                                                        style: AppTextStyle.labelText.copyWith(
                                                                                            fontSize: 11,
                                                                                            fontWeight: FontWeight.normal,
                                                                                            color: AppColor.textColor),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              ))
                                                                            ],
                                                                          ),
                                                                          SizedBox(height: 8),
                                                                          Column(
                                                                            crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                'نوع سفارش',
                                                                                style: AppTextStyle.labelText.copyWith(
                                                                                    fontSize: 11,
                                                                                    fontWeight: FontWeight.normal,
                                                                                    color: AppColor.textColor),
                                                                              ),
                                                                              SizedBox(height: 10,),
                                                                              Obx(() => Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                children: [
                                                                                  Row(
                                                                                    children: [
                                                                                      Radio<int?>(
                                                                                        value: 1,
                                                                                        groupValue: orderController.type.value,
                                                                                        onChanged: (value) {
                                                                                          orderController.checkType(value);
                                                                                        },
                                                                                        activeColor: AppColor.primaryColor,
                                                                                      ),
                                                                                      Text(
                                                                                        'خرید',
                                                                                        style: AppTextStyle.labelText.copyWith(
                                                                                            fontSize: 11,
                                                                                            fontWeight: FontWeight.normal,
                                                                                            color: AppColor.textColor),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  Row(
                                                                                    children: [
                                                                                      Radio<int?>(
                                                                                        value: 0,
                                                                                        groupValue: orderController.type.value,
                                                                                        onChanged: (value) {
                                                                                          orderController.checkType(value);
                                                                                        },
                                                                                        activeColor: AppColor.primaryColor,
                                                                                      ),
                                                                                      Text(
                                                                                        'فروش',
                                                                                        style: AppTextStyle.labelText.copyWith(
                                                                                            fontSize: 11,
                                                                                            fontWeight: FontWeight.normal,
                                                                                            color: AppColor.textColor),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  Row(
                                                                                    children: [
                                                                                      Radio<int?>(
                                                                                        value: null,
                                                                                        groupValue: orderController.type.value,
                                                                                        onChanged: (value) {
                                                                                          orderController.checkType(value);
                                                                                        },
                                                                                        activeColor: AppColor.primaryColor,
                                                                                      ),
                                                                                      Text(
                                                                                        'همه',
                                                                                        style: AppTextStyle.labelText.copyWith(
                                                                                            fontSize: 11,
                                                                                            fontWeight: FontWeight.normal,
                                                                                            color: AppColor.textColor),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              ))
                                                                            ],
                                                                          ),
                                                                          SizedBox(
                                                                            height: 8,),
                                                                          SizedBox(
                                                                            height: 8,),
                                                                          Column(
                                                                            crossAxisAlignment:
                                                                            CrossAxisAlignment
                                                                                .start,
                                                                            children: [
                                                                              Text(
                                                                                'نام',
                                                                                style: AppTextStyle
                                                                                    .labelText
                                                                                    .copyWith(
                                                                                    fontSize: 11,
                                                                                    fontWeight: FontWeight
                                                                                        .normal,
                                                                                    color: AppColor
                                                                                        .textColor),
                                                                              ),
                                                                              SizedBox(
                                                                                height: 10,),
                                                                              IntrinsicHeight(
                                                                                child: TextSelectionTheme(
                                                                                  data: TextSelectionThemeData(
                                                                                    selectionColor: Colors.white.withOpacity(0.4),
                                                                                  ),
                                                                                  child: TextFormField(
                                                                                    autovalidateMode: AutovalidateMode
                                                                                        .onUserInteraction,
                                                                                    controller: orderController
                                                                                        .nameFilterController,
                                                                                    style: AppTextStyle
                                                                                        .labelText
                                                                                        .copyWith(
                                                                                        fontSize: 15),
                                                                                    textAlign: TextAlign
                                                                                        .start,
                                                                                    keyboardType: TextInputType
                                                                                        .text,
                                                                                    decoration: InputDecoration(
                                                                                      contentPadding:
                                                                                      const EdgeInsets
                                                                                          .symmetric(
                                                                                          vertical: 11,
                                                                                          horizontal: 15
                                                                                      ),
                                                                                      isDense: true,
                                                                                      border: OutlineInputBorder(
                                                                                        borderRadius:
                                                                                        BorderRadius
                                                                                            .circular(
                                                                                            6),
                                                                                      ),
                                                                                      filled: true,
                                                                                      fillColor: AppColor
                                                                                          .textFieldColor,
                                                                                      errorMaxLines: 1,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),

                                                                          SizedBox(
                                                                              height: 8),
                                                                          Column(
                                                                            crossAxisAlignment: CrossAxisAlignment
                                                                                .start,
                                                                            children: [
                                                                              Text(
                                                                                'از تاریخ',
                                                                                style: AppTextStyle
                                                                                    .labelText
                                                                                    .copyWith(
                                                                                    fontSize: 13,
                                                                                    fontWeight: FontWeight
                                                                                        .normal,
                                                                                    color: AppColor
                                                                                        .textColor),
                                                                              ),
                                                                              Container(
                                                                                //height: 50,
                                                                                padding: EdgeInsets
                                                                                    .only(
                                                                                    bottom: 5),
                                                                                child: IntrinsicHeight(
                                                                                  child: TextSelectionTheme(
                                                                                    data: TextSelectionThemeData(
                                                                                      selectionColor: Colors.white.withOpacity(0.4),
                                                                                    ),
                                                                                    child: TextFormField(
                                                                                      validator: (
                                                                                          value) {
                                                                                        if (value ==
                                                                                            null ||
                                                                                            value
                                                                                                .isEmpty) {
                                                                                          return 'لطفا تاریخ را انتخاب کنید';
                                                                                        }
                                                                                        return null;
                                                                                      },
                                                                                      controller: orderController
                                                                                          .dateStartController,
                                                                                      readOnly: true,
                                                                                      style: AppTextStyle
                                                                                          .labelText,
                                                                                      decoration: InputDecoration(
                                                                                        suffixIcon: Icon(
                                                                                            Icons
                                                                                                .calendar_month,
                                                                                            color: AppColor
                                                                                                .textColor),
                                                                                        border: OutlineInputBorder(
                                                                                          borderRadius: BorderRadius
                                                                                              .circular(
                                                                                              10),
                                                                                        ),
                                                                                        filled: true,
                                                                                        fillColor: AppColor
                                                                                            .textFieldColor,
                                                                                        errorMaxLines: 1,
                                                                                      ),
                                                                                      onTap: () async {
                                                                                        Jalali? pickedDate = await showPersianDatePicker(
                                                                                          context: context,
                                                                                          initialDate: Jalali
                                                                                              .now(),
                                                                                          firstDate: Jalali(
                                                                                              1400,
                                                                                              1,
                                                                                              1),
                                                                                          lastDate: Jalali(
                                                                                              1450,
                                                                                              12,
                                                                                              29),
                                                                                          initialEntryMode: PersianDatePickerEntryMode
                                                                                              .calendar,
                                                                                          initialDatePickerMode: PersianDatePickerMode
                                                                                              .day,
                                                                                          locale: Locale(
                                                                                              "fa",
                                                                                              "IR"),
                                                                                        );
                                                                                        Gregorian gregorian = pickedDate!
                                                                                            .toGregorian();
                                                                                        orderController
                                                                                            .startDateFilter
                                                                                            .value =
                                                                                        "${gregorian
                                                                                            .year}-${gregorian
                                                                                            .month
                                                                                            .toString()
                                                                                            .padLeft(
                                                                                            2,
                                                                                            '0')}-${gregorian
                                                                                            .day
                                                                                            .toString()
                                                                                            .padLeft(
                                                                                            2,
                                                                                            '0')}";

                                                                                        orderController
                                                                                            .dateStartController
                                                                                            .text =
                                                                                        "${pickedDate
                                                                                            .year}/${pickedDate
                                                                                            .month
                                                                                            .toString()
                                                                                            .padLeft(
                                                                                            2,
                                                                                            '0')}/${pickedDate
                                                                                            .day
                                                                                            .toString()
                                                                                            .padLeft(
                                                                                            2,
                                                                                            '0')}";
                                                                                      },
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          SizedBox(
                                                                              height: 8),
                                                                          Column(
                                                                            crossAxisAlignment: CrossAxisAlignment
                                                                                .start,
                                                                            children: [
                                                                              Text(
                                                                                'تا تاریخ',
                                                                                style: AppTextStyle
                                                                                    .labelText
                                                                                    .copyWith(
                                                                                    fontSize: 13,
                                                                                    fontWeight: FontWeight
                                                                                        .normal,
                                                                                    color: AppColor
                                                                                        .textColor),
                                                                              ),
                                                                              Container(
                                                                                //height: 50,
                                                                                padding: EdgeInsets
                                                                                    .only(
                                                                                    bottom: 5),
                                                                                child: IntrinsicHeight(
                                                                                  child: TextSelectionTheme(
                                                                                    data: TextSelectionThemeData(
                                                                                      selectionColor: Colors.white.withOpacity(0.4),
                                                                                    ),
                                                                                    child: TextFormField(
                                                                                      validator: (
                                                                                          value) {
                                                                                        if (value ==
                                                                                            null ||
                                                                                            value
                                                                                                .isEmpty) {
                                                                                          return 'لطفا تاریخ را انتخاب کنید';
                                                                                        }
                                                                                        return null;
                                                                                      },
                                                                                      controller: orderController
                                                                                          .dateEndController,
                                                                                      readOnly: true,
                                                                                      style: AppTextStyle
                                                                                          .labelText,
                                                                                      decoration: InputDecoration(
                                                                                        suffixIcon: Icon(
                                                                                            Icons
                                                                                                .calendar_month,
                                                                                            color: AppColor
                                                                                                .textColor),
                                                                                        border: OutlineInputBorder(
                                                                                          borderRadius: BorderRadius
                                                                                              .circular(
                                                                                              10),
                                                                                        ),
                                                                                        filled: true,
                                                                                        fillColor: AppColor
                                                                                            .textFieldColor,
                                                                                        errorMaxLines: 1,
                                                                                      ),
                                                                                      onTap: () async {
                                                                                        Jalali? pickedDate = await showPersianDatePicker(
                                                                                          context: context,
                                                                                          initialDate: Jalali
                                                                                              .now(),
                                                                                          firstDate: Jalali(
                                                                                              1400,
                                                                                              1,
                                                                                              1),
                                                                                          lastDate: Jalali(
                                                                                              1450,
                                                                                              12,
                                                                                              29),
                                                                                          initialEntryMode: PersianDatePickerEntryMode
                                                                                              .calendar,
                                                                                          initialDatePickerMode: PersianDatePickerMode
                                                                                              .day,
                                                                                          locale: Locale(
                                                                                              "fa",
                                                                                              "IR"),
                                                                                        );
                                                                                        // DateTime date=DateTime.now();
                                                                                        Gregorian gregorian = pickedDate!
                                                                                            .toGregorian();
                                                                                        orderController
                                                                                            .endDateFilter
                                                                                            .value =
                                                                                        "${gregorian
                                                                                            .year}-${gregorian
                                                                                            .month
                                                                                            .toString()
                                                                                            .padLeft(
                                                                                            2,
                                                                                            '0')}-${gregorian
                                                                                            .day
                                                                                            .toString()
                                                                                            .padLeft(
                                                                                            2,
                                                                                            '0')}";

                                                                                        orderController
                                                                                            .dateEndController
                                                                                            .text =
                                                                                        "${pickedDate
                                                                                            .year}/${pickedDate
                                                                                            .month
                                                                                            .toString()
                                                                                            .padLeft(
                                                                                            2,
                                                                                            '0')}/${pickedDate
                                                                                            .day
                                                                                            .toString()
                                                                                            .padLeft(
                                                                                            2,
                                                                                            '0')}";
                                                                                      },
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),

                                                                        ],
                                                                      ),
                                                                    ),*/
                                                        OrderEditedFilterWidget(
                                                          controller: controller,
                                                        ),
                                                        //  Spacer(),
                                                        Container(
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                              horizontal: 20,
                                                              vertical: 10),
                                                          width: double
                                                              .infinity,
                                                          height: 40,
                                                          child: ElevatedButton(
                                                            style: ButtonStyle(
                                                                padding: WidgetStatePropertyAll(
                                                                    EdgeInsets
                                                                        .symmetric(
                                                                        horizontal: 23,
                                                                        vertical: 19)),
                                                                // elevation: WidgetStatePropertyAll(5),
                                                                backgroundColor:
                                                                WidgetStatePropertyAll(
                                                                    AppColor
                                                                        .appBarColor),
                                                                shape: WidgetStatePropertyAll(
                                                                    RoundedRectangleBorder(
                                                                        side: BorderSide(
                                                                            color: AppColor
                                                                                .textColor),
                                                                        borderRadius: BorderRadius
                                                                            .circular(
                                                                            5)))),
                                                            onPressed: () async {
                                                              controller.currentPage.value=1;
                                                              controller.itemsPerPage.value=25;
                                                              controller.getOrderEditedReportPager();
                                                              Get.back();
                                                            },
                                                            child: controller.isLoading.value ?
                                                            CircularProgressIndicator(
                                                              valueColor: AlwaysStoppedAnimation<
                                                                  Color>(
                                                                  AppColor
                                                                      .textColor),
                                                            )
                                                                :
                                                            Text(
                                                              'فیلتر',
                                                              style: AppTextStyle
                                                                  .labelText
                                                                  .copyWith(
                                                                  fontSize: isDesktop
                                                                      ? 12
                                                                      : 10),
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
                                      ColorFilter
                                          .mode(
                                        controller
                                            .nameFilterController
                                            .text != "" ||
                                            controller.dateStartController.text != "" ||
                                            controller.dateEndController.text != "" ||
                                            controller.dateStartCreatedOnController.text != "" ||
                                            controller.dateEndCreatedOnController.text != "" ||
                                            controller.dateStartModifiedOnController.text != "" ||
                                            controller.dateEndModifiedOnController.text != "" ||
                                            controller.byAdmin.value != null ||
                                            controller.type.value != null ||
                                            controller.selectedItemFilter.value !=null
                                            ? AppColor
                                            .accentColor
                                            : AppColor
                                            .textColor,
                                        BlendMode
                                            .srcIn,
                                      )),
                                ),
                                // خروجی pdf
                                /*ElevatedButton(
                                  style: ButtonStyle(
                                      padding: WidgetStatePropertyAll(
                                        EdgeInsets.symmetric(
                                            horizontal: 23,vertical: 19
                                        ),
                                      ),
                                      elevation: WidgetStatePropertyAll(5),
                                      //fixedSize: WidgetStatePropertyAll(Size(100,30)),
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
                                                          controller.getOrderEditedReportPager();
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
                                            SizedBox(width: 10,),
                                            Row(
                                              children: [
                                                // فیلتر
                                                OutlinedButton.icon(
                                                  onPressed: () async {
                                                    showGeneralDialog(
                                                        context: context,
                                                        barrierDismissible: true,
                                                        barrierLabel: MaterialLocalizations
                                                            .of(context)
                                                            .modalBarrierDismissLabel,
                                                        barrierColor: Colors
                                                            .black45,
                                                        transitionDuration: const Duration(
                                                            milliseconds: 200),
                                                        pageBuilder: (
                                                            BuildContext buildContext,
                                                            Animation animation,
                                                            Animation secondaryAnimation) {
                                                          return Center(
                                                            child: Material(
                                                              color: Colors
                                                                  .transparent,
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius
                                                                        .circular(
                                                                        8),
                                                                    color: AppColor
                                                                        .backGroundColor
                                                                ),
                                                                width: isDesktop ? Get.width * 0.35
                                                                    : Get.height * 0.5,
                                                                height: isDesktop ? Get.height * 0.75
                                                                    : Get.height * 0.75,
                                                                padding: EdgeInsets
                                                                    .all(20),
                                                                child: SingleChildScrollView(
                                                                  child: Column(
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                        child: Row(
                                                                          mainAxisAlignment: MainAxisAlignment
                                                                              .end,
                                                                          children: [
                                                                            Expanded(
                                                                              child: Center(
                                                                                child: Text(
                                                                                  'فیلتر',
                                                                                  style: AppTextStyle
                                                                                      .labelText
                                                                                      .copyWith(
                                                                                    fontSize: 15,
                                                                                    fontWeight: FontWeight
                                                                                        .normal,
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
                                                                                        EdgeInsets
                                                                                            .symmetric(
                                                                                            horizontal: 2,
                                                                                            vertical: 1)),
                                                                                    // elevation: WidgetStatePropertyAll(5),
                                                                                    backgroundColor:
                                                                                    WidgetStatePropertyAll(
                                                                                        AppColor
                                                                                            .accentColor
                                                                                            .withOpacity(
                                                                                            0.5)),
                                                                                    shape: WidgetStatePropertyAll(
                                                                                        RoundedRectangleBorder(
                                                                                            side: BorderSide(
                                                                                                color: AppColor
                                                                                                    .textColor),
                                                                                            borderRadius: BorderRadius
                                                                                                .circular(
                                                                                                5)))),
                                                                                onPressed: () async {
                                                                                  controller
                                                                                      .clearFilter();
                                                                                  controller
                                                                                      .getOrderEditedReportPager();
                                                                                  Get
                                                                                      .back();
                                                                                },
                                                                                child: Text(
                                                                                  'حذف فیلتر',
                                                                                  style: AppTextStyle
                                                                                      .labelText
                                                                                      .copyWith(
                                                                                      fontSize: isDesktop
                                                                                          ? 9
                                                                                          : 8),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        color: AppColor
                                                                            .textColor,
                                                                        height: 0.2,
                                                                      ),
                                                                      /*Padding(
                                                                      padding: const EdgeInsets
                                                                          .symmetric(
                                                                          horizontal: 10),
                                                                      child: Column(
                                                                        children: [
                                                                          SizedBox(height: 8),
                                                                          Column(
                                                                            crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                'فیلتر ادمین',
                                                                                style: AppTextStyle.labelText.copyWith(
                                                                                    fontSize: 11,
                                                                                    fontWeight: FontWeight.normal,
                                                                                    color: AppColor.textColor),
                                                                              ),
                                                                              SizedBox(height: 10,),
                                                                              Obx(() => Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                children: [
                                                                                  Row(
                                                                                    children: [
                                                                                      Radio<int?>(
                                                                                        value: 1,
                                                                                        groupValue: orderController.byAdmin.value,
                                                                                        onChanged: (value) {
                                                                                          orderController.checkByAdmin(value);
                                                                                        },
                                                                                        activeColor: AppColor.primaryColor,
                                                                                      ),
                                                                                      Text(
                                                                                        'ادمین',
                                                                                        style: AppTextStyle.labelText.copyWith(
                                                                                            fontSize: 11,
                                                                                            fontWeight: FontWeight.normal,
                                                                                            color: AppColor.textColor),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  Row(
                                                                                    children: [
                                                                                      Radio<int?>(
                                                                                        value: 0,
                                                                                        groupValue: orderController.byAdmin.value,
                                                                                        onChanged: (value) {
                                                                                          orderController.checkByAdmin(value);
                                                                                        },
                                                                                        activeColor: AppColor.primaryColor,
                                                                                      ),
                                                                                      Text(
                                                                                        'غیر ادمین',
                                                                                        style: AppTextStyle.labelText.copyWith(
                                                                                            fontSize: 11,
                                                                                            fontWeight: FontWeight.normal,
                                                                                            color: AppColor.textColor),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  Row(
                                                                                    children: [
                                                                                      Radio<int?>(
                                                                                        value: null,
                                                                                        groupValue: orderController.byAdmin.value,
                                                                                        onChanged: (value) {
                                                                                          orderController.checkByAdmin(value);
                                                                                        },
                                                                                        activeColor: AppColor.primaryColor,
                                                                                      ),
                                                                                      Text(
                                                                                        'همه',
                                                                                        style: AppTextStyle.labelText.copyWith(
                                                                                            fontSize: 11,
                                                                                            fontWeight: FontWeight.normal,
                                                                                            color: AppColor.textColor),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              ))
                                                                            ],
                                                                          ),
                                                                          SizedBox(height: 8),
                                                                          Column(
                                                                            crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                'نوع سفارش',
                                                                                style: AppTextStyle.labelText.copyWith(
                                                                                    fontSize: 11,
                                                                                    fontWeight: FontWeight.normal,
                                                                                    color: AppColor.textColor),
                                                                              ),
                                                                              SizedBox(height: 10,),
                                                                              Obx(() => Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                children: [
                                                                                  Row(
                                                                                    children: [
                                                                                      Radio<int?>(
                                                                                        value: 1,
                                                                                        groupValue: orderController.type.value,
                                                                                        onChanged: (value) {
                                                                                          orderController.checkType(value);
                                                                                        },
                                                                                        activeColor: AppColor.primaryColor,
                                                                                      ),
                                                                                      Text(
                                                                                        'خرید',
                                                                                        style: AppTextStyle.labelText.copyWith(
                                                                                            fontSize: 11,
                                                                                            fontWeight: FontWeight.normal,
                                                                                            color: AppColor.textColor),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  Row(
                                                                                    children: [
                                                                                      Radio<int?>(
                                                                                        value: 0,
                                                                                        groupValue: orderController.type.value,
                                                                                        onChanged: (value) {
                                                                                          orderController.checkType(value);
                                                                                        },
                                                                                        activeColor: AppColor.primaryColor,
                                                                                      ),
                                                                                      Text(
                                                                                        'فروش',
                                                                                        style: AppTextStyle.labelText.copyWith(
                                                                                            fontSize: 11,
                                                                                            fontWeight: FontWeight.normal,
                                                                                            color: AppColor.textColor),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  Row(
                                                                                    children: [
                                                                                      Radio<int?>(
                                                                                        value: null,
                                                                                        groupValue: orderController.type.value,
                                                                                        onChanged: (value) {
                                                                                          orderController.checkType(value);
                                                                                        },
                                                                                        activeColor: AppColor.primaryColor,
                                                                                      ),
                                                                                      Text(
                                                                                        'همه',
                                                                                        style: AppTextStyle.labelText.copyWith(
                                                                                            fontSize: 11,
                                                                                            fontWeight: FontWeight.normal,
                                                                                            color: AppColor.textColor),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              ))
                                                                            ],
                                                                          ),
                                                                          SizedBox(
                                                                            height: 8,),
                                                                          SizedBox(
                                                                            height: 8,),
                                                                          Column(
                                                                            crossAxisAlignment:
                                                                            CrossAxisAlignment
                                                                                .start,
                                                                            children: [
                                                                              Text(
                                                                                'نام',
                                                                                style: AppTextStyle
                                                                                    .labelText
                                                                                    .copyWith(
                                                                                    fontSize: 11,
                                                                                    fontWeight: FontWeight
                                                                                        .normal,
                                                                                    color: AppColor
                                                                                        .textColor),
                                                                              ),
                                                                              SizedBox(
                                                                                height: 10,),
                                                                              IntrinsicHeight(
                                                                                child: TextSelectionTheme(
                                                                                  data: TextSelectionThemeData(
                                                                                    selectionColor: Colors.white.withOpacity(0.4),
                                                                                  ),
                                                                                  child: TextFormField(
                                                                                    autovalidateMode: AutovalidateMode
                                                                                        .onUserInteraction,
                                                                                    controller: orderController
                                                                                        .nameFilterController,
                                                                                    style: AppTextStyle
                                                                                        .labelText
                                                                                        .copyWith(
                                                                                        fontSize: 15),
                                                                                    textAlign: TextAlign
                                                                                        .start,
                                                                                    keyboardType: TextInputType
                                                                                        .text,
                                                                                    decoration: InputDecoration(
                                                                                      contentPadding:
                                                                                      const EdgeInsets
                                                                                          .symmetric(
                                                                                          vertical: 11,
                                                                                          horizontal: 15
                                                                                      ),
                                                                                      isDense: true,
                                                                                      border: OutlineInputBorder(
                                                                                        borderRadius:
                                                                                        BorderRadius
                                                                                            .circular(
                                                                                            6),
                                                                                      ),
                                                                                      filled: true,
                                                                                      fillColor: AppColor
                                                                                          .textFieldColor,
                                                                                      errorMaxLines: 1,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),

                                                                          SizedBox(
                                                                              height: 8),
                                                                          Column(
                                                                            crossAxisAlignment: CrossAxisAlignment
                                                                                .start,
                                                                            children: [
                                                                              Text(
                                                                                'از تاریخ',
                                                                                style: AppTextStyle
                                                                                    .labelText
                                                                                    .copyWith(
                                                                                    fontSize: 13,
                                                                                    fontWeight: FontWeight
                                                                                        .normal,
                                                                                    color: AppColor
                                                                                        .textColor),
                                                                              ),
                                                                              Container(
                                                                                //height: 50,
                                                                                padding: EdgeInsets
                                                                                    .only(
                                                                                    bottom: 5),
                                                                                child: IntrinsicHeight(
                                                                                  child: TextSelectionTheme(
                                                                                    data: TextSelectionThemeData(
                                                                                      selectionColor: Colors.white.withOpacity(0.4),
                                                                                    ),
                                                                                    child: TextFormField(
                                                                                      validator: (
                                                                                          value) {
                                                                                        if (value ==
                                                                                            null ||
                                                                                            value
                                                                                                .isEmpty) {
                                                                                          return 'لطفا تاریخ را انتخاب کنید';
                                                                                        }
                                                                                        return null;
                                                                                      },
                                                                                      controller: orderController
                                                                                          .dateStartController,
                                                                                      readOnly: true,
                                                                                      style: AppTextStyle
                                                                                          .labelText,
                                                                                      decoration: InputDecoration(
                                                                                        suffixIcon: Icon(
                                                                                            Icons
                                                                                                .calendar_month,
                                                                                            color: AppColor
                                                                                                .textColor),
                                                                                        border: OutlineInputBorder(
                                                                                          borderRadius: BorderRadius
                                                                                              .circular(
                                                                                              10),
                                                                                        ),
                                                                                        filled: true,
                                                                                        fillColor: AppColor
                                                                                            .textFieldColor,
                                                                                        errorMaxLines: 1,
                                                                                      ),
                                                                                      onTap: () async {
                                                                                        Jalali? pickedDate = await showPersianDatePicker(
                                                                                          context: context,
                                                                                          initialDate: Jalali
                                                                                              .now(),
                                                                                          firstDate: Jalali(
                                                                                              1400,
                                                                                              1,
                                                                                              1),
                                                                                          lastDate: Jalali(
                                                                                              1450,
                                                                                              12,
                                                                                              29),
                                                                                          initialEntryMode: PersianDatePickerEntryMode
                                                                                              .calendar,
                                                                                          initialDatePickerMode: PersianDatePickerMode
                                                                                              .day,
                                                                                          locale: Locale(
                                                                                              "fa",
                                                                                              "IR"),
                                                                                        );
                                                                                        Gregorian gregorian = pickedDate!
                                                                                            .toGregorian();
                                                                                        orderController
                                                                                            .startDateFilter
                                                                                            .value =
                                                                                        "${gregorian
                                                                                            .year}-${gregorian
                                                                                            .month
                                                                                            .toString()
                                                                                            .padLeft(
                                                                                            2,
                                                                                            '0')}-${gregorian
                                                                                            .day
                                                                                            .toString()
                                                                                            .padLeft(
                                                                                            2,
                                                                                            '0')}";

                                                                                        orderController
                                                                                            .dateStartController
                                                                                            .text =
                                                                                        "${pickedDate
                                                                                            .year}/${pickedDate
                                                                                            .month
                                                                                            .toString()
                                                                                            .padLeft(
                                                                                            2,
                                                                                            '0')}/${pickedDate
                                                                                            .day
                                                                                            .toString()
                                                                                            .padLeft(
                                                                                            2,
                                                                                            '0')}";
                                                                                      },
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          SizedBox(
                                                                              height: 8),
                                                                          Column(
                                                                            crossAxisAlignment: CrossAxisAlignment
                                                                                .start,
                                                                            children: [
                                                                              Text(
                                                                                'تا تاریخ',
                                                                                style: AppTextStyle
                                                                                    .labelText
                                                                                    .copyWith(
                                                                                    fontSize: 13,
                                                                                    fontWeight: FontWeight
                                                                                        .normal,
                                                                                    color: AppColor
                                                                                        .textColor),
                                                                              ),
                                                                              Container(
                                                                                //height: 50,
                                                                                padding: EdgeInsets
                                                                                    .only(
                                                                                    bottom: 5),
                                                                                child: IntrinsicHeight(
                                                                                  child: TextSelectionTheme(
                                                                                    data: TextSelectionThemeData(
                                                                                      selectionColor: Colors.white.withOpacity(0.4),
                                                                                    ),
                                                                                    child: TextFormField(
                                                                                      validator: (
                                                                                          value) {
                                                                                        if (value ==
                                                                                            null ||
                                                                                            value
                                                                                                .isEmpty) {
                                                                                          return 'لطفا تاریخ را انتخاب کنید';
                                                                                        }
                                                                                        return null;
                                                                                      },
                                                                                      controller: orderController
                                                                                          .dateEndController,
                                                                                      readOnly: true,
                                                                                      style: AppTextStyle
                                                                                          .labelText,
                                                                                      decoration: InputDecoration(
                                                                                        suffixIcon: Icon(
                                                                                            Icons
                                                                                                .calendar_month,
                                                                                            color: AppColor
                                                                                                .textColor),
                                                                                        border: OutlineInputBorder(
                                                                                          borderRadius: BorderRadius
                                                                                              .circular(
                                                                                              10),
                                                                                        ),
                                                                                        filled: true,
                                                                                        fillColor: AppColor
                                                                                            .textFieldColor,
                                                                                        errorMaxLines: 1,
                                                                                      ),
                                                                                      onTap: () async {
                                                                                        Jalali? pickedDate = await showPersianDatePicker(
                                                                                          context: context,
                                                                                          initialDate: Jalali
                                                                                              .now(),
                                                                                          firstDate: Jalali(
                                                                                              1400,
                                                                                              1,
                                                                                              1),
                                                                                          lastDate: Jalali(
                                                                                              1450,
                                                                                              12,
                                                                                              29),
                                                                                          initialEntryMode: PersianDatePickerEntryMode
                                                                                              .calendar,
                                                                                          initialDatePickerMode: PersianDatePickerMode
                                                                                              .day,
                                                                                          locale: Locale(
                                                                                              "fa",
                                                                                              "IR"),
                                                                                        );
                                                                                        // DateTime date=DateTime.now();
                                                                                        Gregorian gregorian = pickedDate!
                                                                                            .toGregorian();
                                                                                        orderController
                                                                                            .endDateFilter
                                                                                            .value =
                                                                                        "${gregorian
                                                                                            .year}-${gregorian
                                                                                            .month
                                                                                            .toString()
                                                                                            .padLeft(
                                                                                            2,
                                                                                            '0')}-${gregorian
                                                                                            .day
                                                                                            .toString()
                                                                                            .padLeft(
                                                                                            2,
                                                                                            '0')}";

                                                                                        orderController
                                                                                            .dateEndController
                                                                                            .text =
                                                                                        "${pickedDate
                                                                                            .year}/${pickedDate
                                                                                            .month
                                                                                            .toString()
                                                                                            .padLeft(
                                                                                            2,
                                                                                            '0')}/${pickedDate
                                                                                            .day
                                                                                            .toString()
                                                                                            .padLeft(
                                                                                            2,
                                                                                            '0')}";
                                                                                      },
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),

                                                                        ],
                                                                      ),
                                                                    ),*/
                                                                      OrderEditedFilterWidget(
                                                                        controller: controller,
                                                                      ),
                                                                      //  Spacer(),
                                                                      Container(
                                                                        margin: EdgeInsets
                                                                            .symmetric(
                                                                            horizontal: 20,
                                                                            vertical: 10),
                                                                        width: double
                                                                            .infinity,
                                                                        height: 40,
                                                                        child: ElevatedButton(
                                                                          style: ButtonStyle(
                                                                              padding: WidgetStatePropertyAll(
                                                                                  EdgeInsets
                                                                                      .symmetric(
                                                                                      horizontal: 23,
                                                                                      vertical: 19)),
                                                                              // elevation: WidgetStatePropertyAll(5),
                                                                              backgroundColor:
                                                                              WidgetStatePropertyAll(
                                                                                  AppColor
                                                                                      .appBarColor),
                                                                              shape: WidgetStatePropertyAll(
                                                                                  RoundedRectangleBorder(
                                                                                      side: BorderSide(
                                                                                          color: AppColor
                                                                                              .textColor),
                                                                                      borderRadius: BorderRadius
                                                                                          .circular(
                                                                                          5)))),
                                                                          onPressed: () async {
                                                                            controller
                                                                                .getOrderEditedReportPager();
                                                                            Get
                                                                                .back();
                                                                          },
                                                                          child: controller
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
                                                                            'فیلتر',
                                                                            style: AppTextStyle
                                                                                .labelText
                                                                                .copyWith(
                                                                                fontSize: isDesktop
                                                                                    ? 12
                                                                                    : 10),
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
                                                            : 10,
                                                        color: controller
                                                            .nameFilterController
                                                            .text != "" ||
                                                            controller.dateStartController.text != "" ||
                                                            controller.dateEndController.text != ""||
                                                            controller.dateStartCreatedOnController.text != "" ||
                                                            controller.dateEndCreatedOnController.text != "" ||
                                                            controller.dateStartModifiedOnController.text != "" ||
                                                            controller.dateEndModifiedOnController.text != "" ||
                                                            controller.byAdmin.value != null||
                                                            controller.type.value != null ||
                                                            controller.selectedItemFilter.value !=null
                                                            ? AppColor
                                                            .accentColor
                                                            : AppColor
                                                            .textColor),
                                                  ),
                                                  icon: SvgPicture.asset(
                                                      'assets/svg/filter3.svg',
                                                      height: 17,
                                                      colorFilter:
                                                      ColorFilter
                                                          .mode(
                                                        controller
                                                            .nameFilterController
                                                            .text != "" ||
                                                            controller.dateStartController.text != "" ||
                                                            controller.dateEndController.text != "" ||
                                                            controller.dateStartCreatedOnController.text != "" ||
                                                            controller.dateEndCreatedOnController.text != "" ||
                                                            controller.dateStartModifiedOnController.text != "" ||
                                                            controller.dateEndModifiedOnController.text != "" ||
                                                            controller.byAdmin.value != null ||
                                                            controller.type.value != null ||
                                                            controller.selectedItemFilter.value !=null
                                                            ? AppColor
                                                            .accentColor
                                                            : AppColor
                                                            .textColor,
                                                        BlendMode
                                                            .srcIn,
                                                      )),
                                                ),
                                                /*ElevatedButton(
                                  style: ButtonStyle(
                                      padding: WidgetStatePropertyAll(
                                          EdgeInsets.symmetric(
                                              horizontal: 23,
                                              vertical: 12)),
                                      // elevation: WidgetStatePropertyAll(5),
                                      backgroundColor:
                                      WidgetStatePropertyAll(
                                          AppColor.appBarColor
                                              .withOpacity(
                                              0.5)),
                                      shape: WidgetStatePropertyAll(
                                          RoundedRectangleBorder(
                                              side: BorderSide(
                                                  color: AppColor
                                                      .textColor),
                                              borderRadius: BorderRadius
                                                  .circular(
                                                  5)))),
                                  onPressed: () async {
                                    showGeneralDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        barrierLabel: MaterialLocalizations
                                            .of(context)
                                            .modalBarrierDismissLabel,
                                        barrierColor: Colors
                                            .black45,
                                        transitionDuration: const Duration(
                                            milliseconds: 200),
                                        pageBuilder: (
                                            BuildContext buildContext,
                                            Animation animation,
                                            Animation secondaryAnimation) {
                                          return Center(
                                            child: Material(
                                              color: Colors
                                                  .transparent,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius
                                                        .circular(
                                                        8),
                                                    color: AppColor
                                                        .backGroundColor
                                                ),
                                                width: isDesktop ? Get.width * 0.35
                                                    : Get.height * 0.5,
                                                height: isDesktop ? Get.height * 0.75
                                                    : Get.height * 0.75,
                                                padding: EdgeInsets
                                                    .all(20),
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets
                                                            .all(
                                                            8.0),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment
                                                              .end,
                                                          children: [
                                                            Expanded(
                                                              child: Center(
                                                                child: Text(
                                                                  'فیلتر',
                                                                  style: AppTextStyle
                                                                      .labelText
                                                                      .copyWith(
                                                                    fontSize: 15,
                                                                    fontWeight: FontWeight
                                                                        .normal,
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
                                                                        EdgeInsets
                                                                            .symmetric(
                                                                            horizontal: 2,
                                                                            vertical: 1)),
                                                                    // elevation: WidgetStatePropertyAll(5),
                                                                    backgroundColor:
                                                                    WidgetStatePropertyAll(
                                                                        AppColor
                                                                            .accentColor
                                                                            .withOpacity(
                                                                            0.5)),
                                                                    shape: WidgetStatePropertyAll(
                                                                        RoundedRectangleBorder(
                                                                            side: BorderSide(
                                                                                color: AppColor
                                                                                    .textColor),
                                                                            borderRadius: BorderRadius
                                                                                .circular(
                                                                                5)))),
                                                                onPressed: () async {
                                                                  controller
                                                                      .clearFilter();
                                                                  controller
                                                                      .getOrderEditedReportPager();
                                                                  Get
                                                                      .back();
                                                                },
                                                                child: Text(
                                                                  'حذف فیلتر',
                                                                  style: AppTextStyle
                                                                      .labelText
                                                                      .copyWith(
                                                                      fontSize: isDesktop
                                                                          ? 9
                                                                          : 8),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        color: AppColor
                                                            .textColor,
                                                        height: 0.2,
                                                      ),
                                                      *//*Padding(
                                                                      padding: const EdgeInsets
                                                                          .symmetric(
                                                                          horizontal: 10),
                                                                      child: Column(
                                                                        children: [
                                                                          SizedBox(height: 8),
                                                                          Column(
                                                                            crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                'فیلتر ادمین',
                                                                                style: AppTextStyle.labelText.copyWith(
                                                                                    fontSize: 11,
                                                                                    fontWeight: FontWeight.normal,
                                                                                    color: AppColor.textColor),
                                                                              ),
                                                                              SizedBox(height: 10,),
                                                                              Obx(() => Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                children: [
                                                                                  Row(
                                                                                    children: [
                                                                                      Radio<int?>(
                                                                                        value: 1,
                                                                                        groupValue: orderController.byAdmin.value,
                                                                                        onChanged: (value) {
                                                                                          orderController.checkByAdmin(value);
                                                                                        },
                                                                                        activeColor: AppColor.primaryColor,
                                                                                      ),
                                                                                      Text(
                                                                                        'ادمین',
                                                                                        style: AppTextStyle.labelText.copyWith(
                                                                                            fontSize: 11,
                                                                                            fontWeight: FontWeight.normal,
                                                                                            color: AppColor.textColor),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  Row(
                                                                                    children: [
                                                                                      Radio<int?>(
                                                                                        value: 0,
                                                                                        groupValue: orderController.byAdmin.value,
                                                                                        onChanged: (value) {
                                                                                          orderController.checkByAdmin(value);
                                                                                        },
                                                                                        activeColor: AppColor.primaryColor,
                                                                                      ),
                                                                                      Text(
                                                                                        'غیر ادمین',
                                                                                        style: AppTextStyle.labelText.copyWith(
                                                                                            fontSize: 11,
                                                                                            fontWeight: FontWeight.normal,
                                                                                            color: AppColor.textColor),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  Row(
                                                                                    children: [
                                                                                      Radio<int?>(
                                                                                        value: null,
                                                                                        groupValue: orderController.byAdmin.value,
                                                                                        onChanged: (value) {
                                                                                          orderController.checkByAdmin(value);
                                                                                        },
                                                                                        activeColor: AppColor.primaryColor,
                                                                                      ),
                                                                                      Text(
                                                                                        'همه',
                                                                                        style: AppTextStyle.labelText.copyWith(
                                                                                            fontSize: 11,
                                                                                            fontWeight: FontWeight.normal,
                                                                                            color: AppColor.textColor),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              ))
                                                                            ],
                                                                          ),
                                                                          SizedBox(height: 8),
                                                                          Column(
                                                                            crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                'نوع سفارش',
                                                                                style: AppTextStyle.labelText.copyWith(
                                                                                    fontSize: 11,
                                                                                    fontWeight: FontWeight.normal,
                                                                                    color: AppColor.textColor),
                                                                              ),
                                                                              SizedBox(height: 10,),
                                                                              Obx(() => Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                children: [
                                                                                  Row(
                                                                                    children: [
                                                                                      Radio<int?>(
                                                                                        value: 1,
                                                                                        groupValue: orderController.type.value,
                                                                                        onChanged: (value) {
                                                                                          orderController.checkType(value);
                                                                                        },
                                                                                        activeColor: AppColor.primaryColor,
                                                                                      ),
                                                                                      Text(
                                                                                        'خرید',
                                                                                        style: AppTextStyle.labelText.copyWith(
                                                                                            fontSize: 11,
                                                                                            fontWeight: FontWeight.normal,
                                                                                            color: AppColor.textColor),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  Row(
                                                                                    children: [
                                                                                      Radio<int?>(
                                                                                        value: 0,
                                                                                        groupValue: orderController.type.value,
                                                                                        onChanged: (value) {
                                                                                          orderController.checkType(value);
                                                                                        },
                                                                                        activeColor: AppColor.primaryColor,
                                                                                      ),
                                                                                      Text(
                                                                                        'فروش',
                                                                                        style: AppTextStyle.labelText.copyWith(
                                                                                            fontSize: 11,
                                                                                            fontWeight: FontWeight.normal,
                                                                                            color: AppColor.textColor),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  Row(
                                                                                    children: [
                                                                                      Radio<int?>(
                                                                                        value: null,
                                                                                        groupValue: orderController.type.value,
                                                                                        onChanged: (value) {
                                                                                          orderController.checkType(value);
                                                                                        },
                                                                                        activeColor: AppColor.primaryColor,
                                                                                      ),
                                                                                      Text(
                                                                                        'همه',
                                                                                        style: AppTextStyle.labelText.copyWith(
                                                                                            fontSize: 11,
                                                                                            fontWeight: FontWeight.normal,
                                                                                            color: AppColor.textColor),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              ))
                                                                            ],
                                                                          ),
                                                                          SizedBox(
                                                                            height: 8,),
                                                                          SizedBox(
                                                                            height: 8,),
                                                                          Column(
                                                                            crossAxisAlignment:
                                                                            CrossAxisAlignment
                                                                                .start,
                                                                            children: [
                                                                              Text(
                                                                                'نام',
                                                                                style: AppTextStyle
                                                                                    .labelText
                                                                                    .copyWith(
                                                                                    fontSize: 11,
                                                                                    fontWeight: FontWeight
                                                                                        .normal,
                                                                                    color: AppColor
                                                                                        .textColor),
                                                                              ),
                                                                              SizedBox(
                                                                                height: 10,),
                                                                              IntrinsicHeight(
                                                                                child: TextSelectionTheme(
                                                                                  data: TextSelectionThemeData(
                                                                                    selectionColor: Colors.white.withOpacity(0.4),
                                                                                  ),
                                                                                  child: TextFormField(
                                                                                    autovalidateMode: AutovalidateMode
                                                                                        .onUserInteraction,
                                                                                    controller: orderController
                                                                                        .nameFilterController,
                                                                                    style: AppTextStyle
                                                                                        .labelText
                                                                                        .copyWith(
                                                                                        fontSize: 15),
                                                                                    textAlign: TextAlign
                                                                                        .start,
                                                                                    keyboardType: TextInputType
                                                                                        .text,
                                                                                    decoration: InputDecoration(
                                                                                      contentPadding:
                                                                                      const EdgeInsets
                                                                                          .symmetric(
                                                                                          vertical: 11,
                                                                                          horizontal: 15
                                                                                      ),
                                                                                      isDense: true,
                                                                                      border: OutlineInputBorder(
                                                                                        borderRadius:
                                                                                        BorderRadius
                                                                                            .circular(
                                                                                            6),
                                                                                      ),
                                                                                      filled: true,
                                                                                      fillColor: AppColor
                                                                                          .textFieldColor,
                                                                                      errorMaxLines: 1,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),

                                                                          SizedBox(
                                                                              height: 8),
                                                                          Column(
                                                                            crossAxisAlignment: CrossAxisAlignment
                                                                                .start,
                                                                            children: [
                                                                              Text(
                                                                                'از تاریخ',
                                                                                style: AppTextStyle
                                                                                    .labelText
                                                                                    .copyWith(
                                                                                    fontSize: 13,
                                                                                    fontWeight: FontWeight
                                                                                        .normal,
                                                                                    color: AppColor
                                                                                        .textColor),
                                                                              ),
                                                                              Container(
                                                                                //height: 50,
                                                                                padding: EdgeInsets
                                                                                    .only(
                                                                                    bottom: 5),
                                                                                child: IntrinsicHeight(
                                                                                  child: TextSelectionTheme(
                                                                                    data: TextSelectionThemeData(
                                                                                      selectionColor: Colors.white.withOpacity(0.4),
                                                                                    ),
                                                                                    child: TextFormField(
                                                                                      validator: (
                                                                                          value) {
                                                                                        if (value ==
                                                                                            null ||
                                                                                            value
                                                                                                .isEmpty) {
                                                                                          return 'لطفا تاریخ را انتخاب کنید';
                                                                                        }
                                                                                        return null;
                                                                                      },
                                                                                      controller: orderController
                                                                                          .dateStartController,
                                                                                      readOnly: true,
                                                                                      style: AppTextStyle
                                                                                          .labelText,
                                                                                      decoration: InputDecoration(
                                                                                        suffixIcon: Icon(
                                                                                            Icons
                                                                                                .calendar_month,
                                                                                            color: AppColor
                                                                                                .textColor),
                                                                                        border: OutlineInputBorder(
                                                                                          borderRadius: BorderRadius
                                                                                              .circular(
                                                                                              10),
                                                                                        ),
                                                                                        filled: true,
                                                                                        fillColor: AppColor
                                                                                            .textFieldColor,
                                                                                        errorMaxLines: 1,
                                                                                      ),
                                                                                      onTap: () async {
                                                                                        Jalali? pickedDate = await showPersianDatePicker(
                                                                                          context: context,
                                                                                          initialDate: Jalali
                                                                                              .now(),
                                                                                          firstDate: Jalali(
                                                                                              1400,
                                                                                              1,
                                                                                              1),
                                                                                          lastDate: Jalali(
                                                                                              1450,
                                                                                              12,
                                                                                              29),
                                                                                          initialEntryMode: PersianDatePickerEntryMode
                                                                                              .calendar,
                                                                                          initialDatePickerMode: PersianDatePickerMode
                                                                                              .day,
                                                                                          locale: Locale(
                                                                                              "fa",
                                                                                              "IR"),
                                                                                        );
                                                                                        Gregorian gregorian = pickedDate!
                                                                                            .toGregorian();
                                                                                        orderController
                                                                                            .startDateFilter
                                                                                            .value =
                                                                                        "${gregorian
                                                                                            .year}-${gregorian
                                                                                            .month
                                                                                            .toString()
                                                                                            .padLeft(
                                                                                            2,
                                                                                            '0')}-${gregorian
                                                                                            .day
                                                                                            .toString()
                                                                                            .padLeft(
                                                                                            2,
                                                                                            '0')}";

                                                                                        orderController
                                                                                            .dateStartController
                                                                                            .text =
                                                                                        "${pickedDate
                                                                                            .year}/${pickedDate
                                                                                            .month
                                                                                            .toString()
                                                                                            .padLeft(
                                                                                            2,
                                                                                            '0')}/${pickedDate
                                                                                            .day
                                                                                            .toString()
                                                                                            .padLeft(
                                                                                            2,
                                                                                            '0')}";
                                                                                      },
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          SizedBox(
                                                                              height: 8),
                                                                          Column(
                                                                            crossAxisAlignment: CrossAxisAlignment
                                                                                .start,
                                                                            children: [
                                                                              Text(
                                                                                'تا تاریخ',
                                                                                style: AppTextStyle
                                                                                    .labelText
                                                                                    .copyWith(
                                                                                    fontSize: 13,
                                                                                    fontWeight: FontWeight
                                                                                        .normal,
                                                                                    color: AppColor
                                                                                        .textColor),
                                                                              ),
                                                                              Container(
                                                                                //height: 50,
                                                                                padding: EdgeInsets
                                                                                    .only(
                                                                                    bottom: 5),
                                                                                child: IntrinsicHeight(
                                                                                  child: TextSelectionTheme(
                                                                                    data: TextSelectionThemeData(
                                                                                      selectionColor: Colors.white.withOpacity(0.4),
                                                                                    ),
                                                                                    child: TextFormField(
                                                                                      validator: (
                                                                                          value) {
                                                                                        if (value ==
                                                                                            null ||
                                                                                            value
                                                                                                .isEmpty) {
                                                                                          return 'لطفا تاریخ را انتخاب کنید';
                                                                                        }
                                                                                        return null;
                                                                                      },
                                                                                      controller: orderController
                                                                                          .dateEndController,
                                                                                      readOnly: true,
                                                                                      style: AppTextStyle
                                                                                          .labelText,
                                                                                      decoration: InputDecoration(
                                                                                        suffixIcon: Icon(
                                                                                            Icons
                                                                                                .calendar_month,
                                                                                            color: AppColor
                                                                                                .textColor),
                                                                                        border: OutlineInputBorder(
                                                                                          borderRadius: BorderRadius
                                                                                              .circular(
                                                                                              10),
                                                                                        ),
                                                                                        filled: true,
                                                                                        fillColor: AppColor
                                                                                            .textFieldColor,
                                                                                        errorMaxLines: 1,
                                                                                      ),
                                                                                      onTap: () async {
                                                                                        Jalali? pickedDate = await showPersianDatePicker(
                                                                                          context: context,
                                                                                          initialDate: Jalali
                                                                                              .now(),
                                                                                          firstDate: Jalali(
                                                                                              1400,
                                                                                              1,
                                                                                              1),
                                                                                          lastDate: Jalali(
                                                                                              1450,
                                                                                              12,
                                                                                              29),
                                                                                          initialEntryMode: PersianDatePickerEntryMode
                                                                                              .calendar,
                                                                                          initialDatePickerMode: PersianDatePickerMode
                                                                                              .day,
                                                                                          locale: Locale(
                                                                                              "fa",
                                                                                              "IR"),
                                                                                        );
                                                                                        // DateTime date=DateTime.now();
                                                                                        Gregorian gregorian = pickedDate!
                                                                                            .toGregorian();
                                                                                        orderController
                                                                                            .endDateFilter
                                                                                            .value =
                                                                                        "${gregorian
                                                                                            .year}-${gregorian
                                                                                            .month
                                                                                            .toString()
                                                                                            .padLeft(
                                                                                            2,
                                                                                            '0')}-${gregorian
                                                                                            .day
                                                                                            .toString()
                                                                                            .padLeft(
                                                                                            2,
                                                                                            '0')}";

                                                                                        orderController
                                                                                            .dateEndController
                                                                                            .text =
                                                                                        "${pickedDate
                                                                                            .year}/${pickedDate
                                                                                            .month
                                                                                            .toString()
                                                                                            .padLeft(
                                                                                            2,
                                                                                            '0')}/${pickedDate
                                                                                            .day
                                                                                            .toString()
                                                                                            .padLeft(
                                                                                            2,
                                                                                            '0')}";
                                                                                      },
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),

                                                                        ],
                                                                      ),
                                                                    ),*//*
                                                      OrderEditedFilterWidget(
                                                        controller: controller,
                                                      ),
                                                      //  Spacer(),
                                                      Container(
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                            horizontal: 20,
                                                            vertical: 10),
                                                        width: double
                                                            .infinity,
                                                        height: 40,
                                                        child: ElevatedButton(
                                                          style: ButtonStyle(
                                                              padding: WidgetStatePropertyAll(
                                                                  EdgeInsets
                                                                      .symmetric(
                                                                      horizontal: 23,
                                                                      vertical: 19)),
                                                              // elevation: WidgetStatePropertyAll(5),
                                                              backgroundColor:
                                                              WidgetStatePropertyAll(
                                                                  AppColor
                                                                      .appBarColor),
                                                              shape: WidgetStatePropertyAll(
                                                                  RoundedRectangleBorder(
                                                                      side: BorderSide(
                                                                          color: AppColor
                                                                              .textColor),
                                                                      borderRadius: BorderRadius
                                                                          .circular(
                                                                          5)))),
                                                          onPressed: () async {
                                                            controller
                                                                .getOrderEditedReportPager();
                                                            Get
                                                                .back();
                                                          },
                                                          child: controller
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
                                                            'فیلتر',
                                                            style: AppTextStyle
                                                                .labelText
                                                                .copyWith(
                                                                fontSize: isDesktop
                                                                    ? 12
                                                                    : 10),
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
                                            controller
                                                .nameFilterController
                                                .text != "" ||
                                                controller.dateStartController.text != "" ||
                                                controller.dateEndController.text != "" ||
                                                controller.dateStartCreatedOnController.text != "" ||
                                                controller.dateEndCreatedOnController.text != "" ||
                                                controller.dateStartModifiedOnController.text != "" ||
                                                controller.dateEndModifiedOnController.text != "" ||
                                                controller.byAdmin.value != null ||
                                                controller.type.value != null ||
                                                controller.selectedItemFilter.value !=null
                                                ? AppColor
                                                .accentColor
                                                : AppColor
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
                                                : 10,
                                            color: controller
                                                .nameFilterController
                                                .text != "" ||
                                                controller.dateStartController.text != "" ||
                                                controller.dateEndController.text != ""||
                                                controller.dateStartCreatedOnController.text != "" ||
                                                controller.dateEndCreatedOnController.text != "" ||
                                                controller.dateStartModifiedOnController.text != "" ||
                                                controller.dateEndModifiedOnController.text != "" ||
                                                controller.byAdmin.value != null||
                                                controller.type.value != null ||
                                                controller.selectedItemFilter.value !=null
                                                ? AppColor
                                                .accentColor
                                                : AppColor
                                                .textColor),
                                      ),
                                    ],
                                  ),
                                ),*/
                                                SizedBox(width: 20,),
                                                // خروجی pdf
                                                /*ElevatedButton(
                                  style: ButtonStyle(
                                      padding: WidgetStatePropertyAll(
                                        EdgeInsets.symmetric(
                                            horizontal: 23,vertical: 19
                                        ),
                                      ),
                                      elevation: WidgetStatePropertyAll(5),
                                      //fixedSize: WidgetStatePropertyAll(Size(100,30)),
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
                                                          controller.getOrderEditedReportPager();
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
                                        horizontalMargin: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ) :
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                            child:
                            Column(
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: controller.orderEditedReportList.length,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    final order = controller.orderEditedReportList[index];
                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 12),
                                      padding: const EdgeInsets.only(top: 5,right: 15,left: 15,bottom: 12),
                                      decoration: BoxDecoration(
                                        color: order.createdOn!=order.date ? AppColor.accent2Color.withAlpha(20) : AppColor.secondaryColor.withAlpha(180),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: const Color(0xFF64748B)),
                                      ),
                                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Header row with row number and dates
                                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "${order.rowNum ?? 0}",
                                                style: AppTextStyle.bodyText.copyWith(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(width: 5,),
                                              Expanded(
                                                child: funcOrderDetail(
                                                    '',
                                                    (order.account?.name?.length ?? 0) > 20 ?
                                                    "${order.account?.name?.substring(0, 20)}..." :
                                                    order.account?.name ?? "",
                                                    size: 11
                                                ),
                                              ),
                                              funcOrderDetail(
                                                  'تاریخ سفارش: ',
                                                  order.date != null ? order.date?.toPersianDate(twoDigits: true, showTime: true, timeSeprator: '-') ?? '' : 'تاریخ نامشخص',
                                                  size: 11
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5,),
                                          Divider(color: AppColor.iconViewColor, height: 2,),
                                          SizedBox(height: 5,),

                                          // Account and Created/Modified By
                                          Container(
                                            margin: const EdgeInsets.all(5),
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              color: AppColor.secondary2Color.withAlpha(50),
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(color: const Color(0xFF64748B)),
                                            ),
                                            child: Column(
                                              children: [
                                                if (order.modifiedBy?.name != null && order.modifiedBy?.name != "")
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: funcOrderDetail(
                                                          'ایجاد:',
                                                          (order.createdBy?.name?.length ?? 0) > 25 ?
                                                          "${order.createdBy?.name?.substring(0 , 25)}..." :
                                                          order.createdBy?.name ?? "",
                                                          size: 11
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: funcOrderDetail(
                                                          'ویرایش:',
                                                          (order.modifiedBy?.name?.length ?? 0) > 15 ?
                                                          "${order.modifiedBy?.name?.substring(0 , 15)}..." :
                                                          order.modifiedBy?.name ?? "",
                                                          color: AppColor.dividerColor,
                                                          size: 11
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Dates section
                                          Container(
                                            margin: const EdgeInsets.all(5),
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              color: AppColor.dividerColor.withAlpha(50),
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(color: const Color(0xFF64748B)),
                                            ),
                                            child: Column(
                                              children: [
                                                if (order.createdOn != null)
                                                  Padding(
                                                    padding: const EdgeInsets.only(bottom: 5),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: funcOrderDetail(
                                                              'تاریخ ایجاد:',
                                                              order.createdOn?.toPersianDate(twoDigits: true, showTime: true, timeSeprator: '-') ?? '',
                                                              size: 11
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                if (order.modifiedOn != null)
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: funcOrderDetail(
                                                            'تاریخ ویرایش:',
                                                            order.modifiedOn?.toPersianDate(twoDigits: true, showTime: true, timeSeprator: '-') ?? '',
                                                            color: AppColor.dividerColor,
                                                            size: 11
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                              ],
                                            ),
                                          ),

                                          // Product and Quantity
                                          Container(
                                            margin: const EdgeInsets.all(5),
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              color:(order.type == 0) ? AppColor.accentColor.withAlpha(30) : AppColor.primaryColor.withAlpha(50) ,
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(color: const Color(0xFF64748B)),
                                            ),
                                            child: Row(
                                              children: [
                                                if (order.item?.icon != null)
                                                  Image.network(
                                                    '${BaseUrl.baseUrl}Attachment/downloadResource?fileName=${order.item?.icon}',
                                                    width: 22,
                                                    height: 22,
                                                  ),
                                                SizedBox(width: 8,),
                                                Expanded(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(
                                                        order.item?.name ?? "",
                                                        style: AppTextStyle.bodyText.copyWith(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.bold,
                                                          color: (order.type == 0) ? AppColor.accentColor : AppColor.primaryColor,
                                                        ),
                                                      ),
                                                      SizedBox(height: 3,),
                                                      funcOrderDetail(
                                                          'مقدار:',
                                                          "${order.quantity?.toString().seRagham(separator: ",")} ${order.item?.itemUnit?.name ?? ""}",
                                                          size: 11
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          // Prices section
                                          Container(
                                            margin: const EdgeInsets.all(5),
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              color: AppColor.dividerColor.withAlpha(50),
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(color: const Color(0xFF64748B)),
                                            ),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: funcOrderDetail(
                                                          'قیمت(مثقال):',
                                                          "${order.mesghalPrice == null ? 0 : order.mesghalPrice?.toInt().toString().seRagham(separator: ',')} ریال",
                                                          size: 11
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 5,),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: funcOrderDetail(
                                                          'قیمت(ریال):',
                                                          "${order.price == null ? 0 : order.price?.toInt().toString().seRagham(separator: ',')} ریال",
                                                          size: 11
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 5,),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: funcOrderDetail(
                                                          'مبلغ کل:',
                                                          (order.totalPrice != null) ? "${order.totalPrice?.toInt().toString().seRagham(separator: ',')} ریال" : "0",
                                                          size: 12,
                                                          color: AppColor.textColor
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),

                                          // Status and flags
                                          Container(
                                            margin: const EdgeInsets.all(5),
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              color: AppColor.secondary2Color.withAlpha(50),
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(color: const Color(0xFF64748B)),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(
                                                  children: [
                                                    Text(
                                                      'توسط ادمین',
                                                      style: AppTextStyle.labelText.copyWith(
                                                        color: const Color(0xFF94A3B8),
                                                        fontSize: 10,
                                                      ),
                                                    ),
                                                    SizedBox(height: 3,),
                                                    order.byAdmin==true ?
                                                    SvgPicture.asset('assets/svg/shield-check.svg',
                                                      colorFilter: ColorFilter.mode(
                                                        AppColor.primaryColor,
                                                        BlendMode.srcIn,
                                                      ),
                                                      width: 20,
                                                      height: 20,
                                                    ) :
                                                    SvgPicture.asset('assets/svg/shield-close.svg',
                                                      colorFilter: ColorFilter.mode(
                                                        AppColor.accentColor,
                                                        BlendMode.srcIn,
                                                      ),
                                                      width: 20,
                                                      height: 20,
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    Text(
                                                      'حذف شده',
                                                      style: AppTextStyle.labelText.copyWith(
                                                        color: const Color(0xFF94A3B8),
                                                        fontSize: 10,
                                                      ),
                                                    ),
                                                    SizedBox(height: 3,),
                                                    order.isDeleted==true ?
                                                    SvgPicture.asset('assets/svg/check-square.svg',
                                                      colorFilter: ColorFilter.mode(
                                                        AppColor.buttonColor,
                                                        BlendMode.srcIn,
                                                      ),
                                                      width: 20,
                                                      height: 20,
                                                    ) :
                                                    SvgPicture.asset('assets/svg/close-square.svg',
                                                      colorFilter: ColorFilter.mode(
                                                        AppColor.accentColor,
                                                        BlendMode.srcIn,
                                                      ),
                                                      width: 20,
                                                      height: 20,
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    Text(
                                                      'وضعیت',
                                                      style: AppTextStyle.labelText.copyWith(
                                                        color: const Color(0xFF94A3B8),
                                                        fontSize: 10,
                                                      ),
                                                    ),
                                                    SizedBox(height: 3,),
                                                    Text(
                                                      '${order.status == 0 ? 'در انتظار' : order.status == 1 ? 'تایید شده' : 'تایید نشده'}',
                                                      style: AppTextStyle.bodyText.copyWith(
                                                          color: order.status == 1 ? AppColor.primaryColor : order.status == 2 ? AppColor.accentColor : AppColor.textColor,
                                                          fontSize: 11,
                                                          fontWeight: FontWeight.bold
                                                      ),
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
                                  if (controller.isLoading.value && controller.orderEditedReportList.isNotEmpty) {
                                    return Container(
                                      padding: EdgeInsets.all(16),
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  }

                                  if (!controller.hasMore.value && controller.orderEditedReportList.isNotEmpty) {
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
                controller.getOrderEditedReportPager();
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
                  //color: AppColor.appBarColor.withAlpha(130),
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
      ): SizedBox.shrink(),
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
      DataColumn(
          label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
              child: Text('ردیف', style: AppTextStyle.labelText)),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
        label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
            child: Text('تاریخ سفارش', style: AppTextStyle.labelText)),
        headingRowAlignment: MainAxisAlignment.center,
        onSort: (columnIndex, ascending) {
          controller.onSort(columnIndex, ascending);
        },
      ),
      DataColumn(
        label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
            child: Text('تاریخ ایجاد', style: AppTextStyle.labelText)),
        headingRowAlignment: MainAxisAlignment.center,
        onSort: (columnIndex, ascending) {
          controller.onSort(columnIndex, ascending);
        },
      ),
      DataColumn(
        label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
            child: Text('تاریخ ویرایش', style: AppTextStyle.labelText)),
        headingRowAlignment: MainAxisAlignment.center,
        onSort: (columnIndex, ascending) {
          controller.onSort(columnIndex, ascending);
        },
      ),
      DataColumn(
          label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
              child: Text('نام کاربر', style: AppTextStyle.labelText)),
          headingRowAlignment: MainAxisAlignment.center,
          onSort: (columnIndex, ascending) {
            controller.onSort(columnIndex, ascending);
          }
      ),
      DataColumn(
          label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
              child: Text('ایجاد توسط', style: AppTextStyle.labelText)),
          headingRowAlignment: MainAxisAlignment.center,
          onSort: (columnIndex, ascending) {
            controller.onSort(columnIndex, ascending);
          }
      ),
      DataColumn(
          label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
              child: Text('ویرایش توسط', style: AppTextStyle.labelText)),
          headingRowAlignment: MainAxisAlignment.center,
          onSort: (columnIndex, ascending) {
            controller.onSort(columnIndex, ascending);
          }
      ),
      DataColumn(
          label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
              child: Text('محصول', style: AppTextStyle.labelText)),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
              child: Text('مقدار', style: AppTextStyle.labelText)),
          headingRowAlignment: MainAxisAlignment.center,
          onSort: (columnIndex, ascending) {
            controller.onSort(columnIndex, ascending);
          }
      ),
      DataColumn(
          label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
              child: Text('قیمت(مثقال)', style: AppTextStyle.labelText)),
          headingRowAlignment: MainAxisAlignment.center,
          onSort: (columnIndex, ascending) {
            controller.onSort(columnIndex, ascending);
          }
      ),
      DataColumn(
          label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
              child: Text('قیمت(ریال)', style: AppTextStyle.labelText)),
          headingRowAlignment: MainAxisAlignment.center,
          onSort: (columnIndex, ascending) {
            controller.onSort(columnIndex, ascending);
          }
      ),
      DataColumn(
          label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
              child: Text('مبلغ کل', style: AppTextStyle.labelText)),
          headingRowAlignment: MainAxisAlignment.center,
          onSort: (columnIndex, ascending) {
            controller.onSort(columnIndex, ascending);
          }
      ),
      DataColumn(
          label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
              child: Text('توسط ادمین', style: AppTextStyle.labelText)),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
              child: Text('حذف شده', style: AppTextStyle.labelText)),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
              child: Text('وضعیت', style: AppTextStyle.labelText)),
          headingRowAlignment: MainAxisAlignment.center),
    ];
  }

  List<DataRow> buildDataRows(BuildContext context) {
    return controller.orderEditedReportList.asMap().entries.map((entry) {
      final index = entry.key;
      final order = entry.value;
      final rowColor = index.isEven
          ? AppColor.backGroundColor
          : AppColor.secondaryColor.withAlpha(100);
      return DataRow(
        color: WidgetStateProperty.all(order.createdOn!=order.date ? AppColor.accent2Color.withAlpha(30) : rowColor),
        cells: [
          // ردیف
          DataCell(
              Center(
                child:
                    Text("${order.rowNum}",
                      style:
                      AppTextStyle.bodyText,
                    ),
              )),
          // تاریخ
          DataCell(
              Center(
                child: Text(
                  order.date != null ? order.date?.toPersianDate(
                      twoDigits: true, showTime: true, timeSeprator: '-') ?? ''
                      : 'تاریخ نامشخص',
                  style:
                  AppTextStyle.bodyText.copyWith(fontSize: 11),
                ),
              )),
          // تاریخ ایجاد
          DataCell(
              Center(
                child: Text(
                  order.createdOn != null ? order.createdOn?.toPersianDate(
                      twoDigits: true, showTime: true, timeSeprator: '-') ?? ''
                      : 'تاریخ نامشخص',
                  style:
                  AppTextStyle.bodyText.copyWith(fontSize: 11),
                ),
              )),
          // تاریخ ویرایش
          DataCell(
              Center(
                child: Text(
                  order.modifiedOn != null ? order.modifiedOn?.toPersianDate(
                      twoDigits: true, showTime: true, timeSeprator: '-') ?? ''
                      : '',
                  style:
                  AppTextStyle.bodyText.copyWith(fontSize: 11,color: AppColor.dividerColor),
                ),
              )),
          // نام کاربر
          DataCell(
              Center(
                child: Text(
                  order.account?.name ?? "",
                  style: AppTextStyle.bodyText.copyWith(fontSize: 12,),
                ),
              )),
          // ایجاد توسط
          DataCell(
              Center(
                child: Text(
                  order.createdBy?.name ?? "",
                  style: AppTextStyle.bodyText.copyWith(fontSize: 12,),
                ),
              )),
          // ویرایش توسط
          DataCell(
              Center(
                child: Text(
                  order.modifiedBy?.name ?? "",
                  style: AppTextStyle.bodyText.copyWith(fontSize: 12,color: AppColor.dividerColor),
                ),
              )),
          // محصول
          DataCell(
              Container(
                //height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: (order.type == 0)
                      ? AppColor.accentColor.withAlpha(120)
                      : AppColor.primaryColor.withAlpha(120),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child:
                Row(
                  children: [
                    Image.network('${BaseUrl
                        .baseUrl}Attachment/downloadResource?fileName=${order
                        .item?.icon}',
                      width: 25,
                      height: 25,),
                    SizedBox(width: 5,),
                    Text(
                      order.item?.name ?? "",
                      style:
                      AppTextStyle.bodyText.copyWith(fontSize: 13,fontWeight: FontWeight.bold,color: AppColor.textColor),
                    ),
                  ],
                ),
              )),
          // مقدار
          DataCell(
              Center(
                child: Text(
                  "${order.quantity?.toString().seRagham(
                      separator: ",")} ${order.item?.itemUnit?.name ?? ""}",
                  style:
                  AppTextStyle.bodyText.copyWith(fontSize: 11),
                ),
              )),
          // قیمت مثقال
          DataCell(
            Center(
              child: Text(
                "${order.mesghalPrice == null ? 0 : order.mesghalPrice?.toInt()
                    .toString()
                    .seRagham(separator: ',')} ریال",
                style:
                AppTextStyle.bodyText.copyWith(fontSize: 11),
              ),
            ),
          ),
          // قیمت ریال
          DataCell(
            Center(
              child: Text(
                "${order.price == null ? 0 : order.price?.toInt()
                    .toString()
                    .seRagham(separator: ',')} ریال",
                style:
                AppTextStyle.bodyText.copyWith(fontSize: 11),
              ),
            ),
          ),
          //مبلغ کل
          DataCell(
            Center(
              child: Text(
                (order.totalPrice != null)
                    ? "${order.totalPrice?.toInt().toString().seRagham(
                    separator: ',')} ریال"
                    : "0",
                style: AppTextStyle.bodyText.copyWith(
                    fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          // توسط ادمین
          DataCell(
              Center(
                child:
                order.byAdmin==true ?
                SvgPicture.asset('assets/svg/shield-check.svg',
                  colorFilter: ColorFilter.mode(
                    AppColor.primaryColor,
                    BlendMode.srcIn,
                  ),) :
                SvgPicture.asset('assets/svg/shield-close.svg',
                  colorFilter: ColorFilter.mode(
                    AppColor.accentColor,
                    BlendMode.srcIn,
                  ),),
              )),
          // حذف شده
          DataCell(
              Center(
                child:
                order.isDeleted==true ?
                SvgPicture.asset('assets/svg/check-square.svg',
                  colorFilter: ColorFilter.mode(
                    AppColor.buttonColor,
                    BlendMode.srcIn,
                  ),) :
                SvgPicture.asset('assets/svg/close-square.svg',
                  colorFilter: ColorFilter.mode(
                    AppColor.accentColor,
                    BlendMode.srcIn,
                  ),),
              )),
          // وضعیت
          DataCell(
             Center(
                child:
                    Text(
                      '${order.status == 0 ? 'در انتظار' : order.status == 1
                          ? 'تایید شده'
                          : 'تایید نشده'} ',
                      style: AppTextStyle
                          .bodyText.copyWith(
                          color: order.status == 1
                              ? AppColor.primaryColor
                              : order.status == 2
                              ? AppColor.accentColor
                              : AppColor.textColor, fontSize: 11,fontWeight: FontWeight.bold
                      ),
                    ),
              ),
          ),
        ],
      );
    }).toList();
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

}
