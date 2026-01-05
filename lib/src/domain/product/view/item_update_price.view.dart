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
import '../../../widget/background_image_total.widget.dart';
import '../../../widget/custom_appbar.widget.dart';
import '../../../widget/empty.dart';
import '../../../widget/err_page.dart';
import '../../home/widget/chat_dialog.widget.dart';
import '../model/item.model.dart';
import '../widget/buy_range.widget.dart';
import '../widget/buy_status.widget.dart';
import '../widget/sale_range.widget.dart';
import '../widget/sell_status.widget.dart';

class ProductUpdatePriceView extends StatefulWidget {
  ProductUpdatePriceView({super.key});

  @override
  State<ProductUpdatePriceView> createState() => _ProductUpdatePriceViewState();
}

class _ProductUpdatePriceViewState extends State<ProductUpdatePriceView> {
  final formKey = GlobalKey<FormState>();

  ProductController productController = Get.find<ProductController>();

  @override
  void dispose() {
    productController.socketSubscription?.cancel();
    super.dispose();
  }

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
              padding: EdgeInsets.all(isDesktop ? 30 : 25),
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
              padding: EdgeInsets.symmetric(vertical: 45, horizontal: isDesktop ? 20 : 10),
              child: SizedBox(
                width: Get.width,
                height: Get.height,
                child: Card(
                  color: AppColor.backGroundColor1.withAlpha(150),
                  //color: AppColor.secondaryColor.withAlpha(150),
                  elevation: 10,
                  child: Padding(
                    padding: EdgeInsets.all(isDesktop ? 20 : 5),
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
                              overlayColor: WidgetStatePropertyAll(AppColor.backGroundColor1),
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
                                      if (isDesktop)
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
                                                       headingRowColor: WidgetStatePropertyAll(AppColor.buttonColor.withAlpha(40)),
                                                        dataRowMaxHeight: 60,
                                                        headingRowHeight: 40,
                                                        columnSpacing: 60,
                                                        horizontalMargin: 40,
                                                      ),

                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      else
                                        buildMobileActiveList(context),
                                      //Tabbar2 غیر فعال
                                      if (isDesktop)
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
                                                      headingRowColor: WidgetStatePropertyAll(AppColor.buttonColor.withAlpha(40)),
                                                      dataRowMaxHeight: 60,
                                                      headingRowHeight: 40,
                                                      columnSpacing: 60,
                                                      horizontalMargin: 40,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      else
                                        buildMobileInactiveList(context),
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
      floatingActionButton: isDesktop ? FloatingActionButton(
        onPressed: () {
          Get.dialog(const ChatDialog());
        },
        backgroundColor: AppColor.primaryColor,
        child: Icon(
          Icons.chat,
          color: Colors.white,
        ),
      ) : SizedBox.shrink(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  List<DataColumn> buildDataColumnsActive() {
    return [
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100,),
              child: Text('عنوان',
                  style: AppTextStyle.bodyText)),
          headingRowAlignment: MainAxisAlignment.center
      ),
      DataColumn(
        headingRowAlignment: MainAxisAlignment.center,
        label: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 150,),
          child: Text('قیمت خرید',
            style: AppTextStyle
                .bodyText,),
        ),
      ),
      DataColumn(
        headingRowAlignment: MainAxisAlignment.center,
        label: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 150,),
          child: Text('قیمت فروش',
            style: AppTextStyle
                .bodyText,),
        ),
      ),
      DataColumn(
          label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100,),
              child: Text('تاریخ آخرین تغییر',
                  style: AppTextStyle.bodyText)),
          headingRowAlignment: MainAxisAlignment.center
      ),
      /*DataColumn(
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
      ),*/

      DataColumn(
        headingRowAlignment: MainAxisAlignment.center,

        label: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 60,),
          child: Text('وضعیت',
            style: AppTextStyle
                .bodyText,),
        ),
      ),
      DataColumn(
          label: Text('ویرایش',
              style: AppTextStyle.bodyText),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: Text('وضعیت خرید',
              style: AppTextStyle.bodyText),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: Text('وضعیت فروش',
              style: AppTextStyle.bodyText),
          headingRowAlignment: MainAxisAlignment.center),
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
    return productController.activeItemList.asMap().entries.map((entry) {
      final index = entry.key;
      final activeList = entry.value;
      final rowColor = index.isEven
          ? AppColor.backGroundColor
          : AppColor.secondaryColor.withAlpha(100);
      return DataRow(
        color: WidgetStateProperty.all(rowColor),
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
              (((activeList.mesghalPrice?.toDouble() ?? 0)-(activeList.mesghalDifferentPrice?.toDouble() ?? 0)).toString().seRagham(separator: ',')),
              style: AppTextStyle.bodyText,
            ),
          ),
          // price
          DataCell(
                () {
              String price = activeList.mesghalPrice.toString().replaceAll(RegExp(r'[^0-9]'), '');
              List<String> parts = [];
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
                  : '0';
              String price2 = parts
                  .length >= 2
                  ? parts[1]
                  : '0';
              String price3 = parts
                  .length >= 3
                  ? parts[2]
                  : '0';
              String price4 = remaining;
              return PriceSellWidget(
                price1: price1,
                price2: price2,
                price3: price3,
                price4: price4,
                mesghalDifferent: activeList
                    .mesghalDifferentPrice ??
                    0,
                id: activeList
                    .id!,
                itemUnitId: activeList.itemUnit?.id ?? 0,
                refrence:activeList.refrence,

              );
            }(),
          ),
          DataCell(
            Row(
              children: [
                Text(activeList.itemPriceDate?.toPersianDate(twoDigits: true, showTime: true, timeSeprator: '-') ?? "", style: AppTextStyle.bodyText.copyWith(color: AppColor.dividerColor, fontWeight: FontWeight.bold,fontSize: 12)),
              ],
            ),
          ),
          //different
          /*DataCell(
              () {
            String differentPrice = activeList
                .mesghalDifferentPrice
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
              mesghalPrice: activeList
                  .mesghalPrice ?? 0,
              id: activeList
                  .id!,
              itemUnitId: activeList.itemUnit?.id ?? 0,
            );
          }(),
        ),*/
          // max sell
          /*DataCell(
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
        ),*/
          // max buy
          /*DataCell(
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
        ),*/
          // sale range
          /*DataCell(
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
        ),*/
          // buy range
          /*DataCell(
              () {
            String buyRange = activeList
                .buyRange
                .toString();
            return BuyRangeWidget(
              maxBuy: activeList.maxBuy ?? 0,
              maxSell: activeList.maxSell ?? 0,
              saleRange: activeList.salesRange ?? 0,
              buyRange: buyRange,
              id: activeList.id!,

            );
          }(),
        ),*/
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
          // edit
          DataCell(
            Center(
              child: GestureDetector(
                onTap: () {
                  Get.toNamed('/productEdit', parameters: {"id": activeList.id.toString()});
                  print('activeListId:::::::::${activeList.id}');
                },
                child: Icon(
                  Icons.edit,
                  color: AppColor.iconViewColor,
                ),
              ),
            ),
          ),
          // وضعیت خرید
          DataCell(
            BuyStatusWidget(item: activeList),
          ),
          // وضعیت فروش
          DataCell(
            SellStatusWidget(item: activeList),
          ),
          // change status
          DataCell(
              Center(
                  child: Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      GestureDetector(
                        onTap: (){
                          productController.updateStatusItem(activeList.id??0,false,false,false);
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
                          productController.updateStatusItem(activeList.id??0,true,true,true);
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
                  ))
          ),
        ],
      );
    }
    ).toList();
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

      /*DataColumn(
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
      ),*/

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
          label: Text('ویرایش',
              style: AppTextStyle.labelText.copyWith(fontSize: 11)),
          headingRowAlignment: MainAxisAlignment.center),
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
    return productController.inactiveItemList.asMap().entries.map((entry) {
      final index = entry.key;
      final inActiveList = entry.value;
      final rowColor = index.isEven
          ? AppColor.backGroundColor
          : AppColor.secondaryColor.withAlpha(100);
      return DataRow(
        color: WidgetStateProperty.all(rowColor),
        cells: [
          DataCell(
            Row(
              children: [
                inActiveList.icon!=null ?
                Image.network('${BaseUrl.baseUrl}Attachment/downloadResource?fileName=${inActiveList.icon}',
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
                  "${inActiveList.name}",
                  style: AppTextStyle.bodyText,
                ),
              ],
            ),
          ),
          DataCell(
            Text(
              textAlign: TextAlign.center,
              (((inActiveList.mesghalPrice?.toDouble() ?? 0)-(inActiveList.mesghalDifferentPrice?.toDouble() ?? 0)).toString().seRagham(separator: ',')),
              style: AppTextStyle.bodyText,
            ),
          ),
          // price
          DataCell(
                () {
              String price = inActiveList
                  .mesghalPrice.toString()
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
                  : '0';
              String price2 = parts
                  .length >= 2
                  ? parts[1]
                  : '0';
              String price3 = parts
                  .length >= 3
                  ? parts[2]
                  : '0';
              String price4 = remaining;
              return PriceSellWidget(
                price1: price1,
                price2: price2,
                price3: price3,
                price4: price4,
                mesghalDifferent: inActiveList
                    .mesghalDifferentPrice ??
                    0,
                id: inActiveList
                    .id!,
                itemUnitId: inActiveList.itemUnit?.id ?? 0,
                refrence:inActiveList.refrence,
              );
            }(),
          ),
          //different
          /*DataCell(
              () {
            String differentPrice = inActiveList
                .mesghalDifferentPrice
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
              mesghalPrice: inActiveList
                  .mesghalPrice ?? 0,
              id: inActiveList
                  .id!,
              itemUnitId: inActiveList.itemUnit?.id ?? 0,
            );
          }(),
        ),*/
          // max sell
          /*DataCell(
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
        ),*/
          // max buy
          /*DataCell(
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
        ),*/
          // sale range
          /*DataCell(
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
        ),*/
          // buy range
          /*DataCell(
              () {
            String buyRange = inActiveList
                .buyRange
                .toString();
            return BuyRangeWidget(
              maxBuy: inActiveList.maxBuy ?? 0,
              maxSell: inActiveList.maxSell ?? 0,
              saleRange: inActiveList.salesRange ?? 0,
              buyRange: buyRange,
              id: inActiveList.id!,

            );
          }(),
        ),*/
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
          // edit
          DataCell(
            Center(
              child: GestureDetector(
                onTap: () {
                  Get.toNamed('/productEdit', parameters: {"id": inActiveList.id.toString()});
                },
                child: Icon(
                  Icons.edit,
                  color: AppColor.iconViewColor,
                ),
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
                      productController.updateStatusItem(inActiveList.id??0,false,false,false);
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
                      productController.updateStatusItem(inActiveList.id??0,true,true,true);
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
      );
    }
    ).toList();
  }

  // موبایل تب فعال
  Widget buildMobileActiveList(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 16),
      physics: BouncingScrollPhysics(),
      itemCount: productController.activeItemList.length,
      separatorBuilder: (_, __) => SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = productController.activeItemList[index];
        final buyPrice = (((item.mesghalPrice?.toDouble() ?? 0) - (item.mesghalDifferentPrice?.toDouble() ?? 0))
            .toStringAsFixed(0)
            .seRagham(separator: ','));

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColor.secondary100Color, AppColor.secondaryColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(50),
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Card(
            elevation: 0,
            color: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.only(left: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      item.icon != null
                          ? Image.network(
                        '${BaseUrl.baseUrl}Attachment/downloadResource?fileName=${item.icon}',
                        width: 30,
                        height: 30,
                      )
                          : SvgPicture.asset('assets/svg/gold.svg', width: 25, height: 25),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item.name ?? '',
                          style: AppTextStyle.bodyText.copyWith(fontSize: 13,fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: item.status == true ? AppColor.primaryColor : AppColor.accentColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          item.status == true ? 'فعال' : 'غیر فعال',
                          style: AppTextStyle.labelText,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text('قیمت خرید', style: AppTextStyle.bodyText),
                          SizedBox(width: 10,),
                          Text(buyPrice, style: AppTextStyle.bodyText.copyWith(color: AppColor.primaryColor, fontWeight: FontWeight.bold,fontSize: 12)),
                        ],
                      ),
                      Row(
                        children: [
                          Text('زمان تغییر: ', style: AppTextStyle.bodyText),
                          SizedBox(width: 3,),
                          Text(item.itemPriceDate?.toPersianDate(twoDigits: true, showTime: true, timeSeprator: '-') ?? "", style: AppTextStyle.bodyText.copyWith(color: AppColor.dividerColor, fontWeight: FontWeight.bold,fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('وضعیت خرید', style: AppTextStyle.bodyText.copyWith(fontSize: 10)),
                      Expanded(child: BuyStatusWidget(item: item)),
                      Text('وضعیت فروش', style: AppTextStyle.bodyText.copyWith(fontSize: 10)),
                      Expanded(child: SellStatusWidget(item: item)),
                    ],
                  ),
                  SizedBox(height: 12),
                  // قیمت فروش (قابل ویرایش با PriceSellWidget)
                  Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PriceSellWidget(
                        price1: _splitPrice(item.mesghalPrice?.toStringAsFixed(0)).item1,
                        price2: _splitPrice(item.mesghalPrice?.toStringAsFixed(0)).item2,
                        price3: _splitPrice(item.mesghalPrice?.toStringAsFixed(0)).item3,
                        price4: _splitPrice(item.mesghalPrice?.toStringAsFixed(0)).item4,
                        mesghalDifferent: item.mesghalDifferentPrice ?? 0,
                        id: item.id!,
                        itemUnitId: item.itemUnit?.id ?? 0,
                        refrence: item.refrence,
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          Get.toNamed('/productEdit', parameters: {"id": item.id.toString()});
                        },
                        icon: Icon(Icons.edit, color: AppColor.iconViewColor),
                        label: Text('ویرایش', style: AppTextStyle.labelText),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              productController.updateStatusItem(item.id ?? 0, false, false, false);
                            },
                            child: SvgPicture.asset('assets/svg/close-circle1.svg',width: 30,height: 30,
                                colorFilter: ColorFilter.mode(AppColor.accentColor, BlendMode.srcIn)),
                          ),
                          SizedBox(width: 14),
                          GestureDetector(
                            onTap: () {
                              productController.updateStatusItem(item.id ?? 0, true, true, true);
                            },
                            child: SvgPicture.asset('assets/svg/check-mark-circle.svg',width: 30,height: 30,
                                colorFilter: ColorFilter.mode(AppColor.primaryColor, BlendMode.srcIn)),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // موبایل تب غیرفعال
  Widget buildMobileInactiveList(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.only(top: 16, bottom: 16),
      physics: BouncingScrollPhysics(),
      itemCount: productController.inactiveItemList.length,
      separatorBuilder: (_, __) => SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = productController.inactiveItemList[index];
        final buyPrice = (((item.mesghalPrice?.toDouble() ?? 0) - (item.mesghalDifferentPrice?.toDouble() ?? 0))
            .toString()
            .seRagham(separator: ','));

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColor.secondary100Color, AppColor.secondaryColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(50),
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Card(
            elevation: 0,
            color: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      item.icon != null
                          ? Image.network(
                        '${BaseUrl.baseUrl}Attachment/downloadResource?fileName=${item.icon}',
                        width: 30,
                        height: 30,
                      )
                          : SvgPicture.asset('assets/svg/gold.svg', width: 25, height: 25),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item.name ?? '',
                          style: AppTextStyle.bodyText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: item.status == true ? AppColor.primaryColor : AppColor.accentColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          item.status == true ? 'فعال' : 'غیر فعال',
                          style: AppTextStyle.labelText,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('قیمت خرید', style: AppTextStyle.smallTitleText),
                      SizedBox(width: 50,),
                      Text(buyPrice, style: AppTextStyle.bodyText),
                    ],
                  ),

                  SizedBox(height: 10),
                  // قیمت فروش (قابل ویرایش با PriceSellWidget)
                  Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PriceSellWidget(
                        price1: _splitPrice(item.mesghalPrice?.toStringAsFixed(0)).item1,
                        price2: _splitPrice(item.mesghalPrice?.toStringAsFixed(0)).item2,
                        price3: _splitPrice(item.mesghalPrice?.toStringAsFixed(0)).item3,
                        price4: _splitPrice(item.mesghalPrice?.toStringAsFixed(0)).item4,
                        mesghalDifferent: item.mesghalDifferentPrice ?? 0,
                        id: item.id!,
                        itemUnitId: item.itemUnit?.id ?? 0,
                        refrence: item.refrence,
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          Get.toNamed('/productEdit', parameters: {"id": item.id.toString()});
                        },
                        icon: Icon(Icons.edit, color: AppColor.iconViewColor),
                        label: Text('ویرایش', style: AppTextStyle.labelText),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              productController.updateStatusItem(item.id ?? 0, false, false, false);
                            },
                            child: SvgPicture.asset('assets/svg/close-circle1.svg',
                                colorFilter: ColorFilter.mode(AppColor.accentColor, BlendMode.srcIn)),
                          ),
                          SizedBox(width: 14),
                          GestureDetector(
                            onTap: () {
                              productController.updateStatusItem(item.id ?? 0, true, true, true);
                            },
                            child: SvgPicture.asset('assets/svg/check-mark-circle.svg',
                                colorFilter: ColorFilter.mode(AppColor.primaryColor, BlendMode.srcIn)),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Helper to split price into 4 segments expected by PriceSellWidget
  _PriceParts _splitPrice(dynamic value) {
    final raw = (value?.toString() ?? '0').replaceAll(RegExp(r'[^0-9]'), '');
    List<String> parts = [];
    String remaining = raw;
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
    String price1 = parts.isNotEmpty ? parts[0] : '0';
    String price2 = parts.length >= 2 ? parts[1] : '0';
    String price3 = parts.length >= 3 ? parts[2] : '0';
    String price4 = remaining;
    return _PriceParts(price1, price2, price3, price4);
  }
}

class _PriceParts {
  final String item1;
  final String item2;
  final String item3;
  final String item4;
  _PriceParts(this.item1, this.item2, this.item3, this.item4);
}



