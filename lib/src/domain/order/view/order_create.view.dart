import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/order/controller/order_create.controller.dart';
import 'package:hanigold_admin/src/widget/custom_dropdown.widget.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../config/const/app_color.dart';
import '../../../widget/custom_appbar.widget.dart';
import '../../account/model/account.model.dart';

class OrderCreateView extends StatefulWidget {
  OrderCreateView({super.key});

  @override
  State<OrderCreateView> createState() => _OrderCreateViewState();
}

class _OrderCreateViewState extends State<OrderCreateView> {
  final formKey = GlobalKey<FormState>();

  OrderCreateController orderCreateController =
  Get.find<OrderCreateController>();

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    return Scaffold(
      appBar:isDesktop ? AppBar(
        iconTheme: IconThemeData(color: AppColor.textColor,),
      ) :
       CustomAppBar(
        title: 'ایجاد سفارش جدید',onBackTap: () {
        Get.back();
        orderCreateController.clearList();
      },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: ResponsiveRowColumn(
              layout:isDesktop ? ResponsiveRowColumnType.ROW : ResponsiveRowColumnType.COLUMN,
              columnSpacing: 15,
              rowSpacing: 20,
              rowCrossAxisAlignment: CrossAxisAlignment.start,
              rowMainAxisAlignment: MainAxisAlignment.start,
              columnCrossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(isMobile)
                ResponsiveRowColumnItem(
                  rowFlex: 1,
                  child: Container(
                      width: 300,
                      margin: EdgeInsets.only(right: 20),
                      child:
                      Card(color: AppColor.secondaryColor,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'تراز کاربر',
                                style: AppTextStyle.smallTitleText.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                  ),
                ),
                ResponsiveRowColumnItem(
                  rowFlex: 1,
                  child: SizedBox(
                    width: Get.width*0.9,
                    height: Get.height,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ResponsiveRowColumnItem(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 40,bottom: 10),
                                child: Text(
                                  'سفارش جدید',
                                  style: AppTextStyle.smallTitleText,
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                    onTap: (){
                                      Get.back();
                                      orderCreateController.clearList();
                                    },
                                    child:Padding(
                                      padding: EdgeInsets.only(right: isDesktop ? 200 : 135),
                                      child: Row(mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text('لیست سفارشات',style: AppTextStyle.smallTitleText,),
                                          SizedBox(width: 10,),
                                          SvgPicture.asset('assets/svg/list.svg',alignment: Alignment.centerLeft,
                                            width: 21,
                                            height: 26,
                                            colorFilter: ColorFilter.mode(AppColor.textColor, BlendMode.srcIn),),
                                        ],
                                      ),
                                    )

                                ),
                              ),
                            ],
                          ),
                        ),
                        ResponsiveRowColumnItem(
                            child: isDesktop ? SizedBox( width: 480,
                              child: Divider(
                                height: 1,
                                color: AppColor.appBarColor,
                              ),
                            ) : SizedBox( width: 420,
                              child: Divider(
                                height: 1,
                                color: AppColor.appBarColor,
                              ),
                            ),
                        ),
                        ResponsiveRowColumnItem(
                          rowFlex: 1,
                          child: Container(
                            constraints: isDesktop ? BoxConstraints(maxWidth: 500) : BoxConstraints(maxWidth: 400),
                            padding: isDesktop
                                  ? const EdgeInsets.symmetric(horizontal: 40)
                                  : const EdgeInsets.symmetric(horizontal: 24),
                              child: Obx(() {
                                return Form(
                                  key:formKey,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // خرید/فروش
                                      Container(
                                        padding: EdgeInsets.only(bottom: 3,top: 10),
                                        child: Text(
                                          'خرید/فروش',
                                          style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10),
                                        ),
                                      ),
                                      // خرید/فروش
                                      Container(
                                        padding: EdgeInsets.only(bottom: 5),
                                        child: CustomDropdownWidget(
                                          validator: (value) {
                                            if (value == 'انتخاب کنید' || value == null || value.isEmpty) {
                                              return 'نوع سفارش را انتخاب کنید';
                                            }
                                            return null;
                                          },
                                            items:  [
                                              'انتخاب کنید',
                                              ...orderCreateController.orderTypeList
                                                  .where((type) => type.id != null)
                                                  .map((type) => type.name ?? '')
                                            ].toList(),
                                            selectedValue: orderCreateController.selectedBuySell.value?.name ?? '',
                                            onChanged: (String? newValue){
                                              if (newValue == 'انتخاب کنید') {
                                                orderCreateController.changeSelectedBuySell(null);
                                              } else {
                                                var selectedBuySell = orderCreateController.orderTypeList
                                                    .firstWhere((type) => type.name == newValue);
                                                orderCreateController.changeSelectedBuySell(selectedBuySell);
                                              }
                                            },
                                          backgroundColor: AppColor.textFieldColor,
                                          borderRadius: 7,
                                          borderColor: AppColor.secondaryColor,
                                          hideUnderline: true,
                                        ),
                                      ),
                                      // محصول
                                      Container(
                                        padding: EdgeInsets.only(bottom: 3,top: 5),
                                        child: Text(
                                          'محصول',
                                          style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10),
                                        ),
                                      ),
                                      // محصول
                                      Container(
                                        padding: EdgeInsets.only(bottom: 5),
                                        child: CustomDropdownWidget(
                                          validator: (value) {
                                            if (value == 'انتخاب کنید' || value == null || value.isEmpty) {
                                              return 'محصول را انتخاب کنید';
                                            }
                                            return null;
                                          },
                                          items: [
                                            'انتخاب کنید',
                                            ...orderCreateController.itemList.map((item) => item.name ?? '')
                                          ].toList(),
                                          selectedValue: orderCreateController.selectedItem.value?.name,
                                          onChanged: (String? newValue){
                                            if (newValue == 'انتخاب کنید') {
                                              orderCreateController.changeSelectedItem(null);
                                            } else {
                                              var selectedItem = orderCreateController.itemList
                                                  .firstWhere((item) => item.name == newValue);
                                              orderCreateController.changeSelectedItem(selectedItem);
                                            }
                                          },
                                          backgroundColor: AppColor.textFieldColor,
                                          borderRadius: 7,
                                          borderColor: AppColor.secondaryColor,
                                          hideUnderline: true,
                                        ),
                                      ),
                                      // کاربر
                                      Container(
                                        padding: EdgeInsets.only(bottom: 3,top: 5),
                                        child: Text(
                                          'کاربر',
                                          style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10),
                                        ),
                                      ),
                                      // کاربر
                                      Container(
                                        padding: EdgeInsets.only(bottom: 5),
                                        child:
                                        CustomDropdownWidget(

                                          dropdownSearchData: DropdownSearchData<String>(
                                          searchController: orderCreateController
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
                                              controller: orderCreateController
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
                                        value: orderCreateController.selectedAccount.value,
                                          validator: (value) {
                                            if (value == 'انتخاب کنید' || value == null || value.isEmpty) {
                                              return 'کاربر را انتخاب کنید';
                                            }
                                            return null;
                                          },
                                          showSearchBox: true,
                                          items: [
                                            'انتخاب کنید',
                                            ...orderCreateController.searchedAccounts.map((account) => account.name ?? "")
                                          ].toList(),
                                          selectedValue: orderCreateController.selectedAccount.value?.name,
                                          onChanged: (String? newValue){
                                            if (newValue == 'انتخاب کنید') {
                                              orderCreateController.changeSelectedAccount(null);
                                            } else {
                                              var selectedAccount = orderCreateController.searchedAccounts
                                                  .firstWhere((account) => account.name == newValue);
                                              orderCreateController.changeSelectedAccount(selectedAccount);
                                            }
                                          },
                                          onMenuStateChange: (isOpen) {
                                            if (!isOpen) {
                                              orderCreateController.resetAccountSearch();
                                            }else{

                                            }
                                          },
                                          backgroundColor: AppColor.textFieldColor,
                                          borderRadius: 7,
                                          borderColor: AppColor.secondaryColor,
                                          hideUnderline: true,
                                        ),
                                      ),
                                      // قیمت
                                      Container(
                                        padding: EdgeInsets.only(bottom: 3,top: 5),
                                        child: Text(
                                          'قیمت (ریال)',
                                          style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10),
                                        ),
                                      ),
                                      // قیمت
                                      Container(
                                        height: 50,
                                        padding: EdgeInsets.only(bottom: 5),
                                        child:
                                        TextFormField(
                                          controller: orderCreateController.priceController,
                                          style: AppTextStyle.labelText,
                                          keyboardType: TextInputType.number,
                                          onChanged: (value) {
                                            // حذف کاماهای قبلی و فرمت جدید
                                            String cleanedValue = value.replaceAll(',', '');
                                            if (cleanedValue.isNotEmpty) {
                                              orderCreateController.priceController.text =
                                                  cleanedValue.toPersianDigit().seRagham();
                                              orderCreateController.priceController.selection =
                                                  TextSelection.collapsed(
                                                      offset: orderCreateController.priceController.text.length);
                                            }
                                          },
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            filled: true,
                                            fillColor: AppColor.textFieldColor,
                                          ),
                                        ),
                                      ),
                                      // گرم/عدد
                                      Container(
                                        padding: EdgeInsets.only(bottom: 3,top: 5),
                                        child: Text(
                                          'گرم/عدد',
                                          style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10),
                                        ),
                                      ),
                                      // گرم/عدد
                                      orderCreateController.selectedBuySell.value?.name=='فروش به کاربر' ?
                                      SizedBox(
                                        height: 70,
                                        child: Container(
                                          padding: EdgeInsets.only(bottom: 5),
                                          child:
                                          IntrinsicHeight(
                                            child: TextFormField(
                                              validator: (value){
                                                if(value==null || value.isEmpty){
                                                  return 'لطفا مقدار سفارش را وارد کنید';
                                                }
                                                return null;
                                              },
                                              onChanged: (value) {
                                                setState(() {
                                                  int item=int.parse(value.replaceAll(" ", "").toEnglishDigit());
                                                  if(item>=orderCreateController.maxItemSell.value){
                                                    orderCreateController.quantityController.text=orderCreateController.maxItemSell.value.toString();
                                                    print(item);
                                                  }
                                                });
                                              },
                                              autovalidateMode: AutovalidateMode.onUserInteraction,
                                              controller: orderCreateController.quantityController,
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
                                      )
                                      : SizedBox(
                                        height: 70,
                                        child: Container(
                                          padding: EdgeInsets.only(bottom: 5),
                                          child:
                                          IntrinsicHeight(
                                            child: TextFormField(
                                              validator: (value){
                                                if(value==null || value.isEmpty){
                                                  return 'لطفا مقدار سفارش را وارد کنید';
                                                }
                                                return null;
                                              },
                                              onChanged: (value) {
                                                setState(() {
                                                  int item=int.parse(value.replaceAll(" ", "").toEnglishDigit());
                                                  if(item>=orderCreateController.maxItemBuy.value){
                                                    orderCreateController.quantityController.text=orderCreateController.maxItemBuy.value.toString();
                                                    print(item);
                                                  }
                                                });
                                              },
                                              autovalidateMode: AutovalidateMode.onUserInteraction,
                                              controller: orderCreateController.quantityController,
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
                                      ),
                                      orderCreateController.selectedBuySell.value?.name=='فروش به کاربر' ?
                                      Row(
                                        children: [
                                          Text(' حداکثر مقدار فروش برای این محصول: ',style: AppTextStyle.labelText,),
                                          Text('${orderCreateController.maxItemSell.value}',style: AppTextStyle.bodyText.copyWith(color: AppColor.primaryColor),)
                                        ],
                                      )
                                      :
                                      Row(
                                        children: [
                                          Text(' حداکثر مقدار خرید برای این محصول: ',style: AppTextStyle.labelText,),
                                          Text('${orderCreateController.maxItemBuy.value}',style: AppTextStyle.bodyText.copyWith(color: AppColor.primaryColor),)
                                        ],
                                      ),
                                      SizedBox(height: 5,),
                                      // مبلغ کل
                                      Container(
                                        padding: EdgeInsets.only(bottom: 3,top: 5),
                                        child: Text(
                                          'مبلغ کل (ریال)',
                                          style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10),
                                        ),
                                      ),
                                      // مبلغ کل
                                      Container(
                                        height: 50,
                                        padding: EdgeInsets.only(bottom: 5),
                                        child:
                                        TextFormField(
                                          controller: orderCreateController.totalPriceController,
                                          style: AppTextStyle.labelText,
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                                          style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10),
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
                                            controller: orderCreateController.dateController,
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
                                              DateTime date=DateTime.now();

                                              if(pickedDate!=null){
                                                orderCreateController.dateController.text =
                                                 "${pickedDate.year}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}";

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
                                          style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10),
                                        ),
                                      ),
                                      // توضیحات
                                      Container(
                                        padding: EdgeInsets.only(bottom: 5),
                                        child:
                                        TextFormField(
                                          controller: orderCreateController.descriptionController,
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
                                      // دکمه ایجاد سفارش
                                      SizedBox(height: 20,),
                                          orderCreateController.selectedBuySell.value?.name=='خرید از کاربر'?
                                          SizedBox(width: double.infinity,
                                            height: 40,
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                  padding: WidgetStatePropertyAll(
                                                      EdgeInsets.symmetric(horizontal: 7)),
                                                  elevation: WidgetStatePropertyAll(5),
                                                  backgroundColor:
                                                  WidgetStatePropertyAll(AppColor.primaryColor),
                                                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10)))),
                                              onPressed: () async{if(formKey.currentState!.validate()) {
                                                        await orderCreateController.insertOrder();

                                              }
                                              },
                                              child:orderCreateController.isLoading.value
                                                  ?
                                              CircularProgressIndicator(
                                                valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor),
                                              ) :
                                              Text(
                                                'ایجاد سفارش خرید',
                                                style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10)
                                              ),
                                            ),
                                          ) :
                                          SizedBox(width: double.infinity,
                                            height: 40,
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                  padding: WidgetStatePropertyAll(
                                                      EdgeInsets.symmetric(horizontal: 7)),
                                                  elevation: WidgetStatePropertyAll(5),
                                                  backgroundColor:
                                                  WidgetStatePropertyAll(AppColor.accentColor),
                                                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10)))),
                                              onPressed: () async {if(formKey.currentState!.validate()) {
                                                await orderCreateController.insertOrder();

                                                      }
                                                    },
                                                    child: orderCreateController.isLoading.value
                                                        ?
                                                    CircularProgressIndicator(
                                                      valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor),
                                                    ) :
                                              Text(
                                                'ایجاد سفارش فروش',
                                                style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10),
                                              ),
                                            ),
                                          )
                                    ],
                                  ),
                                );
                              }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if(isDesktop)
                  ResponsiveRowColumnItem(
                    rowFlex: 1,
                    child: Container(
                        width: 300,
                        margin: EdgeInsets.only(right: 20),
                        child:
                        Card(color: AppColor.secondaryColor,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'تراز کاربر',
                                  style: AppTextStyle.smallTitleText.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
