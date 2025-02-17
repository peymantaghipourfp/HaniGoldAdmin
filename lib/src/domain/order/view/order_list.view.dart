import 'package:flutter/material.dart';
import 'package:hanigold_admin/src/config/const/app_color.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/order/controller/order.controller.dart';
import 'package:hanigold_admin/src/widget/custom_appbar.widget.dart';

class OrderListView extends StatelessWidget {
  OrderListView({super.key});

  final OrderController orderController = Get.find<OrderController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: 'سفارشات'
      ),
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
            width: Get.width,
            child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(),
                        ),
                        ElevatedButton(
                            style: ButtonStyle(
                                elevation: WidgetStatePropertyAll(5),
                                backgroundColor: WidgetStatePropertyAll(AppColor.buttonColor),
                              shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
                            ),
                            onPressed: (){
                              Get.toNamed('/orderCreate');
                            },
                            child: Text('ایجاد سفارش جدید',style: AppTextStyle.labelText,),
                        ),
                      ],
                    ),
                  ),
                  Obx(() {
                    if (orderController.isLoading.value) {
                      return Center(child:  CircularProgressIndicator());
                    }
                    if (orderController.orderList.isEmpty) {
                      return Center(
                        child: Text(orderController.errorMessage.value),
                      );
                    }
                    return Expanded(
                      child: GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1, mainAxisExtent: 200),
                            itemCount: orderController.orderList.length,
                            itemBuilder: (context, index) {
                              if (index >= orderController.orderList.length) {
                                return SizedBox();
                              }

                              var orders = orderController.orderList[index];
                              return InkWell(
                                onTap: () {
                                },
                                child: Card(
                                  margin: EdgeInsets.fromLTRB(8, 5, 8, 10),
                                  color: AppColor.secondaryColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  elevation: 10,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 10,left: 10,right: 15,bottom: 10),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Row(
                                          children: [
                                            Text('نام کاربر: ',style: AppTextStyle.bodyText.copyWith(fontWeight: FontWeight.bold),),
                                            Text(orders.account?.name??'', style: AppTextStyle.bodyText,),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text('محصول: ',style: AppTextStyle.bodyText.copyWith(fontWeight: FontWeight.bold),),
                                            Text(
                                              (orders.salesOrderDetails != null && orders.salesOrderDetails!.isNotEmpty) &&
                                                  (orders.salesOrderDetails!.first.item != null && orders.salesOrderDetails!.first.item!.name != null) ?
                                              orders.salesOrderDetails!.first.item!.name! : "خالی",
                                              style: AppTextStyle.bodyText,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text('تاریخ سفارش: ',style: AppTextStyle.bodyText.copyWith(fontWeight: FontWeight.bold),),
                                            Text(orders.date.toString(),style: AppTextStyle.bodyText,),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text('مقدار سفارش: ',style: AppTextStyle.bodyText.copyWith(fontWeight: FontWeight.bold),),
                                            Text(
                                              (orders.salesOrderDetails != null && orders.salesOrderDetails!.isNotEmpty) &&
                                                  (orders.salesOrderDetails!.first.amount != null ) ?
                                              orders.salesOrderDetails!.first.amount.toString() : "0",
                                              style: AppTextStyle.bodyText,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text('قیمت سفارش: ',style: AppTextStyle.bodyText.copyWith(fontWeight: FontWeight.bold),),
                                            Text(
                                              (orders.salesOrderDetails != null && orders.salesOrderDetails!.isNotEmpty) &&
                                                  (orders.salesOrderDetails!.first.price != null ) ?
                                              "${orders.salesOrderDetails!.first.price.toString()} ریال" : "0",
                                              style: AppTextStyle.bodyText,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text('قیمت کل: ',style: AppTextStyle.bodyText.copyWith(fontWeight: FontWeight.bold),),
                                            Text(
                                              (orders.salesOrderDetails != null && orders.salesOrderDetails!.isNotEmpty) &&
                                                  (orders.salesOrderDetails!.first.totalPrice != null ) ?
                                              "${orders.salesOrderDetails!.first.totalPrice} ریال" : "0",
                                              style: AppTextStyle.bodyText,
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
                    );
                  }),
                ],
              ),
                    ),
          )),
    );
  }
}
