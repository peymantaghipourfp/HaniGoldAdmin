import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/inventory/controller/inventory_create_payment.controller.dart';
import 'package:hanigold_admin/src/domain/inventory/model/inventory_detail.model.dart';
import 'package:hanigold_admin/src/domain/laboratory/model/laboratory.model.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../widget/custom_dropdown.widget.dart';
import '../../../widget/pager_widget.dart';
import '../controller/inventory_create_receive.controller.dart';
import 'item_temp_detail_payment.widget.dart';

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
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 40 : 20,
            vertical: isDesktop ? 30 : 20
        ),

        child: Obx(() {
          return Form(
            key: formKey,
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
                      searchController: inventoryCreatePaymentController
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
                          controller: inventoryCreatePaymentController
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
                    value: inventoryCreatePaymentController.selectedAccount
                        .value,
                    validator: (value) {
                      if (value == 'انتخاب کنید' || value == null ||
                          value.isEmpty) {
                        return 'کاربر را انتخاب کنید';
                      }
                      return null;
                    },
                    showSearchBox: true,
                    items: [
                      'انتخاب کنید',
                      ...inventoryCreatePaymentController.searchedAccounts.map((
                          account) => account.name ?? "")
                    ].toList(),
                    selectedValue: inventoryCreatePaymentController
                        .selectedAccount
                        .value?.name,
                    onChanged: (String? newValue) {
                      if (newValue == 'انتخاب کنید') {
                        inventoryCreatePaymentController.changeSelectedAccount(
                            null);
                      } else {
                        var selectedAccount = inventoryCreatePaymentController
                            .searchedAccounts
                            .firstWhere((account) => account.name == newValue);
                        inventoryCreatePaymentController.changeSelectedAccount(
                            selectedAccount);
                        widget.callBack(selectedAccount.id!);
                      }
                    },
                    onMenuStateChange: (isOpen) {
                      if (!isOpen) {
                        inventoryCreatePaymentController.resetAccountSearch();
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
                    inventoryCreatePaymentController.walletAccountList.map((
                        wallet) {
                      return DropdownMenuItem(
                          value: wallet,
                          child: Row(
                            children: [
                              Text("${wallet.item?.name}" ?? "",
                                style: AppTextStyle.bodyText,),
                            ],
                          ));
                    }).toList(),
                    value: inventoryCreatePaymentController
                        .selectedWalletAccount
                        .value,
                    onChanged: (newValue) {
                      if (newValue != null) {
                        inventoryCreatePaymentController
                            .changeSelectedWalletAccount(
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
                // لیست دریافتی ها
                inventoryCreatePaymentController.selectedWalletAccount.value
                    ?.item?.itemUnit?.id == 2 ?
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
                    ?.item?.itemUnit?.id != 2 ?
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
                        ),
                      ),
                    ),
                  ],
                ) : SizedBox.shrink(),
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
                    width: Get.width * (isDesktop ? 0.6 : 1),
                    height: isDesktop ? 300 : 200,
                    child: Card(color: AppColor.secondaryColor,
                      child: Column(
                        children: [
                          SizedBox(height: 5,),
                          Text(
                            'آیتم‌های موقت (${inventoryCreatePaymentController
                                .tempDetails.length})',
                            style: AppTextStyle.bodyText,),
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
                                        color: AppColor.accentColor,),
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
                          hoverColor: AppColor.textFieldColor.withOpacity(0.8),
                          value: inventoryCreatePaymentController.factorChecked
                              .value,
                          onChanged: (value) async {
                            inventoryCreatePaymentController.factorChecked
                                .value = value!;
                          },
                        ),
                        SizedBox(width: 8,),
                        Text(
                          'ثبت نهایی همراه با صدور فاکتور', style: AppTextStyle
                            .bodyTextBold,)
                      ],
                    ),
                    SizedBox(height: 5,),
                    Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // دکمه ثبت
                        inventoryCreatePaymentController.selectedWalletAccount
                            .value?.item?.itemUnit?.id != 2 ?
                        ElevatedButton(
                          style: ButtonStyle(
                              fixedSize: WidgetStatePropertyAll(Size(
                                  isDesktop ? Get.width * 0.12 : Get.width *
                                      0.3,
                                  isDesktop ? 50 : 40
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
                              inventoryCreatePaymentController.addToTempList();
                              inventoryCreatePaymentController
                                  .descriptionController.clear();
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
                        ) : SizedBox.shrink(),
                        SizedBox(width: 10,),
                        // دکمه ثبت نهایی
                        ElevatedButton(
                          style: ButtonStyle(
                              fixedSize: WidgetStatePropertyAll(Size(
                                  isDesktop ? Get.width * 0.12 : Get.width *
                                      0.3,
                                  isDesktop ? 50 : 40
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
                              await inventoryCreatePaymentController
                                  .uploadImagesDesktop(
                                  "image", "InventoryDetail");
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
    Get.dialog(
      SingleChildScrollView(
        child: Dialog(
          backgroundColor: AppColor.backGroundColor,
          insetPadding: EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 600,
              maxHeight: Get.height * 0.8,
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
                            height: 70,
                            margin: EdgeInsets.symmetric(
                                horizontal: 70, vertical: 10),
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            color: AppColor.appBarColor.withOpacity(0.5),
                            alignment: Alignment.bottomCenter,
                            child: PagerWidget(
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
          height: Get.height * 0.65, // تعیین ارتفاع ثابت
          width: Get.width * 0.5,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 12,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('لیست دریافتی ها', style: AppTextStyle.smallTitleText),
                      IconButton(
                          onPressed: Get.back,
                          icon: Icon(Icons.close))
                    ],
                  ),
                ),
                SizedBox(height: 12,),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 41,
                        child: TextFormField(
                          controller: inventoryCreatePaymentController
                              .searchLaboratoryController,
                          style: AppTextStyle.labelText,
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
                            hintStyle: AppTextStyle.labelText,
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
                                  size: 30,)
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
                    maxHeight: Get.height * 0.65,
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
                      return ListTile(
                        onTap: () {
                          Get.back();
                          if (forPayment.id != null) {
                            inventoryCreatePaymentController
                                .selectedForPaymentId.add(forPayment.id!);
                          }

                          inventoryCreatePaymentController.selectedInputItem
                              .value = forPayment;
                          inventoryCreatePaymentController.clearItemFields();

                          inventoryCreatePaymentController.selectQuantity(
                              forPayment.quantityRemainded ?? 0.0);
                          inventoryCreatePaymentController.selectedLaboratory
                              .value = forPayment.laboratory;
                          inventoryCreatePaymentController.quantityController
                              .text =
                              forPayment.quantityRemainded?.toString() ?? '0';
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
                            padding: const EdgeInsets
                                .only(
                                top: 8,
                                left: 12,
                                right: 12,
                                bottom: 8),
                            child: Column(
                              children: [
                                // آزمایشگاه
                                Row(
                                  children: [
                                    Text(
                                        ' آزمایشگاه: ',
                                        style: AppTextStyle
                                            .labelText),
                                    Text(
                                        forPayment.laboratory?.name ?? '',
                                        style: AppTextStyle
                                            .bodyText),
                                  ],
                                ),
                                SizedBox(height: 5,),
                                Divider(
                                  height: 1, color: AppColor.dividerColor,),
                                SizedBox(height: 5,),
                                // عیار-وزن 750
                                Row(mainAxisAlignment: MainAxisAlignment
                                    .spaceEvenly,
                                  children: [
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
                                SizedBox(height: 8,),
                                // باقیمانده
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                            ' باقیمانده: ',
                                            style: AppTextStyle
                                                .labelText),
                                        Text(
                                            '${forPayment.quantityRemainded ??
                                                0} ${forPayment.itemUnit
                                                ?.name ?? ""}',
                                            style: AppTextStyle
                                                .bodyText
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,),
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

  void showSearchResults(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(backgroundColor: AppColor.backGroundColor,
            title: Text('انتخاب کنید', style: AppTextStyle.smallTitleText,),
            content: SizedBox(
              width: Get.width * 0.5,
              height: Get.height * 0.5,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: inventoryCreatePaymentController.searchedLaboratories
                    .length,
                itemBuilder: (context, index) {
                  final laboratory = inventoryCreatePaymentController
                      .searchedLaboratories[index];
                  return ListTile(
                      title: Text(laboratory.name ?? '',
                        style: AppTextStyle.bodyText.copyWith(fontSize: 15),),
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
                child: Text('بستن', style: AppTextStyle.bodyText,),
              ),
            ],
          ),
    );
  }
}

