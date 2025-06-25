import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/widget/custom_appbar1.widget.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../widget/app_drawer.widget.dart';
import '../../../widget/background_image.widget.dart';
import '../../../widget/background_image_total.widget.dart';
import '../../../widget/custom_appbar.widget.dart';
import '../controller/trading_balance.controller.dart';
import '../widgets/balance_item.widget.dart';


class TradingBalanceView extends StatefulWidget {
  const TradingBalanceView({super.key});

  @override
  State<TradingBalanceView> createState() => _UserInfoTransactionViewState();
}

class _UserInfoTransactionViewState extends State<TradingBalanceView> {
  var controller=Get.find<TradingBalanceController>();
  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    return Obx(() => Scaffold(
      appBar: CustomAppbar1(
        title: 'تراز معاملاتی',
        onBackTap: () => Get.back(),
      ),
      drawer: const AppDrawer(),
      body: Stack(
        children: [
          BackgroundImageTotal(),
          SafeArea(
            child: controller.state.value == PageStateBalance.loading
                ? Center(
              child: CircularProgressIndicator(),
            )
                : controller.state.value == PageStateBalance.list
                ? SizedBox(
              height: Get.height,
              width: Get.width,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 7,backgroundColor: AppColor.buttonColor,
                          ),
                          SizedBox(width: 10,),
                          Text(
                            "طلا",
                            style: AppTextStyle.labelText.copyWith(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width:  Get.width ,
                      height: isDesktop ? Get.height * 0.3 : Get.height *0.5 ,
                      margin: EdgeInsets.symmetric(horizontal: 0,vertical: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(3)),
                          border: Border.all(color: AppColor.circularLoadingColor,width: 0.5),
                         ),
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: ListView.builder(
                        scrollDirection:isDesktop? Axis.horizontal:Axis.vertical,
                        controller: controller.scrollController,
                        itemCount: controller.tradingBalanceList.length ,
                        itemBuilder: (context, index) {
                          return controller.tradingBalanceList[index].itemGroup=="طلا"?
                          BalanceItemWidget(
                          title: controller.tradingBalanceList[index].dateName??"",
                            balanceList: controller.tradingBalanceList[index].balances??[],
                            titleBase: controller.tradingBalanceList[index].itemGroup??"", isDesktop: isDesktop,
                          ):SizedBox();
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),

                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 7,backgroundColor: AppColor.buttonColor,
                          ),
                          SizedBox(width: 10,),
                          Text(
                            "سکه",
                            style: AppTextStyle.labelText.copyWith(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width:  Get.width ,
                      height: isDesktop ? Get.height * 0.36 : Get.height *0.5 ,
                      margin: EdgeInsets.symmetric(horizontal: 0,vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(3)),
                        border: Border.all(color: AppColor.circularLoadingColor,width: 0.5),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: ListView.builder(
                        scrollDirection:isDesktop? Axis.horizontal:Axis.vertical,
                        controller: controller.scrollController,
                        itemCount: controller.tradingBalanceList.length ,
                        itemBuilder: (context, index) {
                          return controller.tradingBalanceList[index].itemGroup=="سکه"?
                          BalanceItemWidget(
                            title: controller.tradingBalanceList[index].dateName??"",
                            balanceList: controller.tradingBalanceList[index].balances??[],
                            titleBase: controller.tradingBalanceList[index].itemGroup??"", isDesktop: isDesktop,
                          ):SizedBox();
                        },
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),

                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 7,backgroundColor: AppColor.buttonColor,
                          ),
                          SizedBox(width: 10,),
                          Text(
                            "ارز",
                            style: AppTextStyle.labelText.copyWith(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width:  Get.width ,
                      height: isDesktop ? Get.height * 0.36 : Get.height *0.5 ,
                      margin: EdgeInsets.symmetric(horizontal: 0,vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(3)),
                        border: Border.all(color: AppColor.circularLoadingColor,width: 0.5),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: ListView.builder(
                        scrollDirection:isDesktop? Axis.horizontal:Axis.vertical,
                        controller: controller.scrollController,
                        itemCount: controller.tradingBalanceList.length ,
                        itemBuilder: (context, index) {
                          return controller.tradingBalanceList[index].itemGroup=="ارز"?
                          BalanceItemWidget(
                            title: controller.tradingBalanceList[index].dateName??"",
                            balanceList: controller.tradingBalanceList[index].balances??[],
                            titleBase: controller.tradingBalanceList[index].itemGroup??"", isDesktop: isDesktop,
                          ):SizedBox();
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),

                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 7,backgroundColor: AppColor.buttonColor,
                          ),
                          SizedBox(width: 10,),
                          Text(
                            "تراز تجمیعی",
                            style: AppTextStyle.labelText.copyWith(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width:  Get.width ,
                      height: isDesktop ? Get.height * 0.36 : Get.height *0.5 ,
                      margin: EdgeInsets.symmetric(horizontal: 0,vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(3)),
                        border: Border.all(color: AppColor.circularLoadingColor,width: 0.5),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: ListView.builder(
                        scrollDirection:isDesktop? Axis.horizontal:Axis.vertical,
                        controller: controller.scrollController,
                        itemCount: controller.tradingBalanceList.length ,
                        itemBuilder: (context, index) {
                          return controller.tradingBalanceList[index].itemGroup==null?
                          BalanceItemWidget(
                            title: controller.tradingBalanceList[index].dateName??"",
                            balanceList: controller.tradingBalanceList[index].balances??[],
                            titleBase: controller.tradingBalanceList[index].itemGroup??"", isDesktop: isDesktop,
                          ):SizedBox();
                        },
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
    ));
  }

}

