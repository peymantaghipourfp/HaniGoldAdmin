import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:hanigold_admin/src/domain/withdraw/controller/withdraw.controller.dart';
import '../../../config/const/app_color.dart';
import '../../../widget/custom_appbar.widget.dart';
import '../../../widget/empty.dart';
import '../../../widget/err_page.dart';

class WithdrawsList extends StatelessWidget {
  WithdrawsList({super.key});

  final WithdrawController withdrawController=Get.find<WithdrawController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'لیست درخواست های برداشت',
        onBackTap: ()=>Get.back(),
      ),
      body: SafeArea(
          child: Padding(
              padding: EdgeInsets.all(8),
            child: SizedBox(
              width:Get.width,
              child: Column(
                children: [
                  Obx(() {
                    if (withdrawController.state.value == PageState.loading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (withdrawController.state.value == PageState.empty) {
                      return EmptyPage(
                        title: 'درخواستی وجود ندارد',
                        callback: () {
                          withdrawController.fetchWithdrawList();
                        },
                      );
                    } else if (withdrawController.state.value == PageState.list) {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: withdrawController.withdrawList.length,
                            itemBuilder: (context, index) {
                              var withdraws=withdrawController.withdrawList[index];
                              return
                                InkWell(
                                onTap: (){

                                },
                                child: Card(
                                  margin: EdgeInsets.fromLTRB(8, 5, 8, 10),
                                  color: AppColor.secondaryColor,
                                  elevation: 10,
                                  child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, left: 10, right: 15, bottom: 10),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Row(
                                          children: [
                                            Text(withdraws.bankAccount!.ownerName.toString(),
                                              style: AppTextStyle.bodyText,)
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
}
