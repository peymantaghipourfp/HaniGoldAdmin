import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../widget/custom_appbar.widget.dart';
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
      appBar: CustomAppBar(
        title: 'ایجاد حواله', onBackTap: () => Get.back(),),
      body: SafeArea(
        child: SizedBox(
          height: Get.height,
          width: Get.width,
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
                            childAspectRatio:isDesktop? 7: 5,
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
                                    // controller: inventoryCreateController.impurityController,
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
                                    // controller: inventoryCreateController.impurityController,
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
                                  margin: const EdgeInsets.symmetric(horizontal: 0,vertical: 0),
                                  height: 35,
                                  width: Get.width ,
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton2<String>(
                                      isExpanded: true,
                                      hint: Row(
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Text(
                                                  "-",
                                                  style: context.textTheme.bodyMedium!.copyWith(fontSize: 14,color: AppColor.textColor),
                                                  overflow: TextOverflow
                                                      .ellipsis,
                                                ),

                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      items:controller.getList
                                          .map((item) =>
                                          DropdownMenuItem<String>(
                                            value: item,
                                            child: FittedBox(
                                              fit: BoxFit.fitWidth,
                                              child: Text(
                                                item,
                                                style: context.textTheme.labelMedium!.copyWith(fontSize: 13,color: AppColor.textColor),
                                                overflow: TextOverflow
                                                    .ellipsis,
                                              ),
                                            ),
                                          ))
                                          .toList(),
                                      value:controller.indexGet,
                                      onChanged: (value) {
                                        setState(() {
                                          controller.get(value!);
                                        });
                                        // controller.getIndexPacking(value!);
                                      },
                                      buttonStyleData: ButtonStyleData(
                                        height: 50,
                                        width: 90,
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius
                                                .circular(10),
                                            color: AppColor.backGroundColor,
                                            border: Border.all(color: AppColor.textColor,width: 1)
                                        ),
                                        elevation: 0,
                                      ),
                                      iconStyleData:  IconStyleData(
                                        icon: const Icon(
                                          Icons.keyboard_arrow_down,
                                        ),
                                        iconSize: 23,
                                        iconEnabledColor: AppColor.textColor,
                                        iconDisabledColor: Colors.grey,
                                      ),
                                      dropdownStyleData: DropdownStyleData(
                                        maxHeight: 200,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius
                                              .circular(7),
                                          color: AppColor.backGroundColor,
                                        ),
                                        offset: const Offset(-0, 0),
                                        scrollbarTheme: ScrollbarThemeData(
                                          radius: const Radius.circular(
                                              7),
                                          thickness: WidgetStateProperty
                                              .all(6),
                                          thumbVisibility: WidgetStateProperty
                                              .all(true),
                                        ),
                                      ),
                                      menuItemStyleData: const MenuItemStyleData(
                                        height: 40,
                                        padding: EdgeInsets.only(
                                            left: 10, right: 10),
                                      ),
                                    ),
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
                                  margin: const EdgeInsets.symmetric(horizontal: 0,vertical: 0),
                                  height: 35,
                                  width: Get.width ,
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton2<String>(
                                      isExpanded: true,
                                      hint: Row(
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Text(
                                                  "-",
                                                  style: context.textTheme.bodyMedium!.copyWith(fontSize: 14,color: AppColor.textColor),
                                                  overflow: TextOverflow
                                                      .ellipsis,
                                                ),

                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      items:controller.getList
                                          .map((item) =>
                                          DropdownMenuItem<String>(
                                            value: item,
                                            child: FittedBox(
                                              fit: BoxFit.fitWidth,
                                              child: Text(
                                                item,
                                                style: context.textTheme.labelMedium!.copyWith(fontSize: 13,color: AppColor.textColor),
                                                overflow: TextOverflow
                                                    .ellipsis,
                                              ),
                                            ),
                                          ))
                                          .toList(),
                                      value:controller.indexGet,
                                      onChanged: (value) {
                                        setState(() {
                                          controller.get(value!);
                                        });
                                        // controller.getIndexPacking(value!);
                                      },
                                      buttonStyleData: ButtonStyleData(
                                        height: 50,
                                        width: 90,
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius
                                                .circular(10),
                                            color: AppColor.backGroundColor,
                                            border: Border.all(color: AppColor.textColor,width: 1)
                                        ),
                                        elevation: 0,
                                      ),
                                      iconStyleData:  IconStyleData(
                                        icon: const Icon(
                                          Icons.keyboard_arrow_down,
                                        ),
                                        iconSize: 23,
                                        iconEnabledColor: AppColor.textColor,
                                        iconDisabledColor: Colors.grey,
                                      ),
                                      dropdownStyleData: DropdownStyleData(
                                        maxHeight: 200,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius
                                              .circular(7),
                                          color: AppColor.backGroundColor,
                                        ),
                                        offset: const Offset(-0, 0),
                                        scrollbarTheme: ScrollbarThemeData(
                                          radius: const Radius.circular(
                                              7),
                                          thickness: WidgetStateProperty
                                              .all(6),
                                          thumbVisibility: WidgetStateProperty
                                              .all(true),
                                        ),
                                      ),
                                      menuItemStyleData: const MenuItemStyleData(
                                        height: 40,
                                        padding: EdgeInsets.only(
                                            left: 10, right: 10),
                                      ),
                                    ),
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
                                  margin: const EdgeInsets.symmetric(horizontal: 0,vertical: 0),
                                  height: 35,
                                  width: Get.width ,
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton2<String>(
                                      isExpanded: true,
                                      hint: Row(
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Text(
                                                  "-",
                                                  style: context.textTheme.bodyMedium!.copyWith(fontSize: 14,color: AppColor.textColor),
                                                  overflow: TextOverflow
                                                      .ellipsis,
                                                ),

                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      items:controller.getList
                                          .map((item) =>
                                          DropdownMenuItem<String>(
                                            value: item,
                                            child: FittedBox(
                                              fit: BoxFit.fitWidth,
                                              child: Text(
                                                item,
                                                style: context.textTheme.labelMedium!.copyWith(fontSize: 13,color: AppColor.textColor),
                                                overflow: TextOverflow
                                                    .ellipsis,
                                              ),
                                            ),
                                          ))
                                          .toList(),
                                      value:controller.indexGet,
                                      onChanged: (value) {
                                        setState(() {
                                          controller.get(value!);
                                        });
                                        // controller.getIndexPacking(value!);
                                      },
                                      buttonStyleData: ButtonStyleData(
                                        height: 50,
                                        width: 90,
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius
                                                .circular(10),
                                            color: AppColor.backGroundColor,
                                            border: Border.all(color: AppColor.textColor,width: 1)
                                        ),
                                        elevation: 0,
                                      ),
                                      iconStyleData:  IconStyleData(
                                        icon: const Icon(
                                          Icons.keyboard_arrow_down,
                                        ),
                                        iconSize: 23,
                                        iconEnabledColor: AppColor.textColor,
                                        iconDisabledColor: Colors.grey,
                                      ),
                                      dropdownStyleData: DropdownStyleData(
                                        maxHeight: 200,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius
                                              .circular(7),
                                          color: AppColor.backGroundColor,
                                        ),
                                        offset: const Offset(-0, 0),
                                        scrollbarTheme: ScrollbarThemeData(
                                          radius: const Radius.circular(
                                              7),
                                          thickness: WidgetStateProperty
                                              .all(6),
                                          thumbVisibility: WidgetStateProperty
                                              .all(true),
                                        ),
                                      ),
                                      menuItemStyleData: const MenuItemStyleData(
                                        height: 40,
                                        padding: EdgeInsets.only(
                                            left: 10, right: 10),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'گرم',
                                  style: AppTextStyle.labelText.copyWith(fontSize: 13,
                                      fontWeight: FontWeight.normal,color: AppColor.textColor ),
                                ),
                                IntrinsicHeight(
                                  child: TextFormField(

                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    // controller: inventoryCreateController.impurityController,
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
                                IntrinsicHeight(
                                  child: TextFormField(

                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                     controller: controller.dateController,
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
                                      suffixIcon: Icon(Icons.calendar_month, color: AppColor.textColor),
                                      isDense: true,
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
                                        controller.dateController.text =
                                        "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";

                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),


                          ],
                        ),
                      ],
                    )
                  ],
                ),
              )

            ],
          ),
        ),
      ),
    ));
  }
}
