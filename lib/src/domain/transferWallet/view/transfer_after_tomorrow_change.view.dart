import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/const/app_color.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:hanigold_admin/src/domain/transferWallet/controller/transfer_after_tomorrow_change.controller.dart';
import 'package:hanigold_admin/src/utils/num_display.dart';
import 'package:hanigold_admin/src/widget/custom_appbar1.widget.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import '../../../widget/app_drawer.widget.dart';
import '../../../widget/empty.dart';
import '../../../widget/err_page.dart';
import '../../chat/widget/chat_dialog.widget.dart';

class TransferAfterTomorrowChangeView extends StatelessWidget {
  const TransferAfterTomorrowChangeView({super.key});

  @override
  Widget build(BuildContext context) {
    final TransferAfterTomorrowChangeController controller = Get.find<TransferAfterTomorrowChangeController>();
    final bool isMobile = Get.width < 600;

    return Scaffold(
      appBar: CustomAppbar1(
        title: 'تغییر تاریخ انتقال',
        onBackTap: () => Get.offNamed('/home'),
      ),
      drawer: const AppDrawer(),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bgHaniGold.png'),
            fit: BoxFit.contain,
            opacity: 0.06,
          ),
        ),
        child: Center(
          child: Container(
            width: isMobile ? Get.width * 0.95 : Get.width * 0.55,
            margin: EdgeInsets.symmetric(vertical: isMobile ? 10 : 15,horizontal: isMobile ? 10 : 15),
            padding: EdgeInsets.all(isMobile ? 12.0 : 24.0),
            decoration: BoxDecoration(
              color: AppColor.secondaryColor.withOpacity(0.8),
              borderRadius: BorderRadius.circular(16),
            ),
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(isMobile ? 10 : 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child:
                      TextFormField(
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty) {
                            return 'لطفا تاریخ را انتخاب کنید';
                          }
                          return null;
                        },
                        controller: controller
                            .dateController,
                        readOnly: true,
                        style: AppTextStyle.labelText,
                        decoration: InputDecoration(
                          suffixIcon: Icon(
                              Icons.calendar_month,
                              color: AppColor
                                  .textColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius
                                .circular(10),
                          ),
                          filled: true,
                          fillColor: AppColor
                              .textFieldColor,
                          errorMaxLines: 1,
                        ),
                        onTap: () async {
                          Jalali? pickedDate = await showPersianDatePicker(
                            context: context,
                            initialDate: Jalali.now(),
                            firstDate: Jalali(
                                1400, 1, 1),
                            lastDate: Jalali(
                                1450, 12, 29),
                            initialEntryMode: PersianDatePickerEntryMode
                                .calendar,
                            initialDatePickerMode: PersianDatePickerMode
                                .day,
                            locale: Locale(
                                "fa", "IR"),
                          );
                          DateTime date = DateTime
                              .now();

                          if (pickedDate != null) {
                            controller.dateController.text =
                            "${pickedDate
                                .year}/${pickedDate
                                .month.toString()
                                .padLeft(
                                2, '0')}/${pickedDate
                                .day.toString()
                                .padLeft(
                                2, '0')} ${date.hour
                                .toString().padLeft(
                                2, '0')}:${date.minute
                                .toString().padLeft(
                                2, '0')}:${date.second
                                .toString().padLeft(
                                2, '0')}";
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Obx(() {
                        final bool disabled = controller.isLoading.value;
                        return ElevatedButton(
                          onPressed: disabled
                              ? null
                              : () async {
                            await Get.defaultDialog(
                                backgroundColor: AppColor.backGroundColor,
                                title: "انتقال",
                                titleStyle: AppTextStyle.smallTitleText,
                                middleText: "آیا از انتقال مطمئن هستید؟",
                                middleTextStyle: AppTextStyle.bodyText,
                                confirm: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor: WidgetStatePropertyAll(
                                            AppColor.primaryColor)),
                                    onPressed: () {
                                      Get.back();
                                      controller.submitTransfer();
                                    },
                                    child: Text(
                                      'انتقال',
                                      style: AppTextStyle.bodyText,
                                    ))
                            );
                          },
                          style: ButtonStyle(
                            padding: WidgetStateProperty.all(
                              const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 15),
                            ),
                            elevation: WidgetStateProperty.all(5),
                            backgroundColor:
                            WidgetStateProperty.all(AppColor.primaryColor),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          child: Text(
                            'انتقال',
                            style: AppTextStyle.bodyText,
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 20),
                    // لیست سفارش‌های انتقال داده نشده
                    Obx(() {
                      final pageState = controller.state.value;

                      if (pageState == PageState.loading) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      if (pageState == PageState.err) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Center(
                            child: ErrPage(
                              callback: () {
                                controller.getAfterNotChange();
                              },
                              title: "خطا در دریافت لیست سفارش ها",
                              des: 'برای دریافت لیست سفارش ها مجددا تلاش کنید',
                            ),
                          ),
                        );
                      }

                      if (pageState == PageState.empty) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Center(
                            child: EmptyPage(
                              tryText: "سفارشی برای نمایش وجود ندارد.",
                              callback: (){
                                controller.getAfterNotChange();
                              },
                            )
                          ),
                        );
                      }

                      // حالت نمایش لیست
                      final orders = controller.orderAfterNotChangeList;
                      if (orders.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'سفارش‌های انتقال داده نشده',
                              style: AppTextStyle.smallTitleText,
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              height: Get.height,
                              child: ListView.separated(
                                shrinkWrap: true,
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemCount: orders.length,
                                separatorBuilder: (_, __) =>
                                const SizedBox(height: 8),
                                itemBuilder: (context, index) {
                                  final order = orders[index];
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 2),
                                    padding: const EdgeInsets.only(top: 5,right: 10,left: 10,bottom: 5),
                                    decoration: BoxDecoration(
                                      color: AppColor.secondary50Color.withAlpha(150),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: const Color(
                                          0xFF91D9A5)),
                                      boxShadow: [
                                      BoxShadow(
                                      color: Colors.black54,
                                      blurRadius: 10,
                                      offset: const Offset(0,3),
                                      ),
                                      ],
                                    ),
                                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    '${order.account?.name}',
                                                    style: AppTextStyle.bodyText.copyWith(fontSize: 13,fontWeight: FontWeight.w600, color: AppColor.textErrorColor),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    '${order.date?.toPersianDate(showTime: false)}',
                                                    style: AppTextStyle.bodyText.copyWith(fontSize: 12 , fontWeight: FontWeight.w700, color: AppColor.textErrorColor ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                        SizedBox(height: 3,),
                                        Divider(color: AppColor.secondary2Color.withAlpha(100), height: 5,),
                                        Container(
                                            margin: const EdgeInsets.symmetric(vertical: 4),
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              color:AppColor.primaryColor.withAlpha(10),
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(color: const Color(0xFF64748B)),
                                            ),
                                            child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    '${order.item?.name}',
                                                    style: AppTextStyle.bodyText.copyWith(fontSize: 13,fontWeight: FontWeight.w600, color: AppColor.primaryColor),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Row(
                                                    children: [
                                                      Text("مقدار: ",style: AppTextStyle.labelText.copyWith(fontSize: 10,fontWeight: FontWeight.w400,),),
                                                      Text(
                                                        '${order.quantity?.toDisplayString().seRagham()} ${order.item?.itemUnit?.name}',
                                                        style: AppTextStyle.bodyText.copyWith(fontSize: 13,fontWeight: FontWeight.w700, color: AppColor.errorColor),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(),
                                              ],
                                            ),
                                          ),
                                        Container(
                                          margin: const EdgeInsets.symmetric(vertical: 4),
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            color:AppColor.primaryColor.withAlpha(10),
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(color: const Color(0xFF64748B)),
                                          ),
                                          child: Row(mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                'مبلغ کل: ${order.totalPrice?.toStringAsFixed(0).seRagham()}',
                                                style: AppTextStyle.bodyText.copyWith(fontSize: 13,fontWeight: FontWeight.w600, color: AppColor.dividerColor),
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
                    }),
                  ],
                ),
              ),
            ),
          ),
        ),
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
    );
  }
}


