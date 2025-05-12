import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hanigold_admin/src/config/const/app_color.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/order/controller/order.controller.dart';
import 'package:hanigold_admin/src/domain/order/model/order.model.dart';
import 'package:hanigold_admin/src/domain/product/view/item_update_price.view.dart';
import 'package:hanigold_admin/src/widget/background_image_total.widget.dart';
import 'package:hanigold_admin/src/widget/custom_appbar.widget.dart';
import 'package:hanigold_admin/src/widget/custom_appbar1.widget.dart';
import 'package:hanigold_admin/src/widget/empty.dart';
import 'package:hanigold_admin/src/widget/err_page.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:responsive_framework/responsive_framework.dart';

class OrderListView extends StatelessWidget {
  OrderListView({super.key});

  final OrderController orderController = Get.find<OrderController>();

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    return Scaffold(
      appBar: isDesktop ? 
      CustomAppbar1(title: 'سفارشات',onBackTap: () => Get.offNamed('/home'),)
          :
      CustomAppBar(title: 'سفارشات',
        onBackTap: ()=>Get.offNamed('/home'),
      ),
      body: Stack(
        children: [
          BackgroundImageTotal(),
          SafeArea(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: Get.width,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constraints) {
                        if(isDesktop) {
                          return Row(
                            children: [
                              //فیلد جستجو
                              Expanded(
                                child:
                                SizedBox(
                                  height: 41,
                                  child: TextFormField(
                                    controller: orderController.searchController,
                                    style: AppTextStyle.labelText,
                                    textInputAction: TextInputAction.search,
                                    onFieldSubmitted: (value) async {
                                      if (value.isNotEmpty) {
                                        await orderController.searchAccounts(value);
                                        showSearchResults(context);
                                      } else {
                                        orderController.clearSearch();
                                      }
                                    },
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: isDesktop ? 16 : 12,
                                        horizontal: 16,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      filled: true,
                                      fillColor: AppColor.textFieldColor,
                                      hintText: "جستجوی سفارش ... ",
                                      hintStyle: AppTextStyle.labelText,
                                      prefixIcon: IconButton(
                                          onPressed: () async {
                                            if (orderController.searchController
                                                .text.isNotEmpty) {
                                              await orderController.searchAccounts(
                                                  orderController.searchController
                                                      .text
                                              );
                                              showSearchResults(context);
                                            } else {
                                              orderController.clearSearch();
                                            }
                                          },
                                          icon: Icon(
                                            Icons.search, color: AppColor.textColor,
                                            size: 30,)
                                      ),
                                      suffixIcon: orderController.selectedAccountId
                                          .value > 0
                                          ? IconButton(
                                        onPressed: orderController.clearSearch,
                                        icon: Icon(
                                            Icons.close, color: AppColor.textColor),
                                      )
                                          : null,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              //دکمه ایجاد سفارش جدید
                              ElevatedButton(
                                style: ButtonStyle(
                                    padding: WidgetStatePropertyAll(
                                      EdgeInsets.symmetric(
                                        horizontal: isDesktop ? 24 : 16,
                                      ),
                                    ),
                                    elevation: WidgetStatePropertyAll(5),
                                    backgroundColor:
                                    WidgetStatePropertyAll(AppColor.buttonColor),
                                    shape: WidgetStatePropertyAll(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                10)))),
                                onPressed: () {
                                  Get.toNamed('/orderCreate');
                                },
                                child: Text(
                                  'ایجاد سفارش جدید',
                                  style: AppTextStyle.labelText,
                                ),
                              ),

                            ],
                          );
                        }else{
                          return Column(
                            children: [
                              TextFormField(
                                controller: orderController.searchController,
                                style: AppTextStyle.labelText,
                                textInputAction: TextInputAction.search,
                                onFieldSubmitted: (value) async {
                                  if (value.isNotEmpty) {
                                    await orderController.searchAccounts(value);
                                    showSearchResults(context);
                                  } else {
                                    orderController.clearSearch();
                                  }
                                },
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: isDesktop ? 16 : 12,
                                    horizontal: 16,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  filled: true,
                                  fillColor: AppColor.textFieldColor,
                                  hintText: "جستجوی سفارش ... ",
                                  hintStyle: AppTextStyle.labelText,
                                  prefixIcon: IconButton(
                                      onPressed: () async {
                                        if (orderController.searchController
                                            .text.isNotEmpty) {
                                          await orderController.searchAccounts(
                                              orderController.searchController
                                                  .text
                                          );
                                          showSearchResults(context);
                                        } else {
                                          orderController.clearSearch();
                                        }
                                      },
                                      icon: Icon(
                                        Icons.search, color: AppColor.textColor,
                                        size: 30,)
                                  ),
                                  suffixIcon: orderController.selectedAccountId
                                      .value > 0
                                      ? IconButton(
                                    onPressed: orderController.clearSearch,
                                    icon: Icon(
                                        Icons.close, color: AppColor.textColor),
                                  )
                                      : null,
                                ),
                              ),
                              SizedBox(height: 12),
                              ElevatedButton(
                                style: ButtonStyle(
                                    padding: WidgetStatePropertyAll(
                                      EdgeInsets.symmetric(
                                        horizontal: isDesktop ? 24 : 16,
                                      ),
                                    ),
                                    elevation: WidgetStatePropertyAll(5),
                                    backgroundColor:
                                    WidgetStatePropertyAll(AppColor.buttonColor),
                                    shape: WidgetStatePropertyAll(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                10)))),
                                onPressed: () {
                                  Get.toNamed('/orderCreate');
                                },
                                child: Text(
                                  'ایجاد سفارش جدید',
                                  style: AppTextStyle.labelText,
                                ),
                              ),
                            ],
                          );
                        }
                      }
                    ),
                  ),
                  // لیست سفارشات
                  Obx(() {
                    if (orderController.state.value == PageState.loading) {
                      return Center(child: CircularProgressIndicator());
                    }
                    else if (orderController.state.value == PageState.empty) {
                      return EmptyPage(
                        title: 'سفارشی وجود ندارد',
                        callback: () {
                          orderController.fetchOrderList();
                        },
                      );
                    }
                    else if (orderController.state.value == PageState.list) {
                      // لیست سفارشات
                      return
                        isDesktop ?
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      DataTable(
                                        columns: buildDataColumns(),
                                        rows: buildDataRows(context),
                                        dataRowMaxHeight: double.infinity,
                                        dividerThickness: 0.3,
                                        border: TableBorder.symmetric(inside: BorderSide(color: AppColor.textFieldColor,width: 0.5)),
                                        //dataRowColor: WidgetStatePropertyAll(AppColor.secondaryColor),
                                       //headingRowColor: WidgetStatePropertyAll(AppColor.primaryColor.withOpacity(0.2)),
                                        headingRowHeight: 40,
                                        columnSpacing: 30,
                                        horizontalMargin: 5,
                                      ),
                                      buildPaginationControls(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ) :

                        Expanded(
                          child: GridView.builder(
                            controller: orderController.scrollController,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                                mainAxisExtent: 200,
                            ),
                            itemCount: orderController.orderList.length+
                                (orderController.hasMore.value ? 1 : 0),
                            itemBuilder: (context, index) {
                              /*if (index >= orderController.filteredOrders.length) {
                                return SizedBox();
                              }*/
                              print(orderController.orderList.length);
                              if (index >= orderController.orderList.length) {
                                return orderController.hasMore.value
                                    ? Center(child: CircularProgressIndicator())
                                    : SizedBox.shrink();
                              }
                              var orders = orderController.orderList[index];
                              return GestureDetector(
                                onTap: () {
                                  showOrderDetailsSheet(context, orders);
                                },
                                child: Card(
                                  margin: EdgeInsets.all( 8),
                                  color: AppColor.secondaryColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  elevation: 10,
                                  child: Padding(
                                    padding: EdgeInsets.all( 8),

                                    child: ResponsiveRowColumn(
                                      layout: ResponsiveRowColumnType.COLUMN,
                                      rowCrossAxisAlignment: CrossAxisAlignment.start,
                                      rowMainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        ResponsiveRowColumnItem(
                                          child: Expanded(
                                            child: Column(
                                              children: [
                                                // تاریخ سفارش
                                                funcOrderDetail(
                                                    'assets/svg/date.svg',
                                                    '',
                                                    orders.date?.toPersianDate(
                                                            twoDigits: true,
                                                            showTime: true,
                                                            timeSeprator: '-') ??
                                                        "نامشخص",

                                                ),
                                                Divider(
                                                  color: AppColor.backGroundColor,
                                                  height: 2,
                                                ),
                                                // نام کاربر
                                                funcOrderDetail(
                                                    'assets/svg/user.svg',
                                                    'نام کاربر:',
                                                    orders.account?.name ?? "نامشخص",
                                                  ),
                                                // محصول
                                                funcOrderDetail('assets/svg/product.svg',
                                                    'محصول:', orders.item?.name ?? "نامشخص",
                                                 ),
                                                //مقدار سفارش
                                                funcOrderDetail(
                                                    'assets/svg/amount.svg',
                                                    'مقدار سفارش:',
                                                    "${orders.quantity?.toString().seRagham(separator: ",")} ${orders.item?.itemUnit?.name ?? ""}",
                                                  ),
                                                //قیمت سفارش
                                                funcOrderDetail(
                                                  'assets/svg/amount-price.svg',
                                                  'قیمت سفارش:',
                                                  (orders.price != null)
                                                      ? "${orders.price?.toInt().toString().seRagham(separator: ',')} ریال"
                                                      : "0",
                                                ),
                                                // مبلغ کل و نوع سفارش
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    // مبلغ کل
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.start,
                                                      children: [
                                                        SvgPicture.asset(
                                                          'assets/svg/total-price.svg',
                                                          colorFilter: ColorFilter.mode(
                                                              AppColor.textFieldColor,
                                                              BlendMode.srcIn),
                                                          width: isDesktop?24:18,
                                                          height: isDesktop?24:18,
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(
                                                          'مبلغ کل: ',
                                                          style: AppTextStyle.labelText.copyWith(fontSize:isDesktop ? 16 : 14,
                                                            fontWeight: FontWeight.bold, ),
                                                        ),
                                                        Text(
                                                          (orders.totalPrice != null)
                                                              ? "${orders.totalPrice?.toInt().toString().seRagham(separator: ',')} ریال"
                                                              : "0",
                                                          style: AppTextStyle.labelText.copyWith(fontSize:isDesktop ? 16 : 14, ),
                                                        ),
                                                      ],
                                                    ),

                                                    // نوع سفارش
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 50,
                                                          height: 20,
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(7),
                                                              color: (orders.type == 0)
                                                                  ? AppColor.accentColor
                                                                  : AppColor.secondary2Color,
                                                            ),
                                                            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 1),

                                                            child: Text(
                                                                (orders.type == 0)
                                                                    ? 'فروش'
                                                                    : 'خرید',
                                                                style: TextStyle(color: AppColor.textColor , fontSize: 11),
                                                                textAlign: TextAlign.center),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                    }
                    return ErrPage(
                      callback: () {
                        orderController.fetchOrderList();
                      },
                      title: "خطا در دریافت سفارشات",
                      des: 'برای دریافت سفارشات مجددا تلاش کنید',
                    );
                  }),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }

// ButtonSheet جزئیات سفارش
  void showOrderDetailsSheet(BuildContext context, OrderModel orders) {
    showModalBottomSheet(
      enableDrag: true,
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColor.backGroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Card(
            margin: EdgeInsets.all(5),
            color: AppColor.backGroundColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(
                    right: 15,
                    top: 5,
                    bottom: 5,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'جزئیات سفارش',
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    funcOrderDetail(
                        '',
                        'تاریخ سفارش:',
                        orders.date?.toPersianDate(
                                twoDigits: true,
                                showTime: true,
                                timeSeprator: '-') ??
                            "نامشخص",
                      ),
                    SizedBox(height: 3,),
                    funcOrderDetail(
                        '', 'نام کاربر:', orders.account?.name ?? "نامشخص",
                      ),
                    SizedBox(height: 3,),
                    funcOrderDetail(
                        '', 'محصول:', orders.item?.name ?? "نامشخص",
                      ),
                    SizedBox(height: 3,),
                    funcOrderDetail('', 'مقدار سفارش:',
                        "${orders.quantity?.toString() ?? "0"} ${orders.item?.itemUnit?.name ?? ""}",
                      ),
                    SizedBox(height: 3,),
                    funcOrderDetail(
                      '',
                      'قیمت سفارش:',
                      (orders.price != null)
                          ? "${orders.price?.toInt().toString().seRagham(separator: ',')} ریال"
                          : "0",

                    ),
                    SizedBox(height: 3,),
                    funcOrderDetail(
                      '',
                      'مبلغ کل:',
                      (orders.totalPrice != null)
                          ? "${orders.totalPrice?.toInt().toString().seRagham(separator: ',')} ریال"
                          : "0",

                    ),
                    SizedBox(height: 3,),
                    funcOrderDetail('', 'شماره تماس:',
                        "${orders.account?.contactInfo ?? "0"} ",
                      ),
                    SizedBox(height: 3,),
                    orders.status == 1
                        ? funcOrderDetail('', 'وضعیت:', "تایید شده",
                            color: AppColor.primaryColor,
                      )
                        : funcOrderDetail('', 'وضعیت:', "تایید نشده",
                            color: AppColor.accentColor,
                      ),
                    SizedBox(height: 3,),
                    orders.type==1
                        ? funcOrderDetail('', 'نوع سفارش:', "خرید",color: AppColor.secondary2Color,
                      )
                        : funcOrderDetail('', 'نوع سفارش:', "فروش",color: AppColor.accentColor,
                      )
                  ],
                ),
                Spacer(),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      //دکمه حذف سفارش
                      OutlinedButton(
                        onPressed: () {
                          Get.defaultDialog(
                              backgroundColor: AppColor.backGroundColor,
                              title: "حذف سفارش",
                              titleStyle: AppTextStyle.smallTitleText,
                              middleText: "آیا از حذف سفارش مطمئن هستید؟",
                              middleTextStyle: AppTextStyle.bodyText,
                              confirm: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor: WidgetStatePropertyAll(
                                          AppColor.primaryColor)),
                                  onPressed: () {
                                    Get.back();
                                    orderController.deleteOrder(orders.id!, true);
                                    //orderController.fetchOrderList();
                                    Get.back();
                                  },
                                  child: Text(
                                    'حذف',
                                    style: AppTextStyle.bodyText,
                                  )));
                          //orderController.fetchOrderList();
                        },
                        style: ButtonStyle(
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        child: SvgPicture.asset(
                          'assets/svg/trash-bin.svg',
                          colorFilter: ColorFilter.mode(
                              AppColor.accentColor, BlendMode.srcIn,),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      //دکمه ادیت جزئیات سفارش
                      OutlinedButton(
                        onPressed: () {
                          Get.back();
                          Get.toNamed('/orderUpdate',arguments: orders);
                        },
                        style: ButtonStyle(
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        child: SvgPicture.asset(
                          'assets/svg/edit.svg',
                          colorFilter: ColorFilter.mode(
                              AppColor.textColor, BlendMode.srcIn),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      //دکمه تایید سفارش در جزئیات
                      ElevatedButton(
                        onPressed: () {
                          Get.defaultDialog(
                              backgroundColor: AppColor.backGroundColor,
                              title: "تایید سفارش",
                              titleStyle: AppTextStyle.smallTitleText,
                              middleText: "آیا از تایید سفارش مطمئن هستید؟",
                              middleTextStyle: AppTextStyle.bodyText,
                              confirm: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor: WidgetStatePropertyAll(
                                          AppColor.primaryColor)),
                                  onPressed: () {
                                    Get.back();
                                    orderController.updateStatusOrder(orders.id!, 1);
                                    orderController.fetchOrderList();
                                    Get.back();
                                  },
                                  child: Text(
                                    'تایید',
                                    style: AppTextStyle.bodyText,
                                  )));
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(AppColor.primaryColor),
                            shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4)))),
                        child: Container(height: 23,width: 25,alignment: Alignment(0, 0),
                          child: Text(
                            'تایید',
                            style: AppTextStyle.bodyText,textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      //دکمه رد سفارش در جزئیات
                      ElevatedButton(
                        onPressed: () {
                          Get.defaultDialog(
                              backgroundColor: AppColor.backGroundColor,
                              title: "رد سفارش",
                              titleStyle: AppTextStyle.smallTitleText,
                              middleTextStyle: AppTextStyle.bodyText,
                              middleText: "آیا از رد سفارش مطمئن هستید؟",
                              confirm: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor: WidgetStatePropertyAll(
                                          AppColor.accentColor)),
                                  onPressed: () {
                                    Get.back();
                                    orderController.updateStatusOrder(orders.id!, 2);
                                    orderController.fetchOrderList();
                                    Get.back();
                                  },
                                  child: Text(
                                    'رد',
                                    style: AppTextStyle.bodyText,
                                  )));
                        },
                        style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(AppColor.accentColor),
                            shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4)))),
                        child: Container(height: 23,width: 25,alignment: Alignment(0, 0),
                          child: Text('رد',
                            style: AppTextStyle.bodyText,textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

//
  Widget funcOrderDetail(String iconPath, String label, String value,
      {Color color = AppColor.textColor,}) {
    return Row(
      children: [
        SvgPicture.asset(iconPath,
            width:18,
            height:18,
            colorFilter:
                ColorFilter.mode(AppColor.textFieldColor, BlendMode.srcIn)),
        SizedBox(width:8),
        Text(label, style: AppTextStyle.labelText.copyWith(
          fontSize:14,
          fontWeight: FontWeight.bold,
        ),
        ),
        SizedBox(width: 7),
        Expanded(
            child: Text(value,
                style: AppTextStyle.bodyText.copyWith(color: color,fontSize:14))),
      ],
    );
  }

  void showSearchResults(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(backgroundColor: AppColor.backGroundColor,
        title: Text('انتخاب کنید',style: AppTextStyle.smallTitleText,),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: orderController.searchedAccounts.length,
            itemBuilder: (context, index) {
              final account = orderController.searchedAccounts[index];
              return ListTile(
                title: Text(account.name ?? '',style: AppTextStyle.bodyText.copyWith(fontSize: 15),),
                onTap: () => orderController.selectAccount(account),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('بستن',style: AppTextStyle.bodyText,),
          ),
        ],
      ),
    );
  }

  List<DataColumn> buildDataColumns() {
    return [
      DataColumn(label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
          child: Text('تاریخ', style: AppTextStyle.labelText)),headingRowAlignment:MainAxisAlignment.center ),
      DataColumn(label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
          child: Text('نام کاربر', style: AppTextStyle.labelText)),headingRowAlignment:MainAxisAlignment.center ),
      DataColumn(label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
          child: Text('موبایل', style: AppTextStyle.labelText)),headingRowAlignment:MainAxisAlignment.center ),
      DataColumn(label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
          child: Text('محصول', style: AppTextStyle.labelText)),headingRowAlignment:MainAxisAlignment.center ),
      DataColumn(label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
          child: Text('مقدار', style: AppTextStyle.labelText)),headingRowAlignment:MainAxisAlignment.center ),
      DataColumn(label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
          child: Text('قیمت', style: AppTextStyle.labelText)),headingRowAlignment:MainAxisAlignment.center ),
      DataColumn(label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
          child: Text('مبلغ کل', style: AppTextStyle.labelText)),headingRowAlignment:MainAxisAlignment.center ),
      DataColumn(label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
          child: Text('خرید/فروش', style: AppTextStyle.labelText)),headingRowAlignment:MainAxisAlignment.center ),
      DataColumn(label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
          child: Text('وضعیت', style: AppTextStyle.labelText)),headingRowAlignment:MainAxisAlignment.center ),
      DataColumn(label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
          child: Text('عملیات', style: AppTextStyle.labelText)),headingRowAlignment:MainAxisAlignment.center ),
      DataColumn(label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
          child: Text('مانده سکه', style: AppTextStyle.labelText)),headingRowAlignment:MainAxisAlignment.center ),
      DataColumn(label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
          child: Text('مانده ریالی', style: AppTextStyle.labelText)),headingRowAlignment:MainAxisAlignment.center ),
      DataColumn(label: ConstrainedBox(constraints: BoxConstraints(maxWidth: 80),
          child: Text('مانده طلایی', style: AppTextStyle.labelText)),headingRowAlignment:MainAxisAlignment.center ),
    ];
  }

  List<DataRow> buildDataRows(BuildContext context) {
    return orderController.orderList.map((order) {
      return DataRow(
        cells: [
          // تاریخ
          DataCell(
              Center(
                child: Text(
                  order.date != null ? order.date?.toPersianDate(twoDigits: true, showTime: true, timeSeprator: '-') ?? ''
                      : 'تاریخ نامشخص',
                  style:
                  AppTextStyle.bodyText,
                ),
              )),
          // نام کاربر
          DataCell(
              Center(
                child: Text(
                  order.account?.name ?? "",
                  style:
                  AppTextStyle.bodyText,
                ),
              )),
          // موبایل
          DataCell(
              Center(
                child: Text(
                  order.account?.contactInfo ?? "",
                  style:
                  AppTextStyle.bodyText,
                ),
              )),
          // محصول
          DataCell(
              Center(
                child: Text(
                  order.item?.name ?? "",
                  style:
                  AppTextStyle.bodyText,
                ),
              )),
          // مقدار
          DataCell(
              Center(
                child: Text(
                  "${order.quantity?.toString().seRagham(separator: ",")} ${order.item?.itemUnit?.name ?? ""}",
                  style:
                  AppTextStyle.bodyText,
                ),
              )),
          // قیمت
          DataCell(
              Center(
                child: Text(
                  "${order.price == null ? 0 : order.price?.toInt().toString().seRagham(separator: ',')} ریال",
                  style:
                  AppTextStyle.bodyText,
                ),
              ),
          ),
          //مبلغ کل
          DataCell(
            Center(
              child: Text(
                (order.totalPrice != null)
                    ? "${order.totalPrice?.toInt().toString().seRagham(separator: ',')} ریال"
                    : "0",
                style: AppTextStyle.bodyText,
              ),
            ),
          ),
          // خرید/فروش
          DataCell(
            Center(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                  color: (order.type == 0)
                      ? AppColor.accentColor
                      : AppColor.secondary2Color,
                ),
                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                
                child: Text(
                    (order.type == 0)
                        ? 'فروش'
                        : 'خرید',
                    style: TextStyle(color: AppColor.textColor , fontSize: 11),
                    textAlign: TextAlign.center),
              ),
            ),
          ),
          // وضعیت
          DataCell(
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Center(
                child: Column(
                  children: [
                    SizedBox(height: 5,),
                    Text(
                      '${order.status == 0 ? 'نامشخص' : order.status == 1
                          ? 'تایید شده'
                          : 'تایید نشده'} ',
                      style: AppTextStyle
                          .bodyText.copyWith(
                        color: order.status == 1
                            ? AppColor.primaryColor
                            : order.status == 2
                            ? AppColor.accentColor
                            : AppColor.textColor,
                      ),
                    ),
                    SizedBox(height: 6,),
                    //دکمه تایید سفارش در جزئیات
                     GestureDetector(
                        onTap:  () {
                          Get.defaultDialog(
                              backgroundColor: AppColor.backGroundColor,
                              title: "تایید سفارش",
                              titleStyle: AppTextStyle.smallTitleText,
                              middleText: "آیا از تایید سفارش مطمئن هستید؟",
                              middleTextStyle: AppTextStyle.bodyText,
                              confirm: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor: WidgetStatePropertyAll(
                                          AppColor.primaryColor)),
                                  onPressed: () {
                                    orderController.updateStatusOrder(order.id!, 1);
                                    Get.back();
                                    orderController.fetchOrderList();
                                  },
                                  child: Text(
                                    'تایید',
                                    style: AppTextStyle.labelText,
                                  )));
                        },
                        child: Container(
                          height: 24,
                          width: 37,
                          alignment: Alignment(0, 0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                            color: AppColor.primaryColor
                          ),
                          child: Text(
                            'تایید',
                            style: AppTextStyle.bodyText,textAlign: TextAlign.center,
                          ),
                        ),
                      ),

                    SizedBox(
                      height: 3,
                    ),
                    //دکمه رد سفارش در جزئیات
                    GestureDetector(
                        onTap: () {
                          Get.defaultDialog(
                              backgroundColor: AppColor.backGroundColor,
                              title: "رد سفارش",
                              titleStyle: AppTextStyle.smallTitleText,
                              middleTextStyle: AppTextStyle.bodyText,
                              middleText: "آیا از رد سفارش مطمئن هستید؟",
                              confirm: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor: WidgetStatePropertyAll(
                                          AppColor.accentColor)),
                                  onPressed: () {
                                    orderController.updateStatusOrder(order.id!, 2);
                                    Get.back();
                                    orderController.fetchOrderList();

                                  },
                                  child: Text(
                                    'رد',
                                    style: AppTextStyle.bodyText,
                                  )));
                        },
                        child: Container(
                          height: 24,
                          width: 37,
                          alignment: Alignment(0, 0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: AppColor.accentColor
                          ),
                          child: Text('رد',
                            style: AppTextStyle.bodyText,textAlign: TextAlign.center,
                          ),
                        ),
                      ),

                  ],
                ),
              ),
            ),
          ),
          // آیکون های عملیات
          DataCell(
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //دکمه حذف سفارش
                  OutlinedButton(
                    onPressed: () {
                      Get.defaultDialog(
                          backgroundColor: AppColor.backGroundColor,
                          title: "حذف سفارش",
                          titleStyle: AppTextStyle.smallTitleText,
                          middleText: "آیا از حذف سفارش مطمئن هستید؟",
                          middleTextStyle: AppTextStyle.bodyText,
                          confirm: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(
                                      AppColor.primaryColor)),
                              onPressed: () {
                                orderController.deleteOrder(order.id!, true);
                                Get.back();
                              },
                              child: Text(
                                'حذف',
                                style: AppTextStyle.bodyText,
                              )));
                      //orderController.fetchOrderList();
                    },
                    style: ButtonStyle(
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    child: SvgPicture.asset(
                      'assets/svg/trash-bin.svg',
                      colorFilter: ColorFilter.mode(
                        AppColor.accentColor, BlendMode.srcIn,),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                    height: 3,
                  ),
                  //دکمه ادیت جزئیات سفارش
                  OutlinedButton(
                    onPressed: () {
                      Get.back();
                      Get.toNamed('/orderUpdate',arguments: order);
                    },
                    style: ButtonStyle(
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    child: SvgPicture.asset(
                      'assets/svg/edit.svg',
                      colorFilter: ColorFilter.mode(
                          AppColor.iconViewColor, BlendMode.srcIn),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                ],
              ),
            ),
          ),
          // مانده سکه
          DataCell(
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    order.balances!=null ?
                    Column(
                      children: order.balances!.map((e)=>
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.only(left: 2),
                                child: e.unitName=="عدد"? Text( "${e.balance}",style:e.balance!>0 ?
                                AppTextStyle.bodyText.copyWith(fontSize: 12,color: AppColor.primaryColor,fontWeight: FontWeight.bold) :
                                AppTextStyle.bodyText.copyWith(fontSize: 12,color: AppColor.accentColor,fontWeight: FontWeight.bold),
                                textDirection: TextDirection.ltr,
                                ):SizedBox(),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 2),
                                child: e.unitName=="عدد"? Text( "${e.unitName}",style:e.balance!>0 ?
                                AppTextStyle.bodyText.copyWith(fontSize: 12,color: AppColor.primaryColor) :
                                AppTextStyle.bodyText.copyWith(fontSize: 12,color: AppColor.accentColor),
                                  textDirection: TextDirection.ltr,
                                ):SizedBox(),
                              ),
                              Container(
                                child: e.unitName=="عدد"? Text( "${e.itemName}",style:e.balance!>0 ?
                                AppTextStyle.bodyText.copyWith(fontSize: 12,color: AppColor.primaryColor) :
                                AppTextStyle.bodyText.copyWith(fontSize: 12,color: AppColor.accentColor),
                                  textDirection: TextDirection.ltr,
                                ):SizedBox(),
                              ),
                            ],
                          )).toList()
                    ) : SizedBox.shrink(),
                  ],
                ),
              ),
            )
          ),
          // مانده ریالی
          DataCell(
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      order.balances!=null ?
                           Column(
                             children: order.balances!.map((e)=>
                               Row(
                                 children: [
                                   Container(
                                     padding: EdgeInsets.only(left: 2),
                                     child: e.unitName=="ریال"? Text( "${e.balance?.toInt().toString().seRagham(separator: ',')}",style:e.balance!>0 ?
                                     AppTextStyle.bodyText.copyWith(fontSize: 12,color: AppColor.primaryColor,fontWeight: FontWeight.bold) :
                                     AppTextStyle.bodyText.copyWith(fontSize: 12,color: AppColor.accentColor,fontWeight: FontWeight.bold),
                                       textDirection: TextDirection.ltr,
                                     ):SizedBox(),
                                   ),
                                   Container(
                                     padding: EdgeInsets.only(left: 2),
                                     child: e.unitName=="ریال"? Text( "${e.unitName}",style:e.balance!>0 ?
                                     AppTextStyle.bodyText.copyWith(fontSize: 12,color: AppColor.primaryColor) :
                                     AppTextStyle.bodyText.copyWith(fontSize: 12,color: AppColor.accentColor),
                                       textDirection: TextDirection.ltr,
                                     ):SizedBox(),
                                   ),
                                   Container(
                                     child: e.unitName=="ریال"? Text( "${e.itemName}",style:e.balance!>0 ?
                                     AppTextStyle.bodyText.copyWith(fontSize: 12,color: AppColor.primaryColor) :
                                     AppTextStyle.bodyText.copyWith(fontSize: 12,color: AppColor.accentColor),
                                       textDirection: TextDirection.ltr,
                                     ):SizedBox(),
                                   ),
                                 ],
                           )).toList(),
                        ) : SizedBox.shrink(),
                  ],
                ),
              ),
              ),
          ),
          // مانده طلایی
          DataCell(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  order.balances !=null ?
                    Column(
                      children:  order.balances!.map((e)=>
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 2),
                              child: e.unitName=="گرم"? Text( "${e.balance}",style:e.balance!>0 ?
                              AppTextStyle.bodyText.copyWith(fontSize: 12,color: AppColor.primaryColor,fontWeight: FontWeight.bold) :
                              AppTextStyle.bodyText.copyWith(fontSize: 12,color: AppColor.accentColor,fontWeight: FontWeight.bold),
                                textDirection: TextDirection.ltr,
                              ):SizedBox(),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 2),
                              child: e.unitName=="گرم"? Text( "${e.unitName}",style:e.balance!>0 ?
                              AppTextStyle.bodyText.copyWith(fontSize: 12,color: AppColor.primaryColor) :
                              AppTextStyle.bodyText.copyWith(fontSize: 12,color: AppColor.accentColor),
                                textDirection: TextDirection.ltr,
                              ):SizedBox(),
                            ),
                            Container(
                              child: e.unitName=="گرم"? Text( "${e.itemName}",style:e.balance!>0 ?
                              AppTextStyle.bodyText.copyWith(fontSize: 12,color: AppColor.primaryColor) :
                              AppTextStyle.bodyText.copyWith(fontSize: 12,color: AppColor.accentColor),
                                textDirection: TextDirection.ltr,
                              ):SizedBox(),
                            ),
                          ],
                        )).toList()
                    ) : SizedBox.shrink(),
                      ],
              ),
            ),
          )
          ),
        ],
      );
    }).toList();
  }

  Widget buildPaginationControls() {
    return Obx(() => Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.chevron_left),
            onPressed: orderController.currentPage.value > 1
                ? orderController.previousPage
                : null,
          ),
          Text(
            'صفحه ${orderController.currentPage.value}',
            style: AppTextStyle.bodyText,
          ),
          IconButton(
            icon: Icon(Icons.chevron_right),
            onPressed: orderController.hasMore.value
                ? orderController.nextPage
                : null,
          ),
        ],
      ),
    ),

    );
  }
}
