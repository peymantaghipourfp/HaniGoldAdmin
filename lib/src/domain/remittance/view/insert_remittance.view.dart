import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/widget/custom_appbar1.widget.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../widget/background_image.widget.dart';
import '../../../widget/custom_appbar.widget.dart';
import '../../../widget/custom_dropdown.widget.dart';
import '../controller/remittance.controller.dart';


class InsertRemittanceView extends StatefulWidget {
  const InsertRemittanceView({super.key});

  @override
  State<InsertRemittanceView> createState() => _InsertRemittanceViewState();
}

class _InsertRemittanceViewState extends State<InsertRemittanceView> {

  var controller=Get.find<RemittanceController>();


  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    return Obx(()=>Scaffold(
      appBar: CustomAppbar1(
        title: 'ایجاد حواله', onBackTap: () => Get.back(),),
      body: Stack(
        children: [
          BackgroundImage(),
          SafeArea(
            child: SizedBox(
              height: Get.height,
              width: Get.width,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 10,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: Get.width * 0.48,
                          //height: controller.isOpenMore.value?300:200,
                          constraints: BoxConstraints(
                            // maxHeight: controller.isOpenMore.value?300:120,
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 15),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColor.secondaryColor
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'بدهکار: جعفرنیا (حساب تجارت) ',
                                    style: AppTextStyle.labelText.copyWith(fontSize: 14,
                                      fontWeight: FontWeight.bold, ),
                                  ),
                                ],
                              ),
                              const Divider(height: 10.0,color: Colors.white,thickness: 0.5,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'طلای آب شده',
                                    style: AppTextStyle.labelText.copyWith(fontSize: 14,
                                      fontWeight: FontWeight.normal, ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    '2.5 گرم',
                                    style: AppTextStyle.labelText.copyWith(fontSize: 14,
                                        fontWeight: FontWeight.normal, color: AppColor.primaryColor),
                                  ),
                                ],
                              ),
                              const Divider(height: 10.0,color: Colors.white,thickness: 0.2,),
                              GestureDetector(
                                onTap: (){
                                  controller.isOpenMore.value= !controller.isOpenMore.value;
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'مشاهده جزییات',
                                      style: AppTextStyle.labelText.copyWith(fontSize: 13,
                                          fontWeight: FontWeight.normal,color: AppColor.iconViewColor ),
                                    ),
                                    Icon(
                                      controller.isOpenMore.value ? Icons.expand_less : Icons.expand_more,size: 20,
                                      color: controller.isOpenMore.value ?
                                      AppColor.iconViewColor :
                                      AppColor.iconViewColor,
                                    ),
                                  ],
                                ),
                              ),
                              AnimatedSize(
                                duration: Duration(
                                    milliseconds: 500),
                                curve: Curves.easeInOut,
                                child:controller.isOpenMore.value ? Container(

                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: AppColor.secondaryColor
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 5,
                                                backgroundColor: AppColor.textColor,
                                              ),
                                              SizedBox(width: 5,),
                                              Text(
                                                'وجه نقد',
                                                style: AppTextStyle.labelText.copyWith(fontSize: 13,
                                                    fontWeight: FontWeight.normal,color: AppColor.iconViewColor ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            '1000 ریال',
                                            style: AppTextStyle.labelText.copyWith(fontSize: 14,
                                                fontWeight: FontWeight.normal,color: AppColor.textColor ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 5,
                                                backgroundColor: AppColor.textColor,
                                              ),
                                              SizedBox(width: 5,),
                                              Text(
                                                'طلای آب شده',
                                                style: AppTextStyle.labelText.copyWith(fontSize: 13,
                                                    fontWeight: FontWeight.normal,color: AppColor.iconViewColor ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            '10 گرم',
                                            style: AppTextStyle.labelText.copyWith(fontSize: 14,
                                                fontWeight: FontWeight.normal,color: AppColor.textColor ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 5,
                                                backgroundColor: AppColor.textColor,
                                              ),
                                              SizedBox(width: 5,),
                                              Text(
                                                'تمام سکه بانکی',
                                                style: AppTextStyle.labelText.copyWith(fontSize: 13,
                                                    fontWeight: FontWeight.normal,color: AppColor.iconViewColor ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            '1 عدد',
                                            style: AppTextStyle.labelText.copyWith(fontSize: 14,
                                                fontWeight: FontWeight.normal,color: AppColor.textColor ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 5,
                                                backgroundColor: AppColor.textColor,
                                              ),
                                              SizedBox(width: 5,),
                                              Text(
                                                'نیم سکه بانکی',
                                                style: AppTextStyle.labelText.copyWith(fontSize: 13,
                                                    fontWeight: FontWeight.normal,color: AppColor.iconViewColor ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            '1 عدد',
                                            style: AppTextStyle.labelText.copyWith(fontSize: 14,
                                                fontWeight: FontWeight.normal,color: AppColor.textColor ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 5,
                                                backgroundColor: AppColor.textColor,
                                              ),
                                              SizedBox(width: 5,),
                                              Text(
                                                'ربع سکه بانکی',
                                                style: AppTextStyle.labelText.copyWith(fontSize: 13,
                                                    fontWeight: FontWeight.normal,color: AppColor.iconViewColor ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            '1 عدد',
                                            style: AppTextStyle.labelText.copyWith(fontSize: 14,
                                                fontWeight: FontWeight.normal,color: AppColor.textColor ),
                                          ),
                                        ],
                                      ),
                                      const Divider(height: 10.0,color: Colors.white,thickness: 0.2,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'تراز کل',
                                                style: AppTextStyle.labelText.copyWith(fontSize: 14,
                                                    fontWeight: FontWeight.normal,color: AppColor.iconViewColor ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            '1300 ریال',
                                            style: AppTextStyle.labelText.copyWith(fontSize: 14,
                                                fontWeight: FontWeight.normal,color: AppColor.textColor ),
                                          ),
                                        ],
                                      ),

                                    ],
                                  ),
                                ):SizedBox(),
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: Get.width * 0.48,
                          //height: controller.isOpenMore.value?300:200,
                          constraints: BoxConstraints(
                            // maxHeight: controller.isOpenMore.value?300:120,
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 15),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColor.secondaryColor
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'بدهکار: جعفرنیا (حساب تجارت) ',
                                    style: AppTextStyle.labelText.copyWith(fontSize: 14,
                                      fontWeight: FontWeight.bold, ),
                                  ),
                                ],
                              ),
                              const Divider(height: 10.0,color: Colors.white,thickness: 0.5,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'طلای آب شده',
                                    style: AppTextStyle.labelText.copyWith(fontSize: 14,
                                      fontWeight: FontWeight.normal, ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    '2.5 گرم',
                                    style: AppTextStyle.labelText.copyWith(fontSize: 14,
                                        fontWeight: FontWeight.normal, color: AppColor.primaryColor),
                                  ),
                                ],
                              ),
                              const Divider(height: 10.0,color: Colors.white,thickness: 0.2,),
                              GestureDetector(
                                onTap: (){
                                  controller.isOpenMoreB.value= !controller.isOpenMoreB.value;
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'مشاهده جزییات',
                                      style: AppTextStyle.labelText.copyWith(fontSize: 13,
                                          fontWeight: FontWeight.normal,color: AppColor.iconViewColor ),
                                    ),
                                    Icon(
                                      controller.isOpenMoreB.value ? Icons.expand_less : Icons.expand_more,size: 20,
                                      color: controller.isOpenMoreB.value ?
                                      AppColor.iconViewColor :
                                      AppColor.iconViewColor,
                                    ),
                                  ],
                                ),
                              ),
                              AnimatedSize(
                                duration: Duration(
                                    milliseconds: 500),
                                curve: Curves.easeInOut,
                                child:controller.isOpenMoreB.value ? Container(

                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: AppColor.secondaryColor
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 5,
                                                backgroundColor: AppColor.textColor,
                                              ),
                                              SizedBox(width: 5,),
                                              Text(
                                                'وجه نقد',
                                                style: AppTextStyle.labelText.copyWith(fontSize: 13,
                                                    fontWeight: FontWeight.normal,color: AppColor.iconViewColor ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            '1000 ریال',
                                            style: AppTextStyle.labelText.copyWith(fontSize: 14,
                                                fontWeight: FontWeight.normal,color: AppColor.textColor ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 5,
                                                backgroundColor: AppColor.textColor,
                                              ),
                                              SizedBox(width: 5,),
                                              Text(
                                                'طلای آب شده',
                                                style: AppTextStyle.labelText.copyWith(fontSize: 13,
                                                    fontWeight: FontWeight.normal,color: AppColor.iconViewColor ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            '10 گرم',
                                            style: AppTextStyle.labelText.copyWith(fontSize: 14,
                                                fontWeight: FontWeight.normal,color: AppColor.textColor ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 5,
                                                backgroundColor: AppColor.textColor,
                                              ),
                                              SizedBox(width: 5,),
                                              Text(
                                                'تمام سکه بانکی',
                                                style: AppTextStyle.labelText.copyWith(fontSize: 13,
                                                    fontWeight: FontWeight.normal,color: AppColor.iconViewColor ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            '1 عدد',
                                            style: AppTextStyle.labelText.copyWith(fontSize: 14,
                                                fontWeight: FontWeight.normal,color: AppColor.textColor ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 5,
                                                backgroundColor: AppColor.textColor,
                                              ),
                                              SizedBox(width: 5,),
                                              Text(
                                                'نیم سکه بانکی',
                                                style: AppTextStyle.labelText.copyWith(fontSize: 13,
                                                    fontWeight: FontWeight.normal,color: AppColor.iconViewColor ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            '1 عدد',
                                            style: AppTextStyle.labelText.copyWith(fontSize: 14,
                                                fontWeight: FontWeight.normal,color: AppColor.textColor ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 5,
                                                backgroundColor: AppColor.textColor,
                                              ),
                                              SizedBox(width: 5,),
                                              Text(
                                                'ربع سکه بانکی',
                                                style: AppTextStyle.labelText.copyWith(fontSize: 13,
                                                    fontWeight: FontWeight.normal,color: AppColor.iconViewColor ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            '1 عدد',
                                            style: AppTextStyle.labelText.copyWith(fontSize: 14,
                                                fontWeight: FontWeight.normal,color: AppColor.textColor ),
                                          ),
                                        ],
                                      ),
                                      const Divider(height: 10.0,color: Colors.white,thickness: 0.2,),

                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [

                                                Text(
                                                  'تراز کل',
                                                  style: AppTextStyle.labelText.copyWith(fontSize: 14,
                                                      fontWeight: FontWeight.normal,color: AppColor.iconViewColor ),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              '1300 ریال',
                                              style: AppTextStyle.labelText.copyWith(fontSize: 14,
                                                  fontWeight: FontWeight.normal,color: AppColor.textColor ),
                                            ),
                                          ],
                                        ),
                                      ),

                                    ],
                                  ),
                                ):SizedBox(),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: Get.width ,
                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 15),
                      margin: EdgeInsets.symmetric(horizontal: 20,vertical: 30),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColor.secondaryColor
                      ),
                      child: Column(
                        children: [
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'ایجاد حواله',
                                    style: AppTextStyle.labelText.copyWith(fontSize: 15,
                                        fontWeight: FontWeight.bold,color: AppColor.textColor ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20,),
                              GridView(
                                primary: true,
                                shrinkWrap: true,
                                gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio:isDesktop? 7.5: 5,
                                  crossAxisCount:isDesktop? 2:1,
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 5,
                                ),
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'نام بستانکار',
                                        style: AppTextStyle.labelText.copyWith(fontSize: 13,
                                            fontWeight: FontWeight.normal,color: AppColor.textColor ),
                                      ),
                                      IntrinsicHeight(
                                        child: TextFormField(
                                          autovalidateMode: AutovalidateMode.onUserInteraction,
                                           controller: controller.namePayerController,
                                          style: AppTextStyle.labelText,
                                          readOnly: true,

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
                                            contentPadding: const EdgeInsets.symmetric(vertical: 17, ),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            filled: true,
                                            fillColor: AppColor.textFieldColor,
                                            errorMaxLines: 1,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'شماره بستانکار',
                                        style: AppTextStyle.labelText.copyWith(fontSize: 13,
                                            fontWeight: FontWeight.normal,color: AppColor.textColor ),
                                      ),
                                      IntrinsicHeight(
                                        child: TextFormField(
                                          autovalidateMode: AutovalidateMode.onUserInteraction,
                                           controller: controller.mobilePayerController,
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
                                            contentPadding: const EdgeInsets.symmetric(vertical: 17, ),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            filled: true,
                                            fillColor: AppColor.textFieldColor,
                                            errorMaxLines: 1,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'بستانکار(دریافت)',
                                        style: AppTextStyle.labelText.copyWith(fontSize: 13,
                                            fontWeight: FontWeight.normal,color: AppColor.textColor ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                            bottom: 5),
                                        child:
                                        CustomDropdownWidget(

                                          dropdownSearchData: DropdownSearchData<String>(
                                            searchController: controller
                                                .searchControllerP,
                                            searchInnerWidgetHeight: 50,
                                            searchInnerWidget: Container(
                                              height: 50,
                                              padding: const EdgeInsets.only(
                                                top: 8,
                                                right: 15,
                                                left: 15,
                                              ),
                                              child: TextFormField(style: AppTextStyle.bodyText,
                                                controller: controller
                                                    .searchControllerP,
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
                                          value: controller.selectedAccountP.value,
                                          /*validator: (value) {
                          if (value == 'انتخاب کنید' || value == null || value.isEmpty) {
                            return 'کاربر را انتخاب کنید';
                          }
                          return null;
                        },*/
                                          showSearchBox: true,
                                          items: [
                                            'انتخاب کنید',
                                            ...controller.searchedAccountsP.map((
                                                account) => account.name ?? "")
                                          ].toList(),
                                          selectedValue: controller.selectedAccountP
                                              .value?.name,
                                          onChanged: (String? newValue) {
                                            if (newValue == 'انتخاب کنید') {
                                              controller.changeSelectedAccountP(null);
                                            } else {
                                              var selectedAccount = controller
                                                  .searchedAccountsP
                                                  .firstWhere((account) => account.name == newValue);
                                              controller.changeSelectedAccountP(
                                                  selectedAccount);
                                            }
                                          },
                                          onMenuStateChange: (isOpen) {
                                            if (!isOpen) {
                                              controller.resetAccountSearchP();
                                            }
                                          },
                                          backgroundColor: AppColor.textFieldColor,
                                          borderRadius: 7,
                                          borderColor: AppColor.secondaryColor,
                                          hideUnderline: true,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'بدهکار(پرداخت)',
                                        style: AppTextStyle.labelText.copyWith(fontSize: 13,
                                            fontWeight: FontWeight.normal,color: AppColor.textColor ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                            bottom: 5),
                                        child:
                                        CustomDropdownWidget(

                                          dropdownSearchData: DropdownSearchData<String>(
                                            searchController: controller
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
                                                controller: controller
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
                                          value: controller.selectedAccount.value,
                                          /*validator: (value) {
                          if (value == 'انتخاب کنید' || value == null || value.isEmpty) {
                            return 'کاربر را انتخاب کنید';
                          }
                          return null;
                        },*/
                                          showSearchBox: true,
                                          items: [
                                            'انتخاب کنید',
                                            ...controller.searchedAccounts.map((
                                                account) => account.name ?? "")
                                          ].toList(),
                                          selectedValue: controller.selectedAccount
                                              .value?.name,
                                          onChanged: (String? newValue) {
                                            if (newValue == 'انتخاب کنید') {
                                              controller.changeSelectedAccount(null);
                                            } else {
                                              var selectedAccount = controller
                                                  .searchedAccounts
                                                  .firstWhere((account) => account.name == newValue);
                                              controller.changeSelectedAccount(
                                                  selectedAccount);
                                            }
                                          },
                                          onMenuStateChange: (isOpen) {
                                            if (!isOpen) {
                                              controller.resetAccountSearch();
                                            }
                                          },
                                          backgroundColor: AppColor.textFieldColor,
                                          borderRadius: 7,
                                          borderColor: AppColor.secondaryColor,
                                          hideUnderline: true,
                                        ),
                                      ),
                                    ],
                                  ),

                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'محصول',
                                        style: AppTextStyle.labelText.copyWith(fontSize: 13,
                                            fontWeight: FontWeight.normal,color: AppColor.textColor ),
                                      ),
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
                                            ...controller.itemList.map((item) => item.name ?? '')
                                          ].toList(),
                                          selectedValue: controller.selectedItem.value?.name,
                                          onChanged: (String? newValue){
                                            if (newValue == 'انتخاب کنید') {
                                              controller.changeSelectedItem(null);
                                            } else {
                                              var selectedItem = controller.itemList
                                                  .firstWhere((item) => item.name == newValue);
                                              controller.changeSelectedItem(selectedItem);
                                            }
                                          },
                                          backgroundColor: AppColor.textFieldColor,
                                          borderRadius: 7,
                                          borderColor: AppColor.secondaryColor,
                                          hideUnderline: true,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'مقدار',
                                        style: AppTextStyle.labelText.copyWith(fontSize: 13,
                                            fontWeight: FontWeight.normal,color: AppColor.textColor ),
                                      ),
                                      IntrinsicHeight(
                                        child: TextFormField(
                                          autovalidateMode: AutovalidateMode.onUserInteraction,
                                           controller: controller.quantityPayerController,
                                          style: AppTextStyle.labelText,
                                          textAlign: TextAlign.center,
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
                                            contentPadding: const EdgeInsets.symmetric(vertical: 17, ),
                                            isDense: true,
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            filled: true,
                                            fillColor: AppColor.textFieldColor,
                                            errorMaxLines: 1,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'تاریخ',
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
                                            controller: controller.dateController,
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
                                                controller.dateController.text =
                                                "${pickedDate.year}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}";

                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'توضیحات',
                                        style: AppTextStyle.labelText.copyWith(fontSize: 13,
                                            fontWeight: FontWeight.normal,color: AppColor.textColor ),
                                      ),
                                      IntrinsicHeight(
                                        child: TextFormField(
                                          maxLines: 3,
                                          autovalidateMode: AutovalidateMode.onUserInteraction,
                                          controller: controller.descController,
                                          style: AppTextStyle.labelText,
                                          keyboardType: TextInputType.text,
                                          // inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^[\d٠-٩۰-۹]*\.?[\d٠-٩۰-۹]*$')),
                                          //   TextInputFormatter.withFunction((oldValue, newValue) {
                                          //     // تبدیل اعداد فارسی به انگلیسی برای پردازش راحت‌تر
                                          //     String newText = newValue.text
                                          //         .replaceAll('٠', '0')
                                          //         .replaceAll('١', '1')
                                          //         .replaceAll('٢', '2')
                                          //         .replaceAll('٣', '3')
                                          //         .replaceAll('٤', '4')
                                          //         .replaceAll('٥', '5')
                                          //         .replaceAll('٦', '6')
                                          //         .replaceAll('٧', '7')
                                          //         .replaceAll('٨', '8')
                                          //         .replaceAll('٩', '9');
                                          //
                                          //     return newValue.copyWith(text: newText, selection: TextSelection.collapsed(offset: newText.length));
                                          //   }),
                                          // ],
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
                                    ],
                                  ),


                                ],
                              ),
                              Container(
                                width: Get.width,
                                height: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: AppColor.textColor
                                ),
                                child:  Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset('assets/svg/camera.svg',height: 30,
                                        colorFilter: ColorFilter.mode(
                                          AppColor.textFieldColor,
                                          BlendMode.srcIn,
                                        )),
                                    Text(
                                      'انتخاب عکس',
                                      style: AppTextStyle.labelText.copyWith(fontSize: 15,
                                          fontWeight: FontWeight.bold,color: AppColor.textFieldColor ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 20,vertical: 20),

                                width: double.infinity,
                                height: 40,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      padding: WidgetStatePropertyAll(
                                          EdgeInsets.symmetric(horizontal: 7)),
                                      elevation: WidgetStatePropertyAll(5),
                                      backgroundColor:
                                      WidgetStatePropertyAll(AppColor.buttonColor),
                                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10)))),
                                  onPressed: () async {
                                    controller.insertRemittance();
                                  },
                                  child: controller.isLoading.value
                                      ?
                                  CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor),
                                  ) :
                                  Text(
                                    'ایجاد حواله جدید',
                                    style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    )

                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
