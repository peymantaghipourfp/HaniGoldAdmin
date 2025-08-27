import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/account/model/account.model.dart';
import 'package:hanigold_admin/src/domain/inventory/controller/inventory_create_receive.controller.dart';
import 'package:hanigold_admin/src/domain/inventory/controller/inventory_update_receive.controller.dart';
import 'package:hanigold_admin/src/widget/background_image.widget.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../widget/app_drawer.widget.dart';
import '../../../widget/custom_appbar.widget.dart';
import '../../../widget/custom_appbar1.widget.dart';
import '../../../widget/custom_dropdown.widget.dart';
import '../../../widget/pager_widget.dart';
import '../../home/widget/chat_dialog.widget.dart';
import '../../users/widgets/balance.widget.dart';
import '../controller/inventory_detail_insert_payment.controller.dart';
import '../controller/inventory_detail_insert_receive.controller.dart';

class InventoryDetailInsertPaymentView extends StatefulWidget {
  const InventoryDetailInsertPaymentView({super.key});

  @override
  State<InventoryDetailInsertPaymentView> createState() =>
      _InventoryDetailInsertPaymentViewState();
}

class _InventoryDetailInsertPaymentViewState
    extends State<InventoryDetailInsertPaymentView>
    with TickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();
  InventoryDetailInsertPaymentController inventoryDetailInsertPaymentController = Get
      .find<InventoryDetailInsertPaymentController>();


  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    final isMobile = ResponsiveBreakpoints
        .of(context)
        .isMobile;
    return Obx(() {
      return Scaffold(
        appBar:
        CustomAppbar1(title: 'ایجاد پرداختی جدید', onBackTap: () => Get.back(),),
        drawer: const AppDrawer(),
        body: Stack(
          children: [
            BackgroundImage(),
            SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  child: ResponsiveRowColumn(
                    layout: isDesktop
                        ? ResponsiveRowColumnType.ROW
                        : ResponsiveRowColumnType.COLUMN,
                    columnSpacing: 30,
                    rowSpacing: 20,
                    rowCrossAxisAlignment: CrossAxisAlignment.start,
                    rowMainAxisAlignment: MainAxisAlignment.start,
                    columnCrossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if(isMobile)
                        ResponsiveRowColumnItem(
                          rowFlex: 1,
                          child:
                          inventoryDetailInsertPaymentController.balanceList
                              .isEmpty ?
                          Center(child: CircularProgressIndicator(),)
                              :
                          BalanceWidget(
                            listBalance: inventoryDetailInsertPaymentController
                                .balanceList,
                            size: 400,),
                        ),
                      ResponsiveRowColumnItem(
                        rowFlex: 2,
                        child: Container(
                          constraints: BoxConstraints(maxWidth: 700),
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 20),
                          /*decoration: BoxDecoration(
                            color: AppColor.backGroundColor1,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 12,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),*/
                          child: SizedBox(
                            width: Get.width * 0.9,
                            height: Get.height,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ResponsiveRowColumnItem(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 40, bottom: 10),
                                        child: Text(
                                          'پرداختی جدید',
                                          style: AppTextStyle.smallTitleText,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ResponsiveRowColumnItem(
                                  child: isDesktop ? SizedBox(width: 480,
                                    child: Divider(
                                      height: 1,
                                      color: AppColor.appBarColor,
                                    ),
                                  ) : SizedBox(width: 420,
                                    child: Divider(
                                      height: 1,
                                      color: AppColor.appBarColor,
                                    ),
                                  ),
                                ),
                                ResponsiveRowColumnItem(
                                    rowFlex: 1,
                                    child: SingleChildScrollView(
                                      physics: BouncingScrollPhysics(),
                                      child: Container(
                                        constraints: isDesktop ? BoxConstraints(
                                            maxWidth: 500) : BoxConstraints(
                                            maxWidth: 400),
                                        padding: isDesktop
                                            ? const EdgeInsets.symmetric(
                                            horizontal: 40)
                                            : const EdgeInsets.symmetric(
                                            horizontal: 24),
                                        child:
                                        Form(
                                          key: formKey,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: [
                                              // ولت اکانت
                                              Container(
                                                padding: EdgeInsets.only(
                                                    bottom: 3, top: 5),
                                                child: Text(
                                                  'حساب wallet',
                                                  style: AppTextStyle.labelText
                                                      .copyWith(
                                                      fontSize: isDesktop
                                                          ? 12
                                                          : 10),
                                                ),
                                              ),
                                              // ولت اکانت
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
                                                              .labelText
                                                              .copyWith(
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
                                                  items:
                                                  inventoryDetailInsertPaymentController
                                                      .walletAccountList.map((
                                                      wallet) {
                                                    return DropdownMenuItem(
                                                        value: wallet,
                                                        child: Row(
                                                          children: [
                                                            Text("${wallet.item
                                                                ?.name}" ?? "",
                                                              style: AppTextStyle
                                                                  .bodyText,),
                                                          ],
                                                        ));
                                                  }).toList(),
                                                  value: inventoryDetailInsertPaymentController
                                                      .selectedWalletAccount
                                                      .value,
                                                  onChanged: (newValue) {
                                                    if (newValue != null) {
                                                      inventoryDetailInsertPaymentController
                                                          .changeSelectedWalletAccount(
                                                          newValue);
                                                    }
                                                  },
                                                  buttonStyleData: ButtonStyleData(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 5),
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
                                                    padding: EdgeInsets
                                                        .symmetric(
                                                        horizontal: 10),
                                                  ),
                                                ),
                                              ),
                                              // لیست دریافتی ها
                                              inventoryDetailInsertPaymentController.selectedWalletAccount.value?.item?.id == 1 ?
                                              ElevatedButton(
                                                style: ButtonStyle(
                                                    fixedSize: WidgetStatePropertyAll(
                                                      Size(
                                                          isDesktop
                                                              ? Get.width * 0.10
                                                              : Get.width * 0.3,
                                                          isDesktop ? 40 : 30
                                                      ),
                                                    ),
                                                    padding: WidgetStatePropertyAll(
                                                      EdgeInsets.symmetric(
                                                          horizontal: isDesktop
                                                              ? 12
                                                              : 5
                                                      ),),
                                                    elevation: WidgetStatePropertyAll(
                                                        5),
                                                    backgroundColor:
                                                    WidgetStatePropertyAll(
                                                        AppColor.buttonColor),
                                                    shape: WidgetStatePropertyAll(
                                                        RoundedRectangleBorder(
                                                            borderRadius: BorderRadius
                                                                .circular(
                                                                10)))),
                                                onPressed: () async {
                                                  showForPaymentModal();
                                                  print(
                                                      'idIttttem ${inventoryDetailInsertPaymentController
                                                          .selectedWalletAccount
                                                          .value?.item?.id}');
                                                  print(
                                                      'idIttttemUnnnnitId ${inventoryDetailInsertPaymentController
                                                          .selectedWalletAccount
                                                          .value?.item?.itemUnit
                                                          ?.id}');
                                                },
                                                child: inventoryDetailInsertPaymentController
                                                    .isLoading.value
                                                    ?
                                                CircularProgressIndicator(
                                                  valueColor: AlwaysStoppedAnimation<
                                                      Color>(
                                                      AppColor.textColor),
                                                ) :
                                                Text(
                                                  'لیست دریافتی ها',
                                                  style: AppTextStyle.bodyText,
                                                ),
                                              )
                                                  : SizedBox.shrink(),
                                              // مقدار
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment
                                                    .start,
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        bottom: 3, top: 5),
                                                    child: Text(
                                                      'مقدار',
                                                      style: AppTextStyle
                                                          .labelText,
                                                    ),
                                                  ),
                                                  // مقدار
                                                  Container(
                                                    //height: 50,
                                                    padding: EdgeInsets.only(
                                                        bottom: 5),
                                                    child:
                                                    IntrinsicHeight(
                                                      child: TextFormField(
                                                        validator: (value) {
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            return 'لطفا مقدار را وارد کنید';
                                                          }
                                                          return null;
                                                        },
                                                        autovalidateMode: AutovalidateMode
                                                            .onUserInteraction,
                                                        controller: inventoryDetailInsertPaymentController
                                                            .quantityController,
                                                        style: AppTextStyle
                                                            .labelText,
                                                        keyboardType: TextInputType
                                                            .numberWithOptions(
                                                            decimal: true),
                                                        inputFormatters: [
                                                          FilteringTextInputFormatter
                                                              .allow(
                                                              RegExp(
                                                                  r'^[\d٠-٩۰-۹]*\.?[\d٠-٩۰-۹]*$')),
                                                          TextInputFormatter
                                                              .withFunction((
                                                              oldValue,
                                                              newValue) {
                                                            // تبدیل اعداد فارسی به انگلیسی برای پردازش راحت‌تر
                                                            String newText = newValue
                                                                .text
                                                                .replaceAll(
                                                                '٠', '0')
                                                                .replaceAll(
                                                                '١', '1')
                                                                .replaceAll(
                                                                '٢', '2')
                                                                .replaceAll(
                                                                '٣', '3')
                                                                .replaceAll(
                                                                '٤', '4')
                                                                .replaceAll(
                                                                '٥', '5')
                                                                .replaceAll(
                                                                '٦', '6')
                                                                .replaceAll(
                                                                '٧', '7')
                                                                .replaceAll(
                                                                '٨', '8')
                                                                .replaceAll(
                                                                '٩', '9');

                                                            return newValue
                                                                .copyWith(
                                                                text: newText,
                                                                selection: TextSelection
                                                                    .collapsed(
                                                                    offset: newText
                                                                        .length));
                                                          }),
                                                        ],
                                                        decoration: InputDecoration(
                                                          isDense: true,
                                                          border: OutlineInputBorder(
                                                            borderRadius: BorderRadius
                                                                .circular(10),
                                                          ),
                                                          filled: true,
                                                          fillColor: AppColor
                                                              .textFieldColor,
                                                          errorMaxLines: 1,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              // تاریخ
                                              Container(
                                                padding: EdgeInsets.only(
                                                    bottom: 3, top: 5),
                                                child: Text(
                                                  'تاریخ سفارش',
                                                  style: AppTextStyle.labelText
                                                      .copyWith(
                                                      fontSize: isDesktop
                                                          ? 12
                                                          : 10),
                                                ),
                                              ),
                                              // تاریخ
                                              Container(
                                                //height: 50,
                                                padding: EdgeInsets.only(
                                                    bottom: 5),
                                                child: IntrinsicHeight(
                                                  child: TextFormField(
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'لطفا تاریخ را انتخاب کنید';
                                                      }
                                                      return null;
                                                    },
                                                    controller: inventoryDetailInsertPaymentController
                                                        .dateController,
                                                    readOnly: true,
                                                    style: AppTextStyle
                                                        .labelText,
                                                    decoration: InputDecoration(
                                                      suffixIcon: Icon(
                                                          Icons.calendar_month,
                                                          color: AppColor
                                                              .textColor),
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius
                                                            .circular(10),
                                                      ),
                                                      filled: true,
                                                      fillColor: AppColor
                                                          .textFieldColor,
                                                      errorMaxLines: 1,
                                                    ),
                                                    onTap: () async {
                                                      Jalali? pickedDate = await showPersianDatePicker(
                                                        context: context,
                                                        initialDate: Jalali
                                                            .now(),
                                                        firstDate: Jalali(
                                                            1400, 1, 1),
                                                        lastDate: Jalali(
                                                            1450, 12, 29),
                                                        initialEntryMode: PersianDatePickerEntryMode
                                                            .calendar,
                                                        initialDatePickerMode: PersianDatePickerMode
                                                            .day,
                                                        locale: Locale(
                                                            "fa", "IR"),
                                                      );
                                                      DateTime date = DateTime
                                                          .now();
                                                      if (pickedDate != null) {
                                                        inventoryDetailInsertPaymentController
                                                            .dateController
                                                            .text =
                                                        "${pickedDate
                                                            .year}/${pickedDate
                                                            .month.toString()
                                                            .padLeft(2,
                                                            '0')}/${pickedDate
                                                            .day.toString()
                                                            .padLeft(
                                                            2, '0')} ${date.hour
                                                            .toString().padLeft(
                                                            2, '0')}:${date
                                                            .minute.toString()
                                                            .padLeft(
                                                            2, '0')}:${date
                                                            .second.toString()
                                                            .padLeft(2, '0')}";
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ),
                                              // توضیحات
                                              Container(
                                                padding: EdgeInsets.only(
                                                    bottom: 3, top: 5),
                                                child: Text(
                                                  'توضیحات',
                                                  style: AppTextStyle.labelText
                                                      .copyWith(
                                                      fontSize: isDesktop
                                                          ? 12
                                                          : 10),
                                                ),
                                              ),
                                              // توضیحات
                                              Container(
                                                padding: EdgeInsets.only(
                                                    bottom: 5),
                                                child:
                                                TextFormField(
                                                  controller: inventoryDetailInsertPaymentController
                                                      .descriptionController,
                                                  maxLines: 4,
                                                  style: AppTextStyle.labelText,
                                                  decoration: InputDecoration(
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius
                                                          .circular(10),
                                                    ),
                                                    filled: true,
                                                    fillColor: AppColor
                                                        .textFieldColor,
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Obx(() {
                                                    if (inventoryDetailInsertPaymentController
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
                                                      width: Get.width * 0.17,
                                                      child: SingleChildScrollView(
                                                        scrollDirection: Axis.horizontal,
                                                        child: Row(
                                                          children: inventoryDetailInsertPaymentController.selectedImagesDesktop.map((e){
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
                                                                    inventoryDetailInsertPaymentController.selectedImagesDesktop.remove(e);
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
                                                        inventoryDetailInsertPaymentController.pickImageDesktop(),
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
                                              //  دکمه ثبت نهایی
                                              SizedBox(height: 20,),
                                              SizedBox(width: double.infinity,
                                                height: 40,
                                                // دکمه ثبت نهایی
                                                child: ElevatedButton(
                                                  style: ButtonStyle(
                                                      fixedSize: WidgetStatePropertyAll(
                                                          Size(Get.width * .77,
                                                              40)),
                                                      padding: WidgetStatePropertyAll(
                                                        EdgeInsets.symmetric(
                                                            horizontal: isDesktop
                                                                ? 20
                                                                : 7
                                                        ),),
                                                      elevation: WidgetStatePropertyAll(
                                                          5),
                                                      backgroundColor:
                                                      WidgetStatePropertyAll(
                                                          AppColor
                                                              .primaryColor),
                                                      shape: WidgetStatePropertyAll(
                                                          RoundedRectangleBorder(
                                                              borderRadius: BorderRadius
                                                                  .circular(
                                                                  10)))),
                                                  onPressed: () async {
                                                   if(formKey.currentState!.validate()){
                                                     if(inventoryDetailInsertPaymentController.selectedWalletAccount.value!=null){
                                                       inventoryDetailInsertPaymentController.uploadImagesDesktop( "image", "InventoryDetail");
                                                     }
                                                   }
                                                  },
                                                  child: inventoryDetailInsertPaymentController
                                                      .isLoading.value
                                                      ?
                                                  CircularProgressIndicator(
                                                    valueColor: AlwaysStoppedAnimation<
                                                        Color>(
                                                        AppColor.textColor),
                                                  ) :
                                                  Text(
                                                    'درج جدید',
                                                    style: AppTextStyle
                                                        .bodyText,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )


                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if(isDesktop)
                        ResponsiveRowColumnItem(
                          rowFlex: 1,
                          child:
                          inventoryDetailInsertPaymentController.balanceList
                              .isEmpty ?
                          Center(child: CircularProgressIndicator(),)
                              :
                          BalanceWidget(
                            listBalance: inventoryDetailInsertPaymentController
                                .balanceList,
                            size: 400,),
                        ),
                    ],
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
      );
    });
  }

  void showForPaymentModal() {
    Get.dialog(
      SingleChildScrollView(
        child: Dialog(
          backgroundColor: AppColor.backGroundColor,
          insetPadding: EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 600,
              maxHeight: Get.height * 0.8,
            ),
            child: Column(
              children: [
                buildForPaymentDetail(),
                Obx(() {
                  return Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        inventoryDetailInsertPaymentController.paginated.value != null
                            ? Container(
                            height: 70,
                            margin: EdgeInsets.symmetric(
                                horizontal: 70, vertical: 10),
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            color: AppColor.appBarColor.withOpacity(0.5),
                            alignment: Alignment.bottomCenter,
                            child: PagerWidget(
                              countPage: inventoryDetailInsertPaymentController
                                  .paginated.value?.totalCount ?? 0,
                              callBack: (int index) {
                                inventoryDetailInsertPaymentController.isChangePage(
                                    index);
                              },))
                            : SizedBox(),
                      ],
                    ),
                  );
                }),
                /*TextButton(
                  onPressed: () =>
                      Get.back(),
                  child: Text("بستن", style: AppTextStyle.bodyText,),
                ),*/
                //SizedBox(height: 15,),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildForPaymentDetail() {
    return Obx(() {
      return
        inventoryDetailInsertPaymentController.isLoading.value ?
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<
              Color>(
              AppColor.textColor),
        ) :
        // لیست ForPayment مربوط به هر ولت
        SizedBox(
          height: Get.height * 0.65, // تعیین ارتفاع ثابت
          width: Get.width * 0.5,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 12,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('لیست دریافتی ها', style: AppTextStyle.smallTitleText),
                      IconButton(
                          onPressed: Get.back,
                          icon: Icon(Icons.close))
                    ],
                  ),
                ),
                SizedBox(height: 12,),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 41,
                        child: TextFormField(
                          controller: inventoryDetailInsertPaymentController
                              .searchLaboratoryController,
                          style: AppTextStyle.labelText,
                          textInputAction: TextInputAction.search,
                          onFieldSubmitted: (value) async {
                            if (value.isNotEmpty) {
                              await inventoryDetailInsertPaymentController
                                  .searchLaboratory(value);
                              showSearchResults(context);
                            } else {
                              inventoryDetailInsertPaymentController
                                  .clearSearch();
                            }
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: AppColor.textFieldColor,
                            hintText: "جستجو ... ",
                            hintStyle: AppTextStyle.labelText,
                            prefixIcon: IconButton(
                                onPressed: () async {
                                  if (inventoryDetailInsertPaymentController
                                      .searchLaboratoryController
                                      .text.isNotEmpty) {
                                    await inventoryDetailInsertPaymentController
                                        .searchLaboratory(
                                        inventoryDetailInsertPaymentController
                                            .searchLaboratoryController.text
                                    );
                                    showSearchResults(context);
                                  } else {
                                    inventoryDetailInsertPaymentController
                                        .clearSearch();
                                  }
                                },
                                icon: Icon(
                                  Icons.search, color: AppColor.textColor,
                                  size: 30,)
                            ),
                            suffixIcon: inventoryDetailInsertPaymentController
                                .selectedLaboratoryId.value > 0
                                ? IconButton(
                              onPressed: inventoryDetailInsertPaymentController
                                  .clearSearch,
                              icon: Icon(
                                  Icons.close, color: AppColor.textColor),
                            )
                                : null,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                inventoryDetailInsertPaymentController.forPaymentList.isNotEmpty ?
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: Get.height * 0.65,
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: inventoryDetailInsertPaymentController
                        .forPaymentList.length,
                    itemBuilder: (context,
                        index) {
                      final forPayment = inventoryDetailInsertPaymentController
                          .forPaymentList[index];
                      return ListTile(
                        onTap: () {
                          Get.back();
                          if (forPayment.id != null) {
                            inventoryDetailInsertPaymentController
                                .selectedForPaymentId.add(forPayment.id!);
                          }

                          inventoryDetailInsertPaymentController
                              .selectedInputItem.value = forPayment;

                          inventoryDetailInsertPaymentController.selectQuantity(
                              forPayment.quantityRemainded ?? 0.0);
                          inventoryDetailInsertPaymentController
                              .selectedLaboratory.value = forPayment.laboratory;
                          inventoryDetailInsertPaymentController
                              .quantityController.text =
                              forPayment.quantityRemainded?.toString() ?? '0';
                          inventoryDetailInsertPaymentController
                              .impurityController.text =
                              forPayment.impurity?.toString() ?? '0';
                          inventoryDetailInsertPaymentController
                              .weight750Controller.text =
                              forPayment.weight750?.toString() ?? '0';
                          inventoryDetailInsertPaymentController.caratController
                              .text = forPayment.carat?.toString() ?? '0';
                          inventoryDetailInsertPaymentController
                              .receiptNumberController.text =
                              forPayment.receiptNumber ?? '';
                        },
                        contentPadding: EdgeInsets.zero,
                        title: Card(
                          color: inventoryDetailInsertPaymentController
                              .selectedForPaymentId.contains(forPayment.id)
                              ? AppColor.textFieldColor
                              : AppColor.secondaryColor,
                          child: Padding(
                            padding: const EdgeInsets
                                .only(
                                top: 8,
                                left: 12,
                                right: 12,
                                bottom: 8),
                            child: Column(
                              children: [
                                // آزمایشگاه
                                Row(
                                  children: [
                                    Text(
                                        ' آزمایشگاه: ',
                                        style: AppTextStyle
                                            .labelText),
                                    Text(
                                        forPayment.laboratory?.name ?? '',
                                        style: AppTextStyle
                                            .bodyText),
                                  ],
                                ),
                                SizedBox(height: 5,),
                                Divider(
                                  height: 1, color: AppColor.dividerColor,),
                                SizedBox(height: 5,),
                                // عیار-وزن 750
                                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                            ' وزن ترازو: ',
                                            style: AppTextStyle
                                                .labelText),
                                        Text(
                                            '${forPayment.weight ??
                                                0}',
                                            style: AppTextStyle
                                                .bodyText),
                                      ],
                                    ),
                                    SizedBox(width: 15,),
                                    Row(
                                      children: [
                                        Text(
                                            ' عیار: ',
                                            style: AppTextStyle
                                                .labelText),
                                        Text(
                                            '${forPayment.carat ??
                                                0}',
                                            style: AppTextStyle
                                                .bodyText),
                                      ],
                                    ),
                                    SizedBox(width: 15,),
                                    Row(
                                      children: [
                                        Text(
                                            ' وزن 750: ',
                                            style: AppTextStyle
                                                .bodyText
                                        ),
                                        Text(
                                            '${forPayment.weight750 ??
                                                0} ${forPayment.itemUnit
                                                ?.name ?? ""}',
                                            style: AppTextStyle
                                                .bodyText
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8,),
                                Divider(
                                  height: 1, color: AppColor.dividerColor,),
                                SizedBox(height: 5,),
                                // باقیمانده
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                            ' باقیمانده: ',
                                            style: AppTextStyle
                                                .labelText),
                                        Text(
                                            '${forPayment.quantityRemainded ??
                                                0} ${forPayment.itemUnit
                                                ?.name ?? ""}',
                                            style: AppTextStyle
                                                .bodyText
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,),
                              ],
                            ),
                          ),
                        ),

                      );
                    },
                  ),
                ) :
                Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            ),
          ),
        );
    });
  }

  void showSearchResults(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(backgroundColor: AppColor.backGroundColor,
            title: Text('انتخاب کنید', style: AppTextStyle.smallTitleText,),
            content: SizedBox(
              width: Get.width * 0.5,
              height: Get.height * 0.5,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: inventoryDetailInsertPaymentController
                    .searchedLaboratories.length,
                itemBuilder: (context, index) {
                  final laboratory = inventoryDetailInsertPaymentController
                      .searchedLaboratories[index];
                  return ListTile(
                      title: Text(laboratory.name ?? '',
                        style: AppTextStyle.bodyText.copyWith(fontSize: 15),),
                      onTap: () {
                        inventoryDetailInsertPaymentController.selectLaboratory(
                            laboratory);
                      }
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: Text('بستن', style: AppTextStyle.bodyText,),
              ),
            ],
          ),
    );
  }
}
