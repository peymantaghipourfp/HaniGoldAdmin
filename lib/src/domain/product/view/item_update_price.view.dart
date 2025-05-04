import 'package:data_table_2/data_table_2.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/product/controller/product.controller.dart';
import 'package:hanigold_admin/src/domain/product/widget/price_different.widget.dart';
import 'package:hanigold_admin/src/domain/product/widget/price_sell.widget.dart';
import 'package:hanigold_admin/src/widget/custom_appbar1.widget.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../widget/custom_appbar.widget.dart';
import '../model/item.model.dart';

class ProductUpdatePriceView extends StatefulWidget {
  ProductUpdatePriceView({super.key});

  @override
  State<ProductUpdatePriceView> createState() => _ProductUpdatePriceViewState();
}

class _ProductUpdatePriceViewState extends State<ProductUpdatePriceView> {
  final formKey = GlobalKey<FormState>();

  ProductController productController = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: 
      CustomAppbar1(title: 'بروزرسانی قیمت محصولات',onBackTap:() =>  Get.back(),),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              padding: EdgeInsets.all(30),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bgHaniGold.png'),
                  fit: BoxFit.fill,
                  opacity: 0.06,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 50,horizontal: 20),
              child: SizedBox(
                width: Get.width,
                height: Get.height,
                child: Card(
                  color: AppColor.secondaryColor,
                  elevation: 5,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child:
                          DefaultTabController(
                            length: 2,
                            child:
                            Column(
                              children: [
                                Container(
                                  constraints: BoxConstraints(
                                      maxWidth: double.infinity
                                  ),
                                  child: TabBar(
                                    labelStyle: AppTextStyle.bodyText.copyWith(
                                        fontSize: 13, fontWeight: FontWeight.bold),
                                    labelColor: AppColor.textColor,
                                    dividerColor: AppColor.backGroundColor,
                                    overlayColor: WidgetStatePropertyAll(
                                        AppColor.textColor),
                                    unselectedLabelColor: AppColor.textColor.withAlpha(
                                        120),
                                    indicatorColor: AppColor.primaryColor,
                                    tabs: [
                                      Tab(text: "فعال"),
                                      Tab(text: "غیر فعال"),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    constraints: BoxConstraints(
                                        maxWidth:double.infinity
                                    ),
                                    child: TabBarView(

                                      children: [
                                        // Tabbar1 فعال
                                      FutureBuilder(future: productController.fetchActiveItemList(),
                                        builder: (context,asyncData) {
                                        if(asyncData.hasData){
                                          List<ItemModel> items = asyncData.data as List<ItemModel>;
                                          return DataTable2(
                                            columnSpacing: 12,
                                            horizontalMargin: 20,

                                            columns: [
                                              DataColumn(
                                                label: Text('عنوان',style: AppTextStyle.smallTitleText,),
                                              ),
                                              DataColumn(
                                                label: Text('قیمت خرید',style: AppTextStyle.smallTitleText,),
                                              ),
                                              DataColumn2(size: ColumnSize.L,
                                                label: Text('تفاوت قیمت فروش',style: AppTextStyle.smallTitleText,),
                                              ),
                                              DataColumn2(size: ColumnSize.L,
                                                label: Text('قیمت فروش',style: AppTextStyle.smallTitleText,),
                                              ),
                                              DataColumn2(size: ColumnSize.S,
                                                label: Text('وضعیت فروش',style: AppTextStyle.smallTitleText,),
                                              ),
                                            ],
                                            rows: List<DataRow>.generate(
                                              items.length,
                                                  (index) => DataRow(cells:
                                              [
                                                DataCell(
                                                  Text(textAlign: TextAlign.center,
                                                    "${items[index].name}",
                                                    style: AppTextStyle.bodyTextBold,
                                                  ),
                                                ),
                                                DataCell(
                                                  Text(textAlign: TextAlign.center,
                                                    items[index].openPrice.toString().seRagham(separator: ','),
                                                    style: AppTextStyle.bodyTextBold,
                                                  ),
                                                ),
                                                //different
                                                DataCell(
                                                      () {
                                                    String differentPrice = items[index].differentPrice.toString().replaceAll(RegExp(r'[^0-9]'), '');
                                                    List<String> parts = [];
                                                    String remaining = differentPrice;
                                                    int count = 0;
                                                    while (remaining.isNotEmpty && count < 3) {
                                                      int end = remaining.length;
                                                      int start = end - 3;
                                                      if (start < 0) start = 0;
                                                      String part = remaining.substring(start, end);
                                                      parts.add(part);
                                                      remaining = remaining.substring(0, start);
                                                      count++;
                                                    }
                                                    String differentPrice1 = parts.isNotEmpty ? parts[0] : '';
                                                    String differentPrice2 = parts.length >= 2 ? parts[1] : '';
                                                    String differentPrice3 = parts.length >= 3 ? parts[2] : '';
                                                    return PriceDifferentWidget(
                                                      differentPrice1: differentPrice1,
                                                      differentPrice2: differentPrice2,
                                                      differentPrice3: differentPrice3,
                                                      price: items[index].price ?? 0,
                                                      id: items[index].id!,
                                                    );
                                                  }(),
                                                ),

                                                // price
                                                DataCell(
                                                      () {
                                                    String price = items[index].price.toString().replaceAll(RegExp(r'[^0-9]'), '');
                                                    List<String> parts = [];
                                                    String remaining = price;
                                                    int count = 0;
                                                    while (remaining.isNotEmpty && count < 3) {
                                                      int end = remaining.length;
                                                      int start = end - 3;
                                                      if (start < 0) start = 0;
                                                      String part = remaining.substring(start, end);
                                                      parts.add(part);
                                                      remaining = remaining.substring(0, start);
                                                      count++;
                                                    }
                                                    String price1 = parts.isNotEmpty ? parts[0] : '';
                                                    String price2 = parts.length >= 2 ? parts[1] : '';
                                                    String price3 = parts.length >= 3 ? parts[2] : '';
                                                    String price4 = remaining;
                                                    return PriceSellWidget(
                                                      price1: price1,
                                                      price2: price2,
                                                      price3: price3,
                                                      price4: price4,
                                                      different: items[index].differentPrice ?? 0,
                                                      id: items[index].id!,

                                                    );
                                                  }(),
                                                ),
                                                // status
                                                DataCell(
                                                  Card(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius
                                                          .circular(5),
                                                    ),
                                                    color: items[index].status == true
                                                        ? AppColor.primaryColor
                                                        : AppColor.accentColor,
                                                    margin: EdgeInsets
                                                        .symmetric(
                                                        vertical: 0,
                                                        horizontal: 5),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .all(6),
                                                      child: Text(
                                                          items[index].status == true
                                                              ? 'فعال'
                                                              : 'غیر فعال',
                                                          style: AppTextStyle
                                                              .labelText,
                                                          textAlign: TextAlign
                                                              .center),
                                                    ),
                                                  ),
                                                )
                                              ]
                                              ),
                                            ),
                                          );
                                        }
                                        return Center(child: CircularProgressIndicator(),);
                                        }
                                      ),
                                        //Tabbar2 غیر فعال
                                        FutureBuilder(future: productController.fetchInactiveItemList(),
                                          builder: (context,asyncData) {
                                          if(asyncData.hasData){
                                            List<ItemModel> items = asyncData.data as List<ItemModel>;
                                            return DataTable2(
                                              columnSpacing: 12,
                                              horizontalMargin: 20,

                                              columns: [
                                                DataColumn(
                                                  label: Text('عنوان',style: AppTextStyle.smallTitleText,),
                                                ),
                                                DataColumn(
                                                  label: Text('قیمت خرید',style: AppTextStyle.smallTitleText,),
                                                ),
                                                DataColumn2(size: ColumnSize.L,
                                                  label: Text('تفاوت قیمت فروش',style: AppTextStyle.smallTitleText,),
                                                ),
                                                DataColumn2(size: ColumnSize.L,
                                                  label: Text('قیمت فروش',style: AppTextStyle.smallTitleText,),
                                                ),
                                                DataColumn2(size: ColumnSize.S,
                                                  label: Text('وضعیت فروش',style: AppTextStyle.smallTitleText,),
                                                ),
                                              ],

                                              rows: List<DataRow>.generate(
                                                items.length,
                                                    (index) => DataRow(cells:
                                                [
                                                  DataCell(
                                                    Text(textAlign: TextAlign.center,
                                                      "${items[index].name}",
                                                      style: AppTextStyle.bodyTextBold,
                                                    ),
                                                  ),
                                                  DataCell(
                                                    Text(textAlign: TextAlign.center,
                                                      items[index].openPrice.toString().seRagham(separator: ','),
                                                      style: AppTextStyle.bodyTextBold,
                                                    ),
                                                  ),
                                                  //different
                                                  DataCell(
                                                        () {
                                                      String differentPrice = items[index].differentPrice.toString().replaceAll(RegExp(r'[^0-9]'), '');
                                                      List<String> parts = [];
                                                      String remaining = differentPrice;
                                                      int count = 0;
                                                      while (remaining.isNotEmpty && count < 3) {
                                                        int end = remaining.length;
                                                        int start = end - 3;
                                                        if (start < 0) start = 0;
                                                        String part = remaining.substring(start, end);
                                                        parts.add(part);
                                                        remaining = remaining.substring(0, start);
                                                        count++;
                                                      }
                                                      String differentPrice1 = parts.isNotEmpty ? parts[0] : '';
                                                      String differentPrice2 = parts.length >= 2 ? parts[1] : '';
                                                      String differentPrice3 = parts.length >= 3 ? parts[2] : '';
                                                      return PriceDifferentWidget(
                                                        differentPrice1: differentPrice1,
                                                        differentPrice2: differentPrice2,
                                                        differentPrice3: differentPrice3,
                                                        price: items[index].price ?? 0,
                                                        id: items[index].id!,
                                                      );
                                                    }(),
                                                  ),

                                                  // price
                                                  DataCell(
                                                        () {
                                                      String price = items[index].price.toString().replaceAll(RegExp(r'[^0-9]'), '');
                                                      List<String> parts = [];
                                                      String remaining = price;
                                                      int count = 0;
                                                      while (remaining.isNotEmpty && count < 3) {
                                                        int end = remaining.length;
                                                        int start = end - 3;
                                                        if (start < 0) start = 0;
                                                        String part = remaining.substring(start, end);
                                                        parts.add(part);
                                                        remaining = remaining.substring(0, start);
                                                        count++;
                                                      }
                                                      String price1 = parts.isNotEmpty ? parts[0] : '';
                                                      String price2 = parts.length >= 2 ? parts[1] : '';
                                                      String price3 = parts.length >= 3 ? parts[2] : '';
                                                      String price4 = remaining;
                                                      return PriceSellWidget(
                                                        price1: price1,
                                                        price2: price2,
                                                        price3: price3,
                                                        price4: price4,
                                                        different: items[index].differentPrice ?? 0,
                                                        id: items[index].id!,

                                                      );
                                                    }(),
                                                  ),
                                                  // status
                                                  DataCell(
                                                    Card(
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius
                                                            .circular(5),
                                                      ),
                                                      color: items[index].status == true
                                                          ? AppColor.primaryColor
                                                          : AppColor.accentColor,
                                                      margin: EdgeInsets
                                                          .symmetric(
                                                          vertical: 0,
                                                          horizontal: 5),
                                                      child: Padding(
                                                        padding: const EdgeInsets
                                                            .all(6),
                                                        child: Text(
                                                            items[index].status == true
                                                                ? 'فعال'
                                                                : 'غیر فعال',
                                                            style: AppTextStyle
                                                                .labelText,
                                                            textAlign: TextAlign
                                                                .center),
                                                      ),
                                                    ),
                                                  )
                                                ]
                                                ),
                                              ),
                                            );
                                          }
                                            return Center(child: CircularProgressIndicator(),);
                                          }
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


