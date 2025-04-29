import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../widget/custom_dropdown.widget.dart';
import '../controller/inventory_create_receive.controller.dart';

class InventoryCreateReceiveTabWidget extends StatefulWidget {
  InventoryCreateReceiveTabWidget({
    super.key,

  });

  @override
  State<InventoryCreateReceiveTabWidget> createState() => _InventoryCreateReceiveTabWidgetState();
}

class _InventoryCreateReceiveTabWidgetState extends State<InventoryCreateReceiveTabWidget> {
  InventoryCreateReceiveController inventoryCreateReceiveController = Get.find<
      InventoryCreateReceiveController>();

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 40 : 20,
            vertical: isDesktop ? 30 : 20
        ),

        child: Obx(() {
          return Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8,),
                // کاربر
                Container(
                  padding: EdgeInsets.only(
                      bottom: 3, top: 5),
                  child: Text(
                    'کاربر',
                    style: AppTextStyle.labelText,
                  ),
                ),
                // کاربر
                Container(
                  padding: EdgeInsets.only(
                      bottom: 5),
                  child:
                  CustomDropdownWidget(

                    dropdownSearchData: DropdownSearchData<String>(
                      searchController: inventoryCreateReceiveController
                          .searchController,
                      searchInnerWidgetHeight: 50,
                      searchInnerWidget: Container(
                        height: 50,
                        padding: const EdgeInsets.only(
                          top: 8,
                          right: 15,
                          left: 15,
                        ),
                        child: TextFormField(style: AppTextStyle.bodyText,
                          controller: inventoryCreateReceiveController
                              .searchController,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding:
                            const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            hintText: 'جستجوی کاربر...',
                            hintStyle: AppTextStyle.labelText,
                            border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ),
                    value: inventoryCreateReceiveController.selectedAccount.value,
                    /*validator: (value) {
                    if (value == 'انتخاب کنید' || value == null || value.isEmpty) {
                      return 'کاربر را انتخاب کنید';
                    }
                    return null;
                  },*/
                    showSearchBox: true,
                    items: [
                      'انتخاب کنید',
                      ...inventoryCreateReceiveController.searchedAccounts.map((
                          account) => account.name ?? "")
                    ].toList(),
                    selectedValue: inventoryCreateReceiveController.selectedAccount
                        .value?.name,
                    onChanged: (String? newValue) {
                      if (newValue == 'انتخاب کنید') {
                        inventoryCreateReceiveController.changeSelectedAccount(null);
                      } else {
                        var selectedAccount = inventoryCreateReceiveController
                            .searchedAccounts
                            .firstWhere((account) => account.name == newValue);
                        inventoryCreateReceiveController.changeSelectedAccount(
                            selectedAccount);
                      }
                    },
                    onMenuStateChange: (isOpen) {
                      if (!isOpen) {
                        inventoryCreateReceiveController.resetAccountSearch();
                      }
                    },
                    backgroundColor: AppColor.textFieldColor,
                    borderRadius: 7,
                    borderColor: AppColor.secondaryColor,
                    hideUnderline: true,
                  ),
                ),
                // ولت اکانت
                Container(
                  padding: EdgeInsets.only(bottom: 3, top: 5),
                  child: Text(
                    'حساب wallet',
                    style: AppTextStyle.labelText,
                  ),
                ),
                // ولت اکانت
                Container(
                  padding: EdgeInsets.only(bottom: 5),
                  child: DropdownButton2(
                    isExpanded: true,
                    hint: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "انتخاب کنید",
                            style: AppTextStyle.labelText.copyWith(
                              fontSize: 14,
                              color: AppColor.textColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    items:
                    inventoryCreateReceiveController.walletAccountList.map((wallet) {
                      return DropdownMenuItem(
                          value: wallet,
                          child: Row(
                            children: [
                              Text("${wallet.item?.name}" ?? "",
                                style: AppTextStyle.bodyText,),
                            ],
                          ));
                    }).toList(),
                    value: inventoryCreateReceiveController.selectedWalletAccount
                        .value,
                    onChanged: (newValue) {
                      if (newValue != null) {
                        inventoryCreateReceiveController.changeSelectedWalletAccount(
                            newValue);
                      }
                    },
                    buttonStyleData: ButtonStyleData(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: AppColor.textFieldColor,
                        border: Border.all(
                            color: AppColor.backGroundColor, width: 1),
                      ),
                      elevation: 0,
                    ),
                    iconStyleData: IconStyleData(
                      icon: const Icon(Icons.keyboard_arrow_down),
                      iconSize: 23,
                      iconEnabledColor: AppColor.textColor,
                      iconDisabledColor: Colors.grey,
                    ),
                    dropdownStyleData: DropdownStyleData(
                      maxHeight: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: AppColor.textFieldColor,
                      ),
                      offset: const Offset(0, 0),
                      scrollbarTheme: ScrollbarThemeData(
                        radius: const Radius.circular(7),
                        thickness: WidgetStateProperty.all(6),
                        thumbVisibility: WidgetStateProperty.all(true),
                      ),
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      height: 40,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                  ),
                ),
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
                  padding: EdgeInsets.only(bottom: 5),
                  child:
                  CustomDropdownWidget(

                    dropdownSearchData: DropdownSearchData<String>(
                      searchController: inventoryCreateReceiveController
                          .searchLaboratoryController,
                      searchInnerWidgetHeight: 50,
                      searchInnerWidget: Container(
                        height: 50,
                        padding: const EdgeInsets.only(
                          top: 8,
                          right: 15,
                          left: 15,
                        ),
                        child: TextFormField(style: AppTextStyle.bodyText,
                          controller: inventoryCreateReceiveController
                              .searchLaboratoryController,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding:
                            const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            hintText: 'جستجوی آزمایشگاه...',
                            hintStyle: AppTextStyle.labelText,
                            border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ),
                    value: inventoryCreateReceiveController.selectedLaboratory.value,
                    /*validator: (value) {
                    if (value == 'انتخاب کنید' || value == null || value.isEmpty) {
                      return 'کاربر را انتخاب کنید';
                    }
                    return null;
                  },*/
                    showSearchBox: true,
                    items: [
                      'انتخاب کنید',
                      ...inventoryCreateReceiveController.searchedLaboratories.map((
                          laboratory) => laboratory.name ?? "")
                    ].toList(),
                    selectedValue: inventoryCreateReceiveController.selectedLaboratory
                        .value?.name,
                    onChanged: (String? newValue) {
                      if (newValue == 'انتخاب کنید') {
                        inventoryCreateReceiveController.changeSelectedLaboratory(
                            null);
                      } else {
                        var selectedLaboratory = inventoryCreateReceiveController
                            .searchedLaboratories
                            .firstWhere((laboratory) =>
                        laboratory.name == newValue);
                        inventoryCreateReceiveController.changeSelectedLaboratory(
                            selectedLaboratory);
                      }
                    },
                    onMenuStateChange: (isOpen) {
                      if (!isOpen) {
                        inventoryCreateReceiveController.resetLaboratorySearch();
                      }
                    },
                    backgroundColor: AppColor.textFieldColor,
                    borderRadius: 7,
                    borderColor: AppColor.secondaryColor,
                    hideUnderline: true,
                  ),
                ),
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
                    ),
                  ),
                ),
                // ناخالصی
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
                // وزن 750
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
                // عیار
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
                    ),
                  ),
                ),
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
                  padding: EdgeInsets.only(bottom: 5),
                  child:
                  TextFormField(
                    controller: inventoryCreateReceiveController
                        .receiptNumberController,
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
                    width: Get.width * (isDesktop ? 0.6 : 1),
                    height: isDesktop ? 300 : 200,
                    child: Card(color: AppColor.secondaryColor,
                      child: Column(
                        children: [
                          SizedBox(height: 5,),
                          Text('آیتم‌های موقت (${inventoryCreateReceiveController
                              .tempDetails.length})',
                            style: AppTextStyle.bodyText,),
                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: inventoryCreateReceiveController.tempDetails
                                  .length,
                              itemBuilder: (context, index) {
                                final detail = inventoryCreateReceiveController
                                    .tempDetails[index];
                                return Card(color: AppColor.backGroundColor,
                                  child: ListTile(
                                    title: Text(detail.item?.name ?? '',
                                      style: AppTextStyle.bodyText,),
                                    subtitle: Text('مقدار: ${detail.quantity}',
                                      style: AppTextStyle.bodyText,),
                                    trailing: IconButton(
                                      icon: Icon(Icons.delete,
                                        color: AppColor.accentColor,),
                                      onPressed: () =>
                                          inventoryCreateReceiveController.tempDetails
                                              .removeAt(index),
                                    ),
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
                SizedBox(height: 20,),
                Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // دکمه ثبت
                    ElevatedButton(
                      style: ButtonStyle(fixedSize: WidgetStatePropertyAll(Size(
                          isDesktop ? Get.width * 0.12 : Get.width * 0.3,
                          isDesktop ? 50 : 40
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
                        inventoryCreateReceiveController.addToTempList();
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

                    SizedBox(width: 10,),
                    // دکمه ثبت نهایی
                    ElevatedButton(
                      style: ButtonStyle(fixedSize: WidgetStatePropertyAll(Size(
                          isDesktop ? Get.width * 0.12 : Get.width * 0.3,
                          isDesktop ? 50 : 40
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
                        inventoryCreateReceiveController.submitFinalInventory();
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
                    )
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