import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:hanigold_admin/src/domain/withdraw/controller/withdraw.controller.dart';
import '../../../config/const/app_color.dart';
import '../../../widget/custom_appbar.widget.dart';
import '../../../widget/empty.dart';
import '../../../widget/err_page.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

class WithdrawsList extends StatelessWidget {
  WithdrawsList({super.key});

  final WithdrawController withdrawController = Get.find<WithdrawController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'لیست درخواست های برداشت',
        onBackTap: () => Get.toNamed('/home'),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: SizedBox(
            width: Get.width,
            child: Column(
              children: [
                Obx(() {
                  if (withdrawController.state.value == PageState.loading) {
                    return Center(child: CircularProgressIndicator());
                  } else
                  if (withdrawController.state.value == PageState.empty) {
                    return EmptyPage(
                      title: 'درخواستی وجود ندارد',
                      callback: () {
                        withdrawController.fetchWithdrawList();
                      },
                    );
                  } else if (withdrawController.state.value == PageState.list) {
                    return Expanded(
                      child: SizedBox(
                        height: Get.height * 0.6,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemCount: withdrawController.withdrawList.length,
                          itemBuilder: (context, index) {
                            var withdraws = withdrawController
                                .withdrawList[index];
                            return
                              Obx(() {
                                bool isExpanded = withdrawController
                                    .isItemExpanded(index);
                                return InkWell(
                                  onTap: () {
                                    withdrawController.toggleItemExpansion(index);
                                  },
                                  child: Card(
                                    margin: EdgeInsets.fromLTRB(8, 5, 8, 10),
                                    color: AppColor.secondaryColor,
                                    elevation: 10,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 10),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ListTile(
                                            title: Column(
                                              children: [
                                                //  ردیف اول
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Text('نام کاربر', style: AppTextStyle.labelText,),
                                                        SizedBox(height: 2,),
                                                        Text(withdraws.wallet!.account!.name.toString(), style: AppTextStyle.bodyText,),
                                                      ],
                                                    ),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Text('نام دارنده حساب', style: AppTextStyle.labelText,),
                                                        SizedBox(height: 2,),
                                                        Text("${withdraws.bankAccount!.ownerName.toString()}""(${withdraws.bankAccount?.bank?.name.toString()})",
                                                          style: AppTextStyle.bodyText,),
                                                      ],
                                                    ),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Text('تاریخ درخواست', style: AppTextStyle.labelText,),
                                                        SizedBox(height: 2,),
                                                        Text(withdraws.requestDate!.toPersianDate(twoDigits: true, showTime: true, timeSeprator: '-'),
                                                          style: AppTextStyle.bodyText,),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 6,),
                                                //  ردیف دوم
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Text('مبلغ کل: ', style: AppTextStyle.labelText,),
                                                        SizedBox(width: 5,),
                                                        Text("${withdraws.amount.toString().seRagham(separator: ',')}ریال",
                                                          style: AppTextStyle.bodyText,),
                                                      ],
                                                    ),
                                                    SizedBox(height: 4,),
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Text('مبلغ مانده: ', style: AppTextStyle.labelText,),
                                                        SizedBox(width: 5,),
                                                        Text('0', style: AppTextStyle.bodyText,),
                                                      ],
                                                    ),
                                                    SizedBox(height: 4,),
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Text('مبلغ واریز شده: ', style: AppTextStyle.labelText,),
                                                        SizedBox(width: 5,),
                                                        Text('0', style: AppTextStyle.bodyText,),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 4,),
                                                Divider(height: 1,),
                                                SizedBox(height: 5,),
                                                // ردیف سوم آیکون ها
                                                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    // آیکون اضافه کردن درخواست deposit request
                                                    Container(
                                                      width: 25,height: 25,
                                                      child: InkWell(
                                                        onTap: (){
                                                          insertDepositRequestBottomSheet(context);
                                                        },
                                                        child: SvgPicture.asset('assets/svg/add.svg',
                                                            colorFilter: ColorFilter.mode(AppColor.buttonColor, BlendMode.srcIn,)
                                                        ),
                                                      ),
                                                    ),
                                                    // آیکون حذف کردن
                                                    Container(
                                                      width: 20,height: 20,
                                                      child: InkWell(
                                                        onTap: (){

                                                        },
                                                        child: SvgPicture.asset('assets/svg/trash-bin.svg',
                                                            colorFilter: ColorFilter.mode(AppColor.accentColor, BlendMode.srcIn,)
                                                        ),
                                                      ),
                                                    ),
                                                    // آیکون مشاهده
                                                    Container(
                                                      width: 20,height: 20,
                                                      child: InkWell(
                                                        onTap: (){

                                                        },
                                                        child: SvgPicture.asset('assets/svg/eye1.svg',
                                                            colorFilter: ColorFilter.mode(AppColor.iconViewColor, BlendMode.srcIn,)
                                                        ),
                                                      ),
                                                    ),
                                                    // آیکون ویرایش
                                                    Container(
                                                      width: 20,height: 20,
                                                      child: InkWell(
                                                        onTap: (){

                                                        },
                                                        child: SvgPicture.asset('assets/svg/edit.svg',
                                                            colorFilter: ColorFilter.mode(AppColor.iconViewColor, BlendMode.srcIn,)
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                // ردیف چهارم
                                                // تعیین وضعیت
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text('وضعیت: نامشخص', style: AppTextStyle.bodyText,),
                                                    IconButton(
                                                      onPressed: () {
                                                        withdrawController.fetchDepositRequestList(withdraws.id!);
                                                        withdrawController.toggleItemExpansion(index);
                                                      },
                                                      icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more,
                                                        color: isExpanded ? AppColor.accentColor : AppColor.primaryColor,
                                                      ),
                                                    ),
                                                    // Popup تعیین وضعیت
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                                      child: PopupMenuButton<int>(
                                                        splashRadius: 10,
                                                        tooltip: 'تعیین وضعیت',
                                                        /*onSelected: (value) async {
                                                          switch (value) {
                                                            case 1:
                                                              controller.getIndexFilter(1);
                                                              break;
                                                            case 2:
                                                              controller.getIndexFilter(2);
                                                              break;
                                                            case 3:
                                                              controller.getIndexFilter(3);
                                                              break;
                                                            case 4:
                                                              controller.getIndexFilter(4);
                                                              break;
                                                          }
                                                        },*/
                                                        shape: const RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                        ),
                                                        color: AppColor.backGroundColor,
                                                        constraints: BoxConstraints(
                                                          minWidth: 70,
                                                          maxWidth: 70,
                                                        ),
                                                          position: PopupMenuPosition.under,
                                                        offset: const Offset(0, 0),
                                                        itemBuilder: (context) =>
                                                        [
                                                          PopupMenuItem<int>(
                                                            labelTextStyle: WidgetStateProperty.all(AppTextStyle.madiumbodyText
                                                            ),
                                                            value: 1,
                                                            child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                Text('تایید',
                                                                  style: AppTextStyle.madiumbodyText.copyWith(color: AppColor.primaryColor, fontSize: 14),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          const PopupMenuDivider(),
                                                          PopupMenuItem<int>(
                                                            value: 2,
                                                            labelTextStyle: WidgetStateProperty.all(AppTextStyle.madiumbodyText
                                                            ),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                Text('رد',
                                                                  style: AppTextStyle.madiumbodyText.copyWith(color: AppColor.accentColor, fontSize: 14),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                        child: Text('تعیین وضعیت',
                                                          style: AppTextStyle.bodyText.copyWith(decoration: TextDecoration.underline, decorationColor: AppColor.textColor
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                            minVerticalPadding: 5,
                                          ),

                                          // لیست deposit request
                                          AnimatedSize(
                                            duration: Duration(milliseconds: 300),
                                            curve: Curves.easeInOut,
                                            child: isExpanded ?
                                            Padding(
                                              padding: EdgeInsets.symmetric(vertical: 3),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  SizedBox(height: 8,),
                                                  Row(
                                                    children: [
                                                      withdrawController.depositRequestList.isEmpty ?
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text('هیچ شخصی جهت واریز مشخص نشده است',
                                                              style: AppTextStyle.labelText),
                                                          SizedBox(width: 125,),
                                                          Container(
                                                            width: 25,height: 25,
                                                            child: InkWell(
                                                              onTap: (){
                                                                insertDepositRequestBottomSheet(context);
                                                              },
                                                              child: SvgPicture.asset('assets/svg/add.svg',
                                                                  colorFilter: ColorFilter.mode(AppColor.buttonColor, BlendMode.srcIn,)
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                          : Expanded(
                                                        child: SizedBox(height: 150,
                                                          // لیست deposit request مربوط به هر درخواست برداشت
                                                          child: ListView.builder(
                                                            itemCount: withdrawController.depositRequestList.length,
                                                            itemBuilder: (context, index) {
                                                              var depositRequests = withdrawController
                                                                  .depositRequestList[index];
                                                              return ListTile(
                                                                title: Card(
                                                                  color: AppColor.backGroundColor,
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.only(top: 8, left: 12, right: 12, bottom: 8),
                                                                    child: Column(
                                                                      children: [
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Text(depositRequests.account!.name.toString(),
                                                                                  style: AppTextStyle.bodyText,),
                                                                                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                  children: [
                                                                                    Text('مبلغ کل:',style: AppTextStyle.bodyText),
                                                                                    SizedBox(width: 4,),
                                                                                    Text("${depositRequests.amount.toString().seRagham(separator: ',')} ریال",
                                                                                          style: AppTextStyle.bodyText,),
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),

                                                                            SizedBox(height: 4,),
                                                                            Row(
                                                                              children: [
                                                                                Text('مبلغ واریز شده:',style: AppTextStyle.bodyText),
                                                                                SizedBox(width: 4,),
                                                                                Text("${depositRequests.paidAmount.toString().seRagham(separator: ',')} ریال",
                                                                                  style: AppTextStyle.bodyText,),
                                                                              ],
                                                                            ),
                                                                            SizedBox(height: 4,),
                                                                            Row(
                                                                              children: [
                                                                                Text('تاریخ:',style: AppTextStyle.bodyText),
                                                                                SizedBox(width: 4,),
                                                                                Text(depositRequests.date!.toPersianDate(showTime: true,twoDigits: true,timeSeprator: '-'),
                                                                                  style: AppTextStyle.bodyText,),
                                                                              ],
                                                                            ),
                                                                        SizedBox(height: 4,),
                                                                        Divider(height: 1,color: AppColor.secondaryColor,),
                                                                        SizedBox(height: 5,),
                                                                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            // آیکون اضافه کردن
                                                                            Container(
                                                                              width: 25,height: 25,
                                                                              child: InkWell(
                                                                                onTap: (){

                                                                                },
                                                                                child: SvgPicture.asset('assets/svg/add.svg',
                                                                                    colorFilter: ColorFilter.mode(AppColor.buttonColor, BlendMode.srcIn,)
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            // آیکون حذف کردن
                                                                            Container(
                                                                                  width: 25,height: 25,
                                                                                  child: InkWell(
                                                                                    onTap: (){

                                                                                    },
                                                                                    child: SvgPicture.asset('assets/svg/trash-bin.svg',
                                                                                        colorFilter: ColorFilter.mode(AppColor.accentColor, BlendMode.srcIn,)
                                                                                    ),
                                                                                  ),
                                                                            ),
                                                                            // آیکون مشاهده
                                                                            Container(
                                                                              width: 25,height: 25,
                                                                              child: InkWell(
                                                                                onTap: (){

                                                                                },
                                                                                child: SvgPicture.asset('assets/svg/eye1.svg',
                                                                                    colorFilter: ColorFilter.mode(AppColor.iconViewColor, BlendMode.srcIn,)
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            // آیکون ویرایش
                                                                            Container(
                                                                              width: 25,height: 25,
                                                                              child: InkWell(
                                                                                onTap: (){

                                                                                },
                                                                                child: SvgPicture.asset('assets/svg/edit.svg',
                                                                                    colorFilter: ColorFilter.mode(AppColor.iconViewColor, BlendMode.srcIn,)
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )
                                                : SizedBox(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              });
                          },
                        ),
                      ),
                    );
                  }
                  return ErrPage(
                    callback: () {
                      withdrawController.fetchWithdrawList();
                    },
                    title: "خطا در دریافت لیست درخواست ها",
                    des: 'برای دریافت درخواست ها مجددا تلاش کنید',
                  );
                },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // bottmSheet درج درخواست واریزی
  void insertDepositRequestBottomSheet(BuildContext context,) {
    showModalBottomSheet(
      enableDrag: true,
      context: context,
      backgroundColor: AppColor.backGroundColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(right: 15, top: 5, bottom: 5,),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('ایجاد درخواست واریزی',
                        style: AppTextStyle.smallTitleText,
                      ),
                      IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: Icon(Icons.close),
                        style: ButtonStyle(
                          iconColor: WidgetStatePropertyAll(AppColor.textColor),
                        ),
                      )
                    ],
                  ),
                ),
                Divider(color: Colors.grey),
                Form(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //کاربر
                          Container(
                            padding: EdgeInsets.only( top: 15,),
                            child: Text(
                              'کاربر',
                              style: AppTextStyle.labelText,
                            ),
                          ),
                          SizedBox(height: 12,),
                          //کاربر
                          Container(
                            padding: EdgeInsets.only(bottom: 5),
                            child: DropdownButton2(
                              isExpanded: true,
                              hint: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "انتخاب کنید",
                                      style: AppTextStyle.labelText.copyWith(
                                        fontSize: 14,
                                        color: AppColor.textColor,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              items: [],
                              /*withdrawCreateController.accountList.map((account){
                                return DropdownMenuItem(
                                    value: account,
                                    child: Text(account.name.toString(),style: AppTextStyle.bodyText,));
                              }).toList(),
                              value: withdrawCreateController.selectedAccount.value,
                              onChanged: (newValue){
                                if(newValue!=null) {
                                  withdrawCreateController.changeSelectedAccount(newValue);
                                }
                              },*/
                              buttonStyleData: ButtonStyleData(
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  color: AppColor.textFieldColor,
                                  border: Border.all(color: AppColor.backGroundColor, width: 1),
                                ),
                                elevation: 0,
                              ),
                              iconStyleData: IconStyleData(
                                icon: const Icon(Icons.keyboard_arrow_down),
                                iconSize: 23,
                                iconEnabledColor: AppColor.textColor,
                                iconDisabledColor: Colors.grey,
                              ),
                              dropdownStyleData: DropdownStyleData(
                                maxHeight: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  color: AppColor.textFieldColor,
                                ),
                                offset: const Offset(0, 0),
                                scrollbarTheme: ScrollbarThemeData(
                                  radius: const Radius.circular(7),
                                  thickness: WidgetStateProperty.all(6),
                                  thumbVisibility: WidgetStateProperty.all(true),
                                ),
                              ),
                              menuItemStyleData: const MenuItemStyleData(
                                height: 45,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                              ),
                            ),
                          ),
                          SizedBox(height: 15,),
                          // قیمت
                          Container(
                            padding: EdgeInsets.only(bottom: 3,top: 5),
                            child: Text(
                              'مبلغ (ریال)',
                              style: AppTextStyle.labelText,
                            ),
                          ),
                          SizedBox(height: 12,),
                          //قیمت
                          Container(
                            height: 50,
                            padding: EdgeInsets.only(bottom: 5),
                            child:
                            TextFormField(
                              //controller: withdrawCreateController.amountController,
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
                        ],
                      ),
                    ),
                  ),
                Spacer(),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      //دکمه ایجاد
                      ElevatedButton(
                        style: ButtonStyle(fixedSize: WidgetStatePropertyAll(Size(Get.width*.77,40)),
                            padding: WidgetStatePropertyAll(
                                EdgeInsets.symmetric(horizontal: 7)),
                            elevation: WidgetStatePropertyAll(5),
                            backgroundColor:
                            WidgetStatePropertyAll(AppColor.buttonColor),
                            shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)))),
                        onPressed: () async{

                        },
                        child:
                        /*withdrawCreateController.isLoading.value
                            ?
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor),
                        ) :*/
                        Text(
                          'ایجاد درخواست',
                          style: AppTextStyle.bodyText,
                        ),
                      )

                    ],
                  ),
                ),
              ],
            );
      },
    );
  }

}

