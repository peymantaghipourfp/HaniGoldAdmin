import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/widget/custom_appbar1.widget.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:image/image.dart' as img;
import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../config/repository/url/base_url.dart';
import '../../../widget/app_drawer.widget.dart';
import '../../../widget/background_image.widget.dart';
import '../../../widget/custom_appbar.widget.dart';
import '../../../widget/custom_dropdown.widget.dart';
import '../../home/widget/chat_dialog.widget.dart';
import '../../users/widgets/balance.widget.dart';
import '../controller/remittance.controller.dart';


class UpdateRemittanceView extends StatefulWidget {
  const UpdateRemittanceView({super.key});

  @override
  State<UpdateRemittanceView> createState() => _UpdateRemittanceViewState();
}

class _UpdateRemittanceViewState extends State<UpdateRemittanceView> {

  var controller=Get.find<RemittanceController>();


  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    return Obx(()=>Scaffold(
      appBar: CustomAppbar1(
        title: 'ویرایش حواله',
          onBackTap: () {
          Get.back();
          controller.clearFilter();
        }
      ),
      drawer: const AppDrawer(),
      body: Stack(

        children: [
          BackgroundImage(),
          SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30,vertical: 15),
              height: Get.height,
              width: Get.width,
              child: SingleChildScrollView(
                child:isDesktop?
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // SizedBox(height: 10,),

                    Container(
                      width: Get.width * 0.4 ,
                      padding: EdgeInsets.symmetric(horizontal: 30,vertical: 15),
                      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 30),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColor.secondaryColor
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(

                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'ویرایش حواله',
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
                                  childAspectRatio:isDesktop? 5: 4.5,
                                  crossAxisCount:isDesktop? 1:1,
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
                                           controller: controller.nameRecieptController,
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
                                           controller: controller.mobileReciptController,
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
                                                .searchControllerRecipt,
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
                                                    .searchControllerRecipt,
                                                focusNode: controller.searchFocusNodeRecipt,
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
                                          value: controller.selectedAccountRecipt.value,
                                          /*validator: (value) {
                          if (value == 'انتخاب کنید' || value == null || value.isEmpty) {
                            return 'کاربر را انتخاب کنید';
                          }
                          return null;
                        },*/
                                          showSearchBox: true,
                                          items: [
                                            'انتخاب کنید',
                                            ...controller.searchedAccountsRecipt.map((
                                                account) =>
                                            '${account.id}:${account.name ?? ""}')
                                          ].toList(),
                                          selectedValue:controller.selectedAccountRecipt
                                              .value !=null ?
                                          '${controller.selectedAccountRecipt.value?.id}:${controller.selectedAccountRecipt.value?.name}'
                                              : null,
                                          onChanged: (String? newValue) {
                                            if (newValue == 'انتخاب کنید') {
                                              controller.changeSelectedAccountRecipt(null);
                                            } else {
                                              var accountId = int.tryParse(newValue!.split(':')[0]);
                                              if(accountId!=null) {
                                                var selectedAccount = controller
                                                    .searchedAccountsRecipt
                                                    .firstWhere((account) =>
                                                account.id == accountId);
                                                controller
                                                    .changeSelectedAccountRecipt(
                                                    selectedAccount);
                                              }
                                            }
                                          },
                                          /*onMenuStateChange: (isOpen) {
                                            if (!isOpen) {
                                              controller.resetAccountSearchP();
                                            }
                                          },*/
                                          onMenuStateChange: controller.onDropdownMenuStateChangeRecipt,
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
                                                .searchControllerPayer,
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
                                                    .searchControllerPayer,
                                                focusNode: controller.searchFocusNodePayer,
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
                                          value: controller.selectedAccountPayer.value,
                                          /*validator: (value) {
                          if (value == 'انتخاب کنید' || value == null || value.isEmpty) {
                            return 'کاربر را انتخاب کنید';
                          }
                          return null;
                        },*/
                                          showSearchBox: true,
                                          items: [
                                            'انتخاب کنید',
                                            ...controller
                                                .searchedAccountsPayer.map((
                                                account) =>
                                            '${account.id}:${account.name ?? ""}')
                                          ].toList(),
                                          selectedValue: controller
                                              .selectedAccountPayer.value != null
                                              ? '${controller.selectedAccountPayer.value!.id}:${controller.selectedAccountPayer.value!.name}'
                                              : null,
                                          onChanged: (String? newValue) {
                                            if (newValue ==
                                                'انتخاب کنید') {
                                              controller
                                                  .changeSelectedAccountPayer(
                                                  null);
                                            } else {
                                              var accountId = int.tryParse(newValue!.split(':')[0]);
                                              if (accountId != null) {
                                                var selectedAccount = controller
                                                    .searchedAccountsPayer
                                                    .firstWhere((account) =>
                                                account.id == accountId);
                                                controller
                                                    .changeSelectedAccountPayer(
                                                    selectedAccount);
                                              }
                                            }
                                          },
                                          /*onMenuStateChange: (isOpen) {
                                            if (!isOpen) {
                                              controller.resetAccountSearch();
                                            }
                                          },*/
                                          onMenuStateChange: controller.onDropdownMenuStateChangePayer,
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
                                        child:
                                        controller.selectedItem.value?.itemUnit?.name == 'ریال' ?
                                        TextFormField(
                                          autovalidateMode: AutovalidateMode.onUserInteraction,
                                          controller: controller.quantityPayerController,
                                          style: AppTextStyle.labelText,
                                          textAlign: TextAlign.center,
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(RegExp(r'[۰-۹0-9]')),
                                          ],
                                          onChanged: (value) {
                                            if (controller.selectedItem.value?.itemUnit?.name == 'ریال') {
                                              String cleanedValue = value
                                                  .replaceAll(',', '');
                                              if (cleanedValue.isNotEmpty) {
                                                controller.quantityPayerController.text = cleanedValue
                                                    .toPersianDigit()
                                                    .seRagham();
                                                controller.quantityPayerController
                                                    .selection =
                                                    TextSelection.collapsed(
                                                        offset: controller.quantityPayerController
                                                            .text.length);
                                              }
                                            }
                                          },
                                          /*inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^[\d٠-٩۰-۹]*\.?[\d٠-٩۰-۹]*$')),
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
                                          ],*/
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
                                        ) :
                                        TextFormField(
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
                                        )
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
                              // Container(
                              //   width: Get.width,
                              //   height: 80,
                              //   decoration: BoxDecoration(
                              //     borderRadius: BorderRadius.circular(10),
                              //     color: AppColor.textColor
                              //   ),
                              //   child:  Row(
                              //     mainAxisAlignment: MainAxisAlignment.center,
                              //     children: [
                              //       SvgPicture.asset('assets/svg/camera.svg',height: 30,
                              //           colorFilter: ColorFilter.mode(
                              //             AppColor.textFieldColor,
                              //             BlendMode.srcIn,
                              //           )),
                              //       Text(
                              //         'انتخاب عکس',
                              //         style: AppTextStyle.labelText.copyWith(fontSize: 15,
                              //             fontWeight: FontWeight.bold,color: AppColor.textFieldColor ),
                              //       ),
                              //     ],
                              //   ),
                              // ),


                            //  controller.imageList.isNotEmpty?
                              SizedBox(
                                width: Get.width * 0.7,
                                height: 100,
                                child: Row(
                                  children: controller.imageList.map((e)=>
                                      Stack(
                                        children: [
                                          GestureDetector(
                                            onTap:(){
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
                                                          margin: EdgeInsets.all(10),
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(8),
                                                              border: Border.all(color: AppColor.textColor),
                                                              image: DecorationImage(image: NetworkImage("${BaseUrl.baseUrl}Attachment/downloadAttachment?fileName=$e"),fit: BoxFit.fill,
                                                              )
                                                          ),
                                                          height: Get.height * 0.8,width: Get.width * 0.4,
                                                          // child: Image.network(e!.path,fit: BoxFit.cover,),
                                                        ),
                                                      ),
                                                    );
                                                  });
                                            },
                                            child: Container(
                                              margin: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(8),
                                                  border: Border.all(color: AppColor.textColor),
                                                  image: DecorationImage(image: NetworkImage("${BaseUrl.baseUrl}Attachment/downloadAttachment?fileName=$e"),fit: BoxFit.cover,
                                                  )
                                              ),
                                              height: 60,width: 60,
                                              // child: Image.network(e!.path,fit: BoxFit.cover,),
                                            ),
                                          ),
                                          GestureDetector(
                                            child: CircleAvatar(
                                              backgroundColor: AppColor.accentColor,radius: 10,
                                              child: Center(child: Icon(Icons.clear,color: AppColor.textColor,size: 15,)),
                                            ),
                                            onTap: (){
                                              controller.deleteImage(e);
                                            },
                                          )
                                        ],
                                      ),).toList(),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Obx(() {
                                    if (controller
                                        .isUploadingDesktop
                                        .value) {
                                      return Row(
                                        children: [
                                          Text(
                                            'در حال بارگزاری عکس',
                                            style: AppTextStyle.labelText.copyWith(fontSize: 12,
                                                fontWeight: FontWeight.normal,color: AppColor.textColor ),
                                          ),
                                          SizedBox(width: 10,),
                                          CircularProgressIndicator(),
                                        ],
                                      );
                                    }
                                    return SizedBox(
                                      height: 80,
                                      width: Get.width * 0.3,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: controller.selectedImagesDesktop.map((e){
                                            return  Stack(
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(8),
                                                      border: Border.all(color: AppColor.textColor),
                                                      image: DecorationImage(image: NetworkImage(e!.path,),fit: BoxFit.cover,)
                                                  ),
                                                  height: 60,width: 60,
                                                  // child: Image.network(e!.path,fit: BoxFit.cover,),
                                                ),
                                                GestureDetector(
                                                  child: CircleAvatar(
                                                    backgroundColor: AppColor.accentColor,radius: 10,
                                                    child: Center(child: Icon(Icons.clear,color: AppColor.textColor,size: 15,)),
                                                  ),
                                                  onTap: (){
                                                    controller.selectedImagesDesktop.remove(e);
                                                  },
                                                )
                                              ],
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    );
                                  }),
                                  GestureDetector(
                                    onTap: () =>
                                        controller.pickImageDesktop(
                                        ),
                                    child: Container(
                                      constraints: BoxConstraints(maxWidth: 100),
                                      child: SvgPicture
                                          .asset(
                                        'assets/svg/camera.svg',
                                        width: 30,
                                        height: 30,
                                        colorFilter: ColorFilter
                                            .mode(
                                            AppColor
                                                .iconViewColor,
                                            BlendMode
                                                .srcIn),),
                                    ),

                                  ),

                                ],
                              ),
                              //     :
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              //   children: [
                              //     Obx(() {
                              //       if (controller
                              //           .isUploadingDesktop
                              //           .value) {
                              //         return Row(
                              //           children: [
                              //             Text(
                              //               'در حال بارگزاری عکس',
                              //               style: AppTextStyle.labelText.copyWith(fontSize: 12,
                              //                   fontWeight: FontWeight.normal,color: AppColor.textColor ),
                              //             ),
                              //             SizedBox(width: 10,),
                              //             CircularProgressIndicator(),
                              //           ],
                              //         );
                              //       }
                              //       return SizedBox(
                              //         height: 80,
                              //         width: Get.width * 0.3,
                              //         child: SingleChildScrollView(
                              //           scrollDirection: Axis.horizontal,
                              //           child: Row(
                              //             children: controller.selectedImagesDesktop.map((e){
                              //               return  Stack(
                              //                 children: [
                              //                   Container(
                              //                     margin: EdgeInsets.all(10),
                              //                     decoration: BoxDecoration(
                              //                         borderRadius: BorderRadius.circular(8),
                              //                         border: Border.all(color: AppColor.textColor),
                              //                         image: DecorationImage(image: NetworkImage(e!.path,),fit: BoxFit.cover,)
                              //                     ),
                              //                     height: 60,width: 60,
                              //                     // child: Image.network(e!.path,fit: BoxFit.cover,),
                              //                   ),
                              //                   GestureDetector(
                              //                     child: CircleAvatar(
                              //                       backgroundColor: AppColor.accentColor,radius: 10,
                              //                       child: Center(child: Icon(Icons.clear,color: AppColor.textColor,size: 15,)),
                              //                     ),
                              //                     onTap: (){
                              //                       controller.selectedImagesDesktop.remove(e);
                              //                     },
                              //                   )
                              //                 ],
                              //               );
                              //             }).toList(),
                              //           ),
                              //         ),
                              //       );
                              //     }),
                              //     GestureDetector(
                              //       onTap: () =>
                              //           controller.pickImageDesktop(
                              //           ),
                              //       child: Container(
                              //         constraints: BoxConstraints(maxWidth: 100),
                              //         child: SvgPicture
                              //             .asset(
                              //           'assets/svg/camera.svg',
                              //           width: 30,
                              //           height: 30,
                              //           colorFilter: ColorFilter
                              //               .mode(
                              //               AppColor
                              //                   .iconViewColor,
                              //               BlendMode
                              //                   .srcIn),),
                              //       ),
                              //
                              //     ),
                              //
                              //   ],
                              // ),
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
                                    await controller. uploadImagesDesktopUpdate( "image", "Remittance");
                                  },
                                  child: controller.isLoading.value
                                      ?
                                  CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor),
                                  ) :
                                  Text(
                                    'ویرایش حواله',
                                    style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          controller.balanceListRecipt.isNotEmpty?  BalanceWidget(
                            title: "بستانکار",
                            listBalance: controller.balanceListRecipt,
                            size:isDesktop? Get.width * 0.4:Get.width * 0.9,):
                          BalanceWidget(
                            title: "بستانکار",
                            listBalance: controller.balanceListRecipt,
                            size:isDesktop? Get.width * 0.4:Get.width * 0.9,),
                          SizedBox(height: 10,),
                          controller.balanceListPayer.isNotEmpty?   BalanceWidget(
                            title: "بدهکار",
                            listBalance: controller.balanceListPayer,
                            size:isDesktop? Get.width * 0.4:Get.width * 0.9,):BalanceWidget(
                            title: "بدهکار",
                            listBalance: controller.balanceListPayer,
                            size:isDesktop? Get.width * 0.4:Get.width * 0.9,)
                        ],
                      ),
                    ),
                  ],
                ):
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          controller.balanceListRecipt.isNotEmpty?  BalanceWidget(
                            listBalance: controller.balanceListRecipt,
                            size:isDesktop? Get.width * 0.4:Get.width * 0.9,):Container(
                            width: isDesktop? Get.width * 0.4:Get.width * 0.9,height: 80,
                            //height: controller.isOpenMore.value?300:200,
                            constraints: BoxConstraints(
                              // maxHeight: controller.isOpenMore.value?300:120,
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                            margin: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColor.secondaryColor
                            ),
                          ),
                          SizedBox(height: 10,),
                          controller.balanceListPayer.isNotEmpty?   BalanceWidget(
                            listBalance: controller.balanceListPayer,
                            size:isDesktop? Get.width * 0.4:Get.width * 0.9,):Container(
                            width: isDesktop? Get.width * 0.4:Get.width * 0.9,height: 80,
                            //height: controller.isOpenMore.value?300:200,
                            constraints: BoxConstraints(
                              // maxHeight: controller.isOpenMore.value?300:120,
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                            margin: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColor.secondaryColor
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: Get.width * 0.9 ,
                      padding: EdgeInsets.symmetric(horizontal: 30,vertical: 15),
                      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 30),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColor.secondaryColor
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(

                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'ویرایش حواله',
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
                                  childAspectRatio:isDesktop? 6: 4,
                                  crossAxisCount:isDesktop? 1:1,
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
                                          controller: controller.nameRecieptController,
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
                                          controller: controller.mobileReciptController,
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
                                                .searchControllerRecipt,
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
                                                    .searchControllerRecipt,
                                                focusNode: controller.searchFocusNodeRecipt,
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
                                          value: controller.selectedAccountRecipt.value,
                                          /*validator: (value) {
                          if (value == 'انتخاب کنید' || value == null || value.isEmpty) {
                            return 'کاربر را انتخاب کنید';
                          }
                          return null;
                        },*/
                                          showSearchBox: true,
                                          items: [
                                            'انتخاب کنید',
                                            ...controller.searchedAccountsRecipt.map((
                                                account) => account.name ?? "")
                                          ].toList(),
                                          selectedValue: controller.selectedAccountRecipt
                                              .value?.name,
                                          onChanged: (String? newValue) {
                                            if (newValue == 'انتخاب کنید') {
                                              controller.changeSelectedAccountRecipt(null);
                                            } else {
                                              var selectedAccount = controller
                                                  .searchedAccountsRecipt
                                                  .firstWhere((account) => account.name == newValue);
                                              controller.changeSelectedAccountRecipt(
                                                  selectedAccount);
                                            }
                                          },
                                          /*onMenuStateChange: (isOpen) {
                                            if (!isOpen) {
                                              controller.resetAccountSearchP();
                                            }
                                          },*/
                                          onMenuStateChange: controller.onDropdownMenuStateChangeRecipt,
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
                                                .searchControllerPayer,
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
                                                    .searchControllerPayer,
                                                focusNode: controller.searchFocusNodePayer,
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
                                          value: controller.selectedAccountPayer.value,
                                          /*validator: (value) {
                          if (value == 'انتخاب کنید' || value == null || value.isEmpty) {
                            return 'کاربر را انتخاب کنید';
                          }
                          return null;
                        },*/
                                          showSearchBox: true,
                                          items: [
                                            'انتخاب کنید',
                                            ...controller.searchedAccountsPayer.map((
                                                account) => account.name ?? "")
                                          ].toList(),
                                          selectedValue: controller.selectedAccountPayer
                                              .value?.name,
                                          onChanged: (String? newValue) {
                                            if (newValue == 'انتخاب کنید') {
                                              controller.changeSelectedAccountPayer(null);
                                            } else {
                                              var selectedAccount = controller
                                                  .searchedAccountsPayer
                                                  .firstWhere((account) => account.name == newValue);
                                              controller.changeSelectedAccountPayer(
                                                  selectedAccount);
                                            }
                                          },
                                          /*onMenuStateChange: (isOpen) {
                                            if (!isOpen) {
                                              controller.resetAccountSearch();
                                            }
                                          },*/
                                          onMenuStateChange: controller.onDropdownMenuStateChangePayer,
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
                                        child:
                                        controller.selectedItem.value?.itemUnit?.name == 'ریال' ?
                                        TextFormField(
                                          autovalidateMode: AutovalidateMode.onUserInteraction,
                                          controller: controller.quantityPayerController,
                                          style: AppTextStyle.labelText,
                                          textAlign: TextAlign.center,
                                          keyboardType: TextInputType.number,
                                          onChanged: (value) {
                                            if (controller.selectedItem.value?.itemUnit?.name == 'ریال') {
                                              String cleanedValue = value
                                                  .replaceAll(',', '');
                                              if (cleanedValue.isNotEmpty) {
                                                controller.quantityPayerController.text = cleanedValue
                                                    .toPersianDigit()
                                                    .seRagham();
                                                controller.quantityPayerController
                                                    .selection =
                                                    TextSelection.collapsed(
                                                        offset: controller.quantityPayerController
                                                            .text.length);
                                              }
                                            }
                                          },
                                          /*inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^[\d٠-٩۰-۹]*\.?[\d٠-٩۰-۹]*$')),
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
                                          ],*/
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
                                        ) :
                                        TextFormField(
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
                                        )
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
                             SizedBox(
                          width: Get.width * 0.7,
                          height: 100,
                          child: Row(
                            children: controller.imageList.map((e)=>
                                Stack(
                                  children: [
                                    GestureDetector(
                                      onTap:(){
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
                                                    margin: EdgeInsets.all(10),
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(8),
                                                        border: Border.all(color: AppColor.textColor),
                                                        image: DecorationImage(image: NetworkImage("${BaseUrl.baseUrl}Attachment/downloadAttachment?fileName=$e"),fit: BoxFit.cover,
                                                        )
                                                    ),
                                                    height: 200,width: 200,
                                                    // child: Image.network(e!.path,fit: BoxFit.cover,),
                                                  ),
                                                ),
                                              );
                                            });
                                      },
                                      child: Container(
                                        margin: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: AppColor.textColor),
                                            image: DecorationImage(image: NetworkImage("${BaseUrl.baseUrl}Attachment/downloadAttachment?fileName=$e"),fit: BoxFit.cover,
                                            )
                                        ),
                                        height: 60,width: 60,
                                        // child: Image.network(e!.path,fit: BoxFit.cover,),
                                      ),
                                    ),
                                    GestureDetector(
                                      child: CircleAvatar(
                                        backgroundColor: AppColor.accentColor,radius: 10,
                                        child: Center(child: Icon(Icons.clear,color: AppColor.textColor,size: 15,)),
                                      ),
                                      onTap: (){
                                        controller.imageList.remove(e);
                                      },
                                    )
                                  ],
                                ),).toList(),
                          ),
                        ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Obx(() {
                                    if (controller
                                        .isUploadingDesktop
                                        .value) {
                                      return Row(
                                        children: [
                                          Text(
                                            'در حال بارگزاری عکس',
                                            style: AppTextStyle.labelText.copyWith(fontSize: 12,
                                                fontWeight: FontWeight.normal,color: AppColor.textColor ),
                                          ),
                                          SizedBox(width: 10,),
                                          CircularProgressIndicator(),
                                        ],
                                      );
                                    }
                                    return SizedBox(
                                      height: 80,
                                      width: Get.width * 0.3,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: controller.selectedImagesDesktop.map((e){
                                            return  Stack(
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(8),
                                                      border: Border.all(color: AppColor.textColor),
                                                      image: DecorationImage(image: NetworkImage(e!.path,),fit: BoxFit.cover,)
                                                  ),
                                                  height: 60,width: 60,
                                                  // child: Image.network(e!.path,fit: BoxFit.cover,),
                                                ),
                                                GestureDetector(
                                                  child: CircleAvatar(
                                                    backgroundColor: AppColor.accentColor,radius: 10,
                                                    child: Center(child: Icon(Icons.clear,color: AppColor.textColor,size: 15,)),
                                                  ),
                                                  onTap: (){
                                                    controller.selectedImagesDesktop.remove(e);
                                                  },
                                                )
                                              ],
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    );
                                  }),
                                  GestureDetector(
                                    onTap: () =>
                                        controller.pickImageDesktop(
                                        ),
                                    child: Container(
                                      constraints: BoxConstraints(maxWidth: 100),
                                      child: SvgPicture
                                          .asset(
                                        'assets/svg/camera.svg',
                                        width: 30,
                                        height: 30,
                                        colorFilter: ColorFilter
                                            .mode(
                                            AppColor
                                                .iconViewColor,
                                            BlendMode
                                                .srcIn),),
                                    ),

                                  ),

                                ],
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

                                    await controller. uploadImagesDesktopUpdate( "image", "Remittance");
                                  },
                                  child: controller.isLoading.value
                                      ?
                                  CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor),
                                  ) :
                                  Text(
                                    'ویرایش حواله',
                                    style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                )
                ,
              ),
            ),
          ),
        ],
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
    ));
  }
}
