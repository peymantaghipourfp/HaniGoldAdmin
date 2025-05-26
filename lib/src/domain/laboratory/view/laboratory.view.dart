import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/widget/custom_appbar1.widget.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../widget/background_image_total.widget.dart';
import '../../../widget/custom_appbar.widget.dart';
import '../../../widget/pager_widget.dart';
import '../controller/laboratory.controller.dart';

class LaboratoryView extends GetView<LaboratoryController> {
  const LaboratoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    return Obx(()=>Scaffold(
      appBar: CustomAppbar1(
        title: 'لیست آزمایشگاه ها',
        onBackTap: () => Get.toNamed("/home"),
      ),
      body:Stack(
        children: [
          BackgroundImageTotal(),
          Padding(
            padding:  EdgeInsets.only(top: Get.height * 0.04),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SafeArea(
                  child: controller.state.value == PageStateLob.loading
                      ? Center(
                    child: SizedBox(
                        height: Get.height * 0.8 ,
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
                      : controller.state.value == PageStateLob.list
                      ? SizedBox(
                    height: Get.height *0.8,
                    width: Get.width,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 50,vertical: 10),
                            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                            color: AppColor.appBarColor.withOpacity(0.5),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: (){
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
                                                                      'ایجاد آزمایشگاه جدید',
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
                                                                    SizedBox(height: 8),
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
                                                                            maxLines: 3,
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

                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(height: 10),
                                                              Spacer(),
                                                              Container(
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
                                                                    controller.insertLaboratory();
                                                                  },
                                                                  child: controller.isLoading.value?
                                                                  CircularProgressIndicator(
                                                                    valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor),
                                                                  ) :
                                                                  Text(
                                                                    'ایجاد آزمایشگاه',
                                                                    style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  });

                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: 15,vertical: 7),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                                  color: AppColor.secondary3Color
                                              ),
                                              child: Row(
                                                children: [
                                                  Icon(Icons.add,color: AppColor.textColor,size: 21,),
                                                  Text(
                                                    'ایجاد آزمایشگاه جدید',
                                                    style: AppTextStyle.labelText.copyWith(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.normal,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 15,vertical: 8),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(5)),
                                            border: Border.all(color: AppColor.textColor)

                                        ),
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                                'assets/svg/filter3.svg',
                                                height: 17,
                                                colorFilter:
                                                ColorFilter
                                                    .mode(
                                                  AppColor
                                                      .textColor,
                                                  BlendMode
                                                      .srcIn,
                                                )),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'فیلتر',
                                              style: AppTextStyle
                                                  .labelText
                                                  .copyWith(
                                                  fontSize: isDesktop
                                                      ? 12
                                                      : 10),
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
                                              sortColumnIndex: controller.sortIndex.value,
                                              sortAscending:
                                              controller.sort.value,
                                              border: TableBorder.symmetric(
                                                  inside: BorderSide(
                                                      color: AppColor
                                                          .textFieldColor,
                                                      width: 0.5),outside: BorderSide(
                                                  color: AppColor
                                                      .textFieldColor,
                                                  width: 0.5),borderRadius: BorderRadius.circular(8)),
                                              dividerThickness: 0.3,
                                              rows: buildDataRows(
                                                  context),
                                              dataRowMaxHeight: 51,
                                              //dataRowColor: WidgetStatePropertyAll(AppColor.secondaryColor),
                                              //headingRowColor: WidgetStatePropertyAll(AppColor.primaryColor.withOpacity(0.2)),
                                              headingRowHeight: 50,
                                              columnSpacing: 150,
                                              horizontalMargin: 60,
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
              ],
            ),
          ),
          //فیلد جستجو
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 50,vertical: 10),
                padding: EdgeInsets.symmetric(horizontal: 20),
                color: AppColor.appBarColor.withOpacity(0.5),
                alignment: Alignment.center,

                height: 80,
                child: TextFormField(
                  // onChanged: (value){
                  //   Future.delayed(const Duration(milliseconds: 3000), () {
                  //     controller.getListTransactionInfo();
                  //   });
                  // },
                  controller: controller.searchController,
                  style: AppTextStyle.labelText,
                  textInputAction: TextInputAction.search,
                  // onFieldSubmitted: (value) async {
                  //   // Future.delayed(const Duration(milliseconds: 700), () {
                  //      controller.getListTransactionInfo();
                  //   // });
                  // },
                  onEditingComplete: () async {
                    // controller.getListTransactionInfo();
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
                          // controller.getListTransactionInfo();
                        },
                        icon: Icon(
                          Icons.search,
                          color: AppColor.textColor,
                          size: 30,
                        )),
                  ),
                ),
              ),
            ],
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
          label: Text('ردیف',
              style: AppTextStyle.labelText.copyWith(fontSize: 11)),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          onSort: (columnIndex, ascending) {
            print(columnIndex);
            controller.setSort(columnIndex,ascending);

            controller.onSortColum(columnIndex, ascending);
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
              Text('آدرس',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11)),
            ],
          ),
          headingRowAlignment: MainAxisAlignment.center),

      DataColumn(
          label: Row(
            children: [
              Text('تاریخ ایجاد',
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



    ];
  }

  List<DataRow> buildDataRows(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    return controller.laboratoryList
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
              "${trans.name}",
              style: AppTextStyle.bodyText
                  .copyWith(color: AppColor.textColor, fontSize: 12,),),
          ),
        )),

        DataCell(
            Center(
              child: SizedBox(
                child: Text(
                  trans.phone??"",
                  style: AppTextStyle.bodyText,
                ),
              ),
            )),

        DataCell(
            Center(
              child: SizedBox(
                child: Text(
                  trans.address??"",
                  style: AppTextStyle.bodyText,
                ),
              ),
            )),
        DataCell(Center(
          child:Row(
            children: [
              Text(
                "${trans.createdOn?.toPersianDate(twoDigits: true,showTime: true,timeSeprator: ' - ')}",
                style: AppTextStyle.bodyText,textDirection: TextDirection.ltr,
              ),
            ],
          ) ,)),

        DataCell(Center(
            child: Row(
              children: [

                GestureDetector(
                  onTap: (){
                    controller.nameController.text=trans.name??"";
                    controller.addressController.text=trans.address??"";
                    controller.phoneController.text=trans.phone??"";
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
                                          SizedBox(height: 8),
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
                                                  maxLines: 3,
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
                                          controller.updateLaboratory(trans.id??0,context);
                                        },
                                        child: controller.isLoading.value?
                                        CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor),
                                        ) :
                                        Text(
                                          'ویرایش آزمایشگاه',
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
                        AppColor.iconViewColor,
                        BlendMode.srcIn,
                      )),
                ),
              ],
            ))),
      ],
    ))
        .toList();
  }

// Widget buildPaginationControls() {
//   return Obx(() => Padding(
//     padding: const EdgeInsets.all(8.0),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         IconButton(
//           icon: Icon(Icons.chevron_left),
//           onPressed: controller.currentPageIndex.value > 1
//               ? controller.previousPage
//               : null,
//         ),
//         Text(
//           'صفحه ${controller.currentPageIndex.value}',
//           style: AppTextStyle.bodyText,
//         ),
//         IconButton(
//           icon: Icon(Icons.chevron_right),
//           onPressed:
//           controller.hasMore.value ? controller.nextPage : null,
//         ),
//       ],
//     ),
//   ));
// }

// Widget buildPaginationControls() {
//   return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child:   SizedBox(
//         height: 60,
//         child:controller.paginated!=null? SfDataPagerTheme(
//           data: SfDataPagerThemeData(
//             itemColor: Colors.transparent,
//             selectedItemColor: AppColor.secondary3Color,
//             backgroundColor: AppColor.textFieldColor,
//             itemTextStyle:  AppTextStyle.bodyText.copyWith(fontSize: 12,color: AppColor.textColor),
//             disabledItemTextStyle: AppTextStyle.bodyText.copyWith(fontSize: 12,color: AppColor.secondaryColor.withOpacity(0.5)),
//             selectedItemTextStyle: AppTextStyle.bodyText.copyWith(fontSize: 12,color: AppColor.textColor),
//             itemBorderColor: AppColor.textColor
//           ),
//           child: SfDataPager(
//             controller:controller.dataPagerController ,
//             onPageNavigationEnd:(value){
//               print(value+1);
//                controller.isChangePage(value+1);
//             },
//             onPageNavigationStart: (value){
//              // print(value);
//              // controller.getUserList();
//             },
//             delegate: DataPagerDelegate(),
//             direction: Axis.horizontal, pageCount: (controller.paginated!.totalCount!/10).toDouble(),
//           ),
//         ):SizedBox(),
//       )
//   );
// }



}


