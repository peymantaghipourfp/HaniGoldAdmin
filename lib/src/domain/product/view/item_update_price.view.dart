import 'package:data_table_2/data_table_2.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/product/controller/product.controller.dart';
import 'package:hanigold_admin/src/domain/product/widget/price_different.widget.dart';
import 'package:hanigold_admin/src/domain/product/widget/price_sell.widget.dart';
import 'package:hanigold_admin/src/widget/custom_appbar1.widget.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../widget/custom_appbar.widget.dart';
import '../../../widget/empty.dart';
import '../../../widget/err_page.dart';
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
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;
    return Scaffold(
      appBar:
      CustomAppbar1(
        title: 'بروزرسانی قیمت محصولات', onBackTap: () => Get.back(),),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              padding: EdgeInsets.all(30),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bgHaniGold.png'),
                  fit: BoxFit.contain,
                  opacity: 0.06,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 45, horizontal: 20),
              child: SizedBox(
                width: Get.width,
                height: Get.height,
                child: Card(
                  color: AppColor.secondaryColor.withOpacity(0.8),
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
                                  AppColor.backGroundColor1),
                              unselectedLabelColor: AppColor.textColor
                                  .withAlpha(
                                  120),
                              indicatorColor: AppColor.primaryColor,
                              tabs: [
                                Tab(text: "فعال"),
                                Tab(text: "غیر فعال"),
                              ],
                            ),
                          ),
                          Obx(() {
                            if (productController.state.value == PageState.loading) {
                              EasyLoading.show(status: 'لطفا منتظر بمانید...');
                            return Center(
                            child: CircularProgressIndicator());
                            } else
                            if (productController.state.value == PageState.empty) {
                              EasyLoading.dismiss();
                            return EmptyPage(
                            title: 'درخواستی وجود ندارد',
                            callback: () {
                            productController
                                .fetchActiveItemList();
                            },
                            );
                            } else
                            if (productController.state.value == PageState.list) {
                              EasyLoading.dismiss();
                              return isDesktop ?
                                Expanded(
                                child: Container(
                                  constraints: BoxConstraints(
                                      maxWidth: double.infinity
                                  ),
                                  child: TabBarView(
                                    children: [
                                      // Tabbar1 فعال
                                        DataTable2(
                                            columnSpacing: 10,
                                            horizontalMargin: 20,
                                            columns: [
                                              DataColumn2(fixedWidth: 150,
                                                label: Text('عنوان',
                                                  style: AppTextStyle
                                                      .smallTitleText,),
                                              ),
                                              DataColumn2(fixedWidth: 150,
                                                label: Text('قیمت خرید',
                                                  style: AppTextStyle
                                                      .smallTitleText,),
                                              ),
                                              DataColumn2(
                                                size: ColumnSize.L,
                                                label: Text('قیمت فروش',
                                                  style: AppTextStyle
                                                      .smallTitleText,),
                                              ),
                                              DataColumn2(
                                                size: ColumnSize.L,
                                                label: Text(
                                                  'تفاوت قیمت فروش',
                                                  style: AppTextStyle
                                                      .smallTitleText,),
                                              ),
                                              DataColumn2(fixedWidth: 100,
                                                size: ColumnSize.S,
                                                label: Text('وضعیت فروش',
                                                  style: AppTextStyle
                                                      .smallTitleText,),
                                              ),
                                            ],

                                            rows: List<DataRow>.generate(
                                              productController.activeItemList.length,
                                                  (index) =>
                                                  DataRow(
                                                      cells:
                                                  [
                                                    DataCell(
                                                      Text(
                                                        textAlign: TextAlign
                                                            .center,
                                                        "${productController
                                                            .activeItemList[index]
                                                            .name}",
                                                        style: AppTextStyle.bodyText,
                                                      ),
                                                    ),
                                                    DataCell(
                                                      Text(
                                                        textAlign: TextAlign.center,
                                                        (((productController.activeItemList[index].price?.toDouble() ?? 0)-(productController.activeItemList[index].differentPrice?.toDouble() ?? 0)).toString().seRagham(separator: ',')),
                                                        style: AppTextStyle.bodyText,
                                                      ),
                                                    ),
                                                    // price
                                                    DataCell(
                                                          () {
                                                        String price = productController
                                                            .activeItemList[index]
                                                            .price
                                                            .toString()
                                                            .replaceAll(
                                                            RegExp(
                                                                r'[^0-9]'),
                                                            '');
                                                        List<
                                                            String> parts = [
                                                        ];
                                                        String remaining = price;
                                                        int count = 0;
                                                        while (remaining
                                                            .isNotEmpty &&
                                                            count < 3) {
                                                          int end = remaining
                                                              .length;
                                                          int start = end -
                                                              3;
                                                          if (start < 0)
                                                            start = 0;
                                                          String part = remaining
                                                              .substring(
                                                              start, end);
                                                          parts.add(part);
                                                          remaining =
                                                              remaining
                                                                  .substring(
                                                                  0,
                                                                  start);
                                                          count++;
                                                        }
                                                        String price1 = parts
                                                            .isNotEmpty
                                                            ? parts[0]
                                                            : '';
                                                        String price2 = parts
                                                            .length >= 2
                                                            ? parts[1]
                                                            : '';
                                                        String price3 = parts
                                                            .length >= 3
                                                            ? parts[2]
                                                            : '';
                                                        String price4 = remaining;
                                                        return PriceSellWidget(
                                                          price1: price1,
                                                          price2: price2,
                                                          price3: price3,
                                                          price4: price4,
                                                          different: productController
                                                              .activeItemList[index]
                                                              .differentPrice ??
                                                              0,
                                                          id: productController
                                                              .activeItemList[index]
                                                              .id!,

                                                        );
                                                      }(),
                                                    ),
                                                    //different
                                                    DataCell(
                                                          () {
                                                        String differentPrice = productController
                                                            .activeItemList[index]
                                                            .differentPrice
                                                            .toString()
                                                            .replaceAll(
                                                            RegExp(
                                                                r'[^0-9]'),
                                                            '');
                                                        List<
                                                            String> parts = [
                                                        ];
                                                        String remaining = differentPrice;
                                                        int count = 0;
                                                        while (remaining
                                                            .isNotEmpty &&
                                                            count < 3) {
                                                          int end = remaining
                                                              .length;
                                                          int start = end -
                                                              3;
                                                          if (start < 0)
                                                            start = 0;
                                                          String part = remaining
                                                              .substring(
                                                              start, end);
                                                          parts.add(part);
                                                          remaining =
                                                              remaining
                                                                  .substring(
                                                                  0,
                                                                  start);
                                                          count++;
                                                        }
                                                        String differentPrice1 = parts
                                                            .isNotEmpty
                                                            ? parts[0]
                                                            : '';
                                                        String differentPrice2 = parts
                                                            .length >= 2
                                                            ? parts[1]
                                                            : '';
                                                        String differentPrice3 = parts
                                                            .length >= 3
                                                            ? parts[2]
                                                            : '';
                                                        return PriceDifferentWidget(
                                                          differentPrice1: differentPrice1,
                                                          differentPrice2: differentPrice2,
                                                          differentPrice3: differentPrice3,
                                                          price: productController
                                                              .activeItemList[index]
                                                              .price ?? 0,
                                                          id: productController
                                                              .activeItemList[index]
                                                              .id!,
                                                        );
                                                      }(),
                                                    ),
                                                    // status
                                                    DataCell(
                                                      Card(
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius
                                                              .circular(
                                                              5),
                                                        ),
                                                        color: productController
                                                            .activeItemList[index]
                                                            .status ==
                                                            true
                                                            ? AppColor
                                                            .primaryColor
                                                            : AppColor
                                                            .accentColor,
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                            vertical: 0,
                                                            horizontal: 5),
                                                        child: Padding(
                                                          padding: const EdgeInsets
                                                              .all(6),
                                                          child: Text(
                                                              productController
                                                                  .activeItemList[index]
                                                                  .status ==
                                                                  true
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
                                                                                     ),
                                      //Tabbar2 غیر فعال
                                        DataTable2(
                                                columnSpacing: 12,
                                                horizontalMargin: 20,

                                                columns: [
                                                  DataColumn2(fixedWidth: 150,
                                                    label: Text('عنوان',
                                                      style: AppTextStyle
                                                          .smallTitleText,),
                                                  ),
                                                  DataColumn2(fixedWidth: 150,
                                                    label: Text('قیمت خرید',
                                                      style: AppTextStyle
                                                          .smallTitleText,),
                                                  ),
                                                  DataColumn2(
                                                    size: ColumnSize.L,
                                                    label: Text('قیمت فروش',
                                                      style: AppTextStyle
                                                          .smallTitleText,),
                                                  ),
                                                  DataColumn2(
                                                    size: ColumnSize.L,
                                                    label: Text('تفاوت قیمت فروش',
                                                      style: AppTextStyle
                                                          .smallTitleText,),
                                                  ),
                                                  DataColumn2(fixedWidth: 100,
                                                    size: ColumnSize.S,
                                                    label: Text('وضعیت فروش',
                                                      style: AppTextStyle
                                                          .smallTitleText,),
                                                  ),
                                                ],

                                                rows: List<DataRow>.generate(
                                                  productController.inactiveItemList.length,
                                                      (index) =>
                                                      DataRow(cells:
                                                      [
                                                        DataCell(
                                                          Text(
                                                            textAlign: TextAlign
                                                                .center,
                                                            "${productController.inactiveItemList[index]
                                                                .name}",
                                                            style: AppTextStyle
                                                                .bodyTextBold,
                                                          ),
                                                        ),
                                                        DataCell(
                                                          Text(
                                                            textAlign: TextAlign
                                                                .center,
                                                            (((productController.inactiveItemList[index].price?.toDouble() ?? 0)-(productController.inactiveItemList[index].differentPrice?.toDouble() ?? 0)).toString().seRagham(separator: ',')),
                                                            style: AppTextStyle
                                                                .bodyTextBold,
                                                          ),
                                                        ),
                                                        // price
                                                        DataCell(
                                                              () {
                                                            String price = productController.inactiveItemList[index]
                                                                .price.toString()
                                                                .replaceAll(
                                                                RegExp(
                                                                    r'[^0-9]'),
                                                                '');
                                                            List<String> parts = [
                                                            ];
                                                            String remaining = price;
                                                            int count = 0;
                                                            while (remaining
                                                                .isNotEmpty &&
                                                                count < 3) {
                                                              int end = remaining
                                                                  .length;
                                                              int start = end - 3;
                                                              if (start < 0)
                                                                start =
                                                                0;
                                                              String part = remaining
                                                                  .substring(
                                                                  start, end);
                                                              parts.add(part);
                                                              remaining =
                                                                  remaining
                                                                      .substring(
                                                                      0, start);
                                                              count++;
                                                            }
                                                            String price1 = parts
                                                                .isNotEmpty
                                                                ? parts[0]
                                                                : '';
                                                            String price2 = parts
                                                                .length >= 2
                                                                ? parts[1]
                                                                : '';
                                                            String price3 = parts
                                                                .length >= 3
                                                                ? parts[2]
                                                                : '';
                                                            String price4 = remaining;
                                                            return PriceSellWidget(
                                                              price1: price1,
                                                              price2: price2,
                                                              price3: price3,
                                                              price4: price4,
                                                              different: productController.inactiveItemList[index]
                                                                  .differentPrice ??
                                                                  0,
                                                              id: productController.inactiveItemList[index]
                                                                  .id!,

                                                            );
                                                          }(),
                                                        ),
                                                        //different
                                                        DataCell(
                                                              () {
                                                            String differentPrice = productController.inactiveItemList[index]
                                                                .differentPrice
                                                                .toString()
                                                                .replaceAll(
                                                                RegExp(
                                                                    r'[^0-9]'),
                                                                '');
                                                            List<String> parts = [
                                                            ];
                                                            String remaining = differentPrice;
                                                            int count = 0;
                                                            while (remaining
                                                                .isNotEmpty &&
                                                                count < 3) {
                                                              int end = remaining
                                                                  .length;
                                                              int start = end - 3;
                                                              if (start < 0)
                                                                start = 0;
                                                              String part = remaining
                                                                  .substring(
                                                                  start, end);
                                                              parts.add(part);
                                                              remaining =
                                                                  remaining
                                                                      .substring(
                                                                      0, start);
                                                              count++;
                                                            }
                                                            String differentPrice1 = parts
                                                                .isNotEmpty
                                                                ? parts[0]
                                                                : '';
                                                            String differentPrice2 = parts
                                                                .length >= 2
                                                                ? parts[1]
                                                                : '';
                                                            String differentPrice3 = parts
                                                                .length >= 3
                                                                ? parts[2]
                                                                : '';
                                                            return PriceDifferentWidget(
                                                              differentPrice1: differentPrice1,
                                                              differentPrice2: differentPrice2,
                                                              differentPrice3: differentPrice3,
                                                              price: productController.inactiveItemList[index]
                                                                  .price ?? 0,
                                                              id: productController.inactiveItemList[index]
                                                                  .id!,
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
                                                            color: productController.inactiveItemList[index]
                                                                .status == true
                                                                ? AppColor
                                                                .primaryColor
                                                                : AppColor
                                                                .accentColor,
                                                            margin: EdgeInsets
                                                                .symmetric(
                                                                vertical: 0,
                                                                horizontal: 5),
                                                            child: Padding(
                                                              padding: const EdgeInsets
                                                                  .all(6),
                                                              child: Text(
                                                                  productController.inactiveItemList[index]
                                                                      .status ==
                                                                      true
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
                                              ),
                                    ],
                                  ),
                                ),
                              ) :

                                Expanded(
                                      child: Container(
                                          constraints: BoxConstraints(maxWidth: 400),
                                          padding: const EdgeInsets.symmetric(horizontal: 24),
                                          child: TabBarView(
                                            children: [
                                              // tab1
                                              ListView.builder(
                                                shrinkWrap: true,
                                                physics: BouncingScrollPhysics(),
                                                itemCount: productController.activeItemList.length,
                                                  itemBuilder: (context, index) {
                                                    var activeItem=productController.activeItemList[index];
                                                    return ListTile(
                                                      title: Column(
                                                        children: [
                                                          Card(
                                                            color: AppColor.secondaryColor,
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(3),
                                                              child: Column(
                                                                children: [
                                                                  Center(
                                                                    child: Text(activeItem.name ?? "",style: AppTextStyle.bodyText,),
                                                                  ),
                                                                      SizedBox(height: 5,),
                                                                  Row(mainAxisAlignment: MainAxisAlignment.start,
                                                                        children: [
                                                                          Text('تغییر قیمت',style: AppTextStyle.bodyText,),
                                                                          SizedBox(width: 9,),
                                                                    () {
                                                                      String price = productController
                                                                          .activeItemList[
                                                                              index]
                                                                          .price
                                                                          .toString()
                                                                          .replaceAll(
                                                                              RegExp(r'[^0-9]'),
                                                                              '');
                                                                      List<String>
                                                                          parts =
                                                                          [];
                                                                      String
                                                                          remaining =
                                                                          price;
                                                                      int count =
                                                                          0;
                                                                      while (remaining
                                                                              .isNotEmpty &&
                                                                          count <
                                                                              3) {
                                                                        int end =
                                                                            remaining.length;
                                                                        int start =
                                                                            end -
                                                                                3;
                                                                        if (start <
                                                                            0)
                                                                          start =
                                                                              0;
                                                                        String part = remaining.substring(
                                                                            start,
                                                                            end);
                                                                        parts.add(
                                                                            part);
                                                                        remaining = remaining.substring(
                                                                            0,
                                                                            start);
                                                                        count++;
                                                                      }
                                                                      String price1 = parts
                                                                              .isNotEmpty
                                                                          ? parts[
                                                                              0]
                                                                          : '';
                                                                      String price2 = parts.length >=
                                                                              2
                                                                          ? parts[
                                                                              1]
                                                                          : '';
                                                                      String price3 = parts.length >=
                                                                              3
                                                                          ? parts[
                                                                              2]
                                                                          : '';
                                                                      String
                                                                          price4 =
                                                                          remaining;
                                                                      return PriceSellWidget(
                                                                        price1:
                                                                            price1,
                                                                        price2:
                                                                            price2,
                                                                        price3:
                                                                            price3,
                                                                        price4:
                                                                            price4,
                                                                        different:
                                                                            productController.activeItemList[index].differentPrice ??
                                                                                0,
                                                                        id: productController
                                                                            .activeItemList[index]
                                                                            .id!,
                                                                      );
                                                                    }(),
                                                                  ],
                                                                      ),
                                                                  SizedBox(height: 5,),
                                                                  Row(mainAxisAlignment: MainAxisAlignment.start,
                                                                    children: [
                                                                      Text('تفاوت قیمت',style: AppTextStyle.bodyText,),
                                                                      SizedBox(width: 5,),
                                                                      () {
                                                                        String differentPrice = productController
                                                                            .activeItemList[index]
                                                                            .differentPrice
                                                                            .toString()
                                                                            .replaceAll(
                                                                            RegExp(
                                                                                r'[^0-9]'),
                                                                            '');
                                                                        List<
                                                                            String> parts = [
                                                                        ];
                                                                        String remaining = differentPrice;
                                                                        int count = 0;
                                                                        while (remaining
                                                                            .isNotEmpty &&
                                                                            count < 3) {
                                                                          int end = remaining
                                                                              .length;
                                                                          int start = end -
                                                                              3;
                                                                          if (start < 0)
                                                                            start = 0;
                                                                          String part = remaining
                                                                              .substring(
                                                                              start, end);
                                                                          parts.add(part);
                                                                          remaining =
                                                                              remaining
                                                                                  .substring(
                                                                                  0,
                                                                                  start);
                                                                          count++;
                                                                        }
                                                                        String differentPrice1 = parts
                                                                            .isNotEmpty
                                                                            ? parts[0]
                                                                            : '';
                                                                        String differentPrice2 = parts
                                                                            .length >= 2
                                                                            ? parts[1]
                                                                            : '';
                                                                        String differentPrice3 = parts
                                                                            .length >= 3
                                                                            ? parts[2]
                                                                            : '';
                                                                        return PriceDifferentWidget(
                                                                          differentPrice1: differentPrice1,
                                                                          differentPrice2: differentPrice2,
                                                                          differentPrice3: differentPrice3,
                                                                          price: productController
                                                                              .activeItemList[index]
                                                                              .price ?? 0,
                                                                          id: productController
                                                                              .activeItemList[index]
                                                                              .id!,
                                                                        );
                                                                      }(),
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),

                                                        ],
                                                      ) ,
                                                    );
                                                  },
                                              ),
                                              
                                              // tab2
                                              ListView.builder(
                                                shrinkWrap: true,
                                                physics: BouncingScrollPhysics(),
                                                itemCount: productController.inactiveItemList.length,
                                                itemBuilder: (context, index) {
                                                  var inActiveItem=productController.inactiveItemList[index];
                                                  return ListTile(
                                                    title: Column(
                                                      children: [
                                                        Card(
                                                          color: AppColor.secondaryColor,
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(3),
                                                            child: Column(
                                                              children: [
                                                                Center(
                                                                  child: Text(inActiveItem.name ?? "",style: AppTextStyle.bodyText,),
                                                                ),
                                                                SizedBox(height: 5,),
                                                                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    Text('تغییر قیمت',style: AppTextStyle.bodyText,),
                                                                    SizedBox(width: 9,),
                                                                        () {
                                                                      String price = productController
                                                                          .inactiveItemList[index]
                                                                          .price
                                                                          .toString()
                                                                          .replaceAll(
                                                                          RegExp(
                                                                              r'[^0-9]'),
                                                                          '');
                                                                      List<
                                                                          String> parts = [
                                                                      ];
                                                                      String remaining = price;
                                                                      int count = 0;
                                                                      while (remaining
                                                                          .isNotEmpty &&
                                                                          count < 3) {
                                                                        int end = remaining
                                                                            .length;
                                                                        int start = end -
                                                                            3;
                                                                        if (start < 0)
                                                                          start = 0;
                                                                        String part = remaining
                                                                            .substring(
                                                                            start, end);
                                                                        parts.add(part);
                                                                        remaining =
                                                                            remaining
                                                                                .substring(
                                                                                0,
                                                                                start);
                                                                        count++;
                                                                      }
                                                                      String price1 = parts
                                                                          .isNotEmpty
                                                                          ? parts[0]
                                                                          : '';
                                                                      String price2 = parts
                                                                          .length >= 2
                                                                          ? parts[1]
                                                                          : '';
                                                                      String price3 = parts
                                                                          .length >= 3
                                                                          ? parts[2]
                                                                          : '';
                                                                      String price4 = remaining;
                                                                      return PriceSellWidget(
                                                                        price1: price1,
                                                                        price2: price2,
                                                                        price3: price3,
                                                                        price4: price4,
                                                                        different: productController
                                                                            .inactiveItemList[index]
                                                                            .differentPrice ??
                                                                            0,
                                                                        id: productController
                                                                            .inactiveItemList[index]
                                                                            .id!,

                                                                      );
                                                                    }(),
                                                                  ],
                                                                ),
                                                                SizedBox(height: 5,),
                                                                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    Text('تفاوت قیمت',style: AppTextStyle.bodyText,),
                                                                    SizedBox(width: 5,),
                                                                        () {
                                                                      String differentPrice = productController
                                                                          .inactiveItemList[index]
                                                                          .differentPrice
                                                                          .toString()
                                                                          .replaceAll(
                                                                          RegExp(
                                                                              r'[^0-9]'),
                                                                          '');
                                                                      List<
                                                                          String> parts = [
                                                                      ];
                                                                      String remaining = differentPrice;
                                                                      int count = 0;
                                                                      while (remaining
                                                                          .isNotEmpty &&
                                                                          count < 3) {
                                                                        int end = remaining
                                                                            .length;
                                                                        int start = end -
                                                                            3;
                                                                        if (start < 0)
                                                                          start = 0;
                                                                        String part = remaining
                                                                            .substring(
                                                                            start, end);
                                                                        parts.add(part);
                                                                        remaining =
                                                                            remaining
                                                                                .substring(
                                                                                0,
                                                                                start);
                                                                        count++;
                                                                      }
                                                                      String differentPrice1 = parts
                                                                          .isNotEmpty
                                                                          ? parts[0]
                                                                          : '';
                                                                      String differentPrice2 = parts
                                                                          .length >= 2
                                                                          ? parts[1]
                                                                          : '';
                                                                      String differentPrice3 = parts
                                                                          .length >= 3
                                                                          ? parts[2]
                                                                          : '';
                                                                      return PriceDifferentWidget(
                                                                        differentPrice1: differentPrice1,
                                                                        differentPrice2: differentPrice2,
                                                                        differentPrice3: differentPrice3,
                                                                        price: productController
                                                                            .inactiveItemList[index]
                                                                            .price ?? 0,
                                                                        id: productController
                                                                            .inactiveItemList[index]
                                                                            .id!,
                                                                      );
                                                                    }(),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),

                                                      ],
                                                    ) ,
                                                  );
                                                },
                                              ),
                                            ],
                                          )
                                      ),
                                  );
                            }
                            EasyLoading.dismiss();
                            return ErrPage(
                              callback: () {
                                productController
                                    .fetchActiveItemList();
                              },
                              title: "خطا در دریافت لیست درخواست ها",
                              des: 'برای دریافت درخواست ها مجددا تلاش کنید',
                            );
                          }),
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


