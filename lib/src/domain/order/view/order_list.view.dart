import 'package:flutter/material.dart';
import 'package:hanigold_admin/src/config/const/app_color.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/order/controller/order.controller.dart';

class OrderListView extends StatelessWidget {
  OrderListView({super.key});

  final OrderController orderController = Get.find<OrderController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColor.textColor),
        title: Text(
          'سفارشات',
          style: AppTextStyle.smallTitleText,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
          child: SizedBox(
        width: Get.width,
        height: Get.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(),
                    )
                  ],
                ),
              ),
              Obx(() {
                if (orderController.isLoading.value) {
                  return CircularProgressIndicator();
                }
                if (orderController.orderList.isEmpty) {
                  return Center(
                    child: Text(orderController.errorMessage.value),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: SizedBox(
                    height: Get.height,
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1, mainAxisExtent: 150),
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        var orders = orderController.orderList[index];
                        return Card(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          color: AppColor.secondaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          elevation: 10,
                          child: Text(orders.date.toString()),
                        );
                      },
                    ),
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
