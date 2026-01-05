import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:hanigold_admin/src/domain/withdraw/controller/withdraw.controller.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/withdraw.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/view/deposit_request_create.view.dart';
import 'package:hanigold_admin/src/domain/withdraw/widget/hover_tooltip_balance_withdraw.widget.dart';
import 'package:hanigold_admin/src/widget/custom_appbar1.widget.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../config/const/app_color.dart';
import '../../../config/repository/url/base_url.dart';
import '../../../widget/app_drawer.widget.dart';
import '../../../widget/background_image_total.widget.dart';
import '../../../widget/empty.dart';
import '../../../widget/err_page.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import '../../../widget/pager_widget.dart';
import '../../home/widget/chat_dialog.widget.dart';
import '../../order/widget/hover_tooltip_balance.widget.dart';
import '../widget/withdraw_filter.widget.dart';
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
    final isMobile = ResponsiveBreakpoints
        .of(context)
        .isMobile;
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
                    isDesktop ?
                    SizedBox.shrink() :
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          //فیلد جستجو
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  color: AppColor.appBarColor.withOpacity(0.5),
                                  alignment: Alignment.center,
                                  height: 80,
                                  child: TextFormField(
                                    controller: withdrawController
                                        .searchController,
                                    style: AppTextStyle.labelText,
                                    textInputAction: TextInputAction.search,
                                    onFieldSubmitted: (value) async {
                                      if (value.isNotEmpty) {
                                        await withdrawController.searchAccounts(
                                            value);
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
                                            if (withdrawController
                                                .searchController.text
                                                .isNotEmpty) {
                                              await withdrawController
                                                  .searchAccounts(
                                                  withdrawController
                                                      .searchController
                                                      .text
                                              );
                                              showSearchResults(context);
                                            } else {
                                              withdrawController.clearSearch();
                                            }
                                          },
                                          icon: Icon(
                                            Icons.search,
                                            color: AppColor.textColor,
                                            size: 30,)
                                      ),
                                      suffixIcon: IconButton(
                                        onPressed: withdrawController
                                            .clearSearch,
                                        icon: Icon(
                                            Icons.close,
                                            color: AppColor.textColor),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                            padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                            decoration: BoxDecoration(
                              color: AppColor.appBarColor.withAlpha(30),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: const Color(0xFF64748B)),
                            ),
                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    //دکمه ایجاد درخواست برداشت جدید
                                    GestureDetector(
                                      onTap: () {
                                        Get.toNamed('/withdrawCreate');
                                      },
                                      child: SvgPicture.asset(
                                        'assets/svg/add-plus.svg',
                                        height: 30,
                                      ),
                                    ),
                                    SizedBox(width: 17,),
                                    // لیست برداشت های در انتظار
                                    GestureDetector(
                                      onTap: () {
                                        Get.toNamed('/withdrawsPendingList');
                                      },
                                      child: SvgPicture.asset(
                                        'assets/svg/list-wait.svg',
                                        height: 32,
                                      ),
                                    ),
                                    SizedBox(width: 5,),
                                    // خروجی اکسل
                                    /*ElevatedButton(
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
                                                              withdrawController.getWithdrawExcel();
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
                                    ),*/
                                    /*SizedBox(width: 5,),*/
                                    // خروجی pdf
                                    /*ElevatedButton(
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
                                    ),*/
                                  ],
                                ),
                                // فیلتر
                                GestureDetector(
                                  onTap: () async {
                                    showGeneralDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        barrierLabel: MaterialLocalizations
                                            .of(context)
                                            .modalBarrierDismissLabel,
                                        barrierColor: Colors.black45,
                                        transitionDuration: const Duration(
                                            milliseconds: 200),
                                        pageBuilder: (BuildContext buildContext,
                                            Animation animation,
                                            Animation secondaryAnimation) {
                                          return Center(
                                            child: Material(
                                              color: Colors.transparent,
                                              child: WithdrawFilterWidget(
                                                withdrawController: withdrawController,
                                                isDesktop: isDesktop,
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
                                        withdrawController
                                            .nameFilterController.text !=
                                            "" ||
                                            withdrawController
                                                .ownerNameFilterController
                                                .text != "" ||
                                            withdrawController
                                                .amountFilterController
                                                .text != "" ||
                                            withdrawController
                                                .dateStartController.text !=
                                                "" ||
                                            withdrawController
                                                .dateEndController.text != ""
                                            ? AppColor.filterColor
                                            : AppColor
                                            .textColor,
                                        BlendMode
                                            .srcIn,
                                      )
                                  ),
                                ),
                              ],
                            ),
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
                      } else
                      if (withdrawController.state.value == PageState.list) {
                        // EasyLoading.dismiss();
                        return isDesktop ?
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                            color: AppColor.backGroundColor1.withAlpha(150),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                   SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: SizedBox(
                                        width: 1500,
                                        // Increased width to prevent column overflow
                                        child: Column(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric( vertical: 5),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 400,
                                                    child: TextFormField(
                                                      controller: withdrawController.searchController,
                                                      style: AppTextStyle.labelText,
                                                      textInputAction: TextInputAction.search,
                                                      onFieldSubmitted: (value) async {
                                                        if (value.isNotEmpty) {
                                                          await withdrawController.searchAccounts(
                                                              value);
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
                                                              if (withdrawController.searchController
                                                                  .text
                                                                  .isNotEmpty) {
                                                                await withdrawController
                                                                    .searchAccounts(
                                                                    withdrawController
                                                                        .searchController
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
                                                  SizedBox(width: 10),
                                                  Row(
                                                    children: [
                                                      //دکمه ایجاد درخواست برداشت جدید
                                                      TextButton.icon(
                                                        onPressed: () {
                                                          Get.toNamed('/withdrawCreate');
                                                        },
                                                          icon: SvgPicture.asset(
                                                            'assets/svg/add-plus.svg',
                                                            height: 24,
                                                          ),
                                                          label: Text(
                                                            'ایجاد درخواست برداشت جدید',
                                                            style: AppTextStyle.labelText,
                                                          ),
                                                      ),
                                                      SizedBox(width: 5,),
                                                      // لیست برداشت های در انتظار
                                                      TextButton.icon(
                                                        onPressed: () {
                                                          Get.toNamed(
                                                              '/withdrawsPendingList');
                                                        },
                                                          label: Text(
                                                            'لیست برداشت های در انتظار',
                                                            style: AppTextStyle.labelText,
                                                          ),
                                                        icon: SvgPicture.asset(
                                                          'assets/svg/list-wait.svg',
                                                          height: 24,
                                                        ),
                                                      ),
                                                      SizedBox(width: 5,),
                                                      // خروجی اکسل
                                                      OutlinedButton.icon(
                                                        onPressed: () {
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
                                                                      width: isDesktop
                                                                          ? Get.width *
                                                                          0.2
                                                                          : Get.height *
                                                                          0.5,
                                                                      height: isDesktop
                                                                          ? Get.height *
                                                                          0.5
                                                                          : Get.height *
                                                                          0.7,
                                                                      padding: EdgeInsets
                                                                          .all(20),
                                                                      child: Column(
                                                                        children: [
                                                                          Padding(
                                                                            padding: const EdgeInsets
                                                                                .all(8.0),
                                                                            child: Row(
                                                                              mainAxisAlignment: MainAxisAlignment
                                                                                  .center,
                                                                              children: [
                                                                                Text(
                                                                                  'خروجی اکسل',
                                                                                  style: AppTextStyle
                                                                                      .labelText
                                                                                      .copyWith(
                                                                                    fontSize: 15,
                                                                                    fontWeight: FontWeight
                                                                                        .normal,
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
                                                                          Padding(
                                                                            padding: const EdgeInsets
                                                                                .symmetric(
                                                                                horizontal: 10),
                                                                            child: Column(
                                                                              children: [
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
                                                                                          controller: withdrawController
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
                                                                                            withdrawController
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

                                                                                            withdrawController
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
                                                                                          controller: withdrawController
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
                                                                                            withdrawController
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

                                                                                            withdrawController
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
                                                                                  ],
                                                                                ),

                                                                              ],
                                                                            ),
                                                                          ),
                                                                          Spacer(),
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
                                                                                withdrawController
                                                                                    .getWithdrawExcel();
                                                                                Get
                                                                                    .back();
                                                                              },
                                                                              child: withdrawController
                                                                                  .isLoading
                                                                                  .value ?
                                                                              CircularProgressIndicator(
                                                                                valueColor: AlwaysStoppedAnimation<
                                                                                    Color>(
                                                                                    AppColor
                                                                                        .textColor),
                                                                              ) :
                                                                              Text(
                                                                                'ثبت',
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
                                                                      width: isDesktop
                                                                          ? Get.width *
                                                                          0.2
                                                                          : Get.height *
                                                                          0.5,
                                                                      height: isDesktop
                                                                          ? Get.height *
                                                                          0.5
                                                                          : Get.height *
                                                                          0.7,
                                                                      padding: EdgeInsets
                                                                          .all(20),
                                                                      child: Column(
                                                                        children: [
                                                                          Padding(
                                                                            padding: const EdgeInsets
                                                                                .all(8.0),
                                                                            child: Row(
                                                                              mainAxisAlignment: MainAxisAlignment
                                                                                  .center,
                                                                              children: [
                                                                                Text(
                                                                                  'خروجی pdf',
                                                                                  style: AppTextStyle
                                                                                      .labelText
                                                                                      .copyWith(
                                                                                    fontSize: 15,
                                                                                    fontWeight: FontWeight
                                                                                        .normal,
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
                                                                          Padding(
                                                                            padding: const EdgeInsets
                                                                                .symmetric(
                                                                                horizontal: 10),
                                                                            child: Column(
                                                                              children: [
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
                                                                                          controller: withdrawController
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
                                                                                            withdrawController
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

                                                                                            withdrawController
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
                                                                                          controller: withdrawController
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
                                                                                            withdrawController
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

                                                                                            withdrawController
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
                                                                                  ],
                                                                                ),

                                                                              ],
                                                                            ),
                                                                          ),
                                                                          Spacer(),
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
                                                                                withdrawController
                                                                                    .exportToPdf();
                                                                                Get
                                                                                    .back();
                                                                              },
                                                                              child: withdrawController
                                                                                  .isLoading
                                                                                  .value ?
                                                                              CircularProgressIndicator(
                                                                                valueColor: AlwaysStoppedAnimation<
                                                                                    Color>(
                                                                                    AppColor
                                                                                        .textColor),
                                                                              ) :
                                                                              Text(
                                                                                'ثبت',
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
                                                              barrierLabel: MaterialLocalizations
                                                                  .of(context)
                                                                  .modalBarrierDismissLabel,
                                                              barrierColor: Colors.black45,
                                                              transitionDuration: const Duration(
                                                                  milliseconds: 200),
                                                              pageBuilder: (
                                                                  BuildContext buildContext,
                                                                  Animation animation,
                                                                  Animation secondaryAnimation) {
                                                                return Center(
                                                                  child: Material(
                                                                    color: Colors.transparent,
                                                                    child: WithdrawFilterWidget(
                                                                      withdrawController: withdrawController,
                                                                      isDesktop: isDesktop,
                                                                    ),
                                                                  ),
                                                                );
                                                              });
                                                        },
                                                          icon: SvgPicture.asset(
                                                              'assets/svg/filter3.svg',
                                                              height: 17,
                                                              colorFilter:
                                                              ColorFilter
                                                                  .mode(
                                                                withdrawController
                                                                    .nameFilterController
                                                                    .text != "" ||
                                                                    withdrawController
                                                                        .ownerNameFilterController
                                                                        .text != "" ||
                                                                    withdrawController
                                                                        .amountFilterController
                                                                        .text != "" ||
                                                                    withdrawController
                                                                        .dateStartController
                                                                        .text != "" ||
                                                                    withdrawController
                                                                        .dateEndController
                                                                        .text != ""
                                                                    ? AppColor.accentColor
                                                                    : AppColor
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
                                                                    : 10,
                                                                color: withdrawController
                                                                    .nameFilterController
                                                                    .text != "" ||
                                                                    withdrawController
                                                                        .ownerNameFilterController
                                                                        .text != "" ||
                                                                    withdrawController
                                                                        .amountFilterController
                                                                        .text != "" ||
                                                                    withdrawController
                                                                        .dateStartController
                                                                        .text != "" ||
                                                                    withdrawController
                                                                        .dateEndController
                                                                        .text != ""
                                                                    ? AppColor.accentColor
                                                                    : AppColor.textColor),
                                                          ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            RepaintBoundary(
                                              key: _dataTableKey,
                                              child: buildExpandableTable(
                                                  context),
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
                            padding: EdgeInsets.only(bottom: 50),
                            controller: withdrawController.scrollController,
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemCount: withdrawController.withdrawList.length +
                                (withdrawController.hasMore.value ? 1 : 0),
                            itemBuilder: (context, index) {
                              print(withdrawController.withdrawList.length);
                              if (index >=
                                  withdrawController.withdrawList.length) {
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
                                    margin: EdgeInsets.all(5),
                                    color:
                                    isExpanded
                                        ? AppColor.appBarColor.withAlpha(90)
                                        : withdraws.amount ==
                                        withdraws.paidAmount ? AppColor
                                        .primaryColor.withAlpha(60)
                                        : withdraws.isReferencedByAnother ==
                                        true ? AppColor.accentColor.withAlpha(
                                        90)
                                        : AppColor.appBarColor.withAlpha(160),
                                    elevation: 10,
                                    child: Padding(
                                      padding: EdgeInsets.only(bottom: 5),
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
                                                      .spaceEvenly,
                                                  children: [
                                                    Text(withdraws.requestDate
                                                        ?.toPersianDate(
                                                      twoDigits: true,
                                                      showTime: true,
                                                      timeSeprator: '-',) ??
                                                        'نامشخص',
                                                      style:
                                                      AppTextStyle.bodyText,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment
                                                          .end,
                                                      children: [
                                                        Text('رفرنس: ',
                                                          style: AppTextStyle
                                                              .labelText,),
                                                        withdraws.refrenceId !=
                                                            null ?
                                                        Icon(Icons.check,
                                                          color: AppColor
                                                              .primaryColor,
                                                          size: 20,) :
                                                        Icon(Icons.close,
                                                          color: AppColor
                                                              .accentColor,
                                                          size: 20,)
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment
                                                          .end,
                                                      children: [
                                                        Text('تلگرام: ',
                                                          style: AppTextStyle
                                                              .labelText,),
                                                        withdraws.allDepositSent == true ?
                                                        Icon(Icons.check,
                                                          color: AppColor
                                                              .primaryColor,
                                                          size: 20,) :
                                                        Icon(Icons.close,
                                                          color: AppColor
                                                              .accentColor,
                                                          size: 20,)
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                SizedBox(height: 3,),
                                                SizedBox(width: 250,
                                                  child: Divider(
                                                    height: 1, color: AppColor
                                                      .dividerColor,),),
                                                SizedBox(height: 8,),

                                                // نام کاربر و نام دارنده حساب
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .center,
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        /*Text('کاربر: ',
                                                          style: AppTextStyle
                                                              .labelText,),
                                                        SizedBox(height: 2,),*/
                                                        Text((withdraws.wallet?.account?.name?.length ?? 0) > 15 ?
                                                        '${withdraws.wallet?.account?.name?.substring(0, 15)}...'
                                                            : withdraws.wallet?.account?.name ?? "",
                                                          style: AppTextStyle
                                                              .bodyText,),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text('حساب: ',
                                                          style: AppTextStyle
                                                              .labelText,),
                                                        SizedBox(height: 2,),
                                                        Text("${ (withdraws
                                                            .ownerName
                                                            ?.length ?? 0) > 15
                                                            ? '${withdraws
                                                            .ownerName
                                                            ?.substring(
                                                            0, 15)}...'
                                                            : withdraws
                                                            .ownerName ??
                                                            ""} (${(withdraws
                                                            .bank?.name
                                                            ?.length ?? 0) > 8
                                                            ? "${withdraws.bank
                                                            ?.name?.substring(
                                                            0, 8)}..."
                                                            : withdraws.bank
                                                            ?.name ?? ""})",
                                                          style: AppTextStyle
                                                              .bodyText
                                                              .copyWith(
                                                              color: AppColor
                                                                  .dividerColor),),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                SizedBox(height: 3,),

                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .spaceEvenly,
                                                  children: [
                                                    // مبلغ درخواستی و مبلغ کل و مبلغ تایید نشده
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment
                                                          .center,
                                                      mainAxisAlignment: MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text('کل: ',
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
                                                        SizedBox(height: 4,),
                                                        Row(
                                                          children: [
                                                            Text('درخواستی: ',
                                                              style: AppTextStyle
                                                                  .labelText,),
                                                            SizedBox(width: 3,),
                                                            Text("${withdraws
                                                                .requestAmount
                                                                ?.toInt()
                                                                .toString()
                                                                .seRagham(
                                                                separator: ',') ??
                                                                0} ریال",
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

                                                    // مبلغ مانده , مبلغ واریز شده
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment
                                                          .center,
                                                      mainAxisAlignment: MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text('مانده: ',
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
                                                                  .bodyText
                                                                  .copyWith(
                                                                  color: AppColor
                                                                      .accentColor),),
                                                          ],
                                                        ),
                                                        SizedBox(height: 4,),
                                                        Row(
                                                          crossAxisAlignment: CrossAxisAlignment
                                                              .center,
                                                          children: [
                                                            Text('واریز شده: ',
                                                              style: AppTextStyle
                                                                  .labelText,),
                                                            SizedBox(width: 3,),
                                                            Text("${withdraws
                                                                .paidAmount ==
                                                                null
                                                                ? 0
                                                                : withdraws
                                                                .paidAmount
                                                                ?.toInt()
                                                                .toString()
                                                                .seRagham(
                                                                separator: ',')} ریال",
                                                              style: AppTextStyle
                                                                  .bodyText
                                                                  .copyWith(
                                                                  color: AppColor
                                                                      .primaryColor),),
                                                          ],
                                                        ),
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
                                                              .bodyText.copyWith(color: AppColor.dividerColor),),
                                                      ],
                                                    ) : SizedBox.shrink(),
                                                  ],
                                                ),
                                                SizedBox(height: 4,),
                                                Divider(height: 1,),
                                                SizedBox(height: 2,),

                                                //  آیکون ها
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    // آیکون اضافه کردن درخواست deposit request
                                                    GestureDetector(
                                                      onTap: () {
                                                        if (withdraws
                                                            .undividedAmount ==
                                                            0) {
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
                                                          withdrawController
                                                              .balanceList
                                                              .clear();
                                                          showModalBottomSheet(
                                                            isScrollControlled: true,
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
                                                            builder: (context) {
                                                              return Container(
                                                                height: MediaQuery.of(context).size.height * 0.7,
                                                                child: InsertDepositRequestWidget(
                                                                  id: withdraws
                                                                      .id!,
                                                                  walletId: withdraws
                                                                      .wallet!
                                                                      .id!,
                                                                  unDividedAmount: withdraws
                                                                      .undividedAmount,
                                                                ),
                                                              );

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
                                                    // ارسال تلگرام
                                                    GestureDetector(
                                                      onTap: () {
                                                        withdraws.allDepositSent == true ?
                                                        Get.defaultDialog(
                                                            backgroundColor: AppColor.backGroundColor,
                                                            title: "ارسال مجدد",
                                                            titleStyle: AppTextStyle.smallTitleText.copyWith(color: AppColor.errorColor),
                                                            middleText: "آیا از ارسال مجدد واریزی ها مطمئن هستید؟",
                                                            middleTextStyle: AppTextStyle.bodyText,
                                                            confirm: ElevatedButton(
                                                                style: ButtonStyle(
                                                                    backgroundColor: WidgetStatePropertyAll(
                                                                        AppColor.primaryColor)),
                                                                onPressed: () {
                                                                  Get.back();
                                                                  withdrawController.sendTelegramWithdrawRequest(withdraws.id ?? 0);
                                                                },
                                                                child: Text(
                                                                  'ارسال مجدد',
                                                                  style: AppTextStyle.bodyText,
                                                                ))
                                                        ) :
                                                        Get.defaultDialog(
                                                            backgroundColor: AppColor.backGroundColor,
                                                            title: "ارسال واریزی ها به تلگرام",
                                                            titleStyle: AppTextStyle.smallTitleText.copyWith(color: Color(0xff0ab6f0)),
                                                            middleText: "آیا از ارسال واریزی ها مطمئن هستید؟",
                                                            middleTextStyle: AppTextStyle.bodyText,
                                                            confirm: ElevatedButton(
                                                                style: ButtonStyle(
                                                                    backgroundColor: WidgetStatePropertyAll(
                                                                        AppColor.primaryColor)),
                                                                onPressed: () {
                                                                  Get.back();
                                                                  withdrawController.sendTelegramWithdrawRequest(withdraws.id ?? 0);
                                                                },
                                                                child: Text(
                                                                  'ارسال',
                                                                  style: AppTextStyle.bodyText,
                                                                ))
                                                        );
                                                      },
                                                      child: Tooltip(
                                                        message: withdraws.allDepositSent == true ?  "ارسال مجدد واریزی ها به تلگرام" : "ارسال واریزی ها به تلگرام",
                                                        child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Text(' ارسال',style: AppTextStyle.labelText.copyWith(color: withdraws.allDepositSent == true ? AppColor.successColor : Color(0xff0ab6f0), fontSize: 11,fontWeight: FontWeight.w400),),
                                                            SvgPicture.asset(
                                                              'assets/svg/telegram.svg',height: 20,
                                                              colorFilter: ColorFilter.mode(withdraws.allDepositSent == true ? AppColor.successColor : Color(0xff0ab6f0), BlendMode.srcIn) ,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    // آیکون مشاهده
                                                    GestureDetector(
                                                      onTap: () {
                                                        Get.toNamed(
                                                            '/withdrawGetOne',
                                                            parameters: {
                                                              "id": withdraws.id
                                                                  .toString()
                                                            });
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
                                                        } else
                                                        {*/
                                                        Get.toNamed(
                                                            '/withdrawUpdate',
                                                            parameters: {
                                                              "id": withdraws.id
                                                                  .toString()
                                                            });
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
                                                              ? 'در انتظار'
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
                                                    withdraws.status == 0 ?
                                                    SizedBox.shrink() :
                                                        // لیست deposit Request
                                                    IconButton(
                                                      onPressed: () {
                                                        withdrawController
                                                            .fetchDepositRequestList(
                                                            withdraws.id!);
                                                        //withdrawController.toggleItemExpansion(index);
                                                        showModalBottomSheet(
                                                          isScrollControlled: true,
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
                                                          builder: (context) {
                                                            return Obx(() {
                                                              return Container(
                                                                height: MediaQuery
                                                                    .of(context)
                                                                    .size
                                                                    .height *
                                                                    0.85,
                                                                child:
                                                                Column(
                                                                  children: [
                                                                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Padding(
                                                                          padding: const EdgeInsets.only(right: 10,top: 5),
                                                                          child: Container(
                                                                            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                                                            padding: EdgeInsets.all(12),
                                                                            decoration: BoxDecoration(
                                                                              color: AppColor.primaryColor.withOpacity(0.1),
                                                                              borderRadius: BorderRadius.circular(8),
                                                                              border: Border.all(
                                                                                color: AppColor.primaryColor.withOpacity(0.3),
                                                                              ),
                                                                            ),
                                                                            child: Column(
                                                                              crossAxisAlignment: CrossAxisAlignment
                                                                                  .start,
                                                                              mainAxisAlignment: MainAxisAlignment
                                                                                  .start,
                                                                              children: [
                                                                                Row(
                                                                                  children: [
                                                                                    Text('کاربر: ',
                                                                                          style: AppTextStyle
                                                                                              .labelText.copyWith(fontSize: 12,fontWeight: FontWeight.bold),),
                                                                                        SizedBox(height: 2,),
                                                                                    Text( withdraws.wallet
                                                                                        ?.account?.name ??
                                                                                        "",
                                                                                      style: AppTextStyle
                                                                                          .bodyText.copyWith(fontSize: 13,fontWeight: FontWeight.bold),),
                                                                                  ],
                                                                                ),
                                                                                SizedBox(height: 4,),
                                                                                Row(
                                                                                  children: [
                                                                                    Text('حساب: ',
                                                                                      style: AppTextStyle
                                                                                          .labelText.copyWith(fontSize: 12,fontWeight: FontWeight.bold),),
                                                                                    SizedBox(height: 2,),
                                                                                    Text("${ withdraws
                                                                                        .ownerName ??
                                                                                        ""} (${ withdraws.bank
                                                                                        ?.name ?? ""})",
                                                                                      style: AppTextStyle
                                                                                          .bodyText
                                                                                          .copyWith(fontSize: 13,fontWeight: FontWeight.bold,color: AppColor.dividerColor),),
                                                                                  ],
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsets.only(left: 20),
                                                                          child: IconButton(
                                                                            onPressed: () {
                                                                              Get.back();
                                                                            },
                                                                            icon: Icon(Icons.close),
                                                                            style: ButtonStyle(iconSize: WidgetStateProperty.all(30) ,
                                                                              iconColor: WidgetStatePropertyAll(AppColor.textColor),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    withdrawController
                                                                        .isLoadingDepositRequestList
                                                                        .value ?
                                                                    Center(
                                                                      child: CircularProgressIndicator(
                                                                        valueColor: AlwaysStoppedAnimation<
                                                                            Color>(
                                                                            AppColor.textColor),
                                                                      ),
                                                                    ) : withdrawController
                                                                        .depositRequestList
                                                                        .isEmpty
                                                                        ?
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment
                                                                          .center,
                                                                      children: [
                                                                        Text(
                                                                            'هیچ شخصی جهت واریز مشخص نشده است',
                                                                            style: AppTextStyle
                                                                                .bodyText),
                                                                      ],
                                                                    ) :
                                                                    Expanded(
                                                                      child:
                                                                      ListView
                                                                          .builder(
                                                                        shrinkWrap: true,
                                                                        physics: ClampingScrollPhysics(),
                                                                        itemCount: withdrawController
                                                                            .depositRequestList
                                                                            .length,
                                                                        itemBuilder: (
                                                                            context,
                                                                            index) {
                                                                          var depositRequests = withdrawController
                                                                              .depositRequestList[index];
                                                                          return ListTile(
                                                                            title: Card(shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(8),
                                                                                side: BorderSide(color: AppColor.iconViewColor)),
                                                                              margin: EdgeInsets
                                                                                  .all(
                                                                                  1),
                                                                              color: AppColor
                                                                                  .backGroundColor1.withAlpha(50),
                                                                              child: Padding(
                                                                                padding: const EdgeInsets
                                                                                    .only(
                                                                                    top: 8,
                                                                                    left: 8,
                                                                                    right: 8,
                                                                                    bottom: 4),
                                                                                child: Column(
                                                                                  children: [
                                                                                    // تاریخ و وضعیت
                                                                                    Row(
                                                                                      mainAxisAlignment: MainAxisAlignment
                                                                                          .spaceBetween,
                                                                                      children: [
                                                                                        /*Row(
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
                                                                              ),*/

                                                                                        // وضعیت
                                                                                        Row(
                                                                                          children: [
                                                                                            Tooltip(
                                                                                              message: "تغییر وضعیت",
                                                                                              child: TextButton(
                                                                                                style: ButtonStyle(
                                                                                                  backgroundColor: WidgetStateProperty.all(AppColor.appBarColor),
                                                                                                  shape: WidgetStateProperty.all(
                                                                                                    RoundedRectangleBorder(
                                                                                                      borderRadius: BorderRadius.circular(10),
                                                                                                    )
                                                                                                  )
                                                                                                ),
                                                                                                  onPressed: () async{
                                                                                                    if (depositRequests.status == 1) {
                                                                                                      if (depositRequests.depositCount != 0) {
                                                                                                        Get
                                                                                                            .defaultDialog(
                                                                                                          title: 'هشدار',
                                                                                                          middleText: 'به دلیل داشتن زیر مجموعه قابل رد نیست',
                                                                                                          titleStyle: AppTextStyle
                                                                                                              .smallTitleText,
                                                                                                          middleTextStyle: AppTextStyle
                                                                                                              .bodyText,
                                                                                                          backgroundColor: AppColor
                                                                                                              .backGroundColor,
                                                                                                          textCancel: 'بستن',
                                                                                                        );
                                                                                                      } else {
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
                                                                                                          2,
                                                                                                          withdrawController
                                                                                                              .selectedReasonRejection
                                                                                                              .value!
                                                                                                              .id!,
                                                                                                        );
                                                                                                        withdrawController
                                                                                                            .fetchDepositRequestList(
                                                                                                            withdraws
                                                                                                                .id!);
                                                                                                      }
                                                                                                    } else {
                                                                                                      await withdrawController
                                                                                                          .updateStatusDepositRequest(
                                                                                                          depositRequests
                                                                                                              .id!,
                                                                                                          1,
                                                                                                          0);
                                                                                                      withdrawController
                                                                                                          .fetchDepositRequestList(
                                                                                                          withdraws
                                                                                                              .id!);
                                                                                                    }
                                                                                                  },
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
                                                                                                            : 'در انتظار',
                                                                                                        style: AppTextStyle
                                                                                                            .labelText.copyWith(color: depositRequests
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
                                                                                                            .secondaryColor,fontWeight: FontWeight.bold),
                                                                                                        textAlign: TextAlign
                                                                                                            .center),
                                                                                                  ),),
                                                                                            ),
                                                                                            /*Card(
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
                                                                                                  .secondaryColor,
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
                                                                                                        : 'در انتظار',
                                                                                                    style: AppTextStyle
                                                                                                        .labelText,
                                                                                                    textAlign: TextAlign
                                                                                                        .center),
                                                                                              ),
                                                                                            ),*/
                                                                                            /*SizedBox(
                                                                                              width: 4,),*/
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
                                                                                                    if (depositRequests
                                                                                                        .depositCount !=
                                                                                                        0) {
                                                                                                      Get
                                                                                                          .defaultDialog(
                                                                                                        title: 'هشدار',
                                                                                                        middleText: 'به دلیل داشتن زیر مجموعه قابل رد نیست',
                                                                                                        titleStyle: AppTextStyle
                                                                                                            .smallTitleText,
                                                                                                        middleTextStyle: AppTextStyle
                                                                                                            .bodyText,
                                                                                                        backgroundColor: AppColor
                                                                                                            .backGroundColor,
                                                                                                        textCancel: 'بستن',
                                                                                                      );
                                                                                                    } else {
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
                                                                                                      withdrawController
                                                                                                          .fetchDepositRequestList(
                                                                                                          withdraws
                                                                                                              .id!);
                                                                                                    }
                                                                                                  } else {
                                                                                                    await withdrawController
                                                                                                        .updateStatusDepositRequest(
                                                                                                        depositRequests
                                                                                                            .id!,
                                                                                                        value,
                                                                                                        0);
                                                                                                    withdrawController
                                                                                                        .fetchDepositRequestList(
                                                                                                        withdraws
                                                                                                            .id!);
                                                                                                  }
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
                                                                                                      int>(
                                                                                                    height: 18,
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
                                                                                                      int>(
                                                                                                    height: 18,
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
                                                                                                child:
                                                                                                SvgPicture
                                                                                                    .asset(
                                                                                                  'assets/svg/change-status.svg',
                                                                                                  height: 15,
                                                                                                  width: 15,
                                                                                                ),
                                                                                              ),
                                                                                            ),*/
                                                                                          ],
                                                                                        ),
                                                                                        // تلگرام
                                                                                        Row(
                                                                                          mainAxisAlignment: MainAxisAlignment
                                                                                              .end,
                                                                                          children: [
                                                                                            Text('تلگرام: ',
                                                                                              style: AppTextStyle
                                                                                                  .labelText,),
                                                                                            depositRequests.isSendTelegram == true ?
                                                                                            Icon(Icons.check,
                                                                                              color: AppColor
                                                                                                  .primaryColor,
                                                                                              size: 20,) :
                                                                                            Icon(Icons.close,
                                                                                              color: AppColor
                                                                                                  .accentColor,
                                                                                              size: 20,)
                                                                                          ],
                                                                                        ),
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
                                                                                      height: 2,),
                                                                                    //  مبلغ کل و واریز شده
                                                                                    Row(
                                                                                      mainAxisAlignment: MainAxisAlignment
                                                                                          .spaceBetween,
                                                                                      children: [
                                                                                        Row(
                                                                                          children: [
                                                                                            Text(
                                                                                                'کل:',
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
                                                                                        Row(
                                                                                          children: [
                                                                                            Text(
                                                                                                'واریز شده:',
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
                                                                                                  .bodyText
                                                                                                  .copyWith(
                                                                                                  color: AppColor
                                                                                                      .primaryColor),),
                                                                                          ],
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: 2,),
                                                                                    // دلیل رد
                                                                                    depositRequests
                                                                                        .status ==
                                                                                        2
                                                                                        ?
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
                                                                                              .bodyText.copyWith(color: AppColor.dividerColor),),
                                                                                      ],
                                                                                    )
                                                                                        : SizedBox.shrink(),

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
                                                                                        withdraws
                                                                                            .isReferencedByAnother ==
                                                                                            true
                                                                                            ? SizedBox
                                                                                            .shrink()
                                                                                            :
                                                                                        Container(
                                                                                          width: 25,
                                                                                          height: 25,
                                                                                          child:
                                                                                          GestureDetector(
                                                                                            onTap: () {
                                                                                              if (depositRequests
                                                                                                  .paidAmount! <
                                                                                                  depositRequests
                                                                                                      .amount!) {
                                                                                                Get
                                                                                                    .toNamed(
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
                                                                                              if (depositRequests
                                                                                                  .depositCount !=
                                                                                                  0) {
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
                                                                                                          withdrawController
                                                                                                              .deleteDepositRequest(
                                                                                                              withdraws
                                                                                                                  .id!,
                                                                                                              depositRequests
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
                                                                                        // ارسال تلگرام
                                                                                        GestureDetector(
                                                                                          onTap: () {
                                                                                            depositRequests.isSendTelegram == true ?
                                                                                            Get.defaultDialog(
                                                                                                backgroundColor: AppColor.backGroundColor,
                                                                                                title: "ارسال مجدد",
                                                                                                titleStyle: AppTextStyle.smallTitleText.copyWith(color: AppColor.errorColor),
                                                                                                middleText: "آیا از ارسال مجدد درخواست واریزی مطمئن هستید؟",
                                                                                                middleTextStyle: AppTextStyle.bodyText,
                                                                                                confirm: ElevatedButton(
                                                                                                    style: ButtonStyle(
                                                                                                        backgroundColor: WidgetStatePropertyAll(
                                                                                                            AppColor.primaryColor)),
                                                                                                    onPressed: () {
                                                                                                      Get.back();
                                                                                                      withdrawController.sendTelegramDepositRequest(depositRequests.id ?? 0,withdraws.id ?? 0);
                                                                                                    },
                                                                                                    child: Text(
                                                                                                      'ارسال مجدد',
                                                                                                      style: AppTextStyle.bodyText,
                                                                                                    ))
                                                                                            ) :
                                                                                            Get.defaultDialog(
                                                                                                backgroundColor: AppColor.backGroundColor,
                                                                                                title: "ارسال به تلگرام",
                                                                                                titleStyle: AppTextStyle.smallTitleText.copyWith(color: Color(0xff0ab6f0)),
                                                                                                middleText: "آیا از ارسال درخواست واریزی مطمئن هستید؟",
                                                                                                middleTextStyle: AppTextStyle.bodyText,
                                                                                                confirm: ElevatedButton(
                                                                                                    style: ButtonStyle(
                                                                                                        backgroundColor: WidgetStatePropertyAll(
                                                                                                            AppColor.primaryColor)),
                                                                                                    onPressed: () {
                                                                                                      Get.back();
                                                                                                      withdrawController.sendTelegramDepositRequest(depositRequests.id ?? 0,withdraws.id ?? 0);
                                                                                                    },
                                                                                                    child: Text(
                                                                                                      'ارسال',
                                                                                                      style: AppTextStyle.bodyText,
                                                                                                    ))
                                                                                            );
                                                                                          },
                                                                                          child: Tooltip(
                                                                                            message: depositRequests.isSendTelegram == true ?  "ارسال مجدد درخواست واریزی به تلگرام" : "ارسال درخواست واریزی به تلگرام",
                                                                                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                              children: [
                                                                                                Text(' ارسال',style: AppTextStyle.labelText.copyWith(color: depositRequests.isSendTelegram == true ? AppColor.successColor : Color(0xff0ab6f0), fontSize: 11,fontWeight: FontWeight.w400),),
                                                                                                SvgPicture.asset(
                                                                                                  'assets/svg/telegram.svg',height: 20,
                                                                                                  colorFilter: ColorFilter.mode(depositRequests.isSendTelegram == true ? AppColor.successColor : Color(0xff0ab6f0), BlendMode.srcIn) ,
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        // آیکون مشاهده
                                                                                        Container(
                                                                                          width: 25,
                                                                                          height: 25,
                                                                                          child: GestureDetector(
                                                                                            onTap: () {
                                                                                              Get
                                                                                                  .toNamed(
                                                                                                  '/depositRequestGetOne',
                                                                                                  parameters: {
                                                                                                    "id": depositRequests
                                                                                                        .id
                                                                                                        .toString()
                                                                                                  });
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
                                                                                    } else
                                                                                    {*/
                                                                                              withdrawController
                                                                                                  .setDepositRequestDetail(
                                                                                                  depositRequests);
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
                                                                                              //}
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
                                                          },
                                                        );
                                                      },
                                                      icon: Icon(
                                                        Icons.list_alt,
                                                        color: AppColor.primaryColor,
                                                      ),
                                                    ),

                                                    // Popup تعیین وضعیت
                                                    Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 0,
                                                          vertical: 0),
                                                      child: Center(
                                                        child: Transform.scale(
                                                          scale: 0.70,
                                                          child: Switch(
                                                            value: withdraws.status == 1,
                                                            onChanged: withdraws.status == 0
                                                                ? null // Disable switch for pending status
                                                                : (value) async {
                                                              // پذیرش = 1، عدم پذیرش = 2
                                                              final newStatus = value ? 1 : 2;

                                                              if (newStatus == 2) {
                                                                // Rejection flow: check for sub-items first
                                                                if (withdraws.depositRequestCount != 0 ||
                                                                    withdraws.depositCount != 0) {
                                                                  Get.defaultDialog(
                                                                    title: 'هشدار',
                                                                    middleText: 'به دلیل داشتن زیر مجموعه قابل رد نیست',
                                                                    titleStyle: AppTextStyle.smallTitleText,
                                                                    middleTextStyle: AppTextStyle.bodyText,
                                                                    backgroundColor: AppColor.backGroundColor,
                                                                    textCancel: 'بستن',
                                                                  );
                                                                  return; // Don't change switch state
                                                                } else {
                                                                  // Reset rejection reason before showing dialog
                                                                  withdrawController.selectedReasonRejection.value = null;
                                                                  // Show rejection reason dialog
                                                                  await withdrawController
                                                                      .showReasonRejectionDialog("WithdrawRequest");
                                                                  // اگر کاربر دلیل رد را انتخاب نکرد، تغییر اعمال نشود
                                                                  if (withdrawController
                                                                      .selectedReasonRejection.value == null) {
                                                                    return; // User cancelled or didn't select reason - no change applied
                                                                  }
                                                                  // Update status with rejection reason
                                                                  await withdrawController.updateStatusWithdraw(
                                                                    withdraws.id!,
                                                                    newStatus,
                                                                    withdrawController
                                                                        .selectedReasonRejection.value!.id!,
                                                                  );
                                                                  withdrawController.getWithdrawListPager();
                                                                }
                                                              } else {
                                                                // Acceptance flow: direct update
                                                                await withdrawController.updateStatusWithdraw(
                                                                  withdraws.id!,
                                                                  newStatus,
                                                                  0,
                                                                );
                                                                withdrawController.getWithdrawListPager();
                                                              }
                                                            },
                                                            thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
                                                              if (states.contains(WidgetState.disabled) ||
                                                                  withdraws.status == 0) {
                                                                return AppColor.dividerColor;
                                                              }
                                                              return withdraws.status == 1
                                                                  ? AppColor.successColor
                                                                  : AppColor.accentColor;
                                                            }),
                                                            trackColor: WidgetStateProperty.resolveWith<Color>((states) {
                                                              if (states.contains(WidgetState.disabled) ||
                                                                  withdraws.status == 0) {
                                                                return AppColor.dividerColor.withAlpha(100);
                                                              }
                                                              return withdraws.status == 1
                                                                  ? AppColor.successColor.withAlpha(100)
                                                                  : AppColor.accentColor.withAlpha(100);
                                                            }),
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
                                          /*AnimatedSize(
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
                                                  //SizedBox(height: 8,),
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
                                                                margin: EdgeInsets
                                                                    .all(1),
                                                                color: AppColor
                                                                    .backGroundColor,
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                      .only(
                                                                      top: 4,
                                                                      left: 12,
                                                                      right: 12,
                                                                      bottom: 4),
                                                                  child: Column(
                                                                    children: [
                                                                      // تاریخ و وضعیت
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment
                                                                            .spaceBetween,
                                                                        children: [
                                                                          *//*Row(
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
                                                                          ),*//*

                                                                          // وضعیت
                                                                          Row(
                                                                            children: [
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
                                                                                          : 'در انتظار',
                                                                                      style: AppTextStyle
                                                                                          .labelText,
                                                                                      textAlign: TextAlign
                                                                                          .center),
                                                                                ),
                                                                              ),
                                                                              SizedBox(
                                                                                width: 4,),
                                                                              //  تعیین وضعیت
                                                                              Container(
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
                                                                                      if (depositRequests
                                                                                          .depositCount !=
                                                                                          0) {
                                                                                        Get
                                                                                            .defaultDialog(
                                                                                          title: 'هشدار',
                                                                                          middleText: 'به دلیل داشتن زیر مجموعه قابل رد نیست',
                                                                                          titleStyle: AppTextStyle
                                                                                              .smallTitleText,
                                                                                          middleTextStyle: AppTextStyle
                                                                                              .bodyText,
                                                                                          backgroundColor: AppColor
                                                                                              .backGroundColor,
                                                                                          textCancel: 'بستن',
                                                                                        );
                                                                                      } else {
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
                                                                                        withdrawController
                                                                                            .fetchDepositRequestList(
                                                                                            withdraws
                                                                                                .id!);
                                                                                      }
                                                                                    } else {
                                                                                      await withdrawController
                                                                                          .updateStatusDepositRequest(
                                                                                          depositRequests
                                                                                              .id!,
                                                                                          value,
                                                                                          0);
                                                                                      withdrawController
                                                                                          .fetchDepositRequestList(
                                                                                          withdraws
                                                                                              .id!);
                                                                                    }
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
                                                                                        int>(
                                                                                      height: 18,
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
                                                                                        int>(
                                                                                      height: 18,
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
                                                                                  child:
                                                                                  SvgPicture
                                                                                      .asset(
                                                                                    'assets/svg/change-status.svg',
                                                                                    height: 15,
                                                                                    width: 15,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
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
                                                                        height: 2,),
                                                                      //  مبلغ کل و واریز شده
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment
                                                                            .spaceBetween,
                                                                        children: [
                                                                          Row(
                                                                            children: [
                                                                              Text(
                                                                                  'کل:',
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
                                                                          Row(
                                                                            children: [
                                                                              Text(
                                                                                  'واریز شده:',
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
                                                                                    .bodyText
                                                                                    .copyWith(
                                                                                    color: AppColor
                                                                                        .primaryColor),),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        height: 2,),
                                                                      // دلیل رد
                                                                      depositRequests
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
                                                                      ) : Text(
                                                                          ""),

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
                                                                          withdraws
                                                                              .isReferencedByAnother ==
                                                                              true
                                                                              ? SizedBox
                                                                              .shrink()
                                                                              :
                                                                          Container(
                                                                            width: 25,
                                                                            height: 25,
                                                                            child:
                                                                            GestureDetector(
                                                                              onTap: () {
                                                                                if (depositRequests
                                                                                    .paidAmount! <
                                                                                    depositRequests
                                                                                        .amount!) {
                                                                                  Get
                                                                                      .toNamed(
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
                                                                                if (depositRequests
                                                                                    .depositCount !=
                                                                                    0) {
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
                                                                                            withdrawController
                                                                                                .deleteDepositRequest(
                                                                                                withdraws
                                                                                                    .id!,
                                                                                                depositRequests
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
                                                                                Get
                                                                                    .toNamed(
                                                                                    '/depositRequestGetOne',
                                                                                    parameters: {
                                                                                      "id": depositRequests
                                                                                          .id
                                                                                          .toString()
                                                                                    });
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
                                                                                *//*if (withdraws.depositCount != 0) {
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
                                                                                } else
                                                                                {*//*
                                                                                withdrawController
                                                                                    .setDepositRequestDetail(
                                                                                    depositRequests);
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
                                                                                //}
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
                                          ),*/
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
          isMobile ? SizedBox.shrink() :
          Obx(() =>
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  withdrawController.paginated.value != null ? Container(
                      height: 70,
                      margin: EdgeInsets.symmetric(
                          horizontal: isMobile ? 20 : 70, vertical: 10),
                      padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 10 : 20),
                      //color: AppColor.appBarColor.withOpacity(0.5),
                      alignment: Alignment.bottomCenter,
                      child: PagerWidget(
                        countPage: withdrawController.paginated.value
                            ?.totalCount ?? 0, callBack: (int index) {
                        withdrawController.isChangePage(index);
                      },)) : SizedBox(),
                ],
              ),)
        ],
      ),
      floatingActionButton: isMobile ? SizedBox.shrink() : FloatingActionButton(
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
      DataColumn(
          label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 40),
              child: Text('ردیف', style: AppTextStyle.labelText)),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
              child: Text('ارسال تلگرام', style: AppTextStyle.labelText)),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 60),
              child: Text('درخواست ها', style: AppTextStyle.labelText)),
          headingRowAlignment: MainAxisAlignment.center),
      /*DataColumn(
          label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
          child: Text('تاریخ تراکنش', style: AppTextStyle.labelText)),
          headingRowAlignment:MainAxisAlignment.center,
        onSort: (columnIndex, ascending) {
          withdrawController.onSort(columnIndex, ascending);
        },
      ),*/
      /*DataColumn(label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
          child: Text('تاریخ', style: AppTextStyle.labelText)),headingRowAlignment:MainAxisAlignment.center ),*/
      DataColumn(
          label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
              child: Text('نام کاربر', style: AppTextStyle.labelText)),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
              child: Text('دارنده حساب', style: AppTextStyle.labelText)),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
              child: Text('مبلغ درخواستی', style: AppTextStyle.labelText)),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
              child: Text('مبلغ کل', style: AppTextStyle.labelText)),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
              child: Text('مبلغ مانده', style: AppTextStyle.labelText)),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
              child: Text('مبلغ واریز شده', style: AppTextStyle.labelText)),
          headingRowAlignment: MainAxisAlignment.center),
      /*DataColumn(label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
          child: Text('اضافه واریزی', style: AppTextStyle.labelText)),headingRowAlignment:MainAxisAlignment.center ),*/
      DataColumn(
          label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 30),
              child: Text('رفرنس', style: AppTextStyle.labelText)),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 30),
              child: Text('تلگرام', style: AppTextStyle.labelText)),
          headingRowAlignment: MainAxisAlignment.center),
      /*DataColumn(label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
          child: Text('مبلغ تایید نشده', style: AppTextStyle.labelText)),headingRowAlignment:MainAxisAlignment.center ),*/
      DataColumn(
          label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
              child: Text('وضعیت', style: AppTextStyle.labelText)),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 30),
              child: Text('تصاویر', style: AppTextStyle.labelText)),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 120),
              child: Text('عملیات', style: AppTextStyle.labelText)),
          headingRowAlignment: MainAxisAlignment.center),
    ];
  }

  // List<DataRow> buildDataRows(BuildContext context) {
  //   final groupedWithdraws = groupWithdrawsByDate(
  //       withdrawController.withdrawList);
  //   final rows = <DataRow>[];
  //   groupedWithdraws.forEach((date, withdraws) {
  //     rows.add(
  //       DataRow(
  //         color: WidgetStatePropertyAll(AppColor.iconViewColor),
  //         cells: [
  //           DataCell(SizedBox.shrink()),
  //           DataCell(
  //             Column(
  //               children: [
  //                 Center(
  //                   child: Column(
  //                     children: [
  //                       Text(date,
  //                         style: AppTextStyle.bodyText.copyWith(
  //                             color: Color(0xff6A1B9A), fontWeight: FontWeight
  //                             .bold, fontSize: 14
  //                         ),
  //                       ),
  //                       Text(withdraws.first.dateMiladiToString ?? "",
  //                         style: AppTextStyle.bodyText.copyWith(
  //                             color: Color(0xff6A1B9A), fontWeight: FontWeight
  //                             .bold, fontSize: 14
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           DataCell(
  //             Column(
  //               children: [
  //                 Text('ج کل', style: AppTextStyle.labelText.copyWith(
  //                     color: AppColor.accentColor,
  //                     fontWeight: FontWeight.bold)),
  //                 SizedBox(height: 1,),
  //                 Text(
  //                   " ( ${withdraws.first.totalAmountPerDay.toString().seRagham(
  //                       separator: ',')} )",
  //                   style: AppTextStyle.bodyText.copyWith(
  //                       color: AppColor.accentColor,
  //                       fontWeight: FontWeight.bold,
  //                       fontSize: 13),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           DataCell(
  //             Column(
  //               children: [
  //                 Text('ج واریز', style: AppTextStyle.labelText.copyWith(
  //                     color: Color(0xff2E7D32), fontWeight: FontWeight.bold)),
  //                 SizedBox(height: 1,),
  //                 Text(" ( ${withdraws.first.totalPaidAmountPerDay
  //                     .toString()
  //                     .seRagham(separator: ',')} )",
  //                   style: AppTextStyle.bodyText.copyWith(
  //                       color: Color(0xff2E7D32),
  //                       fontWeight: FontWeight.bold,
  //                       fontSize: 14),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           DataCell(
  //             Column(
  //               children: [
  //                 Text('ج تقسیم', style: AppTextStyle.labelText.copyWith(
  //                     color: Color(0xffdc4b00), fontWeight: FontWeight.bold)),
  //                 SizedBox(height: 1,),
  //                 Text(" ( ${withdraws.first.totalDepositRequestAmountPerDay
  //                     .toString().seRagham(separator: ',')} )",
  //                   style: AppTextStyle.bodyText.copyWith(
  //                       color: Color(0xffdc4b00),
  //                       fontWeight: FontWeight.bold,
  //                       fontSize: 13),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           DataCell(
  //             Column(
  //               children: [
  //                 Text('تقسیم شده واریز شده',
  //                     style: AppTextStyle.labelText.copyWith(
  //                         color: Color(0xff1B5E20),
  //                         fontWeight: FontWeight.bold)),
  //                 SizedBox(height: 1,),
  //                 Text(" ( ${withdraws.first.totalUndepositedAmountPerDay
  //                     .toString().seRagham(separator: ',')} )",
  //                   style: AppTextStyle.bodyText.copyWith(
  //                       color: Color(0xff1B5E20),
  //                       fontWeight: FontWeight.bold,
  //                       fontSize: 13),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           DataCell(
  //             Column(
  //               children: [
  //                 Text('مانده بدون تقسیم',
  //                     style: AppTextStyle.labelText.copyWith(
  //                         color: Color(0xffC62828),
  //                         fontWeight: FontWeight.bold)),
  //                 SizedBox(height: 1,),
  //                 Text(
  //                   " ( ${withdraws.first.totalUndividedAmountPerDay
  //                       .toString()
  //                       .seRagham(separator: ',')} )",
  //                   style: AppTextStyle.bodyText.copyWith(
  //                       color: Color(0xffC62828),
  //                       fontWeight: FontWeight.bold,
  //                       fontSize: 13),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           DataCell(SizedBox.shrink()),
  //           DataCell(SizedBox.shrink()),
  //           DataCell(SizedBox.shrink()),
  //           DataCell(SizedBox.shrink()),
  //           DataCell(SizedBox.shrink()),
  //           //DataCell(SizedBox.shrink()),
  //         ],
  //       ),
  //     );
  //     for (final withdraw in withdraws) {
  //       final index = withdrawController.withdrawList.indexOf(withdraw);
  //       final isExpanded = withdrawController.isItemExpanded(index);
  //       rows.add(
  //         DataRow(
  //           color: WidgetStatePropertyAll(
  //               isExpanded
  //                   ? AppColor.backGroundColor1.withAlpha(120)
  //                   : withdraw.amount == withdraw.paidAmount ? AppColor
  //                   .primaryColor.withAlpha(40)
  //                   : withdraw.isReferencedByAnother == true ? AppColor
  //                   .accentColor.withAlpha(100)
  //                   : AppColor.appBarColor.withAlpha(120)
  //           ),
  //           cells: [
  //             // ردیف
  //             DataCell(
  //                 Center(
  //                   child: Row(mainAxisAlignment: MainAxisAlignment.start,
  //                     children: [
  //                       GestureDetector(
  //                         onTap: () {
  //                           withdrawController.captureRowScreenshot(
  //                               withdraw, _dataTableKey, _rowKeys);
  //                         },
  //                         child: Row(
  //                           children: [
  //                             SvgPicture.asset(
  //                                 'assets/svg/camera.svg',
  //                                 height: 20,
  //                                 colorFilter: ColorFilter.mode(
  //                                   AppColor.iconViewColor,
  //                                   BlendMode.srcIn,
  //                                 )
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                       SizedBox(width: 5,),
  //                       Text(
  //                         "${withdraw.rowNum}",
  //                         style: AppTextStyle.labelText,
  //                       ),
  //                       SizedBox(width: 8,),
  //                       GestureDetector(
  //                         onTap: () {
  //                           withdrawController.updateRequestDateWithdraw(
  //                               withdraw.id ?? 0);
  //                         },
  //                         child:
  //                         withdraw.amount == withdraw.paidAmount ||
  //                             withdraw.undividedAmount == 0 ||
  //                             withdraw.isReferencedByAnother == true ? SizedBox
  //                             .shrink() :
  //                         SvgPicture.asset('assets/svg/arrow.svg',
  //                           colorFilter: ColorFilter.mode(AppColor.dividerColor,
  //                               BlendMode.srcIn),),
  //                       ),
  //                     ],
  //                   ),
  //                 )),
  //             // تاریخ تراکنش
  //             /*DataCell(
  //                 Center(
  //                   child: Row(
  //                     children: [
  //                       Text(
  //                         //withdraw.status == 0 ?
  //                              withdraw.requestDate?.toPersianDate(twoDigits: true, showTime: true, timeSeprator: '-') ?? 'نامشخص',
  //                             //: withdraw.confirmDate?.toPersianDate(twoDigits: true, showTime: true, timeSeprator: '-') ?? 'نامشخص',
  //                         style: AppTextStyle.bodyText,
  //                       ),
  //                       SizedBox(width: 8,),
  //                       GestureDetector(
  //                         onTap: () {
  //                           withdrawController.updateRequestDateWithdraw(withdraw.id ?? 0);
  //                         },
  //                           child:
  //                               withdraw.amount==withdraw.paidAmount || withdraw.undividedAmount==0 ? SizedBox.shrink() :
  //                           SvgPicture.asset('assets/svg/arrow.svg',colorFilter: ColorFilter.mode(AppColor.dividerColor, BlendMode.srcIn),),
  //                       ),
  //                     ],
  //                   ),
  //                 )),*/
  //             // تاریخ
  //             /*DataCell(
  //                 Center(
  //                   child: Text(
  //                     withdraw.status == 0
  //                         ? withdraw.requestDate?.toPersianDate(twoDigits: true, showTime: true, timeSeprator: '-') ?? 'نامشخص'
  //                         : withdraw.confirmDate?.toPersianDate(twoDigits: true, showTime: true, timeSeprator: '-') ?? 'نامشخص',
  //                     style: AppTextStyle.bodyText,
  //                   ),
  //                 )),*/
  //             // نام کاربر
  //             DataCell(
  //                 Center(
  //                   child: SelectableText(withdraw.wallet?.account?.name ?? "",
  //                       style: AppTextStyle.bodyText),
  //                 )),
  //             // دارنده حساب
  //             DataCell(
  //                 Center(
  //                   child: SelectableText(
  //                       "${withdraw.ownerName ?? ""} (${withdraw.bank?.name ??
  //                           ""})", style: AppTextStyle.bodyText),
  //                 )),
  //             // مبلغ درخواستی
  //             DataCell(
  //                 Center(
  //                   child: SelectableText(
  //                       "${withdraw.requestAmount?.toInt().toString().seRagham(
  //                           separator: ',') ?? 0} ریال",
  //                       style: AppTextStyle.bodyText
  //                   ),
  //                 )),
  //             // مبلغ کل
  //             DataCell(
  //                 Center(
  //                   child: SelectableText(
  //                       "${withdraw.amount?.toInt().toString().seRagham(
  //                           separator: ',')} ریال",
  //                       style: AppTextStyle.bodyText
  //                   ),
  //                 )),
  //             // مبلغ مانده
  //             DataCell(
  //                 Center(
  //                   child: SelectableText(
  //                     "${withdraw.undividedAmount?.toInt().toString().seRagham(
  //                         separator: ',')} ریال",
  //                     style: AppTextStyle.bodyText,),
  //                 )),
  //             // مبلغ واریز شده
  //             DataCell(
  //                 Center(
  //                   child: SelectableText(
  //                     "${withdraw.paidAmount?.toInt().toString().seRagham(
  //                         separator: ',')} ریال",
  //                     style: AppTextStyle.bodyText,),
  //                 )),
  //             // رفرنس
  //             DataCell(
  //                 Center(
  //                     child: withdraw.refrenceId != null
  //                         ?
  //                     Icon(Icons.check, color: AppColor.primaryColor, size: 20,)
  //                         :
  //                     Icon(Icons.close, color: AppColor.accentColor, size: 20,)
  //                 )),
  //             // مبلغ تایید نشده
  //             /*DataCell(
  //             Center(
  //               child: Text(
  //               "${withdraw.notConfirmedAmount?.toInt().toString().seRagham(separator: ',')} ریال",
  //               style: AppTextStyle.bodyText
  //                         ),
  //             )),*/
  //             // وضعیت
  //             DataCell(
  //               Center(
  //                 child: Column(
  //                   key: _rowKeys[withdraw.id],
  //                   children: [
  //                     SizedBox(height: 5,),
  //                     Text(
  //                       '${withdraw.status == 0 ? 'در انتظار' : withdraw
  //                           .status == 1
  //                           ? 'تایید شده'
  //                           : 'تایید نشده'} ',
  //                       style: AppTextStyle
  //                           .bodyText.copyWith(
  //                         color: withdraw.status == 1
  //                             ? AppColor.primaryColor
  //                             : withdraw.status == 2
  //                             ? AppColor.accentColor
  //                             : AppColor.textColor,
  //                       ),
  //                     ),
  //                     SizedBox(height: 6,),
  //                     Container(
  //                       padding: const EdgeInsets
  //                           .symmetric(
  //                           horizontal: 0,
  //                           vertical: 0),
  //                       child: PopupMenuButton<
  //                           int>(
  //                         splashRadius: 10,
  //                         tooltip: 'تعیین وضعیت',
  //                         onSelected: (value) async {
  //                           if (value == 2) {
  //                             if (withdraw.depositRequestCount != 0 ||
  //                                 withdraw.depositCount != 0) {
  //                               Get.defaultDialog(
  //                                 title: 'هشدار',
  //                                 middleText: 'به دلیل داشتن زیر مجموعه قابل رد نیست',
  //                                 titleStyle: AppTextStyle
  //                                     .smallTitleText,
  //                                 middleTextStyle: AppTextStyle
  //                                     .bodyText,
  //                                 backgroundColor: AppColor
  //                                     .backGroundColor,
  //                                 textCancel: 'بستن',
  //                               );
  //                             } else {
  //                               await withdrawController
  //                                   .showReasonRejectionDialog(
  //                                   "WithdrawRequest");
  //                               if (withdrawController
  //                                   .selectedReasonRejection
  //                                   .value ==
  //                                   null) {
  //                                 return; // اگر کاربر دلیل را انتخاب نکرد، عملیات لغو شود
  //                               }
  //                               await withdrawController
  //                                   .updateStatusWithdraw(
  //                                 withdraw.id!,
  //                                 value,
  //                                 withdrawController
  //                                     .selectedReasonRejection
  //                                     .value!.id!,
  //                               );
  //                               withdrawController
  //                                   .getWithdrawListPager();
  //                             }
  //                           } else {
  //                             await withdrawController
  //                                 .updateStatusWithdraw(
  //                                 withdraw.id!,
  //                                 value, 0);
  //                             withdrawController
  //                                 .getWithdrawListPager();
  //                           }
  //                         },
  //                         shape: const RoundedRectangleBorder(
  //                           borderRadius: BorderRadius
  //                               .all(
  //                               Radius.circular(
  //                                   10.0)),
  //                         ),
  //                         color: AppColor
  //                             .backGroundColor,
  //                         constraints: BoxConstraints(
  //                           minWidth: 70,
  //                           maxWidth: 70,
  //                         ),
  //                         position: PopupMenuPosition
  //                             .under,
  //                         offset: const Offset(
  //                             0, 0),
  //                         itemBuilder: (context) =>
  //                         [
  //                           PopupMenuItem<int>(height: 18,
  //                             labelTextStyle: WidgetStateProperty
  //                                 .all(
  //                                 AppTextStyle
  //                                     .madiumbodyText
  //                             ),
  //                             value: 1,
  //                             child: Row(
  //                               mainAxisAlignment: MainAxisAlignment
  //                                   .center,
  //                               children: [
  //                                 withdrawController
  //                                     .isLoading
  //                                     .value
  //                                     ?
  //                                 CircularProgressIndicator(
  //                                   valueColor: AlwaysStoppedAnimation<
  //                                       Color>(
  //                                       AppColor
  //                                           .textColor),
  //                                 ) :
  //                                 Text('تایید',
  //                                   style: AppTextStyle
  //                                       .madiumbodyText
  //                                       .copyWith(
  //                                       color: AppColor
  //                                           .primaryColor,
  //                                       fontSize: 14),
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                           const PopupMenuDivider(),
  //                           PopupMenuItem<int>(height: 18,
  //                             value: 2,
  //                             labelTextStyle: WidgetStateProperty
  //                                 .all(
  //                                 AppTextStyle
  //                                     .madiumbodyText
  //                             ),
  //                             child: Row(
  //                               mainAxisAlignment: MainAxisAlignment
  //                                   .center,
  //                               children: [
  //                                 withdrawController
  //                                     .isLoading
  //                                     .value
  //                                     ?
  //                                 CircularProgressIndicator(
  //                                   valueColor: AlwaysStoppedAnimation<
  //                                       Color>(
  //                                       AppColor
  //                                           .textColor),
  //                                 ) :
  //                                 Text('رد',
  //                                   style: AppTextStyle
  //                                       .madiumbodyText
  //                                       .copyWith(
  //                                       color: AppColor
  //                                           .accentColor,
  //                                       fontSize: 14),
  //                                 ),
  //                               ],
  //                             ),
  //                             onTap: () async {
  //
  //                               /*if (withdrawController.selectedReasonRejection.value != null) {
  //                                                                       await withdrawController.updateStatusWithdraw(withdraws.id!, 2,withdrawController.selectedReasonRejection.value?.id ?? 0);
  //                                                                     }*/
  //                             },
  //                           ),
  //                         ],
  //                         child: Text(
  //                           'تعیین وضعیت',
  //                           style: AppTextStyle
  //                               .bodyText
  //                               .copyWith(
  //                               decoration: TextDecoration
  //                                   .underline,
  //                               decorationColor: AppColor
  //                                   .textColor
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                     SizedBox(height: 6,),
  //                     withdraw.status == 2 ?
  //                     Wrap(
  //                       children: [
  //                         Text('به دلیل ',
  //                           style: AppTextStyle
  //                               .labelText,),
  //                         Text("`${withdraw
  //                             .reasonRejection
  //                             ?.name}`",
  //                           style: AppTextStyle
  //                               .bodyText,),
  //                         Text('رد شد.',
  //                           style: AppTextStyle
  //                               .labelText,),
  //                       ],
  //                     ) : Text(""),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             // نمایش تصاویر
  //             DataCell(
  //                 Center(
  //                   child:
  //                   GestureDetector(
  //                     onTap: () async {
  //                       await withdrawController.getImage(
  //                           withdraw.recId ?? "", "WithdrawRequest");
  //                       Future.delayed(const Duration(milliseconds: 200), () {
  //                         showDialog(
  //                           context: context,
  //                           builder: (BuildContext context) {
  //                             return Dialog(
  //                               backgroundColor: AppColor
  //                                   .backGroundColor,
  //                               shape: RoundedRectangleBorder(
  //                                 borderRadius: BorderRadius
  //                                     .circular(
  //                                     10),
  //                               ),
  //                               child: Container(
  //                                 padding: EdgeInsets
  //                                     .all(
  //                                     8),
  //                                 child: Column(
  //                                   mainAxisSize: MainAxisSize
  //                                       .min,
  //                                   children: [
  //                                     // نمایش اسلایدی عکس‌ها
  //                                     SizedBox(
  //                                       width: 500,
  //                                       height: 500,
  //                                       child: Stack(
  //                                         children: [
  //                                           PageView.builder(
  //                                             controller: withdrawController
  //                                                 .pageController,
  //                                             itemCount: withdrawController
  //                                                 .imageList.length,
  //                                             onPageChanged: (index) =>
  //                                             withdrawController
  //                                                 .currentImagePage
  //                                                 .value =
  //                                                 index,
  //                                             itemBuilder: (context,
  //                                                 index) {
  //                                               final attachment = withdrawController
  //                                                   .imageList[index];
  //                                               return Column(
  //                                                 children: [
  //                                                   if (kIsWeb)
  //                                                     Padding(
  //                                                       padding: const EdgeInsets
  //                                                           .only(right: 50),
  //                                                       child: Row(
  //                                                         mainAxisAlignment: MainAxisAlignment
  //                                                             .start,
  //                                                         children: [
  //                                                           IconButton(
  //                                                             icon: Icon(Icons
  //                                                                 .download,
  //                                                                 color: AppColor
  //                                                                     .dividerColor),
  //                                                             onPressed: () =>
  //                                                                 withdrawController
  //                                                                     .downloadImage(
  //                                                                   attachment,
  //                                                                 ),
  //                                                           ),
  //                                                         ],
  //                                                       ),
  //                                                     ),
  //                                                   SizedBox(
  //                                                     width: 450,
  //                                                     height: 450,
  //                                                     child: Image.network(
  //                                                       "${BaseUrl
  //                                                           .baseUrl}Attachment/downloadAttachment?fileName=$attachment",
  //                                                       loadingBuilder: (
  //                                                           context,
  //                                                           child,
  //                                                           loadingProgress) {
  //                                                         if (loadingProgress ==
  //                                                             null)
  //                                                           return child;
  //                                                         return Center(
  //                                                           child: CircularProgressIndicator(),
  //                                                         );
  //                                                       },
  //                                                       errorBuilder: (context,
  //                                                           error,
  //                                                           stackTrace) =>
  //                                                           Icon(
  //                                                               Icons
  //                                                                   .error,
  //                                                               color: Colors
  //                                                                   .red),
  //                                                       fit: BoxFit.contain,
  //                                                     ),
  //                                                   ),
  //                                                 ],
  //                                               );
  //                                             },
  //                                           ),
  //                                           SizedBox(
  //                                             height: 2,),
  //                                           Obx(() {
  //                                             return Positioned(
  //                                                 left: 10,
  //                                                 top: 0,
  //                                                 bottom: 0,
  //                                                 child: Visibility(
  //                                                   visible: withdrawController
  //                                                       .currentImagePage
  //                                                       .value > 0,
  //                                                   child: IconButton(
  //                                                     style: ButtonStyle(
  //                                                       backgroundColor: WidgetStateProperty
  //                                                           .all(
  //                                                           Colors.black54),
  //                                                       shape: WidgetStateProperty
  //                                                           .all(
  //                                                           CircleBorder()),
  //                                                       padding: WidgetStateProperty
  //                                                           .all(
  //                                                           EdgeInsets.all(8)),
  //                                                     ),
  //                                                     icon: Icon(
  //                                                       Icons.chevron_left,
  //                                                       color: Colors.white,
  //                                                       size: 40,
  //                                                       shadows: [
  //                                                         Shadow(
  //                                                           blurRadius: 10,
  //                                                           color: Colors.black,
  //                                                           offset: Offset(
  //                                                               0, 0),
  //                                                         )
  //                                                       ],
  //                                                     ),
  //                                                     onPressed: () {
  //                                                       withdrawController
  //                                                           .pageController
  //                                                           .previousPage(
  //                                                         duration: Duration(
  //                                                             milliseconds: 300),
  //                                                         curve: Curves
  //                                                             .easeInOut,
  //                                                       );
  //                                                     },
  //                                                   ),
  //                                                 )
  //                                             );
  //                                           }),
  //                                           Obx(() {
  //                                             return Positioned(
  //                                                 right: 10,
  //                                                 top: 0,
  //                                                 bottom: 0,
  //                                                 child: Visibility(
  //                                                   visible: withdrawController
  //                                                       .currentImagePage
  //                                                       .value <
  //                                                       (withdrawController
  //                                                           .imageList.length ??
  //                                                           1) - 1,
  //                                                   child: IconButton(
  //                                                     style: ButtonStyle(
  //                                                       backgroundColor: WidgetStateProperty
  //                                                           .all(
  //                                                           Colors.black54),
  //                                                       shape: WidgetStateProperty
  //                                                           .all(
  //                                                           CircleBorder()),
  //                                                       padding: WidgetStateProperty
  //                                                           .all(
  //                                                           EdgeInsets.all(8)),
  //                                                     ),
  //                                                     icon: Icon(
  //                                                       Icons.chevron_right,
  //                                                       color: Colors.white,
  //                                                       size: 40,
  //                                                       shadows: [
  //                                                         Shadow(
  //                                                           blurRadius: 10,
  //                                                           color: Colors.black,
  //                                                           offset: Offset(
  //                                                               0, 0),
  //                                                         ),
  //                                                       ],
  //                                                     ),
  //                                                     onPressed: () {
  //                                                       withdrawController
  //                                                           .pageController
  //                                                           .nextPage(
  //                                                         duration: Duration(
  //                                                             milliseconds: 300),
  //                                                         curve: Curves
  //                                                             .easeInOut,
  //                                                       );
  //                                                     },
  //                                                   ),
  //                                                 )
  //                                             );
  //                                           }),
  //                                           SizedBox(
  //                                             height: 2,),
  //                                           // نمایش نقاط راهنما
  //                                           Obx(() =>
  //                                               Row(
  //                                                 mainAxisAlignment: MainAxisAlignment
  //                                                     .center,
  //                                                 children: List
  //                                                     .generate(
  //                                                   withdrawController.imageList
  //                                                       .length,
  //                                                       (index) =>
  //                                                       Container(
  //                                                         width: 8,
  //                                                         height: 8,
  //                                                         margin: EdgeInsets
  //                                                             .symmetric(
  //                                                             horizontal: 4),
  //                                                         decoration: BoxDecoration(
  //                                                           shape: BoxShape
  //                                                               .circle,
  //                                                           color: withdrawController
  //                                                               .currentImagePage
  //                                                               .value ==
  //                                                               index
  //                                                               ? Colors
  //                                                               .blue
  //                                                               : Colors
  //                                                               .grey,
  //                                                         ),
  //                                                       ),
  //                                                 ),
  //                                               )),
  //                                           SizedBox(
  //                                               height: 10),
  //                                         ],
  //                                       ),
  //                                     ),
  //                                     TextButton(
  //                                       onPressed: () =>
  //                                           Get
  //                                               .back(),
  //                                       child: Text(
  //                                         "بستن",
  //                                         style: AppTextStyle
  //                                             .bodyText,),
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                             );
  //                           },
  //                         );
  //                       });
  //                     },
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       children: [
  //                         SvgPicture.asset('assets/svg/picture.svg', height: 20,
  //                             colorFilter: ColorFilter.mode(
  //
  //                               AppColor.textColor,
  //
  //                               BlendMode.srcIn,
  //                             )),
  //                       ],
  //                     ),
  //                   ),
  //                 )),
  //             // نمایش درخواست های واریزی
  //             withdraw.status == 0 ?
  //             DataCell(Center(
  //               child: SizedBox.shrink(),
  //             )) :
  //             DataCell(
  //               Center(
  //                 child: IconButton(
  //                   icon: Icon(
  //                       isExpanded ? Icons.expand_less : Icons.expand_more),
  //                   color: isExpanded ? AppColor.accentColor : AppColor
  //                       .secondary2Color,
  //                   onPressed: () {
  //                     final index = withdrawController.withdrawList.indexOf(
  //                         withdraw);
  //                     withdrawController.expandAndScrollHorizontal(
  //                         index, withdraw.id!);
  //                   },
  //                 ),
  //               ),
  //             ),
  //             // آیکون های عملیات
  //             withdraw.status == 0 ?
  //             DataCell(
  //                 Padding(
  //                   padding: const EdgeInsets.only(left: 6),
  //                   child: // آیکون حذف کردن
  //                   Row(mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       GestureDetector(
  //                         onTap: () {
  //                           if (withdraw.depositRequestCount != 0 || withdraw
  //                               .depositCount != 0) {
  //                             Get.defaultDialog(
  //                               title: 'هشدار',
  //                               middleText: 'به دلیل داشتن زیر مجموعه قابل حذف نیست',
  //                               titleStyle: AppTextStyle
  //                                   .smallTitleText,
  //                               middleTextStyle: AppTextStyle
  //                                   .bodyText,
  //                               backgroundColor: AppColor
  //                                   .backGroundColor,
  //                               textCancel: 'بستن',
  //                             );
  //                           } else {
  //                             Get.defaultDialog(
  //                                 backgroundColor: AppColor
  //                                     .backGroundColor,
  //                                 title: "حذف درخواست برداشت",
  //                                 titleStyle: AppTextStyle
  //                                     .smallTitleText,
  //                                 middleText: "آیا از حذف درخواست برداشت مطمئن هستید؟",
  //                                 middleTextStyle: AppTextStyle
  //                                     .bodyText,
  //                                 confirm: ElevatedButton(
  //                                     style: ButtonStyle(
  //                                         backgroundColor: WidgetStatePropertyAll(
  //                                             AppColor
  //                                                 .primaryColor)),
  //                                     onPressed: () {
  //                                       Get.back();
  //                                       withdrawController.deleteWithdraw(
  //                                           withdraw.id!, true);
  //                                     },
  //                                     child: Text(
  //                                       'حذف',
  //                                       style: AppTextStyle
  //                                           .bodyText,
  //                                     )));
  //                             //withdrawController.fetchWithdrawList();
  //                           }
  //                         },
  //                         child: Row(
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           children: [
  //                             SvgPicture.asset(
  //                                 'assets/svg/trash-bin.svg', width: 20,
  //                                 height: 20,
  //                                 colorFilter: ColorFilter
  //                                     .mode(AppColor
  //                                     .accentColor,
  //                                   BlendMode
  //                                       .srcIn,)
  //                             ),
  //                             Text(' حذف',
  //                               style: AppTextStyle
  //                                   .bodyText
  //                                   .copyWith(
  //                                   color: AppColor
  //                                       .accentColor, fontSize: 12),),
  //                           ],
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 )
  //             ) :
  //             DataCell(
  //               Padding(
  //                 padding: const EdgeInsets.only(left: 6),
  //                 child: Column(
  //                   // mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     // آیکون تقسیم و حذف
  //                     Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         // آیکون تقسیم
  //                         GestureDetector(
  //                           onTap: () {
  //                             if (withdraw.undividedAmount == 0) {
  //                               Get.defaultDialog(
  //                                 title: 'هشدار',
  //                                 middleText: 'مبلغ باقیمانده برای تقسیم صفر است',
  //                                 titleStyle: AppTextStyle
  //                                     .smallTitleText,
  //                                 middleTextStyle: AppTextStyle
  //                                     .bodyText,
  //                                 backgroundColor: AppColor
  //                                     .backGroundColor,
  //                                 textCancel: 'بستن',
  //                               );
  //                             } else {
  //                               withdrawController.balanceList.clear();
  //                               showModalBottomSheet(
  //                                 enableDrag: true,
  //                                 context: context,
  //                                 backgroundColor: AppColor
  //                                     .backGroundColor,
  //                                 shape: RoundedRectangleBorder(
  //                                   borderRadius: BorderRadius
  //                                       .vertical(top: Radius
  //                                       .circular(20)),
  //                                 ),
  //                                 builder: (context) {
  //                                   return InsertDepositRequestWidget(
  //                                     id: withdraw.id!,
  //                                     walletId: withdraw
  //                                         .wallet!
  //                                         .id!,
  //                                     unDividedAmount: withdraw
  //                                         .undividedAmount,);
  //                                 },
  //                               ).whenComplete(() {
  //                                 withdrawController
  //                                     .clearList();
  //                               }
  //                               );
  //                               withdrawController
  //                                   .filterAccountListFunc(
  //                                   withdraw.wallet!
  //                                       .account!.id!
  //                                       .toInt());
  //                             }
  //                           },
  //                           child: Row(
  //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                             children: [
  //                               SvgPicture.asset(
  //                                   'assets/svg/add.svg', width: 20, height: 20,
  //                                   colorFilter: ColorFilter
  //                                       .mode(AppColor
  //                                       .buttonColor,
  //                                     BlendMode
  //                                         .srcIn,)
  //                               ),
  //                               Text(' تقسیم',
  //                                 style: AppTextStyle
  //                                     .bodyText
  //                                     .copyWith(
  //                                     color: AppColor
  //                                         .buttonColor, fontSize: 12),),
  //                             ],
  //                           ),
  //                         ),
  //                         // آیکون حذف کردن
  //                         GestureDetector(
  //                           onTap: () {
  //                             if (withdraw.depositRequestCount != 0 ||
  //                                 withdraw.depositCount != 0) {
  //                               Get.defaultDialog(
  //                                 title: 'هشدار',
  //                                 middleText: 'به دلیل داشتن زیر مجموعه قابل حذف نیست',
  //                                 titleStyle: AppTextStyle
  //                                     .smallTitleText,
  //                                 middleTextStyle: AppTextStyle
  //                                     .bodyText,
  //                                 backgroundColor: AppColor
  //                                     .backGroundColor,
  //                                 textCancel: 'بستن',
  //                               );
  //                             } else {
  //                               Get.defaultDialog(
  //                                   backgroundColor: AppColor
  //                                       .backGroundColor,
  //                                   title: "حذف درخواست برداشت",
  //                                   titleStyle: AppTextStyle
  //                                       .smallTitleText,
  //                                   middleText: "آیا از حذف درخواست برداشت مطمئن هستید؟",
  //                                   middleTextStyle: AppTextStyle
  //                                       .bodyText,
  //                                   confirm: ElevatedButton(
  //                                       style: ButtonStyle(
  //                                           backgroundColor: WidgetStatePropertyAll(
  //                                               AppColor
  //                                                   .primaryColor)),
  //                                       onPressed: () {
  //                                         Get.back();
  //                                         withdrawController.deleteWithdraw(
  //                                             withdraw.id!, true);
  //                                       },
  //                                       child: Text(
  //                                         'حذف',
  //                                         style: AppTextStyle
  //                                             .bodyText,
  //                                       )));
  //                               //withdrawController.fetchWithdrawList();
  //                             }
  //                           },
  //                           child: Row(
  //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                             children: [
  //                               SvgPicture.asset(
  //                                   'assets/svg/trash-bin.svg', width: 20,
  //                                   height: 20,
  //                                   colorFilter: ColorFilter
  //                                       .mode(AppColor
  //                                       .accentColor,
  //                                     BlendMode
  //                                         .srcIn,)
  //                               ),
  //                               Text(' حذف',
  //                                 style: AppTextStyle
  //                                     .bodyText
  //                                     .copyWith(
  //                                     color: AppColor
  //                                         .accentColor, fontSize: 12),),
  //                             ],
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //
  //                     SizedBox(height: 10,),
  //                     // آیکون مشاهده و ویرایش
  //                     Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         // آیکون مشاهده
  //                         GestureDetector(
  //                           onTap: () {
  //                             Get.toNamed('/withdrawGetOne',
  //                                 parameters: {"id": withdraw.id.toString()});
  //                             //print(withdraws.id);
  //                           },
  //                           child: Row(
  //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                             children: [
  //                               SvgPicture.asset(
  //                                   'assets/svg/eye1.svg', width: 20,
  //                                   height: 20,
  //                                   colorFilter: ColorFilter
  //                                       .mode(AppColor
  //                                       .iconViewColor,
  //                                     BlendMode
  //                                         .srcIn,)
  //                               ),
  //                               Text(' مشاهده',
  //                                 style: AppTextStyle
  //                                     .bodyText
  //                                     .copyWith(
  //                                     color: AppColor
  //                                         .iconViewColor, fontSize: 12),),
  //                             ],
  //                           ),
  //                         ),
  //                         SizedBox(width: 10,),
  //                         // آیکون ویرایش
  //                         GestureDetector(
  //                           onTap: () {
  //                             /*if (withdraw.depositRequestCount != 0 || withdraw.depositCount != 0) {
  //                           Get.defaultDialog(
  //                             title: 'هشدار',
  //                             middleText: 'به دلیل داشتن زیر مجموعه قابل ویرایش نیست',
  //                             titleStyle: AppTextStyle
  //                                 .smallTitleText,
  //                             middleTextStyle: AppTextStyle
  //                                 .bodyText,
  //                             backgroundColor: AppColor
  //                                 .backGroundColor,
  //                             textCancel: 'بستن',
  //                           );
  //                         } else
  //                         {*/
  //                             Get.toNamed('/withdrawUpdate',
  //                                 parameters: {"id": withdraw.id.toString()});
  //                             //}
  //                           },
  //                           child: Row(
  //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                             children: [
  //                               SvgPicture.asset(
  //                                   'assets/svg/edit.svg', width: 20,
  //                                   height: 20,
  //                                   colorFilter: ColorFilter
  //                                       .mode(AppColor
  //                                       .iconViewColor,
  //                                     BlendMode
  //                                         .srcIn,)
  //                               ),
  //                               Text(' ویرایش',
  //                                 style: AppTextStyle
  //                                     .bodyText
  //                                     .copyWith(
  //                                     color: AppColor
  //                                         .iconViewColor, fontSize: 12),),
  //                             ],
  //                           ),
  //                         ),
  //                       ],
  //                     )
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     }
  //   }
  //   );
  //   return rows;
  // }


  Widget buildExpandableTable(BuildContext context) {
    final groupedWithdraws = groupWithdrawsByDate(
        withdrawController.withdrawList);
    final columns = buildDataColumns();

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.textColor, width: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Header row
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: AppColor.buttonColor.withAlpha(40),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              border: Border(
                bottom: BorderSide(color: AppColor.textColor, width: 0.3),
              ),
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.center,
              children: columns
                  .asMap()
                  .entries
                  .map((entry) {
                final index = entry.key;
                final column = entry.value;
                return Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border(
                        right: index < columns.length
                            ? BorderSide(color: AppColor.textColor, width: 0.3)
                            : BorderSide.none,
                      ),
                    ),
                    child: column.label,
                  ),
                );
              }).toList(),
            ),
          ),
          // Data rows
          ...groupedWithdraws.entries.expand((entry) {
            final date = entry.key;
            final withdraws = entry.value;
            final rows = <Widget>[];

            // Date summary row
            rows.add(
              Container(
                color: AppColor.iconViewColor,
                child: Row(mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    //Expanded(child: SizedBox.shrink()),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        child: Column(
                          children: [
                            Text(date,
                              style: AppTextStyle.bodyText.copyWith(
                                  color: Color(0xff6A1B9A),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12
                              ),
                            ),
                            Text(withdraws.first.dateMiladiToString ?? "",
                              style: AppTextStyle.bodyText.copyWith(
                                  color: Color(0xff6A1B9A),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        child: Column(
                          children: [
                            Text('ج کل', style: AppTextStyle.labelText.copyWith(
                                color: AppColor.accentColor,
                                fontWeight: FontWeight.bold)),
                            SizedBox(height: 1,),
                            Text(
                              " ( ${withdraws.first.totalAmountPerDay
                                  .toString()
                                  .seRagham(separator: ',')} )",
                              style: AppTextStyle.bodyText.copyWith(
                                  color: AppColor.accentColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        child: Column(
                          children: [
                            Text('ج واریز',
                                style: AppTextStyle.labelText.copyWith(
                                    color: Color(0xff2E7D32),
                                    fontWeight: FontWeight.bold)),
                            SizedBox(height: 1,),
                            Text(" ( ${withdraws.first.totalPaidAmountPerDay
                                .toString().seRagham(separator: ',')} )",
                              style: AppTextStyle.bodyText.copyWith(
                                  color: Color(0xff2E7D32),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        child: Column(
                          children: [
                            Text('ج تقسیم',
                                style: AppTextStyle.labelText.copyWith(
                                    color: Color(0xffdc4b00),
                                    fontWeight: FontWeight.bold)),
                            SizedBox(height: 1,),
                            Text(" ( ${withdraws.first
                                .totalDepositRequestAmountPerDay
                                .toString()
                                .seRagham(separator: ',')} )",
                              style: AppTextStyle.bodyText.copyWith(
                                  color: Color(0xffdc4b00),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        child: Column(
                          children: [
                            Text('تقسیم شده واریز نشده',
                                style: AppTextStyle.labelText.copyWith(
                                    color: Color(0xff1B5E20),
                                    fontWeight: FontWeight.bold)),
                            SizedBox(height: 1,),
                            Text(
                              " ( ${withdraws.first.totalUndepositedAmountPerDay
                                  .toString().seRagham(separator: ',')} )",
                              style: AppTextStyle.bodyText.copyWith(
                                  color: Color(0xff1B5E20),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        child: Column(
                          children: [
                            Text('مانده بدون تقسیم',
                                style: AppTextStyle.labelText.copyWith(
                                    color: Color(0xffC62828),
                                    fontWeight: FontWeight.bold)),
                            SizedBox(height: 1,),
                            Text(
                              " ( ${withdraws.first.totalUndividedAmountPerDay
                                  .toString().seRagham(separator: ',')} )",
                              style: AppTextStyle.bodyText.copyWith(
                                  color: Color(0xffC62828),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(child: SizedBox.shrink()),
                    Expanded(child: SizedBox.shrink()),
                    /*Expanded(child: SizedBox.shrink()),
                    Expanded(child: SizedBox.shrink()),
                    Expanded(child: SizedBox.shrink()),*/
                  ],
                ),
              ),
            );

            // Individual withdraw rows
            for (final withdraw in withdraws) {
              final index = withdrawController.withdrawList.indexOf(withdraw);
              final isExpanded = withdrawController.isItemExpanded(index);
              /*final rowColor = index.isEven
                  ? AppColor.backGroundColor
                  : AppColor.secondaryColor.withAlpha(100);*/
              rows.add(
                Column(
                  children: [
                    // Main withdraw row
                    Container(
                      key: _rowKeys[withdraw.id],
                      decoration: BoxDecoration(
                        color: isExpanded
                            ? AppColor.secondary200Color.withAlpha(150)
                            : withdraw.amount == withdraw.paidAmount ? AppColor.primaryColor.withAlpha(40)
                            : withdraw.isReferencedByAnother == true ? AppColor.accentColor.withAlpha(100)
                            : AppColor.backGroundColor,
                        border: Border.all(
                              color: AppColor.iconViewColor, width: 0.3
                        ),
                      ),
                      child: Row(
                        children: [
                          // Row number and actions
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                      color: AppColor.textColor, width: 0.3),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      withdrawController.captureRowScreenshot(
                                          withdraw, _dataTableKey, _rowKeys);
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
                                  SizedBox(width: 8,),
                                  GestureDetector(
                                    onTap: () {
                                      withdrawController
                                          .updateRequestDateWithdraw(
                                          withdraw.id ?? 0);
                                    },
                                    child:
                                    withdraw.amount == withdraw.paidAmount ||
                                        withdraw.undividedAmount == 0 ||
                                        withdraw.isReferencedByAnother == true
                                        ? SizedBox.shrink()
                                        :
                                    Tooltip(
                                      message: 'ایجاد رفرنس درخواست برداشت',
                                      child: SvgPicture.asset('assets/svg/arrow.svg',
                                        colorFilter: ColorFilter.mode(
                                            AppColor.dividerColor,
                                            BlendMode.srcIn),),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // send telegram
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                      color: AppColor.textColor, width: 0.3),
                                ),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  withdraw.allDepositSent == true ?
                                  Get.defaultDialog(
                                      backgroundColor: AppColor.backGroundColor,
                                      title: "ارسال مجدد",
                                      titleStyle: AppTextStyle.smallTitleText.copyWith(color: AppColor.errorColor),
                                      middleText: "آیا از ارسال مجدد واریزی ها مطمئن هستید؟",
                                      middleTextStyle: AppTextStyle.bodyText,
                                      confirm: ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor: WidgetStatePropertyAll(
                                                  AppColor.primaryColor)),
                                          onPressed: () {
                                            Get.back();
                                            withdrawController.sendTelegramWithdrawRequest(withdraw.id ?? 0);
                                          },
                                          child: Text(
                                            'ارسال مجدد',
                                            style: AppTextStyle.bodyText,
                                          ))
                                  ) :
                                  Get.defaultDialog(
                                      backgroundColor: AppColor.backGroundColor,
                                      title: "ارسال واریزی ها به تلگرام",
                                      titleStyle: AppTextStyle.smallTitleText.copyWith(color: Color(0xff0ab6f0)),
                                      middleText: "آیا از ارسال واریزی ها مطمئن هستید؟",
                                      middleTextStyle: AppTextStyle.bodyText,
                                      confirm: ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor: WidgetStatePropertyAll(
                                                  AppColor.primaryColor)),
                                          onPressed: () {
                                            Get.back();
                                            withdrawController.sendTelegramWithdrawRequest(withdraw.id ?? 0);
                                          },
                                          child: Text(
                                            'ارسال',
                                            style: AppTextStyle.bodyText,
                                          ))
                                  );
                                },
                                child: Tooltip(
                                  message: withdraw.allDepositSent == true ?  "ارسال مجدد واریزی ها به تلگرام" : "ارسال واریزی ها به تلگرام",
                                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(' ارسال',style: AppTextStyle.labelText.copyWith(color: withdraw.allDepositSent == true ? AppColor.successColor : Color(0xff0ab6f0), fontSize: 11,fontWeight: FontWeight.w400),),
                                      SvgPicture.asset(
                                        'assets/svg/telegram.svg',height: 20,
                                        colorFilter: ColorFilter.mode(withdraw.allDepositSent == true ? AppColor.successColor : Color(0xff0ab6f0), BlendMode.srcIn) ,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Deposit requests
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                      color: AppColor.textColor, width: 0.3),
                                ),
                              ),
                              child: Center(
                                child: withdraw.status == 0 ?
                                SizedBox.shrink() :
                                IconButton(
                                  icon: Icon(
                                      isExpanded ? Icons.expand_less : Icons
                                          .expand_more),
                                  color: isExpanded
                                      ? AppColor.accentColor
                                      : AppColor.secondary2Color,
                                  onPressed: () {
                                    final index = withdrawController
                                        .withdrawList.indexOf(withdraw);
                                    withdrawController.fetchDepositRequestList(
                                        withdraw.id!);
                                    withdrawController.toggleItemExpansion(
                                        index);
                                  },
                                ),
                              ),
                            ),
                          ),
                          // User name
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                      color: AppColor.textColor, width: 0.3),
                                ),
                              ),
                              child: withdraw.wallet?.account?.id != null
                                  ? HoverTooltipBalanceWithdrawWidget(
                                accountId: withdraw.wallet?.account?.id ?? 0,
                                accountName: withdraw.wallet?.account?.name ??
                                    "",
                                withdrawController: withdrawController,
                              )
                                  : Text(
                                withdraw.wallet?.account?.name ?? "",
                                style: AppTextStyle.bodyText.copyWith(
                                    fontSize: 11),
                              ),
                            ),
                          ),
                          // Account holder
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                      color: AppColor.textColor, width: 0.3),
                                ),
                              ),
                              child: SelectableText(
                                  "${withdraw.ownerName ?? ""} (${withdraw.bank
                                      ?.name ?? ""})",
                                  style: AppTextStyle.bodyText),
                            ),
                          ),
                          // Request amount
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                      color: AppColor.textColor, width: 0.3),
                                ),
                              ),
                              child: SelectableText(
                                  "${withdraw.requestAmount
                                      ?.toInt()
                                      .toString()
                                      .seRagham(separator: ',') ?? 0} ریال",
                                  style: AppTextStyle.bodyText
                              ),
                            ),
                          ),
                          // Total amount
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                      color: AppColor.textColor, width: 0.3),
                                ),
                              ),
                              child: SelectableText(
                                  "${withdraw.amount
                                      ?.toInt()
                                      .toString()
                                      .seRagham(separator: ',')} ریال",
                                  style: AppTextStyle.bodyText
                              ),
                            ),
                          ),
                          // Remaining amount
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                      color: AppColor.textColor, width: 0.3),
                                ),
                              ),
                              child: SelectableText(
                                "${withdraw.undividedAmount
                                    ?.toInt()
                                    .toString()
                                    .seRagham(separator: ',')} ریال",
                                style: AppTextStyle.bodyText,),
                            ),
                          ),
                          // Paid amount
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                      color: AppColor.textColor, width: 0.3),
                                ),
                              ),
                              child: SelectableText(
                                "${withdraw.paidAmount
                                    ?.toInt()
                                    .toString()
                                    .seRagham(separator: ',')} ریال",
                                style: AppTextStyle.bodyText,),
                            ),
                          ),
                          // Extra amount
                          /*Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  border: Border(
                                    right: BorderSide(color: AppColor.textColor, width: 0.3),
                                  ),
                                ),
                                child: SelectableText(
                                  "${withdraw.extraAmount?.toInt().toString().seRagham(separator: ',')} ریال",
                                  style: AppTextStyle.bodyText,),
                              ),
                            ),*/
                          // Reference
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                      color: AppColor.textColor, width: 0.3),
                                ),
                              ),
                              child: Center(
                                  child: withdraw.refrenceId != null ?
                                  Icon(
                                    Icons.check, color: AppColor.primaryColor,
                                    size: 20,) :
                                  Icon(Icons.close, color: AppColor.accentColor,
                                    size: 20,)
                              ),
                            ),
                          ),
                          // telegram
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                      color: AppColor.textColor, width: 0.3),
                                ),
                              ),
                              child: Center(
                                  child: withdraw.allDepositSent == true ?
                                  Icon(
                                    Icons.check, color: AppColor.primaryColor,
                                    size: 20,) :
                                  Icon(Icons.close, color: AppColor.accentColor,
                                    size: 20,)
                              ),
                            ),
                          ),
                          // Status
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 0),
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                      color: AppColor.textColor, width: 0.3),
                                ),
                              ),
                              child: Column(
                                children: [
                                  /*SizedBox(height: 2,),
                                  Text(
                                    '${withdraw.status == 0
                                        ? 'در انتظار'
                                        : withdraw.status == 1
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
                                  ),*/
                                  //SizedBox(height: 3,),
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
                                        if (value == 2) {
                                          if (withdraw.depositRequestCount !=
                                              0 || withdraw.depositCount != 0) {
                                            Get.defaultDialog(
                                              title: 'هشدار',
                                              middleText: 'به دلیل داشتن زیر مجموعه قابل رد نیست',
                                              titleStyle: AppTextStyle
                                                  .smallTitleText,
                                              middleTextStyle: AppTextStyle
                                                  .bodyText,
                                              backgroundColor: AppColor
                                                  .backGroundColor,
                                              textCancel: 'بستن',
                                            );
                                          } else {
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
                                            withdrawController
                                                .getWithdrawListPager();
                                          }
                                        } else {
                                          await withdrawController
                                              .updateStatusWithdraw(
                                              withdraw.id!,
                                              value, 0);
                                          withdrawController
                                              .getWithdrawListPager();
                                        }
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
                                      itemBuilder: (context) =>
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
                                        value: withdraw.status == 1,
                                        onChanged: withdraw.status == 0
                                            ? null // Disable switch for pending status
                                            : (value) async {
                                          // پذیرش = 1، عدم پذیرش = 2
                                          final newStatus = value ? 1 : 2;

                                          if (newStatus == 2) {
                                            // Rejection flow: check for sub-items first
                                            if (withdraw.depositRequestCount != 0 ||
                                                withdraw.depositCount != 0) {
                                              Get.defaultDialog(
                                                title: 'هشدار',
                                                middleText: 'به دلیل داشتن زیر مجموعه قابل رد نیست',
                                                titleStyle: AppTextStyle.smallTitleText,
                                                middleTextStyle: AppTextStyle.bodyText,
                                                backgroundColor: AppColor.backGroundColor,
                                                textCancel: 'بستن',
                                              );
                                              return; // Don't change switch state
                                            } else {
                                              // Reset rejection reason before showing dialog
                                              withdrawController.selectedReasonRejection.value = null;
                                              // Show rejection reason dialog
                                              await withdrawController
                                                  .showReasonRejectionDialog("WithdrawRequest");
                                              // اگر کاربر دلیل رد را انتخاب نکرد، تغییر اعمال نشود
                                              if (withdrawController
                                                  .selectedReasonRejection.value == null) {
                                                return; // User cancelled or didn't select reason - no change applied
                                              }
                                              // Update status with rejection reason
                                              await withdrawController.updateStatusWithdraw(
                                                withdraw.id!,
                                                newStatus,
                                                withdrawController
                                                    .selectedReasonRejection.value!.id!,
                                              );
                                              withdrawController.getWithdrawListPager();
                                            }
                                          } else {
                                            // Acceptance flow: direct update
                                            await withdrawController.updateStatusWithdraw(
                                              withdraw.id!,
                                              newStatus,
                                              0,
                                            );
                                            withdrawController.getWithdrawListPager();
                                          }
                                        },
                                        thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
                                          if (states.contains(WidgetState.disabled) ||
                                              withdraw.status == 0) {
                                            return AppColor.dividerColor;
                                          }
                                          return withdraw.status == 1
                                              ? AppColor.successColor
                                              : AppColor.accentColor;
                                        }),
                                        trackColor: WidgetStateProperty.resolveWith<Color>((states) {
                                          if (states.contains(WidgetState.disabled) ||
                                              withdraw.status == 0) {
                                            return AppColor.dividerColor.withAlpha(100);
                                          }
                                          return withdraw.status == 1
                                              ? AppColor.successColor.withAlpha(100)
                                              : AppColor.accentColor.withAlpha(100);
                                        }),
                                      ),
                                    ),
                                  ),
                                  //SizedBox(height: 3,),
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
                          // Images
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                      color: AppColor.textColor, width: 0.3),
                                ),
                              ),
                              child: Center(
                                child: GestureDetector(
                                  onTap: () async {
                                    await withdrawController.getImage(
                                        withdraw.recId ?? "",
                                        "WithdrawRequest");
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
                                                          controller: withdrawController
                                                              .pageController,
                                                          itemCount: withdrawController
                                                              .imageList.length,
                                                          onPageChanged: (
                                                              index) =>
                                                          withdrawController
                                                              .currentImagePage
                                                              .value =
                                                              index,
                                                          itemBuilder: (context,
                                                              index) {
                                                            final attachment = withdrawController
                                                                .imageList[index];
                                                            return Column(
                                                              children: [
                                                                if (kIsWeb)
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
                                                                              withdrawController
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
                                                                  child: Image
                                                                      .network(
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
                                                                visible: withdrawController
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
                                                                    withdrawController
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
                                                                visible: withdrawController
                                                                    .currentImagePage
                                                                    .value <
                                                                    (withdrawController
                                                                        .imageList
                                                                        .length ??
                                                                        1) - 1,
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
                                                                    withdrawController
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
                                                                withdrawController
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
                                                                        color: withdrawController
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
                                      SvgPicture.asset(
                                          'assets/svg/picture.svg', height: 20,
                                          colorFilter: ColorFilter.mode(
                                            AppColor.textColor,
                                            BlendMode.srcIn,
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Actions
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                      color: AppColor.textColor, width: 0.3),
                                ),
                              ),
                              child: withdraw.status == 0 ?
                              // Delete button for pending status
                              Row(mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (withdraw.depositRequestCount != 0 ||
                                          withdraw.depositCount != 0) {
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
                                                  withdrawController
                                                      .deleteWithdraw(
                                                      withdraw.id!, true);
                                                },
                                                child: Text(
                                                  'حذف',
                                                  style: AppTextStyle
                                                      .bodyText,
                                                )));
                                      }
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween,
                                      children: [
                                        SvgPicture.asset(
                                            'assets/svg/trash-bin.svg',
                                            width: 22, height: 22,
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
                                                  .accentColor, fontSize: 12),),
                                      ],
                                    ),
                                  ),
                                ],
                              ) :
                              // Full actions for confirmed/rejected status
                              Column(
                                children: [
                                  // Split and delete buttons
                                  Row(mainAxisAlignment: MainAxisAlignment
                                      .spaceAround,
                                    children: [
                                      // Split button
                                      GestureDetector(
                                        onTap: () {
                                          if (withdraw.undividedAmount == 0) {
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
                                            withdrawController.balanceList
                                                .clear();
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
                                                return InsertDepositRequestWidget(
                                                  id: withdraw.id!,
                                                  walletId: withdraw
                                                      .wallet!
                                                      .id!,
                                                  unDividedAmount: withdraw
                                                      .undividedAmount,);
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
                                        child: SvgPicture.asset(
                                            'assets/svg/add.svg', width: 22,
                                            height: 22,
                                            colorFilter: ColorFilter
                                                .mode(AppColor
                                                .buttonColor,
                                              BlendMode
                                                  .srcIn,)
                                        ),
                                        /*Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                          ),*/
                                      ),
                                      // Delete button
                                      GestureDetector(
                                        onTap: () {
                                          if (withdraw.depositRequestCount !=
                                              0 || withdraw.depositCount != 0) {
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
                                                      withdrawController
                                                          .deleteWithdraw(
                                                          withdraw.id!, true);
                                                    },
                                                    child: Text(
                                                      'حذف',
                                                      style: AppTextStyle
                                                          .bodyText,
                                                    )));
                                          }
                                        },
                                        child:
                                        SvgPicture.asset(
                                            'assets/svg/trash-bin.svg',
                                            width: 22, height: 22,
                                            colorFilter: ColorFilter
                                                .mode(AppColor
                                                .accentColor,
                                              BlendMode
                                                  .srcIn,)
                                        ),
                                        /*Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                          ),*/
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10,),
                                  // View and edit buttons
                                  Row(mainAxisAlignment: MainAxisAlignment
                                      .spaceAround,
                                    children: [
                                      // View button
                                      GestureDetector(
                                        onTap: () {
                                          Get.toNamed('/withdrawGetOne',
                                              parameters: {
                                                "id": withdraw.id.toString()
                                              });
                                        },
                                        child:
                                        SvgPicture.asset(
                                            'assets/svg/eye1.svg', width: 22,
                                            height: 22,
                                            colorFilter: ColorFilter
                                                .mode(AppColor
                                                .iconViewColor,
                                              BlendMode
                                                  .srcIn,)
                                        ),
                                        /*Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                          ),*/
                                      ),
                                      // Edit button
                                      GestureDetector(
                                        onTap: () {
                                          Get.toNamed('/withdrawUpdate',
                                              parameters: {
                                                "id": withdraw.id.toString()
                                              });
                                        },
                                        child:
                                        SvgPicture.asset(
                                            'assets/svg/edit.svg', width: 22,
                                            height: 22,
                                            colorFilter: ColorFilter
                                                .mode(AppColor
                                                .iconViewColor,
                                              BlendMode
                                                  .srcIn,)
                                        ),
                                        /*Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                          ),*/
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Expanded content (deposit requests)
                    if (isExpanded)
                      Container(
                        width: double.infinity,
                        color: AppColor.backGroundColor1,
                        child: buildDepositRequestsTableForDesktop(withdraw),
                      ),
                  ],
                ),
              );
            }

            return rows;
          }).toList(),
        ],
      ),
    );
  }

  Widget buildDepositRequestsTableForDesktop(WithdrawModel withdraw) {
    return Obx(() {
      if (withdrawController.isLoadingDepositRequestList.value) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Center(child: CircularProgressIndicator()),
        );
      }

      if (withdrawController.depositRequestList.isEmpty) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  'هیچ شخصی جهت واریز مشخص نشده است',
                  style: AppTextStyle.smallTitleText
              ),
              SizedBox(width: 125,),
            ],
          ),
        );
      }

      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16,vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...withdrawController.depositRequestList.map((depositRequest) {
              return Card(
                shadowColor: AppColor.textColor,
                elevation: 2,
                margin: EdgeInsets.only(bottom: 4,top: 2),
                color: AppColor.secondary100Color,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 0),
                  child: Row(
                    children: [
                      // Status badge
                       /*Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          color: depositRequest.status == 2
                              ? AppColor.accentColor
                              : depositRequest.status == 1
                              ? AppColor.primaryColor
                              : AppColor.secondaryColor,
                          margin: EdgeInsets.symmetric(
                              vertical: 0, horizontal: 5),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                                depositRequest.status == 2
                                    ? 'تایید نشده'
                                    : depositRequest.status == 1
                                    ? 'تایید شده'
                                    : 'در انتظار',
                                style: AppTextStyle.labelText,
                                textAlign: TextAlign.center
                            ),
                          ),
                        ),*/
                      //SizedBox(width: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment
                            .end,
                        children: [
                          Text('تلگرام: ',
                            style: AppTextStyle
                                .labelText,),
                          depositRequest.isSendTelegram == true ?
                          Icon(Icons.check,
                            color: AppColor
                                .primaryColor,
                            size: 20,) :
                          Icon(Icons.close,
                            color: AppColor
                                .accentColor,
                            size: 20,)
                        ],
                      ),
                      SizedBox(width: 8,),
                      // ارسال تلگرام
                      GestureDetector(
                        onTap: () {
                          depositRequest.isSendTelegram == true ?
                          Get.defaultDialog(
                              backgroundColor: AppColor.backGroundColor,
                              title: "ارسال مجدد",
                              titleStyle: AppTextStyle.smallTitleText.copyWith(color: AppColor.errorColor),
                              middleText: "آیا از ارسال مجدد درخواست واریزی مطمئن هستید؟",
                              middleTextStyle: AppTextStyle.bodyText,
                              confirm: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor: WidgetStatePropertyAll(
                                          AppColor.primaryColor)),
                                  onPressed: () {
                                    Get.back();
                                    withdrawController.sendTelegramDepositRequest(depositRequest.id ?? 0,withdraw.id ?? 0);
                                  },
                                  child: Text(
                                    'ارسال مجدد',
                                    style: AppTextStyle.bodyText,
                                  ))
                          ) :
                          Get.defaultDialog(
                              backgroundColor: AppColor.backGroundColor,
                              title: "ارسال به تلگرام",
                              titleStyle: AppTextStyle.smallTitleText.copyWith(color: Color(0xff0ab6f0)),
                              middleText: "آیا از ارسال درخواست واریزی مطمئن هستید؟",
                              middleTextStyle: AppTextStyle.bodyText,
                              confirm: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor: WidgetStatePropertyAll(
                                          AppColor.primaryColor)),
                                  onPressed: () {
                                    Get.back();
                                    withdrawController.sendTelegramDepositRequest(depositRequest.id ?? 0,withdraw.id ?? 0);
                                  },
                                  child: Text(
                                    'ارسال',
                                    style: AppTextStyle.bodyText,
                                  ))
                          );
                        },
                        child: Tooltip(
                          message: depositRequest.isSendTelegram == true ?  "ارسال مجدد درخواست واریزی به تلگرام" : "ارسال درخواست واریزی به تلگرام",
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(' ارسال',style: AppTextStyle.labelText.copyWith(color: depositRequest.isSendTelegram == true ? AppColor.successColor : Color(0xff0ab6f0), fontSize: 11,fontWeight: FontWeight.w400),),
                              SvgPicture.asset(
                                'assets/svg/telegram.svg',height: 20,
                                colorFilter: ColorFilter.mode(depositRequest.isSendTelegram == true ? AppColor.successColor : Color(0xff0ab6f0), BlendMode.srcIn) ,
                              ),
                            ],
                          ),
                        ),
                      ),
                      // User name
                      Expanded(
                        flex: 1,
                        child: Text(
                          depositRequest.account!.name ?? "",
                          style: AppTextStyle.bodyText,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(width: 8),

                      // Amount details in a compact column
                      Expanded(
                        flex: 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              children: [
                                Text('کل: ',
                                    style: AppTextStyle.bodyText.copyWith(
                                        fontSize: 12)),
                                Text(
                                  "${depositRequest.amount
                                      ?.toInt()
                                      .toString()
                                      .seRagham(separator: ',')} ریال",
                                  style: AppTextStyle.bodyText.copyWith(
                                      fontSize: 12),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text('مانده: ',
                                    style: AppTextStyle.bodyText.copyWith(
                                        fontSize: 12)),
                                Text(
                                  "${depositRequest.notPaidAmount
                                      ?.toInt()
                                      .toString()
                                      .seRagham(separator: ',')} ریال",
                                  style: AppTextStyle.bodyText.copyWith(
                                      color: AppColor.accentColor,
                                      fontSize: 13,fontWeight: FontWeight.w800),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text('واریز: ',
                                    style: AppTextStyle.bodyText.copyWith(
                                        fontSize: 12)),
                                Text(
                                  "${depositRequest.paidAmount
                                      ?.toInt()
                                      .toString()
                                      .seRagham(separator: ',')} ریال",
                                  style: AppTextStyle.bodyText.copyWith(
                                      color: AppColor.primaryColor,
                                      fontSize: 12,fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 8),

                      // Status Switch
                      withdraw.isReferencedByAnother == true
                          ? SizedBox.shrink()
                          :
                      Expanded(
                        flex: 1,
                        child: Container(
                          /*child: PopupMenuButton<int>(
                            splashRadius: 10,
                            tooltip: 'تعیین وضعیت',
                            onSelected: (value) async {
                              if (value == 2) {
                                if (depositRequest.depositCount != 0) {
                                  Get.defaultDialog(
                                    title: 'هشدار',
                                    middleText: 'به دلیل داشتن زیر مجموعه قابل رد نیست',
                                    titleStyle: AppTextStyle.smallTitleText,
                                    middleTextStyle: AppTextStyle.bodyText,
                                    backgroundColor: AppColor.backGroundColor,
                                    textCancel: 'بستن',
                                  );
                                } else {
                                  await withdrawController
                                      .showReasonRejectionDialog(
                                      "DepositRequest");
                                  if (withdrawController.selectedReasonRejection
                                      .value == null) {
                                    return;
                                  }
                                  await withdrawController
                                      .updateStatusDepositRequest(
                                    depositRequest.id!,
                                    value,
                                    withdrawController.selectedReasonRejection
                                        .value!.id!,
                                  );
                                  withdrawController.fetchDepositRequestList(
                                      withdraw.id!);
                                }
                              } else {
                                await withdrawController
                                    .updateStatusDepositRequest(
                                    depositRequest.id!,
                                    value,
                                    0
                                );
                                withdrawController.fetchDepositRequestList(
                                    withdraw.id!);
                              }
                            },
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(10.0)),
                            ),
                            color: AppColor.backGroundColor,
                            constraints: BoxConstraints(
                                minWidth: 70, maxWidth: 70),
                            position: PopupMenuPosition.under,
                            offset: const Offset(0, 0),
                            itemBuilder: (context) =>
                            [
                              PopupMenuItem<int>(
                                height: 18,
                                labelTextStyle: WidgetStateProperty.all(
                                    AppTextStyle.madiumbodyText),
                                value: 1,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    withdrawController.isLoading.value
                                        ? CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          AppColor.textColor),
                                    )
                                        : Text(
                                      'تایید',
                                      style: AppTextStyle.madiumbodyText
                                          .copyWith(
                                          color: AppColor.primaryColor,
                                          fontSize: 14
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const PopupMenuDivider(),
                              PopupMenuItem<int>(
                                height: 18,
                                value: 2,
                                labelTextStyle: WidgetStateProperty.all(
                                    AppTextStyle.madiumbodyText),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    withdrawController.isLoading.value
                                        ? CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          AppColor.textColor),
                                    )
                                        : Text(
                                      'رد',
                                      style: AppTextStyle.madiumbodyText
                                          .copyWith(
                                          color: AppColor.accentColor,
                                          fontSize: 14
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            child: Text(
                              'تعیین وضعیت',
                              style: AppTextStyle.bodyText.copyWith(
                                  color: AppColor.dividerColor,
                                  decoration: TextDecoration.underline,
                                  decorationColor: AppColor.textColor,
                                  fontSize: 12
                              ),
                            ),
                          ),*/
                          child: Center(
                            child: Column(
                              children: [
                                Transform.scale(
                                  scale: 0.70,
                                  child: Switch(
                                    value: depositRequest.status == 1,
                                    onChanged: depositRequest.status == 0
                                        ? null // Disable switch for pending status
                                        : (value) async {
                                      // پذیرش = 1، عدم پذیرش = 2
                                      final newStatus = value ? 1 : 2;

                                      if (newStatus == 2) {
                                        // Rejection flow: check for sub-items first
                                        if (depositRequest.depositCount != 0) {
                                          Get.defaultDialog(
                                            title: 'هشدار',
                                            middleText: 'به دلیل داشتن زیر مجموعه قابل رد نیست',
                                            titleStyle: AppTextStyle.smallTitleText,
                                            middleTextStyle: AppTextStyle.bodyText,
                                            backgroundColor: AppColor.backGroundColor,
                                            textCancel: 'بستن',
                                          );
                                          return; // Don't change switch state
                                        } else {
                                          // Reset rejection reason before showing dialog
                                          withdrawController.selectedReasonRejection.value = null;
                                          // Show rejection reason dialog
                                          await withdrawController
                                              .showReasonRejectionDialog("DepositRequest");
                                          // اگر کاربر دلیل رد را انتخاب نکرد، تغییر اعمال نشود
                                          if (withdrawController.selectedReasonRejection.value == null) {
                                            return; // User cancelled or didn't select reason - no change applied
                                          }
                                          // Update status with rejection reason
                                          await withdrawController.updateStatusDepositRequest(
                                            depositRequest.id!,
                                            newStatus,
                                            withdrawController.selectedReasonRejection.value!.id!,
                                          );
                                          withdrawController.fetchDepositRequestList(withdraw.id!);
                                        }
                                      } else {
                                        // Acceptance flow: direct update
                                        await withdrawController.updateStatusDepositRequest(
                                          depositRequest.id!,
                                          newStatus,
                                          0,
                                        );
                                        withdrawController.fetchDepositRequestList(withdraw.id!);
                                      }
                                    },
                                    thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
                                      if (states.contains(WidgetState.disabled) ||
                                          depositRequest.status == 0) {
                                        return AppColor.dividerColor;
                                      }
                                      return depositRequest.status == 1
                                          ? AppColor.successColor
                                          : AppColor.accentColor;
                                    }),
                                    trackColor: WidgetStateProperty.resolveWith<Color>((states) {
                                      if (states.contains(WidgetState.disabled) ||
                                          depositRequest.status == 0) {
                                        return AppColor.dividerColor.withAlpha(100);
                                      }
                                      return depositRequest.status == 1
                                          ? AppColor.successColor.withAlpha(100)
                                          : AppColor.accentColor.withAlpha(100);
                                    }),
                                  ),
                                ),
                                if (depositRequest.status == 2) ...[
                                  Row(mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('دلیل رد: ',
                                          style: AppTextStyle.labelText.copyWith(
                                              fontSize: 12)),
                                      Text(
                                        "${depositRequest.reasonRejection
                                            ?.name}" ?? "",
                                        style: AppTextStyle.bodyText.copyWith(
                                            fontSize: 12,color: AppColor.dividerColor),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      // Action buttons
                      Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Add button
                            withdraw.isReferencedByAnother == true ? SizedBox
                                .shrink() :
                            Container(
                              width: 25,
                              height: 25,
                              child: GestureDetector(
                                onTap: () {
                                  if (depositRequest.paidAmount! <
                                      depositRequest.amount!) {
                                    Get.toNamed('/depositCreate',
                                        arguments: depositRequest);
                                  } else {
                                    Get.defaultDialog(
                                      title: 'هشدار',
                                      middleText: 'مبلغ باقیمانده برای واریزی صفر است.',
                                      titleStyle: AppTextStyle.smallTitleText,
                                      middleTextStyle: AppTextStyle.bodyText,
                                      backgroundColor: AppColor.backGroundColor,
                                      textCancel: 'بستن',
                                    );
                                  }
                                },
                                child: SvgPicture.asset(
                                    'assets/svg/add.svg',
                                    colorFilter: ColorFilter.mode(
                                      AppColor.buttonColor,
                                      BlendMode.srcIn,
                                    )
                                ),
                              ),
                            ),
                            // Delete button
                            Container(
                              width: 25,
                              height: 25,
                              child: GestureDetector(
                                onTap: () {
                                  if (depositRequest.depositCount != 0) {
                                    Get.defaultDialog(
                                      title: 'هشدار',
                                      middleText: 'به دلیل داشتن زیر مجموعه قابل حذف نیست',
                                      titleStyle: AppTextStyle.smallTitleText,
                                      middleTextStyle: AppTextStyle.bodyText,
                                      backgroundColor: AppColor.backGroundColor,
                                      textCancel: 'بستن',
                                    );
                                  } else {
                                    Get.defaultDialog(
                                        backgroundColor: AppColor
                                            .backGroundColor,
                                        title: "حذف درخواست واریزی",
                                        titleStyle: AppTextStyle.smallTitleText,
                                        middleText: "آیا از حذف درخواست واریزی مطمئن هستید؟",
                                        middleTextStyle: AppTextStyle.bodyText,
                                        confirm: ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor: WidgetStatePropertyAll(
                                                  AppColor.primaryColor)
                                          ),
                                          onPressed: () {
                                            Get.back();
                                            withdrawController
                                                .deleteDepositRequest(
                                                withdraw.id!,
                                                depositRequest.id!, true);
                                          },
                                          child: Text('حذف',
                                              style: AppTextStyle.bodyText),
                                        )
                                    );
                                  }
                                },
                                child: SvgPicture.asset(
                                    'assets/svg/trash-bin.svg',
                                    colorFilter: ColorFilter.mode(
                                      AppColor.accentColor,
                                      BlendMode.srcIn,
                                    )
                                ),
                              ),
                            ),
                            // View button
                            Container(
                              width: 25,
                              height: 25,
                              child: GestureDetector(
                                onTap: () {
                                  Get.toNamed('/depositRequestGetOne',
                                      parameters: {
                                        "id": depositRequest.id.toString()
                                      });
                                },
                                child: SvgPicture.asset(
                                    'assets/svg/eye1.svg',
                                    colorFilter: ColorFilter.mode(
                                      AppColor.iconViewColor,
                                      BlendMode.srcIn,
                                    )
                                ),
                              ),
                            ),
                            // Edit button
                            Container(
                              width: 25,
                              height: 25,
                              child: GestureDetector(
                                onTap: () {
                                  withdrawController.setDepositRequestDetail(
                                      depositRequest);
                                  showModalBottomSheet(
                                    enableDrag: true,
                                    context: context,
                                    backgroundColor: AppColor.backGroundColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20)),
                                    ),
                                    builder: (context) {
                                      return UpdateDepositRequestWidget(
                                        withdrawId: withdraw.id!,
                                        depositRequest: depositRequest,
                                      );
                                    },
                                  ).whenComplete(() {
                                    withdrawController.clearList();
                                  });
                                },
                                child: SvgPicture.asset(
                                    'assets/svg/edit.svg',
                                    colorFilter: ColorFilter.mode(
                                      AppColor.iconViewColor,
                                      BlendMode.srcIn,
                                    )
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      );
    });
  }

  Map<String, List<WithdrawModel>> groupWithdrawsByDate(
      List<WithdrawModel> withdraws) {
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

