import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/inventory/controller/inventory_create.controller.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../widget/custom_appbar.widget.dart';

class InventoryCreateView extends StatefulWidget {
  const InventoryCreateView({super.key});

  @override
  State<InventoryCreateView> createState() => _InventoryCreateViewState();
}

class _InventoryCreateViewState extends State<InventoryCreateView> with TickerProviderStateMixin {
  late TabController tabController;
  InventoryCreateController inventoryCreateController = Get.find<InventoryCreateController>();

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      inventoryCreateController.selectedTabIndex.value = tabController.index;
      inventoryCreateController.resetFieldsForTab(tabController.index);
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'دریافت و پرداخت جدید',
        onBackTap: () => Get.back(),
      ),
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: DefaultTabController(
                        length: 2,
                        child: Column(
                          children: [
                            TabBar(
                              controller: tabController,
                              labelStyle: AppTextStyle.bodyText.copyWith(
                                  fontSize: 13, fontWeight: FontWeight.bold),
                              labelColor: AppColor.textColor,
                              dividerColor: AppColor.backGroundColor,
                              overlayColor: WidgetStatePropertyAll(
                                  AppColor.textColor),
                              unselectedLabelColor: AppColor.textColor.withAlpha(
                                  120),
                              indicatorColor: AppColor.primaryColor,
                              tabs: [
                                Tab(text: "دریافت"),
                                Tab(text: "پرداخت"),
                              ],
                            ),
                            Expanded(
                              child: Obx(() {
                                return TabBarView(
                                  controller: tabController,
                                    children: [
                                      // TabBar 1 دریافت
                                      SingleChildScrollView(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                          child: Form(
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
                                                  child: DropdownButton2(
                                                    isExpanded: true,
                                                    hint: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            "انتخاب کنید",
                                                            style: AppTextStyle
                                                                .labelText.copyWith(
                                                              fontSize: 14,
                                                              color: AppColor
                                                                  .textColor,
                                                            ),
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    items: inventoryCreateController
                                                        .accountList.map((account) {
                                                      return DropdownMenuItem(
                                                          value: account,
                                                          child: Text(
                                                            account.name ?? "",
                                                            style: AppTextStyle
                                                                .bodyText,));
                                                    }).toList(),
                                                    value: inventoryCreateController
                                                        .selectedAccount.value,
                                                    onChanged: (newValue) {
                                                      if (newValue != null) {
                                                        inventoryCreateController
                                                            .changeSelectedAccount(
                                                            newValue);
                                                      }
                                                    },
                                                    buttonStyleData: ButtonStyleData(
                                                      padding: const EdgeInsets
                                                          .symmetric(horizontal: 5),
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius
                                                            .circular(7),
                                                        color: AppColor
                                                            .textFieldColor,
                                                        border: Border.all(
                                                            color: AppColor
                                                                .backGroundColor,
                                                            width: 1),
                                                      ),
                                                      elevation: 0,
                                                    ),
                                                    iconStyleData: IconStyleData(
                                                      icon: const Icon(Icons
                                                          .keyboard_arrow_down),
                                                      iconSize: 23,
                                                      iconEnabledColor: AppColor
                                                          .textColor,
                                                      iconDisabledColor: Colors
                                                          .grey,
                                                    ),
                                                    dropdownStyleData: DropdownStyleData(
                                                      maxHeight: 200,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius
                                                            .circular(7),
                                                        color: AppColor
                                                            .textFieldColor,
                                                      ),
                                                      offset: const Offset(0, 0),
                                                      scrollbarTheme: ScrollbarThemeData(
                                                        radius: const Radius
                                                            .circular(7),
                                                        thickness: WidgetStateProperty
                                                            .all(6),
                                                        thumbVisibility: WidgetStateProperty
                                                            .all(true),
                                                      ),
                                                    ),
                                                    menuItemStyleData: const MenuItemStyleData(
                                                      height: 40,
                                                      padding: EdgeInsets.symmetric(
                                                          horizontal: 10),
                                                    ),
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
                                                    inventoryCreateController.walletAccountList.map((wallet){
                                                      return DropdownMenuItem(
                                                          value: wallet,
                                                          child: Row(
                                                            children: [
                                                              Text("${wallet.item?.name} , " ?? "",style: AppTextStyle.bodyText,),
                                                            ],
                                                          ));
                                                    }).toList(),
                                                    value: inventoryCreateController.selectedWalletAccount.value,
                                                    onChanged: (newValue){
                                                      if(newValue!=null) {
                                                        inventoryCreateController.changeSelectedWalletAccount(newValue);
                                                      }
                                                    },
                                                    buttonStyleData: ButtonStyleData(
                                                      padding: const EdgeInsets.symmetric(horizontal: 5),
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(7),
                                                        color: AppColor.textFieldColor,
                                                        border: Border.all(color: AppColor.backGroundColor, width: 1),
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
                                                // مقدار
                                                Container(
                                                  padding: EdgeInsets.only(bottom: 3,top: 5),
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
                                                      controller: inventoryCreateController.amountController,
                                                      style: AppTextStyle.labelText,
                                                      keyboardType: TextInputType.numberWithOptions(decimal: true),
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
                                                  padding: EdgeInsets.only(bottom: 3,top: 5),
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
                                                      controller: inventoryCreateController.impurityController,
                                                      style: AppTextStyle.labelText,
                                                      keyboardType: TextInputType.numberWithOptions(decimal: true),
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
                                                  padding: EdgeInsets.only(bottom: 3,top: 5),
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
                                                      controller: inventoryCreateController.weight750Controller,
                                                      style: AppTextStyle.labelText,
                                                      keyboardType: TextInputType.numberWithOptions(decimal: true),
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
                                                  padding: EdgeInsets.only(bottom: 3,top: 5),
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
                                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                                      controller: inventoryCreateController.caratController,
                                                      style: AppTextStyle.labelText,
                                                      keyboardType: TextInputType.numberWithOptions(decimal: true),
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
                                                  padding: EdgeInsets.only(bottom: 3,top: 5),
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
                                                    controller: inventoryCreateController.receiptNumberController,
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
                                                  padding: EdgeInsets.only(bottom: 3,top: 5),
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
                                                      validator: (value){
                                                        if(value==null || value.isEmpty){
                                                          return 'لطفا تاریخ را انتخاب کنید';
                                                        }
                                                        return null;
                                                      },
                                                      controller: inventoryCreateController.dateController,
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

                                                        if(pickedDate!=null){
                                                          inventoryCreateController.dateController.text =
                                                          "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')} ";
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                // توضیحات
                                                Container(
                                                  padding: EdgeInsets.only(bottom: 3,top: 5),
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
                                                    controller: inventoryCreateController.descriptionController,
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
                                                 SizedBox(width: Get.width*1,height: 200,
                                                   child: Card(color: AppColor.secondaryColor,
                                                      child: Column(
                                                        children: [
                                                          SizedBox(height: 5,),
                                                          Text('آیتم‌های موقت (${inventoryCreateController.tempDetails.length})',style: AppTextStyle.bodyText,),
                                                          Expanded(
                                                            child: ListView.builder(
                                                              shrinkWrap: true,
                                                              itemCount: inventoryCreateController.tempDetails.length,
                                                              itemBuilder: (context, index) {
                                                                final detail = inventoryCreateController.tempDetails[index];
                                                                return Card(color: AppColor.backGroundColor,
                                                                  child: ListTile(
                                                                    title: Text(detail.item?.name ?? '',style: AppTextStyle.bodyText,),
                                                                    subtitle: Text('مقدار: ${detail.amount}',style: AppTextStyle.bodyText,),
                                                                    trailing: IconButton(
                                                                      icon: Icon(Icons.delete,color: AppColor.accentColor,),
                                                                      onPressed: () => inventoryCreateController.tempDetails.removeAt(index),
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
                                                //  دکمه ثبت و ثبت نهایی
                                                SizedBox(height: 20,),
                                                Row(mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    // دکمه ثبت
                                                    ElevatedButton(
                                                      style: ButtonStyle(fixedSize: WidgetStatePropertyAll(Size(Get.width*0.3,40)),
                                                          padding: WidgetStatePropertyAll(
                                                              EdgeInsets.symmetric(horizontal: 7)),
                                                          elevation: WidgetStatePropertyAll(5),
                                                          backgroundColor:
                                                          WidgetStatePropertyAll(AppColor.buttonColor),
                                                          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(10)))),
                                                      onPressed: () async{
                                                        inventoryCreateController.addToTempList();
                                                      },
                                                      child:inventoryCreateController.isLoading.value
                                                          ?
                                                      CircularProgressIndicator(
                                                        valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor),
                                                      ) :
                                                      Text(
                                                        'ثبت موقت',
                                                        style: AppTextStyle.bodyText,
                                                      ),
                                                    ),

                                                    SizedBox(width: 10,),
                                                    // دکمه ثبت نهایی
                                                    ElevatedButton(
                                                      style: ButtonStyle(fixedSize: WidgetStatePropertyAll(Size(Get.width*0.3,40)),
                                                          padding: WidgetStatePropertyAll(
                                                              EdgeInsets.symmetric(horizontal: 7)),
                                                          elevation: WidgetStatePropertyAll(5),
                                                          backgroundColor:
                                                          WidgetStatePropertyAll(AppColor.primaryColor),
                                                          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(10)))),
                                                      onPressed: () async{
                                                        inventoryCreateController.submitFinalInventory();
                                                      },
                                                      child:inventoryCreateController.isFinalizing.value
                                                          ?
                                                      CircularProgressIndicator(
                                                        valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor),
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
                                          ),
                                        ),
                                      ),


                                      // TabBar 2 پرداخت
                                      SingleChildScrollView(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                          child: Form(
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
                                                  child: DropdownButton2(
                                                    isExpanded: true,
                                                    hint: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            "انتخاب کنید",
                                                            style: AppTextStyle
                                                                .labelText.copyWith(
                                                              fontSize: 14,
                                                              color: AppColor
                                                                  .textColor,
                                                            ),
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    items: inventoryCreateController
                                                        .accountList.map((account) {
                                                      return DropdownMenuItem(
                                                          value: account,
                                                          child: Text(
                                                            account.name ?? "",
                                                            style: AppTextStyle
                                                                .bodyText,));
                                                    }).toList(),
                                                    value: inventoryCreateController
                                                        .selectedAccount.value,
                                                    onChanged: (newValue) {
                                                      if (newValue != null) {
                                                        inventoryCreateController
                                                            .changeSelectedAccount(
                                                            newValue);
                                                      }
                                                    },
                                                    buttonStyleData: ButtonStyleData(
                                                      padding: const EdgeInsets
                                                          .symmetric(horizontal: 5),
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius
                                                            .circular(7),
                                                        color: AppColor
                                                            .textFieldColor,
                                                        border: Border.all(
                                                            color: AppColor
                                                                .backGroundColor,
                                                            width: 1),
                                                      ),
                                                      elevation: 0,
                                                    ),
                                                    iconStyleData: IconStyleData(
                                                      icon: const Icon(Icons
                                                          .keyboard_arrow_down),
                                                      iconSize: 23,
                                                      iconEnabledColor: AppColor
                                                          .textColor,
                                                      iconDisabledColor: Colors
                                                          .grey,
                                                    ),
                                                    dropdownStyleData: DropdownStyleData(
                                                      maxHeight: 200,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius
                                                            .circular(7),
                                                        color: AppColor
                                                            .textFieldColor,
                                                      ),
                                                      offset: const Offset(0, 0),
                                                      scrollbarTheme: ScrollbarThemeData(
                                                        radius: const Radius
                                                            .circular(7),
                                                        thickness: WidgetStateProperty
                                                            .all(6),
                                                        thumbVisibility: WidgetStateProperty
                                                            .all(true),
                                                      ),
                                                    ),
                                                    menuItemStyleData: const MenuItemStyleData(
                                                      height: 40,
                                                      padding: EdgeInsets.symmetric(
                                                          horizontal: 10),
                                                    ),
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
                                                    inventoryCreateController.walletAccountList.map((wallet){
                                                      return DropdownMenuItem(
                                                          value: wallet,
                                                          child: Row(
                                                            children: [
                                                              Text("${wallet.item?.name} , " ?? "",style: AppTextStyle.bodyText,),
                                                            ],
                                                          ));
                                                    }).toList(),
                                                    value: inventoryCreateController.selectedWalletAccount.value,
                                                    onChanged: (newValue){
                                                      if(newValue!=null) {
                                                        inventoryCreateController.changeSelectedWalletAccount(newValue);
                                                      }
                                                    },
                                                    buttonStyleData: ButtonStyleData(
                                                      padding: const EdgeInsets.symmetric(horizontal: 5),
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(7),
                                                        color: AppColor.textFieldColor,
                                                        border: Border.all(color: AppColor.backGroundColor, width: 1),
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
                                                // مقدار
                                                Container(
                                                  padding: EdgeInsets.only(bottom: 3,top: 5),
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
                                                      controller: inventoryCreateController.amountController,
                                                      style: AppTextStyle.labelText,
                                                      keyboardType: TextInputType.numberWithOptions(decimal: true),
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
                                                  padding: EdgeInsets.only(bottom: 3,top: 5),
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
                                                      controller: inventoryCreateController.impurityController,
                                                      style: AppTextStyle.labelText,
                                                      keyboardType: TextInputType.numberWithOptions(decimal: true),
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
                                                  padding: EdgeInsets.only(bottom: 3,top: 5),
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
                                                      controller: inventoryCreateController.weight750Controller,
                                                      style: AppTextStyle.labelText,
                                                      keyboardType: TextInputType.numberWithOptions(decimal: true),
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
                                                  padding: EdgeInsets.only(bottom: 3,top: 5),
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
                                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                                      controller: inventoryCreateController.caratController,
                                                      style: AppTextStyle.labelText,
                                                      keyboardType: TextInputType.numberWithOptions(decimal: true),
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
                                                  padding: EdgeInsets.only(bottom: 3,top: 5),
                                                  child: Text(
                                                    'شماره قبض',
                                                    style: AppTextStyle.labelText,
                                                  ),
                                                ),
                                                // شماره قبض
                                                Container(
                                                  //height: 50,
                                                  padding: EdgeInsets.only(bottom: 5),
                                                  child:
                                                  IntrinsicHeight(
                                                    child: TextFormField(
                                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                                      controller: inventoryCreateController.receiptNumberController,
                                                      style: AppTextStyle.labelText,
                                                      keyboardType: TextInputType.numberWithOptions(decimal: true),
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
                                                // تاریخ
                                                Container(
                                                  padding: EdgeInsets.only(bottom: 3,top: 5),
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
                                                      validator: (value){
                                                        if(value==null || value.isEmpty){
                                                          return 'لطفا تاریخ را انتخاب کنید';
                                                        }
                                                        return null;
                                                      },
                                                      controller: inventoryCreateController.dateController,
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

                                                        if(pickedDate!=null){
                                                          inventoryCreateController.dateController.text =
                                                          "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";

                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                // توضیحات
                                                Container(
                                                  padding: EdgeInsets.only(bottom: 3,top: 5),
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
                                                    controller: inventoryCreateController.descriptionController,
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
                                                SizedBox(width: Get.width*1,height: 200,
                                                  child: Card(color: AppColor.secondaryColor,
                                                    child: Column(
                                                      children: [
                                                        SizedBox(height: 5,),
                                                        Text('آیتم‌های موقت (${inventoryCreateController.tempDetails.length})',style: AppTextStyle.bodyText,),
                                                        Expanded(
                                                          child: ListView.builder(
                                                            shrinkWrap: true,
                                                            itemCount: inventoryCreateController.tempDetails.length,
                                                            itemBuilder: (context, index) {
                                                              final detail = inventoryCreateController.tempDetails[index];
                                                              return Card(color: AppColor.backGroundColor,
                                                                child: ListTile(
                                                                  title: Text(detail.item?.name ?? '',style: AppTextStyle.bodyText,),
                                                                  subtitle: Text('مقدار: ${detail.amount}',style: AppTextStyle.bodyText,),
                                                                  trailing: IconButton(
                                                                    icon: Icon(Icons.delete,color: AppColor.accentColor,),
                                                                    onPressed: () => inventoryCreateController.tempDetails.removeAt(index),
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
                                                //  دکمه ثبت و ثبت نهایی
                                                Row(mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    // دکمه ثبت
                                                    ElevatedButton(
                                                      style: ButtonStyle(fixedSize: WidgetStatePropertyAll(Size(Get.width*0.3,40)),
                                                          padding: WidgetStatePropertyAll(
                                                              EdgeInsets.symmetric(horizontal: 7)),
                                                          elevation: WidgetStatePropertyAll(5),
                                                          backgroundColor:
                                                          WidgetStatePropertyAll(AppColor.buttonColor),
                                                          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(10)))),
                                                      onPressed: () async{
                                                        inventoryCreateController.addToTempList();
                                                      },
                                                      child:inventoryCreateController.isLoading.value
                                                          ?
                                                      CircularProgressIndicator(
                                                        valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor),
                                                      ) :
                                                      Text(
                                                        'ثبت',
                                                        style: AppTextStyle.bodyText,
                                                      ),
                                                    ),

                                                    SizedBox(width: 10,),
                                                    // دکمه ثبت نهایی
                                                    ElevatedButton(
                                                      style: ButtonStyle(fixedSize: WidgetStatePropertyAll(Size(Get.width*0.3,40)),
                                                          padding: WidgetStatePropertyAll(
                                                              EdgeInsets.symmetric(horizontal: 7)),
                                                          elevation: WidgetStatePropertyAll(5),
                                                          backgroundColor:
                                                          WidgetStatePropertyAll(AppColor.primaryColor),
                                                          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(10)))),
                                                      onPressed: () async{
                                                        inventoryCreateController.submitFinalInventory();
                                                      },
                                                      child:inventoryCreateController.isFinalizing.value
                                                          ?
                                                      CircularProgressIndicator(
                                                        valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor),
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
                                          ),
                                        ),
                                      ),
                                    ]
                                );
                              }),
                            )
                          ],
                        )
                    ),
          ),
      ),
    );
  }
}
