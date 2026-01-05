import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/inventory/controller/inventory_create_payment.controller.dart';
import 'package:hanigold_admin/src/domain/inventory/model/inventory_detail.model.dart';
import 'package:hanigold_admin/src/domain/laboratory/model/laboratory.model.dart';
import 'package:hanigold_admin/src/widget/pager_widget1.dart';
import 'package:image_picker/image_picker.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../config/repository/url/base_url.dart';
import '../../../widget/custom_dropdown.widget.dart';
import '../../../widget/custom_dropdown1.widget.dart';
import '../../../widget/pager_widget.dart';
import '../../account/model/account.model.dart';
import '../../wallet/model/wallet.model.dart';
import '../controller/inventory_create_receive.controller.dart';
import 'item_temp_detail_payment.widget.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

typedef SelectCallBack = Function(int id);

class InventoryCreatePaymentTabWidget extends StatefulWidget {
  final SelectCallBack callBack;

  InventoryCreatePaymentTabWidget({
    super.key, required this.callBack,

  });

  @override
  State<InventoryCreatePaymentTabWidget> createState() =>
      _InventoryCreatePaymentTabWidgetState();
}

class _InventoryCreatePaymentTabWidgetState
    extends State<InventoryCreatePaymentTabWidget> {
  final formKey = GlobalKey<FormState>();
  InventoryCreatePaymentController inventoryCreatePaymentController = Get.find<
      InventoryCreatePaymentController>();

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 8 : isTablet ? 16 : 40,
            vertical: isMobile ? 12 : isTablet ? 20 : 30
        ),

        child: Obx(() {
          return Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8,),
                // کاربر
                inventoryCreatePaymentController.accountList.isEmpty ?
                SizedBox.shrink():
                Container(
                  padding: EdgeInsets.only(
                      bottom: 3, top: 5),
                  child: Text(
                    'کاربر',
                    style: AppTextStyle.labelText,
                  ),
                ),
                // کاربر
                inventoryCreatePaymentController.accountList.isEmpty ?
                Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        AppColor.textColor),
                  ),
                ) :
                Container(
                  padding: EdgeInsets.only(
                      bottom: 5),
                  child: CustomDropdown<AccountModel>(
                    isOpen:inventoryCreatePaymentController.tempDetails.isNotEmpty ? true :false ,
                    items: inventoryCreatePaymentController.accountList,
                    selectedItem: inventoryCreatePaymentController.selectedAccount.value,
                    enableSearch: true,
                    errorText: inventoryCreatePaymentController.dropdownError.value,
                    itemLabel: (account) =>
                    account.name ??
                        "",
                    /*itemIcon: (bank) =>
                      bank.icon ??
                          "",*/
                    onChanged: (account) {
                      setState(() {
                        inventoryCreatePaymentController.selectedAccount.value = account;
                        inventoryCreatePaymentController.dropdownError.value = "";
                        //inventoryCreateReceiveController.getWalletAccount(account?.id ?? 0);
                        inventoryCreatePaymentController.tempDetails.isNotEmpty
                            ? null
                            :
                        inventoryCreatePaymentController.changeSelectedAccount(
                            account);
                        inventoryCreatePaymentController.tempDetails.isNotEmpty
                            ? null
                            :
                        widget.callBack(account?.id ?? 0);
                      });
                      debugPrint(
                        "کاربر انتخاب شد: ${account?.name}",
                      );
                    },
                    isIcon: false,
                  ),
                ),
                // Show warning when dropdown is disabled
                Obx(() => inventoryCreatePaymentController.tempDetails.isNotEmpty
                    ? Container(
                  child: Text(
                    '⚠️ ابتدا آیتم‌های موقت را پاک کنید تا بتوانید کاربر را تغییر دهید',
                    style: AppTextStyle.labelText.copyWith(
                      color: Colors.orange,
                      fontSize: 12,
                    ),
                  ),
                )
                    : SizedBox.shrink()),
                // ولت اکانت
                inventoryCreatePaymentController.walletAccountList.isEmpty ?
                SizedBox.shrink() :
                Container(
                  padding: EdgeInsets.only(bottom: 3, top: 5),
                  child: Text(
                    'حساب wallet',
                    style: AppTextStyle.labelText,
                  ),
                ),
                // ولت اکانت
                inventoryCreatePaymentController.walletAccountList.isEmpty ?
                SizedBox.shrink() :
                Container(
                  padding: EdgeInsets.only(
                      bottom: 5),
                  child: CustomDropdown<WalletModel>(
                    isOpen:inventoryCreatePaymentController.tempDetails.isNotEmpty ? true :false ,
                    items: inventoryCreatePaymentController.walletAccountList,
                    selectedItem: inventoryCreatePaymentController.selectedWalletAccount.value,
                    enableSearch: true,
                    errorText: inventoryCreatePaymentController.dropdownError.value,
                    itemLabel: (walletAccount) =>
                    walletAccount.item?.name ??
                        "",
                    /*itemIcon: (bank) =>
                      bank.icon ??
                          "",*/
                    onChanged: (walletAccount) {
                      setState(() {
                        inventoryCreatePaymentController.selectedWalletAccount.value = walletAccount;
                        inventoryCreatePaymentController.dropdownError.value = "";
                        inventoryCreatePaymentController.tempDetails.isNotEmpty
                            ? null
                            :
                        inventoryCreatePaymentController.changeSelectedWalletAccount(
                            walletAccount);
                      });
                      debugPrint(
                        "حساب ولت انتخاب شد: ${walletAccount?.item?.name}",
                      );
                    },
                    isIcon: false,
                  ),
                ),
                // Show warning when dropdown is disabled
                Obx(() => inventoryCreatePaymentController.tempDetails.isNotEmpty
                    ? Container(
                  child: Text(
                    '⚠️ ابتدا آیتم‌های موقت را پاک کنید تا بتوانید حساب wallet را تغییر دهید',
                    style: AppTextStyle.labelText.copyWith(
                      color: Colors.orange,
                      fontSize: 12,
                    ),
                  ),
                )
                    : SizedBox.shrink()),
                // لیست دریافتی ها
                inventoryCreatePaymentController.selectedWalletAccount.value
                    ?.item?.id == 1 ?
                ElevatedButton(
                  style: ButtonStyle(fixedSize: WidgetStatePropertyAll(Size(
                      isDesktop ? Get.width * 0.10 : Get.width * 0.3,
                      isDesktop ? 40 : 30
                  ),
                  ),
                      padding: WidgetStatePropertyAll(
                        EdgeInsets.symmetric(
                            horizontal: isDesktop ? 12 : 5
                        ),),
                      elevation: WidgetStatePropertyAll(5),
                      backgroundColor:
                      WidgetStatePropertyAll(AppColor.buttonColor),
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)))),
                  onPressed: () async {
                    showForPaymentModal();
                    print('idIttttem ${inventoryCreatePaymentController
                        .selectedWalletAccount.value?.item?.id}');
                  },
                  child: inventoryCreatePaymentController.isLoading.value
                      ?
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        AppColor.textColor),
                  ) :
                  Text(
                    'لیست دریافتی ها',
                    style: AppTextStyle.bodyText,
                  ),
                )
                    : SizedBox.shrink(),
                // مقدار
                inventoryCreatePaymentController.selectedWalletAccount.value
                    ?.item?.id != 1 ?
                Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(bottom: 3, top: 5),
                      child: Text(
                        'مقدار',
                        style: AppTextStyle.labelText,
                      ),
                    ),
                    // مقدار
                    Container(
                      //height: 50,
                      padding: EdgeInsets.only(bottom: 5),
                      child:
                      IntrinsicHeight(
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: inventoryCreatePaymentController
                              .quantityController,
                          style: AppTextStyle.labelText,
                          keyboardType: TextInputType.numberWithOptions(
                              decimal: true),
                          inputFormatters: [FilteringTextInputFormatter.allow(
                              RegExp(r'^[\d٠-٩۰-۹]*\.?[\d٠-٩۰-۹]*$')),
                            TextInputFormatter.withFunction((oldValue,
                                newValue) {
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

                              return newValue.copyWith(text: newText,
                                  selection: TextSelection.collapsed(
                                      offset: newText.length));
                            }),
                          ],
                          decoration: InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: AppColor.textFieldColor,
                            errorMaxLines: 1,
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty) {
                              return 'لطفا مقدار را وارد کنید';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            inventoryCreatePaymentController.viewCountItem();
                          },
                        ),
                      ),
                    ),
                  ],
                ) : SizedBox.shrink(),
                // تعداد
                SizedBox(height: 3),
                inventoryCreatePaymentController.selectedWalletAccount.value?.item?.id == 10 ||
                    inventoryCreatePaymentController.selectedWalletAccount.value?.item?.id == 13 ||
                    inventoryCreatePaymentController.selectedWalletAccount.value?.item?.id == 15 ||
                    inventoryCreatePaymentController.selectedWalletAccount.value?.item?.id == 16
                    ?
                Row(
                  children: [
                    Text(
                      ' تعداد: ',
                      style: AppTextStyle
                          .labelText.copyWith(color: AppColor.textColor.withAlpha(130)),),
                    Text(inventoryCreatePaymentController.itemCountTemp.value,
                      style: AppTextStyle.bodyText
                          .copyWith(color: AppColor
                          .primaryColor.withAlpha(200)),)
                  ],
                ) :
                SizedBox(),
                inventoryCreatePaymentController.selectedWalletAccount.value?.item?.id==10 ||
                    inventoryCreatePaymentController.selectedWalletAccount.value?.item?.id==12 ||
                    inventoryCreatePaymentController.selectedWalletAccount.value?.item?.id==15 ||
                    inventoryCreatePaymentController.selectedWalletAccount.value?.item?.id==16 ||
                    inventoryCreatePaymentController.selectedWalletAccount.value?.item?.id==14 ?
                // عیار
                Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(bottom: 3, top: 5),
                      child: Text(
                        'عیار',
                        style: AppTextStyle.labelText,
                      ),
                    ),
                    // عیار
                    Container(
                      //height: 50,
                      padding: EdgeInsets.only(bottom: 5),
                      child:
                      IntrinsicHeight(
                        child: TextFormField(
                          /*readOnly: inventoryCreatePaymentController.selectedWalletAccount.value?.item?.id==10 ||
                              inventoryCreatePaymentController.selectedWalletAccount.value?.item?.id==12 ||
                              inventoryCreatePaymentController.selectedWalletAccount.value?.item?.id==15 ||
                              inventoryCreatePaymentController.selectedWalletAccount.value?.item?.id==16 ? true :false ,*/
                          onChanged: (value) {
                            inventoryCreatePaymentController.updateW750();
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: inventoryCreatePaymentController.caratController,
                          style: AppTextStyle.labelText,
                          keyboardType: TextInputType.numberWithOptions(
                              decimal: true),
                          inputFormatters: [FilteringTextInputFormatter.allow(
                              RegExp(r'^[\d٠-٩۰-۹]*\.?[\d٠-٩۰-۹]*$')),
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

                              return newValue.copyWith(text: newText,
                                  selection: TextSelection.collapsed(
                                      offset: newText.length));
                            }),
                          ],
                          decoration: InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: AppColor.textFieldColor,
                            errorMaxLines: 1,
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty) {
                              return 'لطفا عیار را وارد کنید';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ],
                ):
                SizedBox.shrink(),

                inventoryCreatePaymentController.selectedWalletAccount.value?.item?.id==10 ||
                    inventoryCreatePaymentController.selectedWalletAccount.value?.item?.id==12 ||
                    inventoryCreatePaymentController.selectedWalletAccount.value?.item?.id==15 ||
                    inventoryCreatePaymentController.selectedWalletAccount.value?.item?.id==16 ||
                    inventoryCreatePaymentController.selectedWalletAccount.value?.item?.id==14 ?
                // وزن 750
                Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(bottom: 3, top: 5),
                      child: Text(
                        'وزن 750',
                        style: AppTextStyle.labelText,
                      ),
                    ),
                    // وزن 750
                    Container(
                      //height: 50,
                      padding: EdgeInsets.only(bottom: 5),
                      child:
                      IntrinsicHeight(
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: inventoryCreatePaymentController.weight750Controller,
                          style: AppTextStyle.labelText,
                          keyboardType: TextInputType.numberWithOptions(
                              decimal: true),
                          inputFormatters: [FilteringTextInputFormatter.allow(
                              RegExp(r'^[\d٠-٩۰-۹]*\.?[\d٠-٩۰-۹]*$')),
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

                              return newValue.copyWith(text: newText,
                                  selection: TextSelection.collapsed(
                                      offset: newText.length));
                            }),
                          ],
                          decoration: InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: AppColor.textFieldColor,
                            errorMaxLines: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ):
                SizedBox.shrink(),
                // نام تحویل گیرنده
                Container(
                  padding: EdgeInsets.only(
                      bottom: 3, top: 5),
                  child: Text(
                    'نام تحویل گیرنده',
                    style: AppTextStyle.labelText
                        .copyWith(
                        fontSize: isDesktop
                            ? 12
                            : 10),
                  ),
                ),
                // نام تحویل گیرنده
                Container(
                  //height: 40,
                  padding: EdgeInsets.only(
                      bottom: 5),
                  child:
                  IntrinsicHeight(
                    child: TextFormField(
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty) {
                          return 'لطفا نام صاحب حساب را وارد کنید';
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: inventoryCreatePaymentController.recipientNameController,
                      style: AppTextStyle.bodyText,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius
                              .circular(10),
                        ),
                        filled: true,
                        fillColor: AppColor
                            .textFieldColor,
                      ),
                    ),
                  ),
                ),
                // تاریخ
                Container(
                  padding: EdgeInsets.only(bottom: 3, top: 5),
                  child: Text(
                    'تاریخ سفارش',
                    style: AppTextStyle.labelText,
                  ),
                ),
                // تاریخ
                Container(
                  //height: 50,
                  padding: EdgeInsets.only(bottom: 5),
                  child: IntrinsicHeight(
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'لطفا تاریخ را انتخاب کنید';
                        }
                        return null;
                      },
                      controller: inventoryCreatePaymentController
                          .dateController,
                      readOnly: true,
                      style: AppTextStyle.labelText,
                      decoration: InputDecoration(
                        suffixIcon: Icon(
                            Icons.calendar_month, color: AppColor.textColor),
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
                        DateTime date = DateTime.now();
                        if (pickedDate != null) {
                          inventoryCreatePaymentController.dateController.text =
                          "${pickedDate.year}/${pickedDate.month.toString()
                              .padLeft(2, '0')}/${pickedDate.day.toString()
                              .padLeft(2, '0')} ${date.hour.toString().padLeft(
                              2, '0')}:${date.minute.toString().padLeft(
                              2, '0')}:${date.second.toString().padLeft(
                              2, '0')}";
                        }
                      },
                    ),
                  ),
                ),
                // verification code
                SizedBox(height: 5,),

                (() {
                  if (inventoryCreatePaymentController.verificationChecked.value == false) {
                    if (!inventoryCreatePaymentController.isVerification.value) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: inventoryCreatePaymentController.isTimerActive.value
                                  ? Colors.grey
                                  : AppColor.primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: inventoryCreatePaymentController.isTimerActive.value
                                ? null
                                : () {
                              print('sendAccountIdddd:::::::${inventoryCreatePaymentController.selectedAccount.value?.id}');
                              inventoryCreatePaymentController.sendVerificationCode(inventoryCreatePaymentController.selectedAccount.value?.id ?? 0);
                            },
                            child: Text(
                              inventoryCreatePaymentController.isTimerActive.value
                                  ? '${inventoryCreatePaymentController.countdownSeconds.value} ثانیه'
                                  : 'درخواست کد',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          if (inventoryCreatePaymentController.isCodeVerified.value)
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(Icons.check_circle, color: Colors.green, size: 28),
                            ),
                        ],
                      );
                    } else if (!inventoryCreatePaymentController.isCodeVerified.value) {
                      return Form(
                        child: Row(
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: inventoryCreatePaymentController.isTimerActive.value
                                    ? Colors.grey
                                    : AppColor.primaryColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: inventoryCreatePaymentController.isTimerActive.value
                                  ? null
                                  : () {
                                print('sendAccountIdddd:::::::${inventoryCreatePaymentController.selectedAccount.value?.id}');
                                inventoryCreatePaymentController.resendVerificationCode();
                              },
                              child: Text(
                                inventoryCreatePaymentController.isTimerActive.value
                                    ? '${inventoryCreatePaymentController.countdownSeconds.value} ثانیه'
                                    : 'درخواست مجدد',
                                style: AppTextStyle.bodyText,
                              ),
                            ),
                            SizedBox(width: 10,),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColor.primaryColor,
                                  padding: EdgeInsets.all(0),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  fixedSize: Size(65, 20)
                              ),
                              child: Text('ثبت کد',
                                  style: AppTextStyle.bodyText),
                              onPressed: () {
                                print('sendAccountIdddd:::::::${inventoryCreatePaymentController.selectedAccount.value?.id}');
                                inventoryCreatePaymentController.checkVerificationCode(
                                  inventoryCreatePaymentController.selectedAccount.value?.id ?? 0,
                                  int.parse(inventoryCreatePaymentController.verificationCodeController.text),
                                );
                              },
                            ),
                            SizedBox(width: 10,),
                            Container(
                              height: 60,
                              width: 70,
                              padding: EdgeInsets.only(bottom: 5, top: 15),
                              child: TextFormField(
                                maxLength: 6,
                                controller: inventoryCreatePaymentController.verificationCodeController,
                                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                                keyboardType: TextInputType.number,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                style: AppTextStyle.labelText,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  filled: true,
                                  fillColor: AppColor.textFieldColor,
                                  counterText: '',
                                  hoverColor: AppColor.appBarColor,
                                  isDense: true,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  } else if (inventoryCreatePaymentController.verificationChecked.value == true) {
                    return Text('مسئولیت به عهده کاربر می باشد.',style: AppTextStyle.bodyText,);
                  } else {
                    return SizedBox.shrink();
                  }
                })(),

                Row(
                  children: [
                    Checkbox(
                      hoverColor: AppColor.textFieldColor.withAlpha(200),
                      value: inventoryCreatePaymentController.verificationChecked
                          .value,
                      onChanged: (value) async {
                        inventoryCreatePaymentController.verificationChecked
                            .value = value!;
                      },
                    ),
                    Text('ضمانت کاربر',style: AppTextStyle.bodyText,)
                  ],
                ),
                SizedBox(height: 5,),
                // توضیحات
                Container(
                  padding: EdgeInsets.only(bottom: 3, top: 5),
                  child: Text(
                    'توضیحات',
                    style: AppTextStyle.labelText,
                  ),
                ),
                // توضیحات
                Container(
                  padding: EdgeInsets.only(bottom: 5),
                  child:
                  TextFormField(
                    controller: inventoryCreatePaymentController
                        .descriptionController,
                    maxLines: 4,
                    style: AppTextStyle.labelText,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: AppColor.textFieldColor,
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                // بخش لیست موقت
                Center(
                  child: SizedBox(
                    width: Get.width * (isDesktop ? 0.6 : isMobile ? 0.95 : 0.8),
                    height: isMobile ? 180 : isDesktop ? 300 : 250,
                    child: Card(color: AppColor.secondaryColor,
                      child: Column(
                        children: [
                          SizedBox(height: 5,),
                          Text(
                            'آیتم‌های موقت (${inventoryCreatePaymentController
                                .tempDetails.length})',
                            style: AppTextStyle.bodyText.copyWith(fontSize: isMobile ? 12 : 14,),),
                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: inventoryCreatePaymentController
                                  .tempDetails
                                  .length,
                              itemBuilder: (context, index) {
                                final detail = inventoryCreatePaymentController
                                    .tempDetails[index];
                                return ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: isMobile ? 8 : 16,
                                    vertical: isMobile ? 2 : 4,
                                  ),
                                  title:
                                  ItemTempDetailWidgetPayment(
                                    detail: detail,
                                    quantity: detail.quantity ?? 0,
                                    onQuantityChanged: (
                                        newQuantity) { // اضافه شده
                                      inventoryCreatePaymentController
                                          .updateTempDetailQuantity(
                                        index,
                                        newQuantity,
                                      );
                                    },
                                    recId: (recId, list) {
                                      inventoryCreatePaymentController
                                          .updateDetail(
                                          index,
                                          recId,
                                          list
                                      );
                                      setState(() {});
                                    },
                                    image: detail.listXfile != null ? detail
                                        .listXfile! : [],

                                  ),
                                  trailing: IconButton(
                                      icon: Icon(Icons.delete,
                                        color: AppColor.accentColor,
                                        size: isMobile ? 20 : 24,
                                      ),
                                      onPressed: () {
                                        final removedDetail = inventoryCreatePaymentController
                                            .tempDetails.removeAt(index);
                                        if (removedDetail.id != null) {
                                          inventoryCreatePaymentController
                                              .selectedForPaymentId.remove(
                                              removedDetail.id);
                                        }
                                        inventoryCreatePaymentController
                                            .getForPaymentListPager();
                                      }
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                //  دکمه ثبت و ثبت نهایی
                Column(
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          hoverColor: AppColor.textFieldColor.withAlpha(200),
                          value: inventoryCreatePaymentController.factorBalanceChecked
                              .value,
                          onChanged: (value) async {
                            inventoryCreatePaymentController.factorBalanceChecked
                                .value = value!;
                          },
                        ),
                        SizedBox(width: 8,),
                        Text(
                          'ثبت نهایی همراه با صدور فاکتور با مانده', style: AppTextStyle
                            .labelText,)
                      ],
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          hoverColor: AppColor.textFieldColor.withAlpha(200),
                          value: inventoryCreatePaymentController.factorChecked
                              .value,
                          onChanged: (value) async {
                            inventoryCreatePaymentController.factorChecked
                                .value = value!;
                          },
                        ),
                        SizedBox(width: 8,),
                        Text(
                          'ثبت نهایی همراه با صدور فاکتور بدون مانده', style: AppTextStyle
                            .labelText,)
                      ],
                    ),
                    SizedBox(height: 6,),
                    Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // دکمه ثبت
                        inventoryCreatePaymentController.selectedWalletAccount
                            .value?.item?.id != 1 ?
                        Expanded(
                          child: ElevatedButton(
                            style: ButtonStyle(
                                fixedSize: WidgetStatePropertyAll(Size(
                                    isDesktop ? Get.width * 0.12 : Get.width *
                                        0.25,
                                    isDesktop ? 50 : 30
                                ),
                                ),
                                padding: WidgetStatePropertyAll(
                                  EdgeInsets.symmetric(
                                      horizontal: isDesktop ? 20 : 7
                                  ),),
                                elevation: WidgetStatePropertyAll(5),
                                backgroundColor:
                                WidgetStatePropertyAll(AppColor.buttonColor),
                                shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            10)))),
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                if(inventoryCreatePaymentController.selectedAccount.value!=null && inventoryCreatePaymentController.selectedWalletAccount.value!=null){
                                  inventoryCreatePaymentController.addToTempList();
                                  inventoryCreatePaymentController
                                      .descriptionController.clear();
                                }
                              }
                            },
                            child: inventoryCreatePaymentController.isLoading
                                .value
                                ?
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColor.textColor),
                            ) :
                            Text(
                              'ثبت',
                              style: AppTextStyle.bodyText,
                            ),
                          ),
                        ) : SizedBox.shrink(),
                        SizedBox(width: 10,),
                        // دکمه ثبت نهایی
                        Expanded(
                          child: ElevatedButton(
                            style: ButtonStyle(
                                fixedSize: WidgetStatePropertyAll(Size(
                                    isDesktop ? Get.width * 0.12 : Get.width *
                                        0.25,
                                    isDesktop ? 50 : 30
                                ),),
                                padding: WidgetStatePropertyAll(
                                  EdgeInsets.symmetric(
                                      horizontal: isDesktop ? 20 : 7
                                  ),),
                                elevation: WidgetStatePropertyAll(5),
                                backgroundColor:
                                WidgetStatePropertyAll(AppColor.primaryColor),
                                shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            10)))),
                            onPressed: () async {
                              if (inventoryCreatePaymentController.tempDetails
                                  .isNotEmpty) {
                                if(inventoryCreatePaymentController.verificationChecked.value==true){
                                  await inventoryCreatePaymentController
                                      .uploadImagesDesktop(
                                      "image", "InventoryDetail");
                                }else if(inventoryCreatePaymentController.verificationChecked.value==false && inventoryCreatePaymentController.isCodeVerified.value==true){
                                  await inventoryCreatePaymentController
                                      .uploadImagesDesktop(
                                      "image", "InventoryDetail");
                                }else{
                                  Get.snackbar(
                                    "هشدار",
                                    "درخواست کد بدهید یا \n تیک ضمانت کاربر را بزنید",
                                    titleText: Text(
                                      "هشدار",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: AppColor.textColor),
                                    ),
                                    messageText: Text(
                                      "درخواست کد بدهید یا \n تیک ضمانت کاربر را بزنید",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: AppColor.textColor),
                                    ),
                                  );
                                }
                              }
                            },
                            child: inventoryCreatePaymentController.isFinalizing
                                .value
                                ?
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColor.textColor),
                            ) :
                            Text(
                              'ثبت نهایی',
                              style: AppTextStyle.bodyText,
                            ),
                          ),
                        ),

                      ],
                    ),
                  ],
                )
              ],
            ),
          );
        }),
      ),
    );
  }


  void showForPaymentModal() {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    Get.dialog(
      SingleChildScrollView(
        child: Dialog(
          backgroundColor: AppColor.backGroundColor,
          insetPadding: EdgeInsets.all(isMobile ? 8 : isTablet ? 16 : 20),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isMobile ? Get.width * 0.95 : isTablet ? 500 : 600,
              maxHeight: isMobile ? Get.height * 0.9 : Get.height * 0.9,
            ),
            child: Column(
              children: [
                buildForPaymentDetail(),
                Obx(() {
                  return Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        inventoryCreatePaymentController.paginated.value != null
                            ? Container(
                            height: isMobile ? 70 : 80,
                            margin: EdgeInsets.symmetric(
                                horizontal: isMobile ? 20 : isTablet ? 50 : 70,
                                vertical: isMobile ? 5 : 10),
                            padding: EdgeInsets.symmetric(horizontal: isMobile ? 10 : 20),
                            color: AppColor.appBarColor.withAlpha(130),
                            alignment: Alignment.bottomCenter,
                            child: PagerWidget1(
                              countPage: inventoryCreatePaymentController
                                  .paginated.value?.totalCount ?? 0,
                              callBack: (int index) {
                                inventoryCreatePaymentController.isChangePage(
                                    index);
                              },))
                            : SizedBox(),
                      ],
                    ),
                  );
                }),
                /*TextButton(
                  onPressed: () =>
                      Get.back(),
                  child: Text("بستن", style: AppTextStyle.bodyText,),
                ),*/
                //SizedBox(height: 15,),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildForPaymentDetail() {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Obx(() {
      return
        inventoryCreatePaymentController.isLoading.value ?
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<
              Color>(
              AppColor.textColor),
        ) :
        // لیست ForPayment مربوط به هر ولت
        SizedBox(
          height: isMobile ? Get.height * 0.8 : Get.height * 0.75, // تعیین ارتفاع ثابت
          width: isMobile ? Get.width * 0.9 : isTablet ? Get.width * 0.7 : Get.width * 0.5,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: isMobile ? 8 : 12,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: isMobile ? 8 : 15),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          'لیست دریافتی ها',
                          style: AppTextStyle.smallTitleText.copyWith(
                              fontSize: isMobile ? 14 : 16
                          )
                      ),
                      IconButton(
                          onPressed: Get.back,
                          icon: Icon(
                            Icons.close,
                            size: isMobile ? 20 : 24,
                          ))
                    ],
                  ),
                ),
                SizedBox(height: isMobile ? 8 : 12,),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: isMobile ? 45 : 41,
                        child: TextFormField(
                          controller: inventoryCreatePaymentController
                              .searchLaboratoryController,
                          style: AppTextStyle.labelText.copyWith(
                            fontSize: isMobile ? 12 : 14,
                          ),
                          textInputAction: TextInputAction.search,
                          onFieldSubmitted: (value) async {
                            if (value.isNotEmpty) {
                              await inventoryCreatePaymentController
                                  .searchLaboratory(value);
                              showSearchResults(context);
                            } else {
                              inventoryCreatePaymentController.clearSearch();
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
                              fontSize: isMobile ? 12 : 14,
                            ),
                            prefixIcon: IconButton(
                                onPressed: () async {
                                  if (inventoryCreatePaymentController
                                      .searchLaboratoryController
                                      .text.isNotEmpty) {
                                    await inventoryCreatePaymentController
                                        .searchLaboratory(
                                        inventoryCreatePaymentController
                                            .searchLaboratoryController.text
                                    );
                                    showSearchResults(context);
                                  } else {
                                    inventoryCreatePaymentController
                                        .clearSearch();
                                  }
                                },
                                icon: Icon(
                                  Icons.search, color: AppColor.textColor,
                                  size: isMobile ? 24 : 30,)
                            ),
                            suffixIcon: inventoryCreatePaymentController
                                .selectedLaboratoryId.value > 0
                                ? IconButton(
                              onPressed: inventoryCreatePaymentController
                                  .clearSearch,
                              icon: Icon(
                                  Icons.close, color: AppColor.textColor),
                            )
                                : null,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                inventoryCreatePaymentController.forPaymentList.isNotEmpty ?
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: isMobile ? Get.height * 0.65 : Get.height * 0.6,
                  ),
                  child:
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: inventoryCreatePaymentController.forPaymentList
                        .length,
                    itemBuilder: (context,
                        index) {
                      final forPayment = inventoryCreatePaymentController
                          .forPaymentList[index];
                      print("itemUnit:::${inventoryCreatePaymentController.forPaymentList[index].itemUnit?.id}");

                      return ListTile(
                        onTap: () async {
                          Get.back();
                          List<XFile> xFiles = [];
                          if (forPayment.id != null) {
                            inventoryCreatePaymentController
                                .selectedForPaymentId.add(forPayment.id!);
                            if(forPayment.recId!=null && forPayment.recId!.isNotEmpty){
                              List<String> imageUrls = await inventoryCreatePaymentController.getImage(
                                  forPayment.recId!,
                                  "InventoryDetail"
                              );
                              // تبدیل هر URL به XFile
                              for (String url in imageUrls) {
                                try {
                                  final response = await http.get(Uri.parse("${BaseUrl.baseUrl}Attachment/downloadAttachment?fileName=$url"));
                                  if (response.statusCode == 200) {
                                    xFiles.add(XFile.fromData(
                                      response.bodyBytes,
                                      name: url.split('/').last,
                                      mimeType: _getMimeType(url),
                                    ));
                                  }
                                } catch (e) {
                                  print('Error converting URL to XFile: $e');
                                }
                              }
                            }
                            print('Fetched images count: ${xFiles.length}');
                            print('Fetched image names: ${xFiles.map((e) => e.name).toList()}');
                            forPayment.listXfile = xFiles;
                            print('Assigned images count: ${forPayment.listXfile?.length}');
                          }

                          inventoryCreatePaymentController.selectedInputItem
                              .value = forPayment;
                          inventoryCreatePaymentController.clearItemFields();

                          inventoryCreatePaymentController.selectQuantity(
                              forPayment.weightRemainded ?? 0.0);
                          inventoryCreatePaymentController.selectedLaboratory
                              .value = forPayment.laboratory;
                          inventoryCreatePaymentController.quantityController
                              .text =
                              forPayment.weightRemainded?.toString() ?? '0';
                          inventoryCreatePaymentController.impurityController
                              .text = forPayment.impurity?.toString() ?? '0';
                          inventoryCreatePaymentController.weight750Controller
                              .text = forPayment.weight750?.toString() ?? '0';
                          inventoryCreatePaymentController.caratController
                              .text = forPayment.carat?.toString() ?? '0';
                          inventoryCreatePaymentController
                              .receiptNumberController.text =
                              forPayment.receiptNumber ?? '';

                          inventoryCreatePaymentController.addToTempList();
                          inventoryCreatePaymentController.descriptionController
                              .clear();
                          inventoryCreatePaymentController.clearItemFields();
                        },
                        contentPadding: EdgeInsets.zero,
                        title: Card(
                          color: inventoryCreatePaymentController
                              .selectedForPaymentId.contains(forPayment.id)
                              ? AppColor.textFieldColor
                              : AppColor.secondaryColor,
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: isMobile ? 6 : 8,
                                left: isMobile ? 8 : 12,
                                right: isMobile ? 8 : 12,
                                bottom: isMobile ? 6 : 8),
                            child: Column(
                              children: [
                                // آزمایشگاه
                                Row(
                                  children: [
                                    Text(
                                        ' آزمایشگاه: ',
                                        style: AppTextStyle
                                            .labelText.copyWith(
                                          fontSize: isMobile ? 11 : 12,
                                        )),
                                    Expanded(
                                      child: Text(
                                          forPayment.laboratory?.name ?? '',
                                          style: AppTextStyle
                                              .bodyText.copyWith(
                                            fontSize: isMobile ? 12 : 14,
                                          )),
                                    ),
                                  ],
                                ),
                                SizedBox(height: isMobile ? 3 : 5,),
                                Divider(
                                  height: 1, color: AppColor.dividerColor,),
                                SizedBox(height: isMobile ? 3 : 5,),
                                // عیار-وزن 750
                                isMobile
                                    ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                            ' وزن ترازو: ',
                                            style: AppTextStyle
                                                .labelText.copyWith(
                                              fontSize: 11,
                                            )),
                                        Text(
                                            '${forPayment.weight ??
                                                0}',
                                            style: AppTextStyle
                                                .bodyText.copyWith(
                                              fontSize: 12,
                                            )),
                                      ],
                                    ),
                                    SizedBox(height: 3,),
                                    Row(
                                      children: [
                                        Text(
                                            ' عیار: ',
                                            style: AppTextStyle
                                                .labelText.copyWith(
                                              fontSize: 11,
                                            )),
                                        Text(
                                            '${forPayment.carat ??
                                                0}',
                                            style: AppTextStyle
                                                .bodyText.copyWith(
                                              fontSize: 12,
                                            )),
                                      ],
                                    ),
                                    SizedBox(height: 3,),
                                    Row(
                                      children: [
                                        Text(
                                            ' وزن 750: ',
                                            style: AppTextStyle
                                                .bodyText.copyWith(
                                              fontSize: 11,
                                            )
                                        ),
                                        Text(
                                            '${forPayment.weight750 ??
                                                0} ${forPayment.itemUnit
                                                ?.name ?? ""}',
                                            style: AppTextStyle
                                                .bodyText.copyWith(
                                              fontSize: 12,
                                            )
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                                    : Row(mainAxisAlignment: MainAxisAlignment
                                    .spaceEvenly,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                            ' وزن ترازو: ',
                                            style: AppTextStyle
                                                .labelText),
                                        Text(
                                            '${forPayment.weight ??
                                                0}',
                                            style: AppTextStyle
                                                .bodyText),
                                      ],
                                    ),
                                    SizedBox(width: 15,),
                                    Row(
                                      children: [
                                        Text(
                                            ' عیار: ',
                                            style: AppTextStyle
                                                .labelText),
                                        Text(
                                            '${forPayment.carat ??
                                                0}',
                                            style: AppTextStyle
                                                .bodyText),
                                      ],
                                    ),
                                    SizedBox(width: 15,),
                                    Row(
                                      children: [
                                        Text(
                                            ' وزن 750: ',
                                            style: AppTextStyle
                                                .bodyText
                                        ),
                                        Text(
                                            '${forPayment.weight750 ??
                                                0} ${forPayment.itemUnit
                                                ?.name ?? ""}',
                                            style: AppTextStyle
                                                .bodyText
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: isMobile ? 5 : 8,),
                                Divider(
                                  height: 1, color: AppColor.dividerColor,),
                                SizedBox(height: isMobile ? 3 : 5,),
                                // باقیمانده
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                            ' باقیمانده: ',
                                            style: AppTextStyle
                                                .labelText.copyWith(
                                              fontSize: isMobile ? 11 : 12,
                                            )),
                                        Text(
                                            '${forPayment.weightRemainded ??
                                                0} ${forPayment.itemUnit
                                                ?.name ?? ""}',
                                            style: AppTextStyle
                                                .bodyText.copyWith(
                                              fontSize: isMobile ? 12 : 14,
                                            )
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: isMobile ? 3 : 5,),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ) :
                Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            ),
          ),
        );
    });
  }

  String _getMimeType(String url) {
    final extension = url.split('.').last.toLowerCase();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'bmp':
        return 'image/bmp';
      case 'webp':
        return 'image/webp';
      default:
        return 'application/octet-stream';
    }
  }

  void showSearchResults(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;

    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            backgroundColor: AppColor.backGroundColor,
            title: Text(
              'انتخاب کنید',
              style: AppTextStyle.smallTitleText.copyWith(
                fontSize: isMobile ? 14 : 16,
              ),
            ),
            content: SizedBox(
              width: isMobile ? Get.width * 0.8 : isTablet ? Get.width * 0.6 : Get.width * 0.5,
              height: isMobile ? Get.height * 0.4 : Get.height * 0.5,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: inventoryCreatePaymentController.searchedLaboratories
                    .length,
                itemBuilder: (context, index) {
                  final laboratory = inventoryCreatePaymentController
                      .searchedLaboratories[index];
                  return ListTile(
                      title: Text(
                        laboratory.name ?? '',
                        style: AppTextStyle.bodyText.copyWith(
                          fontSize: isMobile ? 13 : 15,
                        ),
                      ),
                      onTap: () {
                        inventoryCreatePaymentController.selectLaboratory(
                            laboratory);
                      }
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  'بستن',
                  style: AppTextStyle.bodyText.copyWith(
                    fontSize: isMobile ? 12 : 14,
                  ),
                ),
              ),
            ],
          ),
    );
  }
}


