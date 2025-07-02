import 'package:data_table_2/data_table_2.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/product/controller/product.controller.dart';
import 'package:hanigold_admin/src/domain/product/widget/max_buy.widget.dart';
import 'package:hanigold_admin/src/domain/product/widget/max_sell.widget.dart';
import 'package:hanigold_admin/src/domain/product/widget/price_different.widget.dart';
import 'package:hanigold_admin/src/domain/product/widget/price_sell.widget.dart';
import 'package:hanigold_admin/src/widget/custom_appbar1.widget.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../config/repository/url/base_url.dart';
import '../../../widget/app_drawer.widget.dart';
import '../../../widget/custom_appbar.widget.dart';
import '../../../widget/empty.dart';
import '../../../widget/err_page.dart';
import '../model/item.model.dart';
import '../widget/buy_range.widget.dart';
import '../widget/sale_range.widget.dart';

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
        title: 'بروزرسانی قیمت محصولات', onBackTap: () => Get.toNamed('/home'),),
      drawer: const AppDrawer(),
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
                              //EasyLoading.show(status: 'لطفا منتظر بمانید...');
                            return Center(
                            child: CircularProgressIndicator());
                            } else
                            if (productController.state.value == PageState.empty) {
                              //EasyLoading.dismiss();
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
                              return
                                Expanded(
                                  child: TabBarView(
                                    physics: NeverScrollableScrollPhysics(),
                                    children: [
                                      // Tabbar1 فعال
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          controller: productController.scrollController,
                                          physics: ClampingScrollPhysics(),
                                          child: Row(crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SingleChildScrollView(
                                                child: Column(
                                                  children: [
                                                    DataTable(
                                                        border: TableBorder.symmetric(
                                                            inside: BorderSide(color: AppColor.textColor, width: 0.3),
                                                            outside: BorderSide(color: AppColor.textColor, width: 0.3),
                                                            borderRadius: BorderRadius.circular(8)),
                                                        dividerThickness: 0.3,
                                                        columns: buildDataColumnsActive(),

                                                        rows: buildDataRowsActive(context),
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
                                      //Tabbar2 غیر فعال
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        controller: productController.scrollController,
                                        physics: ClampingScrollPhysics(),
                                        child: Row(crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SingleChildScrollView(
                                              child: Column(
                                                children: [
                                                  DataTable(
                                                    border: TableBorder.symmetric(
                                                        inside: BorderSide(color: AppColor.textColor, width: 0.3),
                                                        outside: BorderSide(color: AppColor.textColor, width: 0.3),
                                                        borderRadius: BorderRadius.circular(8)),
                                                    dividerThickness: 0.3,
                                                    columns: buildDataColumnsInactive(),

                                                    rows: buildDataRowsInactive(context),
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
                                );

                                /*Expanded(
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
                                  );*/
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

  List<DataColumn> buildDataColumnsActive() {
    return [
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100,),
              child: Text('عنوان',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11))),
          headingRowAlignment: MainAxisAlignment.center
      ),
      DataColumn(
        headingRowAlignment: MainAxisAlignment.center,
        label: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 150,),
          child: Text('قیمت خرید',
            style: AppTextStyle
                .smallTitleText,),
        ),
      ),
      DataColumn(
        headingRowAlignment: MainAxisAlignment.center,
        label: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 150,),
          child: Text('قیمت فروش',
            style: AppTextStyle
                .smallTitleText,),
        ),
      ),
      DataColumn(
        headingRowAlignment: MainAxisAlignment.center,
        label: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 150,),
          child: Text(
            'تفاوت قیمت فروش',
            style: AppTextStyle
                .smallTitleText,),
        ),
      ),
      DataColumn(
        headingRowAlignment: MainAxisAlignment.center,
        label: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 150,),
          child: Text('ماکزیمم فروش',
            style: AppTextStyle
                .smallTitleText,),
        ),
      ),
      DataColumn(
        headingRowAlignment: MainAxisAlignment.center,
        label: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 150,),
          child: Text('ماکزیمم خرید',
            style: AppTextStyle
                .smallTitleText,),
        ),
      ),
      DataColumn(
        headingRowAlignment: MainAxisAlignment.center,
        label: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 150,),
          child: Text('محدوده فروش',
            style: AppTextStyle
                .smallTitleText,),
        ),
      ),
      DataColumn(
        headingRowAlignment: MainAxisAlignment.center,
        label: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 150,),
          child: Text('محدوده خرید',
            style: AppTextStyle
                .smallTitleText,),
        ),
      ),
      DataColumn(
        headingRowAlignment: MainAxisAlignment.center,

        label: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 60,),
          child: Text('وضعیت',
            style: AppTextStyle
                .smallTitleText,),
        ),
      ),
      DataColumn(
          label: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('تغییر وضعیت',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11)),
              Text('غیر فعال / فعال',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11)),
            ],
          ),
          headingRowAlignment: MainAxisAlignment.center),

    ];
  }
  List<DataRow> buildDataRowsActive(BuildContext context) {
    return productController.activeItemList
        .map((activeList) => DataRow(
      cells: [
        DataCell(
          Row(
            children: [
              activeList.icon!=null ?
              Image.network('${BaseUrl.baseUrl}Attachment/downloadResource?fileName=${activeList.icon}',
                width: 30,
                height: 30,) :
              SvgPicture.asset(
                'assets/svg/gold.svg',
                width: 25,
                height: 25,),
              SizedBox(width: 5,),
              Text(
                textAlign: TextAlign
                    .center,
                "${activeList.name}",
                style: AppTextStyle.bodyText,
              ),
            ],
          ),
        ),
        DataCell(
          Text(
            textAlign: TextAlign.center,
            (((activeList.price?.toDouble() ?? 0)-(activeList.differentPrice?.toDouble() ?? 0)).toString().seRagham(separator: ',')),
            style: AppTextStyle.bodyText,
          ),
        ),
        // price
        DataCell(
              () {
            String price = activeList
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
              different: activeList
                  .differentPrice ??
                  0,
              id: activeList
                  .id!,

            );
          }(),
        ),
        //different
        DataCell(
              () {
            String differentPrice = activeList
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
              price: activeList
                  .price ?? 0,
              id: activeList
                  .id!,
            );
          }(),
        ),
        // max sell
        DataCell(
              () {
            String maxSell = activeList
                .maxSell
                .toString();
            return MaxSellWidget(
              maxSell: maxSell,
              maxBuy: activeList.maxBuy ?? 0,
              saleRange: activeList.salesRange ?? 0,
              buyRange: activeList.buyRange ?? 0,
              id: activeList.id!,

            );
          }(),
        ),
        // max buy
        DataCell(
              () {
            String maxBuy = activeList
                .maxBuy
                .toString();
            return MaxBuyWidget(
              maxBuy: maxBuy,
              maxSell: activeList.maxSell ?? 0,
              saleRange: activeList.salesRange ?? 0,
              buyRange: activeList.buyRange ?? 0,
              id: activeList.id!,

            );
          }(),
        ),
        // sale range
        DataCell(
              () {
            String salesRange = activeList
                .salesRange
                .toString();
            return SaleRangeWidget(
              maxSell: activeList.maxSell ?? 0,
              maxBuy: activeList.maxBuy ?? 0,
              salesRange: salesRange,
              buyRange: activeList.buyRange ?? 0,
              id: activeList.id!,

            );
          }(),
        ),
        // buy range
        DataCell(
              () {
            String buyRange = activeList
                .buyRange
                .toString();
            return BuyRangeWidget(
              maxBuy: activeList.maxSell ?? 0,
              maxSell: activeList.maxSell ?? 0,
              saleRange: activeList.salesRange ?? 0,
              buyRange: buyRange,
              id: activeList.id!,

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
            color: activeList
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
                  activeList
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
        ),
        // change status
        DataCell(Center(
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  onTap: (){
                    productController.updateStatusItem(activeList.id??0,false);
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
                    productController.updateStatusItem(activeList.id??0,true);
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

  List<DataColumn> buildDataColumnsInactive() {
    return [
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100,),
              child: Text('عنوان',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11))),
          headingRowAlignment: MainAxisAlignment.center
      ),
      DataColumn(
        headingRowAlignment: MainAxisAlignment.center,
        label: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 150,),
          child: Text('قیمت خرید',
            style: AppTextStyle
                .smallTitleText,),
        ),
      ),
      DataColumn(
        headingRowAlignment: MainAxisAlignment.center,
        label: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 150,),
          child: Text('قیمت فروش',
            style: AppTextStyle
                .smallTitleText,),
        ),
      ),
      DataColumn(
        headingRowAlignment: MainAxisAlignment.center,
        label: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 150,),
          child: Text(
            'تفاوت قیمت فروش',
            style: AppTextStyle
                .smallTitleText,),
        ),
      ),
      DataColumn(
        headingRowAlignment: MainAxisAlignment.center,
        label: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 150,),
          child: Text('ماکزیمم فروش',
            style: AppTextStyle
                .smallTitleText,),
        ),
      ),
      DataColumn(
        headingRowAlignment: MainAxisAlignment.center,
        label: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 150,),
          child: Text('ماکزیمم خرید',
            style: AppTextStyle
                .smallTitleText,),
        ),
      ),
      DataColumn(
        headingRowAlignment: MainAxisAlignment.center,
        label: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 150,),
          child: Text('محدوده فروش',
            style: AppTextStyle
                .smallTitleText,),
        ),
      ),
      DataColumn(
        headingRowAlignment: MainAxisAlignment.center,
        label: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 150,),
          child: Text('محدوده خرید',
            style: AppTextStyle
                .smallTitleText,),
        ),
      ),
      DataColumn(
        headingRowAlignment: MainAxisAlignment.center,

        label: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 60,),
          child: Text('وضعیت',
            style: AppTextStyle
                .smallTitleText,),
        ),
      ),
      DataColumn(
          label: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('تغییر وضعیت',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11)),
              Text('غیر فعال / فعال',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11)),
            ],
          ),
          headingRowAlignment: MainAxisAlignment.center),

    ];
  }
  List<DataRow> buildDataRowsInactive(BuildContext context) {
    return productController.inactiveItemList
        .map((inActiveList) => DataRow(
      cells: [
        DataCell(
          Text(
            textAlign: TextAlign
                .center,
            "${inActiveList
                .name}",
            style: AppTextStyle
                .bodyTextBold,
          ),
        ),
        DataCell(
          Text(
            textAlign: TextAlign
                .center,
            (((inActiveList.price?.toDouble() ?? 0)-(inActiveList.differentPrice?.toDouble() ?? 0)).toString().seRagham(separator: ',')),
            style: AppTextStyle
                .bodyTextBold,
          ),
        ),
        // price
        DataCell(
              () {
            String price = inActiveList
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
              different: inActiveList
                  .differentPrice ??
                  0,
              id: inActiveList
                  .id!,

            );
          }(),
        ),
        //different
        DataCell(
              () {
            String differentPrice = inActiveList
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
              price: inActiveList
                  .price ?? 0,
              id: inActiveList
                  .id!,
            );
          }(),
        ),
        // max sell
        DataCell(
              () {
            String maxSell = inActiveList
                .maxSell
                .toString();
            return MaxSellWidget(
              maxSell: maxSell,
              maxBuy: inActiveList.maxBuy ?? 0,
              saleRange: inActiveList.salesRange ?? 0,
              buyRange: inActiveList.buyRange ?? 0,
              id: inActiveList.id!,

            );
          }(),
        ),
        // max buy
        DataCell(
              () {
            String maxBuy = inActiveList
                .maxBuy
                .toString();
            return MaxBuyWidget(
              maxBuy: maxBuy,
              maxSell: inActiveList.maxSell ?? 0,
              saleRange: inActiveList.salesRange ?? 0,
              buyRange: inActiveList.buyRange ?? 0,
              id: inActiveList.id!,

            );
          }(),
        ),
        // sale range
        DataCell(
              () {
            String salesRange = inActiveList
                .salesRange
                .toString();
            return SaleRangeWidget(
              maxSell: inActiveList.maxSell ?? 0,
              maxBuy: inActiveList.maxBuy ?? 0,
              salesRange: salesRange,
              buyRange: inActiveList.buyRange ?? 0,
              id: inActiveList.id!,

            );
          }(),
        ),
        // buy range
        DataCell(
              () {
            String buyRange = inActiveList
                .buyRange
                .toString();
            return BuyRangeWidget(
              maxBuy: inActiveList.maxSell ?? 0,
              maxSell: inActiveList.maxSell ?? 0,
              saleRange: inActiveList.salesRange ?? 0,
              buyRange: buyRange,
              id: inActiveList.id!,

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
            color: inActiveList
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
                  inActiveList
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
        ),
        // change status
        DataCell(Center(
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  onTap: (){
                    productController.updateStatusItem(inActiveList.id??0,false);
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
                    productController.updateStatusItem(inActiveList.id??0,true);
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


