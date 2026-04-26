import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/widget/custom_appbar1.widget.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../widget/app_drawer.widget.dart';
import '../../../widget/background_image.widget.dart';
import '../../../widget/custom_dropdown.widget.dart';
import '../../chat/widget/chat_dialog.widget.dart';
import '../controller/insert_user.controller.dart';
import '../widgets/image_drop_zone_business_license_insert .widget.dart';
import '../widgets/image_drop_zone_national_code_insert.widget.dart';

class InsertUserView extends GetView<InsertUserController> {
  const InsertUserView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    bool isValidNationalCode(String input) {
      final code = input.toEnglishDigit();

      if (!RegExp(r'^\d{10}$').hasMatch(code)) return false;

      final invalidCodes = [
        '0000000000',
        '1111111111',
        '2222222222',
        '3333333333',
        '4444444444',
        '5555555555',
        '6666666666',
        '7777777777',
        '8888888888',
        '9999999999',
      ];

      if (invalidCodes.contains(code)) return false;

      int sum = 0;
      for (int i = 0; i < 9; i++) {
        sum += int.parse(code[i]) * (10 - i);
      }

      int remainder = sum % 11;
      int controlDigit = int.parse(code[9]);

      if (remainder < 2) {
        return controlDigit == remainder;
      } else {
        return controlDigit == (11 - remainder);
      }
    }

    return Obx(()=>Scaffold(
      appBar: CustomAppbar1(
        title: ' ${controller.title.value} کاربر جدید ',
        onBackTap: () {
          Get.back();
          controller.clearList();
        }
      ),
      drawer: const AppDrawer(),
      body: Stack(
        children: [
          BackgroundImage(),
          SafeArea(
            child: controller.state.value == PageState.loading
                ? Center(
              child: SizedBox(
                  height: Get.height,
                  width: Get.width,
                  child: Column(
                    children: [
                      SizedBox(
                          height: 50,
                          width: 50,
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: CircularProgressIndicator(),
                          )),
                    ],
                  )),
            )
                : controller.state.value == PageState.list
                ? Row(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
                  padding: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
                  /*decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: AppColor.circleColor
                  ),*/
                  height: Get.height * 0.9,
                  width:isDesktop? Get.width * 0.35:Get.width * 0.80,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          'ثبت اطلاعات کاربری',
                          style: AppTextStyle.labelText.copyWith(
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                              color: AppColor.textColor),
                        ),
                        SizedBox(height:15,),
                        Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'نقش کاربر',
                                  style: AppTextStyle.labelText.copyWith(fontSize: 11,
                                      fontWeight: FontWeight.normal,color: AppColor.textColor ),
                                ),
                                SizedBox(height: 4,),
                                Container(
                                  padding: EdgeInsets.only(bottom: 5),
                                  child: CustomDropdownWidget(
                                    validator: (value) {
                                      if (value == 'انتخاب کنید' || value == null || value.isEmpty) {
                                        return 'نقش کاربر را انتخاب کنید';
                                      }
                                      return null;
                                    },
                                    items: [
                                      'انتخاب کنید',
                                      ...controller.accountGroupList.map((accountGroup) => accountGroup.name ?? '')
                                    ].toList(),
                                    selectedValue: controller.selectedAccountGroup.value?.name,
                                    onChanged: (String? newValue){
                                      if (newValue == 'انتخاب کنید') {
                                        controller.changeSelectedAccountGroup(null);
                                      } else {
                                        var selectedAccountGroup= controller.accountGroupList
                                            .firstWhere((accountGroup) => accountGroup.name == newValue);
                                        controller.changeSelectedAccountGroup(selectedAccountGroup);
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
                            SizedBox(height: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'گروه قیمت گذاری',
                                  style: AppTextStyle.labelText.copyWith(fontSize: 11,
                                      fontWeight: FontWeight.normal,color: AppColor.textColor ),
                                ),
                                SizedBox(height: 4,),
                                Container(
                                  padding: EdgeInsets.only(bottom: 5),
                                  child: CustomDropdownWidget(
                                    validator: (value) {
                                      if (value == 'انتخاب کنید' || value == null || value.isEmpty) {
                                        return 'گروه قیمت گذاری را انتخاب کنید';
                                      }
                                      return null;
                                    },
                                    items: [
                                      'انتخاب کنید',
                                      ...controller.accountSalesGroupList.map((group) => group.name ?? '')
                                    ].toList(),
                                    selectedValue: controller.selectedAccountSalesGroup.value?.name,
                                    onChanged: (String? newValue){
                                      if (newValue == 'انتخاب کنید') {
                                        controller.changeSelectedAccountSalesGroup(null);
                                      } else {
                                        var selectedAccountSalesGroup= controller.accountSalesGroupList
                                            .firstWhere((group) => group.name == newValue);
                                        controller.changeSelectedAccountSalesGroup(selectedAccountSalesGroup);
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
                            SizedBox(height: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'سطوح کاربری',
                                  style: AppTextStyle.labelText.copyWith(fontSize: 11,
                                      fontWeight: FontWeight.normal,color: AppColor.textColor ),
                                ),
                                SizedBox(height: 4,),
                                Container(
                                  padding: EdgeInsets.only(bottom: 5),
                                  child: CustomDropdownWidget(
                                    validator: (value) {
                                      if (value == 'انتخاب کنید' || value == null || value.isEmpty) {
                                        return 'سطح کاربر را انتخاب کنید';
                                      }
                                      return null;
                                    },
                                    items: [
                                      'انتخاب کنید',
                                      ...controller.accountLevelList.map((accountLevel) => accountLevel.name ?? '')
                                    ].toList(),
                                    selectedValue: controller.selectedAccountLevel.value?.name,
                                    onChanged: (String? newValue){
                                      if (newValue == 'انتخاب کنید') {
                                        controller.changeSelectedAccountLevel(null);
                                      } else {
                                        var selectedAccountLevel= controller.accountLevelList
                                            .firstWhere((accountLevel) => accountLevel.name == newValue);
                                        controller.changeSelectedAccountLevel(selectedAccountLevel);
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
                          ],
                        ),
                        SizedBox(height: 5,),
                        Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              'نام',
                              style: AppTextStyle.labelText.copyWith(
                                  fontSize: 11,
                                  fontWeight: FontWeight.normal,
                                  color: AppColor.textColor),
                            ),
                            SizedBox(height: 4,),
                            IntrinsicHeight(
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty) {
                                    return 'لطفا نام را وارد کنید';
                                  }
                                  return null;
                                },
                                autovalidateMode: AutovalidateMode
                                    .onUserInteraction,
                                controller: controller.nameController,
                                style: AppTextStyle.labelText.copyWith(fontSize: 15),
                                textAlign: TextAlign.start,
                                keyboardType:TextInputType.text,
                                decoration: InputDecoration(
                                  contentPadding:
                                  const EdgeInsets.symmetric(
                                      vertical: 11,horizontal: 15
                                  ),
                                  isDense: true,
                                  border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(6),
                                  ),
                                  filled: true,
                                  fillColor: AppColor.textFieldColor,
                                  errorMaxLines: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              'کد ملی',
                              style: AppTextStyle.labelText.copyWith(
                                  fontSize: 11,
                                  fontWeight: FontWeight.normal,
                                  color: AppColor.textColor),
                            ),
                            SizedBox(height: 4,),
                            IntrinsicHeight(
                              child: TextFormField(
                                controller: controller.nationalCodeController,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                style: AppTextStyle.labelText.copyWith(fontSize: 12),
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'[۰-۹0-9]')),
                                  LengthLimitingTextInputFormatter(10),
                                ],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return null; // فیلد اختیاری است
                                  }
                                  if (!isValidNationalCode(value)) {
                                    return 'کد ملی معتبر نیست';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  contentPadding:
                                  const EdgeInsets.symmetric(
                                      vertical: 11,horizontal: 15
                                  ),
                                  isDense: true,
                                  border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(6),
                                  ),
                                  filled: true,
                                  fillColor: AppColor.textFieldColor,
                                  errorMaxLines: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              'موبایل',
                              style: AppTextStyle.labelText.copyWith(
                                  fontSize: 11,
                                  fontWeight: FontWeight.normal,
                                  color: AppColor.textColor),
                            ),
                            SizedBox(height: 4,),
                            IntrinsicHeight(
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty) {
                                    return 'لطفا موبایل را وارد کنید';
                                  }
                                  return null;
                                },
                                autovalidateMode: AutovalidateMode
                                    .onUserInteraction,
                                controller: controller.mobileController,
                                style: AppTextStyle.labelText.copyWith(fontSize: 15),
                                textAlign: TextAlign.center,
                                keyboardType:TextInputType.phone,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                ],
                                decoration: InputDecoration(
                                  contentPadding:
                                  const EdgeInsets.symmetric(
                                      vertical: 11,horizontal: 15

                                  ),
                                  isDense: true,
                                  border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(6),
                                  ),

                                  filled: true,
                                  fillColor: AppColor.textFieldColor,
                                  errorMaxLines: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              'تلفن ثابت',
                              style: AppTextStyle.labelText.copyWith(
                                  fontSize: 11,
                                  fontWeight: FontWeight.normal,
                                  color: AppColor.textColor),
                            ),
                            SizedBox(height: 4,),
                            IntrinsicHeight(
                              child: TextFormField(
                                autovalidateMode: AutovalidateMode
                                    .onUserInteraction,
                                controller: controller.phoneController,
                                style: AppTextStyle.labelText.copyWith(fontSize: 15),
                                textAlign: TextAlign.center,
                                keyboardType:TextInputType.phone,
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
                                  contentPadding:
                                  const EdgeInsets.symmetric(
                                      vertical: 11,horizontal: 15

                                  ),
                                  isDense: true,
                                  border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(6),
                                  ),

                                  filled: true,
                                  fillColor: AppColor.textFieldColor,
                                  errorMaxLines: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ایمیل',
                              style: AppTextStyle.labelText.copyWith(
                                  fontSize: 11,
                                  fontWeight: FontWeight.normal,
                                  color: AppColor.textColor),
                            ),
                            SizedBox(height: 4,),
                            IntrinsicHeight(
                              child: TextFormField(
                                autovalidateMode: AutovalidateMode
                                    .onUserInteraction,
                                controller: controller.emailController,
                                style: AppTextStyle.labelText.copyWith(fontSize: 15),
                                textAlign: TextAlign.center,
                                keyboardType:TextInputType.emailAddress,
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
                                  contentPadding:
                                  const EdgeInsets.symmetric(
                                      vertical: 11,horizontal: 15

                                  ),
                                  isDense: true,
                                  border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(6),
                                  ),

                                  filled: true,
                                  fillColor: AppColor.textFieldColor,
                                  errorMaxLines: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: (){
                                controller.setChecked();
                              },
                              child: controller.isChecked.value ?
                              SvgPicture.asset(
                                "assets/svg/check-square.svg",
                                height: 25,
                                colorFilter: ColorFilter.mode(AppColor.secondary3Color, BlendMode.srcIn),
                              ):SvgPicture.asset(
                                "assets/svg/square.svg",
                                height: 25,
                                colorFilter: ColorFilter.mode(AppColor.textColor, BlendMode.srcIn),
                              ),
                            ),
                            SizedBox(width: 10,),
                            Text(
                              'بیعانه',
                              style: AppTextStyle.labelText.copyWith(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5,),
                        /*Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              'رمز عبور',
                              style: AppTextStyle.labelText.copyWith(
                                  fontSize: 11,
                                  fontWeight: FontWeight.normal,
                                  color: AppColor.textColor),
                            ),
                            SizedBox(height: 10,),
                            IntrinsicHeight(
                              child: TextFormField(
                                autovalidateMode: AutovalidateMode
                                    .onUserInteraction,
                                controller: controller.passwordController,
                                style: AppTextStyle.labelText.copyWith(fontSize: 15),
                                textAlign: TextAlign.center,
                                keyboardType:TextInputType.number,
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
                                  contentPadding:
                                  const EdgeInsets.symmetric(
                                      vertical: 11,horizontal: 15

                                  ),
                                  isDense: true,
                                  border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(6),
                                  ),

                                  filled: true,
                                  fillColor: AppColor.textFieldColor,
                                  errorMaxLines: 1,
                                ),
                              ),
                            ),
                          ],
                        ),*/
                        /*SizedBox(height: 5,),*/
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'استان',
                              style: AppTextStyle.labelText.copyWith(fontSize: 11,
                                  fontWeight: FontWeight.normal,color: AppColor.textColor ),
                            ),
                            SizedBox(height: 4,),
                            Container(
                              padding: EdgeInsets.only(bottom: 5),
                              child: CustomDropdownWidget(
                                validator: (value) {
                                  if (value == 'انتخاب کنید' || value == null || value.isEmpty) {
                                    return 'استان را انتخاب کنید';
                                  }
                                  return null;
                                },
                                items: [
                                  'انتخاب کنید',
                                  ...controller.stateList.map((item) => item.name ?? '')
                                ].toList(),
                                selectedValue: controller.selectedState.value?.name,
                                onChanged: (String? newValue){
                                  if (newValue == 'انتخاب کنید') {
                                    controller.changeSelectedState(null);
                                  } else {
                                    var selectedItem = controller.stateList
                                        .firstWhere((item) => item.name == newValue);
                                    controller.changeSelectedState(selectedItem);
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
                        SizedBox(height: 5,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'شهر',
                              style: AppTextStyle.labelText.copyWith(fontSize: 11,
                                  fontWeight: FontWeight.normal,color: AppColor.textColor ),
                            ),
                            SizedBox(height: 4,),
                            Container(
                              padding: EdgeInsets.only(bottom: 5),
                              child: CustomDropdownWidget(
                                validator: (value) {
                                  if (value == 'انتخاب کنید' || value == null || value.isEmpty) {
                                    return 'شهر را انتخاب کنید';
                                  }
                                  return null;
                                },
                                items: [
                                  'انتخاب کنید',
                                  ...controller.cityList.map((item) => item.name ?? '')
                                ].toList(),
                                selectedValue: controller.selectedCity.value?.name,
                                onChanged: (String? newValue){
                                  if (newValue == 'انتخاب کنید') {
                                    controller.changeSelectedCity(null);
                                  } else {
                                    var selectedItem = controller.cityList
                                        .firstWhere((item) => item.name == newValue);
                                    controller.changeSelectedCity(selectedItem);
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
                        SizedBox(height: 5),
                        Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              'آدرس',
                              style: AppTextStyle.labelText.copyWith(
                                  fontSize: 11,
                                  fontWeight: FontWeight.normal,
                                  color: AppColor.textColor),
                            ),
                            SizedBox(height: 4,),
                            IntrinsicHeight(
                              child: TextFormField(
                                maxLines: 2,
                                autovalidateMode: AutovalidateMode
                                    .onUserInteraction,
                                controller: controller.addressController,
                                style: AppTextStyle.labelText.copyWith(fontSize: 15),
                                textAlign: TextAlign.start,
                                keyboardType:TextInputType.text,
                                decoration: InputDecoration(
                                  contentPadding:
                                  const EdgeInsets.symmetric(
                                      vertical: 14,horizontal: 15
                                  ),
                                  isDense: true,
                                  border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(6),
                                  ),
                                  filled: true,
                                  fillColor: AppColor.textFieldColor,
                                  errorMaxLines: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        // Image upload sections
                        Row(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'تصویر کارت ملی (اختیاری)',
                                      style: AppTextStyle.labelText.copyWith(fontSize: 11,
                                          fontWeight: FontWeight.normal,color: AppColor.textColor ),
                                    ),
                                    SizedBox(height: 4),
                                    // Drag and Drop Zone for National Code
                                    GestureDetector(
                                      onTap: () => controller.pickImageNationalCodeDesktop(),
                                      child: ImageDropZoneNationalCodeInsert(
                                        controller: controller,
                                        isDesktop: isDesktop,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    // Selected Images Preview for National Code
                                    Obx(() {
                                      if (controller.isUploadingNationalCodeDesktop.value) {
                                        return Container(
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: AppColor.textFieldColor,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'در حال بارگزاری عکس',
                                                style: AppTextStyle.labelText.copyWith(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.normal,
                                                  color: AppColor.textColor,
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              const CircularProgressIndicator(),
                                            ],
                                          ),
                                        );
                                      }

                                      if (controller.selectedImagesNationalCodeDesktop.isEmpty) {
                                        return const SizedBox.shrink();
                                      }

                                      return Container(
                                        height: 100,
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: AppColor.textFieldColor,
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                            color: AppColor.textColor.withOpacity(0.3),
                                          ),
                                        ),
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: controller.selectedImagesNationalCodeDesktop.map((image) {
                                              return Stack(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
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
                                                                ),
                                                                height: Get.height * 0.8,
                                                                width: Get.width * 0.4,
                                                                child: Image.network(
                                                                  image.path,
                                                                  fit: BoxFit.contain,
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: Container(
                                                      margin: const EdgeInsets.all(4),
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(8),
                                                        border: Border.all(color: AppColor.textColor),
                                                      ),
                                                      height: 80,
                                                      width: 80,
                                                      child: Image.network(
                                                        image!.path,
                                                        fit: BoxFit.cover,
                                                        errorBuilder: (context, error, stackTrace) {
                                                          return Container(
                                                            color: AppColor.textColor.withOpacity(0.1),
                                                            child: Icon(
                                                              Icons.image,
                                                              color: AppColor.textColor.withOpacity(0.5),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 0,
                                                    right: 0,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        controller.selectedImagesNationalCodeDesktop.remove(image);
                                                      },
                                                      child: CircleAvatar(
                                                        backgroundColor: AppColor.accentColor,
                                                        radius: 12,
                                                        child: Icon(
                                                          Icons.clear,
                                                          color: AppColor.textColor,
                                                          size: 16,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      );
                                    }),
                                  ],
                                )
                            ),
                            SizedBox(width: 12),
                            Expanded(
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'تصویر جواز کسب (اختیاری)',
                                      style: AppTextStyle.labelText.copyWith(fontSize: 11,
                                          fontWeight: FontWeight.normal,color: AppColor.textColor ),
                                    ),
                                    SizedBox(height: 4),
                                    // Drag and Drop Zone for Business License
                                    GestureDetector(
                                      onTap: () => controller.pickImageBusinessLicenseDesktop(),
                                      child: ImageDropZoneBusinessLicenseInsert(
                                        controller: controller,
                                        isDesktop: isDesktop,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    // Selected Images Preview for Business License
                                    Obx(() {
                                      if (controller.isUploadingBusinessLicenseDesktop.value) {
                                        return Container(
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: AppColor.textFieldColor,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'در حال بارگزاری عکس',
                                                style: AppTextStyle.labelText.copyWith(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.normal,
                                                  color: AppColor.textColor,
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              const CircularProgressIndicator(),
                                            ],
                                          ),
                                        );
                                      }

                                      if (controller.selectedImagesBusinessLicenseDesktop.isEmpty) {
                                        return const SizedBox.shrink();
                                      }

                                      return Container(
                                        height: 100,
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: AppColor.textFieldColor,
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                            color: AppColor.textColor.withOpacity(0.3),
                                          ),
                                        ),
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: controller.selectedImagesBusinessLicenseDesktop.map((image) {
                                              return Stack(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
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
                                                                ),
                                                                height: Get.height * 0.8,
                                                                width: Get.width * 0.4,
                                                                child: Image.network(
                                                                  image.path,
                                                                  fit: BoxFit.contain,
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: Container(
                                                      margin: const EdgeInsets.all(4),
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(8),
                                                        border: Border.all(color: AppColor.textColor),
                                                      ),
                                                      height: 80,
                                                      width: 80,
                                                      child: Image.network(
                                                        image!.path,
                                                        fit: BoxFit.cover,
                                                        errorBuilder: (context, error, stackTrace) {
                                                          return Container(
                                                            color: AppColor.textColor.withOpacity(0.1),
                                                            child: Icon(
                                                              Icons.image,
                                                              color: AppColor.textColor.withOpacity(0.5),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 0,
                                                    right: 0,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        controller.selectedImagesBusinessLicenseDesktop.remove(image);
                                                      },
                                                      child: CircleAvatar(
                                                        backgroundColor: AppColor.accentColor,
                                                        radius: 12,
                                                        child: Icon(
                                                          Icons.clear,
                                                          color: AppColor.textColor,
                                                          size: 16,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      );
                                    }),
                                  ],
                                )
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 0,vertical: 10),

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
                              if(controller.nameController.text.isNotEmpty && controller.mobileController.text.isNotEmpty){
                                if (controller.idUser.value != 0) {
                                  controller.updateUser("");
                                } else {
                                  await controller.uploadAllImagesAndInsertUser();
                                }
                              }else{
                                Get.snackbar("هشدار","فیلد نام و موبایل نمی تواند خالی باشد.",
                                    titleText: Text("هشدار",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: AppColor.textColor),),
                                    messageText: Text("فیلد نام و موبایل نمی تواند خالی باشد.",textAlign: TextAlign.center,style: TextStyle(color: AppColor.textColor)));
                              }
                            },
                            child: controller.isLoading.value
                                ?
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor),
                            ) :
                            Text(
                              '${controller.title.value} کاربر ',
                              style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )
                : Center(
              child: Text(
                'خطا در سمت سرور رخ داده',
                style: AppTextStyle.labelText.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
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
