import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/widget/custom_appbar1.widget.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../widget/background_image.widget.dart';
import '../../../widget/background_image_total.widget.dart';
import '../../../widget/custom_appbar.widget.dart';
import '../../../widget/custom_dropdown.widget.dart';
import '../../../widget/pager_widget.dart';
import '../controller/insert_user.controller.dart';
import '../controller/user_list.controller.dart';

class InsertUserView extends GetView<InsertUserController> {
  const InsertUserView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    return Obx(()=>Scaffold(
      appBar: CustomAppbar1(
        title: ' ${controller.title.value} کاربر جدید ',
        onBackTap: () => Get.back(),
      ),
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
                            Text(
                              'نقش کاربر',
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
                                controller: controller.userController,
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
                              'نام',
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
                              'موبایل',
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
                                controller: controller.mobileController,
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
                              'تلفن ثابت',
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
                            SizedBox(height: 10,),
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
                        Column(
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
                        ),
                        SizedBox(height: 5,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'استان',
                              style: AppTextStyle.labelText.copyWith(fontSize: 11,
                                  fontWeight: FontWeight.normal,color: AppColor.textColor ),
                            ),
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
                            SizedBox(height: 10,),
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
                            controller.idUser.value!=0?controller.updateUser() : controller.insertUser();
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
    ));
  }
}
