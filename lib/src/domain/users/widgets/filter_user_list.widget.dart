import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../controller/person_list.controller.dart';

class FitterUserListWidget extends StatefulWidget {
  const FitterUserListWidget({super.key});

  @override
  State<FitterUserListWidget> createState() => _FitterUserListWidgetState();
}

class _FitterUserListWidgetState extends State<FitterUserListWidget> {

  var controller=Get.find<PersonListController>();
  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    return Obx(()=>Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AppColor.backGroundColor
        ),
        width:isDesktop?  Get.width * 0.2:Get.height * 0.5,
        height:isDesktop?  Get.height * 0.6:Get.height * 0.7,
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'فیلتر',
                      style: AppTextStyle.labelText.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                   padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppColor.accentColor
                    ),
                    child: GestureDetector(
                      onTap: (){
                       setState(() {
                         controller.nameFilterController.text="";
                         controller.nameAccController.text="";
                         controller.mobileFilterController.text="";
                         controller.nameUserController.text="";
                         controller.status.value=0;
                       });

                      },
                      child: Text(
                        'حذف فیلتر',
                        style: AppTextStyle.labelText.copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                color: AppColor.textColor,height: 0.2,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    SizedBox(height: 8,),
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
                            controller: controller.nameFilterController,
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
                    SizedBox(height: 8,),
                    Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          'نام اکانت',
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
                            controller: controller.nameAccController,
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
                    SizedBox(height: 8,),
                    Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          'نام کاربری',
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
                            controller: controller.nameUserController,
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
                    SizedBox(height: 8,),
                    Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          'شماره تماس',
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
                            controller: controller.mobileFilterController,
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
                    SizedBox(height: 8),
                    Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          'وضعیت',
                          style: AppTextStyle.labelText.copyWith(
                              fontSize: 11,
                              fontWeight: FontWeight.normal,
                              color: AppColor.textColor),
                        ),
                        SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: (){
                                controller.checkStatus(1);
                              },
                              child: Row(
                                children: [
                                  Text(
                                    'فعال',
                                    style: AppTextStyle.labelText.copyWith(
                                        fontSize: 11,
                                        fontWeight: FontWeight.normal,
                                        color: AppColor.textColor),
                                  ),
                                  controller.status.value==1? Icon(Icons.radio_button_checked): Icon(Icons.radio_button_off)
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                controller.checkStatus(-1);
                              },
                              child: Row(
                                children: [
                                  Text(
                                    'غیر فعال',
                                    style: AppTextStyle.labelText.copyWith(
                                        fontSize: 11,
                                        fontWeight: FontWeight.normal,
                                        color: AppColor.textColor),
                                  ),
                                  controller.status.value==-1? Icon(Icons.radio_button_checked): Icon(Icons.radio_button_off)
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 8),
          
                  ],
                ),
              ),
             // Spacer(),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  style: ButtonStyle(
                      padding: WidgetStatePropertyAll(
                          EdgeInsets.symmetric(horizontal: 23,vertical: 19)),
                      // elevation: WidgetStatePropertyAll(5),
                      backgroundColor:
                      WidgetStatePropertyAll(AppColor.appBarColor),
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(side: BorderSide(color: AppColor.textColor),
                          borderRadius: BorderRadius.circular(5)))),
                  onPressed: () async {
                    controller.getUserAccountList();
                    Get.back();
          
                  },
                  child: controller.isLoading.value?
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor),
                  ) :
                  Text(
                    'فیلتر',
                    style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
