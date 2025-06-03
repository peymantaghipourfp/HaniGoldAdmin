import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/users/controller/person_list.controller.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../widget/background_image_total.widget.dart';
import '../../../widget/custom_appbar1.widget.dart';
import '../../../widget/pager_widget.dart';
import '../widgets/filter_user_list.widget.dart';

class PersonListView extends GetView<PersonListController> {
  const PersonListView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    return Obx(()=>Scaffold(
      appBar: CustomAppbar1(
        title: 'لیست کاربران',
        onBackTap: () => Get.toNamed("/home"),
      ),
      body:Stack(
        children: [
          BackgroundImageTotal(),
          SafeArea(
            child: controller.state.value == PageStateUser.loading
                ? Center(
              child: SizedBox(
                  height: Get.height ,
                  width: Get.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: 50,width: 50,
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: CircularProgressIndicator(),
                          )),
                    ],
                  )),
            )
                : controller.state.value == PageStateUser.list
                ? SizedBox(
              height: Get.height *0.85,
              width: Get.width,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    //فیلد جستجو
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 50,vertical: 10),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      color: AppColor.appBarColor.withOpacity(0.5),
                      alignment: Alignment.center,

                      height: 80,
                      child: TextFormField(
                        onChanged: (value){
                          // Future.delayed(const Duration(milliseconds: 5000), () {
                          //   controller.getUserAccountList();
                          // });
                        },
                        controller: controller.nameFilterController,
                        style: AppTextStyle.labelText,
                        textInputAction: TextInputAction.search,
                        onFieldSubmitted: (value) async {
                          // Future.delayed(const Duration(milliseconds: 700), () {
                       //   controller.getUserAccountList();
                          // });
                        },
                        onEditingComplete: () async {
                          controller.getUserAccountList();
                        },

                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                          filled: true,
                          fillColor: AppColor.textFieldColor,
                          hintText: "جستجو ... ",
                          hintStyle: AppTextStyle.labelText,

                          prefixIcon: IconButton(
                              onPressed: () async {
                                controller.getUserAccountList();
                              },
                              icon: Icon(
                                Icons.search,
                                color: AppColor.textColor,
                                size: 30,
                              )),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 50,vertical: 10),
                      padding: EdgeInsets.symmetric(horizontal: 50,vertical: 20),
                      color: AppColor.appBarColor.withOpacity(0.5),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(width: 30,),
                                // Row(
                                //   children: [
                                //     ElevatedButton(
                                //       style: ButtonStyle(
                                //           padding: WidgetStatePropertyAll(
                                //               EdgeInsets.symmetric(horizontal: 12,vertical: 17)),
                                //           elevation: WidgetStatePropertyAll(5),
                                //           backgroundColor:
                                //           WidgetStatePropertyAll(AppColor.secondary3Color),
                                //           shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                                //               borderRadius: BorderRadius.circular(5)))),
                                //       onPressed: () async {
                                //         Get.toNamed("/insertUser",parameters: {"id":0.toString()});
                                //       },
                                //       child: Row(
                                //         children: [
                                //           Icon(Icons.add,color: AppColor.textColor,size: 18,),
                                //           SizedBox(width: 5,),
                                //           Text(
                                //             'تبدیل کاربر',
                                //             style: AppTextStyle.labelText,
                                //           ),
                                //         ],
                                //       ),
                                //     ),
                                //     SizedBox(width: 20,),
                                //   ],
                                // ),
                                ElevatedButton(
                                  style: ButtonStyle(
                                      padding: WidgetStatePropertyAll(
                                          EdgeInsets.symmetric(horizontal: 23,vertical: 19)),
                                      // elevation: WidgetStatePropertyAll(5),
                                      backgroundColor:
                                      WidgetStatePropertyAll(AppColor.appBarColor.withOpacity(0.5)),
                                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(side: BorderSide(color: AppColor.textColor),
                                          borderRadius: BorderRadius.circular(5)))),
                                  onPressed: () async {
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
                                            child: FitterUserListWidget(),
                                          );
                                        });
                                  },
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                          'assets/svg/filter3.svg',
                                          height: 17,
                                          colorFilter:
                                          ColorFilter
                                              .mode(
                                            controller.nameFilterController.text!="" ||  controller.mobileFilterController.text!="" ?AppColor.accentColor:  AppColor
                                                .textColor,
                                            BlendMode
                                                .srcIn,
                                          )),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'فیلتر',
                                        style: AppTextStyle
                                            .labelText
                                            .copyWith(
                                            fontSize: isDesktop
                                                ? 12
                                                : 10,color:  controller.nameFilterController.text!="" ||  controller.mobileFilterController.text!="" ?AppColor.accentColor: AppColor.textColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ],

                            ),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            controller:
                            controller.scrollController,
                            physics: ClampingScrollPhysics(),
                            child: Row(
                              children: [
                                SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      DataTable(
                                        columns:
                                        buildDataColumns(),
                                        border: TableBorder.symmetric(
                                            inside: BorderSide(color: AppColor.textColor, width: 0.3),
                                            outside: BorderSide(color: AppColor.textColor, width: 0.3),
                                            borderRadius: BorderRadius.circular(8)),
                                        dividerThickness: 0.3,
                                        rows: buildDataRows(
                                            context),
                                        dataRowMaxHeight: 50,
                                        //dataRowColor: WidgetStatePropertyAll(AppColor.secondaryColor),
                                        //headingRowColor: WidgetStatePropertyAll(AppColor.primaryColor.withOpacity(0.2)),
                                        headingRowHeight: 40,
                                        columnSpacing: 90,
                                        horizontalMargin: 30,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
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
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              controller.paginated!=null?   Container(
                  height: 70,
                  margin: EdgeInsets.symmetric(horizontal: 50,vertical: 10),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  color: AppColor.appBarColor.withOpacity(0.5),
                  alignment: Alignment.bottomCenter,
                  child:PagerWidget(countPage: controller.paginated!.totalCount??0, callBack: (int index) {
                    controller.isChangePage(index);
                  },)):SizedBox(),
            ],
          ),
        ],
      ),
    ));
  }
  List<DataColumn> buildDataColumns() {
    return [
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 50,),
              child: Text('ردیف',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11))),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          onSort: (columnIndex, ascending) {
            print(columnIndex);
            controller.setSort(columnIndex,ascending);

          },
          label: Text('نام',
              style: AppTextStyle.labelText.copyWith(fontSize: 11)),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: Row(
            children: [
              Text('موبایل',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11)),
            ],
          ),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: Row(
            children: [
              Text('وضعیت',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11)),
            ],
          ),
          headingRowAlignment: MainAxisAlignment.center),

      DataColumn(
          label: Row(
            children: [
              Text('نام کاربری',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11)),
            ],
          ),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: Row(
            children: [
              Text('ایمیل',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11)),
            ],
          ),
          headingRowAlignment: MainAxisAlignment.center),

      DataColumn(
          label: Row(
            children: [
              Text('عملیات',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11)),
            ],
          ),
          headingRowAlignment: MainAxisAlignment.center),

      DataColumn(
          label: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('وضعیت',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11)),
              Text('فعال / غیر فعال',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11)),
            ],
          ),
          headingRowAlignment: MainAxisAlignment.center),


    ];
  }

  List<DataRow> buildDataRows(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    return controller.userList
        .map((trans) => DataRow(
      cells: [
        DataCell(
            Center(
              child: Text(
                "${trans.rowNum}",
                style: AppTextStyle.bodyText,
              ),
            )),
        DataCell(Center(
          child: GestureDetector(
            onTap: (){
              //  Get.toNamed("/userInfoTransaction",parameters: {"accountId":trans.accountId.toString()});
              // /controller.getInfo(trans.accountId);
            },
            child: Text(
              trans.contact?.name??"",
              style: AppTextStyle.bodyText
                  .copyWith(color: AppColor.textColor, fontSize: 12,),),
          ),
        )),

        DataCell(
            Center(
              child: SizedBox(
                child: Text(
                  trans.mobileNumber??"",
                  style: AppTextStyle.bodyText,
                ),
              ),
            )),
        DataCell(Center(
            child: Container(
          //    alignment: Alignment.center,
              width: 50,
              padding: EdgeInsets.symmetric(horizontal: 6,vertical: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color:trans.status==1?AppColor.primaryColor: AppColor.accentColor
              ),
              child:Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    trans.status==1?   "فعال":"غیرفعال",
                    style: AppTextStyle.bodyText.copyWith(fontSize: 9),
                  ),
                ],
              ) ,

            ))),

        DataCell(
            Center(
              child: SizedBox(
                child: Text(
                  trans.userName??"",
                  style: AppTextStyle.bodyText,
                ),
              ),
            )),
        DataCell(Center(
          child:Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                trans.email??"-",
                style: AppTextStyle.bodyText,textDirection: TextDirection.ltr,
              ),
            ],
          ) ,)),

        DataCell(Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: (){
                    controller.emailUpdateEndController.text=trans.email??"";
                    controller.userNameUpdateEndController.text=trans.userName??"";
                    controller.mobileUpdateEndController.text=trans.mobileNumber??"";
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
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: AppColor.appBarColor
                                ),
                                width:isDesktop?  Get.width * 0.3:Get.height * 0.5,
                                height:isDesktop?  Get.height * 0.65:Get.height * 0.7,
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            'ویرایش آزمایشگاه جدید',
                                            style: AppTextStyle.labelText.copyWith(
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 30),
                                      child: Column(
                                        children: [
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
                                                  controller: controller.userNameUpdateEndController,
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
                                                'تلفن تماس',
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
                                                  controller: controller.mobileUpdateEndController,
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
                                                'ایمیل',
                                                style: AppTextStyle.labelText.copyWith(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.normal,
                                                    color: AppColor.textColor),
                                              ),
                                              SizedBox(height: 10,),
                                              IntrinsicHeight(
                                                child: TextFormField(
                                                  maxLines: 3,
                                                  autovalidateMode: AutovalidateMode
                                                      .onUserInteraction,
                                                  controller: controller.emailUpdateEndController,
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

                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Spacer(),
                                    Obx(()=>Container(
                                      margin: EdgeInsets.symmetric(horizontal: 40,vertical: 10),

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
                                         controller.updateUserAccount(trans.id??0);
                                        },
                                        child: controller.isLoading.value?
                                        CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor),
                                        ) :
                                        Text(
                                          'ویرایش کاربر',
                                          style: AppTextStyle.labelText.copyWith(fontSize:  12 ),
                                        ),
                                      ),
                                    ),)
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  },
                  child: SvgPicture.asset('assets/svg/edit.svg',height: 20,
                      colorFilter: ColorFilter.mode(
                        AppColor.textColor,
                        BlendMode.srcIn,
                      )),
                ),
              ],
            ))),
        DataCell(Center(
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  onTap: (){
                    controller.updateUserStatusAccount(trans.id??0,-1);
                  },
                  child: SvgPicture.asset('assets/svg/close-circle1.svg',
                      colorFilter: ColorFilter.mode(
                        AppColor.accentColor,
                        BlendMode.srcIn,
                      )),
                ),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: (){
                    controller.updateUserStatusAccount(trans.id??0,1);
                  },
                  child: SvgPicture.asset('assets/svg/check-mark-circle.svg',
                      colorFilter: ColorFilter.mode(
                        AppColor.primaryColor,
                        BlendMode.srcIn,
                      )),
                ),
                SizedBox(
                  width: 20,
                ),
              ],
            ))),



      ],
    ))
        .toList();
  }
}
