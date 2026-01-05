import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/account/model/account.model.dart';
import 'package:hanigold_admin/src/domain/inventory/widget/item_temp_detail_receive.widget.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../widget/custom_dropdown.widget.dart';
import '../../../widget/custom_dropdown1.widget.dart';
import '../../laboratory/model/laboratory.model.dart';
import '../../wallet/model/wallet.model.dart';
import '../controller/inventory_create_receive.controller.dart';

typedef SelectCallBack = Function(int id);

class InventoryCreateReceiveTabWidget extends StatefulWidget {
  final SelectCallBack callBack;
  const InventoryCreateReceiveTabWidget({
    super.key, required this.callBack,

  });

  @override
  State<InventoryCreateReceiveTabWidget> createState() => _InventoryCreateReceiveTabWidgetState();
}
class _InventoryCreateReceiveTabWidgetState extends State<InventoryCreateReceiveTabWidget> {
  final formKey = GlobalKey<FormState>();
  InventoryCreateReceiveController inventoryCreateReceiveController = Get.find<
      InventoryCreateReceiveController>();

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
                inventoryCreateReceiveController.accountList.isEmpty ?
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
                inventoryCreateReceiveController.accountList.isEmpty ?
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
                      isOpen:inventoryCreateReceiveController.tempDetails.isNotEmpty ? true :false ,
                      items: inventoryCreateReceiveController.accountList,
                      selectedItem: inventoryCreateReceiveController.selectedAccount.value,
                      enableSearch: true,
                      errorText: inventoryCreateReceiveController.dropdownError.value,
                      itemLabel: (account) =>
                      account.name ??
                          "",
                      /*itemIcon: (bank) =>
                      bank.icon ??
                          "",*/
                      onChanged: (account) {
                        setState(() {
                          inventoryCreateReceiveController.selectedAccount.value = account;
                          inventoryCreateReceiveController.dropdownError.value = "";
                          //inventoryCreateReceiveController.getWalletAccount(account?.id ?? 0);
                          inventoryCreateReceiveController.tempDetails.isNotEmpty
                              ? null
                              :
                          inventoryCreateReceiveController.changeSelectedAccount(
                              account);
                          inventoryCreateReceiveController.tempDetails.isNotEmpty
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
                Obx(() => inventoryCreateReceiveController.tempDetails.isNotEmpty
                    ? Container(
                  //padding: EdgeInsets.only(top: 5),
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
                inventoryCreateReceiveController.walletAccountList.isEmpty ?
                SizedBox.shrink() :
                Container(
                  padding: EdgeInsets.only(bottom: 3, top: 5),
                  child: Text(
                    'حساب wallet',
                    style: AppTextStyle.labelText,
                  ),
                ),
                // ولت اکانت
                inventoryCreateReceiveController.walletAccountList.isEmpty ?
                SizedBox.shrink() :
                Container(
                  padding: EdgeInsets.only(
                      bottom: 5),
                  child: CustomDropdown<WalletModel>(
                    isOpen:inventoryCreateReceiveController.tempDetails.isNotEmpty ? true :false ,
                    items: inventoryCreateReceiveController.walletAccountList,
                    selectedItem: inventoryCreateReceiveController.selectedWalletAccount.value,
                    enableSearch: true,
                    errorText: inventoryCreateReceiveController.dropdownError.value,
                    itemLabel: (walletAccount) =>
                    walletAccount.item?.name ??
                        "",
                    /*itemIcon: (bank) =>
                      bank.icon ??
                          "",*/
                    onChanged: (walletAccount) {
                      setState(() {
                        inventoryCreateReceiveController.selectedWalletAccount.value = walletAccount;
                        inventoryCreateReceiveController.dropdownError.value = "";
                        inventoryCreateReceiveController.tempDetails.isNotEmpty
                            ? null
                            :
                        inventoryCreateReceiveController.changeSelectedWalletAccount(
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
                Obx(() => inventoryCreateReceiveController.tempDetails.isNotEmpty
                    ? Container(
                  //padding: EdgeInsets.only(top: 5),
                  child: Text(
                    '⚠️ ابتدا آیتم‌های موقت را پاک کنید تا بتوانید حساب wallet را تغییر دهید',
                    style: AppTextStyle.labelText.copyWith(
                      color: Colors.orange,
                      fontSize: 12,
                    ),
                  ),
                )
                    : SizedBox.shrink()),
                inventoryCreateReceiveController.selectedWalletAccount.value?.item?.id==1 ?
                // آزمایشگاه
                Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // آزمایشگاه
                    Container(
                      padding: EdgeInsets.only(
                          bottom: 3, top: 5),
                      child: Text(
                        'آزمایشگاه',
                        style: AppTextStyle.labelText,
                      ),
                    ),
                    // آزمایشگاه
                    Container(
                      padding: EdgeInsets.only(
                          bottom: 5),
                      child: CustomDropdown<LaboratoryModel>(
                        items: inventoryCreateReceiveController.laboratoryList,
                        selectedItem: inventoryCreateReceiveController.selectedLaboratory.value,
                        enableSearch: true,
                        errorText: inventoryCreateReceiveController.dropdownError.value,
                        itemLabel: (laboratory) =>
                        laboratory.name ??
                            "",
                        /*itemIcon: (bank) =>
                      bank.icon ??
                          "",*/
                        onChanged: (laboratory) {
                          setState(() {
                            inventoryCreateReceiveController.selectedLaboratory.value = laboratory;
                            inventoryCreateReceiveController.dropdownError.value = "";

                          });
                          debugPrint(
                            "آزمایشگاه انتخاب شد: ${laboratory?.name}",
                          );
                        },
                        isIcon: false,
                      ),
                    ),
                  ],
                ) :
                SizedBox.shrink(),

                inventoryCreateReceiveController.selectedWalletAccount.value?.item?.id==1 ?
                // شناسه قبض
                Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // شماره قبض
                    Container(
                      padding: EdgeInsets.only(bottom: 3, top: 5),
                      child: Text(
                        'شماره قبض',
                        style: AppTextStyle.labelText,
                      ),
                    ),
                    // شماره قبض
                    Container(
                      //height: 40,
                      padding: EdgeInsets.only(bottom: 5),
                      child:
                      IntrinsicHeight(
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: inventoryCreateReceiveController
                              .receiptNumberController,
                          style: AppTextStyle.labelText,
                          keyboardType: TextInputType
                              .numberWithOptions(
                              decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter
                                .allow(RegExp(
                                r'^[\d٠-٩۰-۹]*\.?[\d٠-٩۰-۹]*$')),
                            TextInputFormatter
                                .withFunction((
                                oldValue, newValue) {
                              // تبدیل اعداد فارسی به انگلیسی برای پردازش راحت‌تر
                              String newText = newValue
                                  .text
                                  .replaceAll(
                                  '٠', '0')
                                  .replaceAll(
                                  '١', '1')
                                  .replaceAll(
                                  '٢', '2')
                                  .replaceAll(
                                  '٣', '3')
                                  .replaceAll(
                                  '٤', '4')
                                  .replaceAll(
                                  '٥', '5')
                                  .replaceAll(
                                  '٦', '6')
                                  .replaceAll(
                                  '٧', '7')
                                  .replaceAll(
                                  '٨', '8')
                                  .replaceAll(
                                  '٩', '9');

                              return newValue
                                  .copyWith(
                                  text: newText,
                                  selection: TextSelection
                                      .collapsed(
                                      offset: newText
                                          .length));
                            }),
                          ],
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: AppColor.textFieldColor,
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty) {
                              return 'لطفا شماره قبض را وارد کنید';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ],
                ):
                SizedBox.shrink(),

                // مقدار
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
                      controller: inventoryCreateReceiveController.quantityController,
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
                          return 'لطفا مقدار را وارد کنید';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        inventoryCreateReceiveController.viewCountItem();
                      },
                    ),
                  ),
                ),
                // تعداد
                SizedBox(height: 3),
                    inventoryCreateReceiveController.selectedWalletAccount.value?.item?.id == 10 ||
                    inventoryCreateReceiveController.selectedWalletAccount.value?.item?.id == 13 ||
                    inventoryCreateReceiveController.selectedWalletAccount.value?.item?.id == 15 ||
                    inventoryCreateReceiveController.selectedWalletAccount.value?.item?.id == 16
                    ?
                Row(
                  children: [
                    Text(
                      ' تعداد: ',
                      style: AppTextStyle
                          .labelText.copyWith(color: AppColor.textColor.withAlpha(130)),),
                    Text(inventoryCreateReceiveController.itemCountTemp.value,
                      style: AppTextStyle.bodyText
                          .copyWith(color: AppColor
                          .primaryColor.withAlpha(200)),)
                  ],
                ) :
                SizedBox(),

                inventoryCreateReceiveController.selectedWalletAccount.value?.item?.id==1 ||
                    inventoryCreateReceiveController.selectedWalletAccount.value?.item?.id==10 ||
                    inventoryCreateReceiveController.selectedWalletAccount.value?.item?.id==12 ||
                    inventoryCreateReceiveController.selectedWalletAccount.value?.item?.id==15 ||
                    inventoryCreateReceiveController.selectedWalletAccount.value?.item?.id==16 ||
                    inventoryCreateReceiveController.selectedWalletAccount.value?.item?.id==14 ?
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
                          onChanged: (value) {
                            inventoryCreateReceiveController.updateW750();
                          },
                          /*readOnly: inventoryCreateReceiveController.selectedWalletAccount.value?.item?.id==10 ||
                              inventoryCreateReceiveController.selectedWalletAccount.value?.item?.id==12 ||
                              inventoryCreateReceiveController.selectedWalletAccount.value?.item?.id==15 ||
                              inventoryCreateReceiveController.selectedWalletAccount.value?.item?.id==16 ? true :false ,*/
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: inventoryCreateReceiveController.caratController,
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

                inventoryCreateReceiveController.selectedWalletAccount.value?.item?.id==1 ||
                    inventoryCreateReceiveController.selectedWalletAccount.value?.item?.id==10 ||
                    inventoryCreateReceiveController.selectedWalletAccount.value?.item?.id==12 ||
                    inventoryCreateReceiveController.selectedWalletAccount.value?.item?.id==15 ||
                    inventoryCreateReceiveController.selectedWalletAccount.value?.item?.id==16 ||
                    inventoryCreateReceiveController.selectedWalletAccount.value?.item?.id==14 ?
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
                          readOnly: inventoryCreateReceiveController.selectedWalletAccount.value?.item?.id==10 ||
                              inventoryCreateReceiveController.selectedWalletAccount.value?.item?.id==12 ||
                              inventoryCreateReceiveController.selectedWalletAccount.value?.item?.id==15 ||
                              inventoryCreateReceiveController.selectedWalletAccount.value?.item?.id==16 ? true :false ,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: inventoryCreateReceiveController.weight750Controller,
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

                inventoryCreateReceiveController.selectedWalletAccount.value?.item?.id==1 ?
                // ناخالصی
                Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(bottom: 3, top: 5),
                      child: Text(
                        'ناخالصی',
                        style: AppTextStyle.labelText,
                      ),
                    ),
                    // ناخالصی
                    Container(
                      //height: 50,
                      padding: EdgeInsets.only(bottom: 5),
                      child:
                      IntrinsicHeight(
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: inventoryCreateReceiveController.impurityController,
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
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: inventoryCreateReceiveController.dateController,
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
                          inventoryCreateReceiveController.dateController.text =
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
                    controller: inventoryCreateReceiveController.descriptionController,
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

                // بخش لیست موقت
                Center(
                  child: SizedBox(
                    width: Get.width * (isDesktop ? 0.6 : isMobile ? 0.95 : 0.8),
                    height: isMobile ? 180 : isDesktop ? 300 : 250,
                    child: Card(color: AppColor.secondaryColor,
                      child: Column(
                        children: [
                          SizedBox(height: 5,),
                          Text('آیتم‌های موقت (${inventoryCreateReceiveController
                              .tempDetails.length})',
                            style: AppTextStyle.bodyText.copyWith(fontSize: isMobile ? 12 : 14,),),
                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: inventoryCreateReceiveController.tempDetails
                                  .length,
                              itemBuilder: (context, index) {
                                final detail = inventoryCreateReceiveController
                                    .tempDetails[index];
                                return ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: isMobile ? 8 : 16,
                                    vertical: isMobile ? 2 : 4,
                                  ),
                                  title:
                                  ItemTempDetailWidgetReceive(
                                    detail: detail,
                                    recId: (recId,list){
                                      inventoryCreateReceiveController.updateDetail(
                                          index,
                                          recId,
                                          list
                                      );
                                      setState(() {

                                      });
                                    },  image: detail.listXfile!=null?detail.listXfile!:[],
                                  ),
                                  trailing: IconButton(
                                      icon: Icon(Icons.delete,
                                        color: AppColor.accentColor,
                                        size: isMobile ? 20 : 24,
                                      ),
                                      onPressed: () {
                                         inventoryCreateReceiveController.tempDetails.removeAt(index);
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
                          value: inventoryCreateReceiveController.factorBalanceChecked.value,
                          onChanged: (value) async{
                            inventoryCreateReceiveController.factorBalanceChecked.value = value!;
                          },
                        ),
                        SizedBox(width: 8,),
                        Text('ثبت نهایی همراه با صدور فاکتور با مانده',style: AppTextStyle.labelText,)
                      ],
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          hoverColor: AppColor.textFieldColor.withAlpha(200),
                          value: inventoryCreateReceiveController.factorChecked.value,
                          onChanged: (value) async{
                            inventoryCreateReceiveController.factorChecked.value = value!;
                          },
                        ),
                        SizedBox(width: 8,),
                        Text('ثبت نهایی همراه با صدور فاکتور بدون مانده',style: AppTextStyle.labelText,)
                      ],
                    ),
                    SizedBox(height: 6,),
                    Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // دکمه ثبت
                        Expanded(
                          child: ElevatedButton(
                            style: ButtonStyle(fixedSize: WidgetStatePropertyAll(Size(
                                isDesktop ? Get.width * 0.12 : Get.width * 0.25,
                                isDesktop ? 50 : 30
                            ),),
                                padding: WidgetStatePropertyAll(
                                  EdgeInsets.symmetric(
                                      horizontal: isDesktop ? 20 : 7
                                  ),),
                                elevation: WidgetStatePropertyAll(5),
                                backgroundColor:
                                WidgetStatePropertyAll(AppColor.buttonColor),
                                shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)))),
                            onPressed: () async {
                              if(formKey.currentState!.validate()){
                                if(inventoryCreateReceiveController.selectedAccount.value!=null && inventoryCreateReceiveController.selectedWalletAccount.value!=null){
                                  inventoryCreateReceiveController.addToTempList();
                                }
                              }
                            },
                            child: inventoryCreateReceiveController.isLoading.value
                                ?
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColor.textColor),
                            ) :
                            Text(
                              'ثبت موقت',
                              style: AppTextStyle.bodyText,
                            ),
                          ),
                        ),

                        SizedBox(width: 10,),
                        // دکمه ثبت نهایی
                        Expanded(
                          child: ElevatedButton(
                            style: ButtonStyle(fixedSize: WidgetStatePropertyAll(Size(
                                isDesktop ? Get.width * 0.12 : Get.width * 0.25,
                                isDesktop ? 50 : 30
                            ),
                            ),
                                padding: WidgetStatePropertyAll(
                                  EdgeInsets.symmetric(
                                      horizontal: isDesktop ? 20 : 7
                                  ),),
                                elevation: WidgetStatePropertyAll(5),
                                backgroundColor:
                                WidgetStatePropertyAll(AppColor.primaryColor),
                                shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)))),
                            onPressed: () async {
                              if(inventoryCreateReceiveController.tempDetails.isNotEmpty){
                                await inventoryCreateReceiveController.uploadImagesDesktop( "image", "InventoryDetail");
                              }
                            },
                            child: inventoryCreateReceiveController.isFinalizing.value
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
                        )
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
}