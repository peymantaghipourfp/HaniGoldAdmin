import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../widget/custom_dropdown.widget.dart';
import '../../../widget/custom_dropdown1.widget.dart';
import '../../account/model/account.model.dart';
import '../../users/widgets/balance.widget.dart';
import '../controller/withdraw.controller.dart';
import '../model/deposit_request.model.dart';

class UpdateDepositRequestWidget extends StatefulWidget {
  final int withdrawId;
  final DepositRequestModel depositRequest;

  const UpdateDepositRequestWidget({
    super.key,
    required this.withdrawId,
    required this.depositRequest,
  });

  @override
  State<UpdateDepositRequestWidget> createState() => _UpdateDepositRequestWidgetState();
}
class _UpdateDepositRequestWidgetState extends State<UpdateDepositRequestWidget> {
  final withdrawController = Get.find<WithdrawController>();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {

    return Obx(() {
      return SizedBox(
        width: 400,
        height: Get.height,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(right: 15, top: 5, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ویرایش درخواست واریزی',
                      style: AppTextStyle.smallTitleText,
                    ),
                    IconButton(
                      onPressed: () {
                        Get.back();
                        withdrawController.clearList();
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
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // کاربر
                      Container(
                        padding: EdgeInsets.only(top: 15),
                        child: Text(
                          'کاربر',
                          style: AppTextStyle.labelText,
                        ),
                      ),
                      SizedBox(height: 10),
                      // Dropdown انتخاب کاربر
                      withdrawController.accountList.isEmpty ?
                      Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              AppColor.textColor),
                        ),
                      ) :
                      Container(
                        padding: EdgeInsets.only(
                            bottom: 5),
                        child: CustomDropdown<AccountModel>(
                          items: withdrawController.accountList,
                          selectedItem: withdrawController.selectedAccount.value,
                          enableSearch: true,
                          errorText: withdrawController.dropdownError.value,
                          itemLabel: (account) =>
                          account.name ??
                              "",
                          /*itemIcon: (bank) =>
                      bank.icon ??
                          "",*/
                          onChanged: (account) {
                            setState(() {
                              withdrawController.selectedAccount.value = account;
                              withdrawController.dropdownError.value = "";

                              withdrawController.changeSelectedAccount(
                                  account);
                            });
                            debugPrint(
                              "کاربر انتخاب شد: ${account?.name}",
                            );
                          },
                          isIcon: false,
                        ),
                      ),

                      // فیلد مبلغ
                      Container(
                        padding: EdgeInsets.only(bottom: 3, top: 5),
                        child: Text(
                          'مبلغ (ریال)',
                          style: AppTextStyle.labelText,
                        ),
                      ),
                      SizedBox(height: 12),
                      Container(
                        //height: 50,
                        padding: EdgeInsets.only(bottom: 5),
                        child: TextFormField(
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty) {
                              return 'لطفا مبلغ را وارد کنید';
                            }
                            return null;
                          },
                          controller: withdrawController.requestAmountController,
                          style: AppTextStyle.labelText,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[۰-۹0-9]')),
                          ],
                          onChanged: (value) {
                            String cleanedValue = value.replaceAll(',', '');
                            if (cleanedValue.isNotEmpty) {
                              withdrawController.requestAmountController.text =
                                  cleanedValue
                                      .toPersianDigit()
                                      .seRagham();
                              withdrawController.requestAmountController
                                  .selection = TextSelection.collapsed(
                                offset: withdrawController
                                    .requestAmountController
                                    .text
                                    .length,
                              );
                            }
                          },
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

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
                child: Center(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      fixedSize: WidgetStatePropertyAll(
                        Size(Get.width * .77, 40),
                      ),
                      padding: WidgetStatePropertyAll(
                        EdgeInsets.symmetric(horizontal: 7),
                      ),
                      elevation: WidgetStatePropertyAll(5),
                      backgroundColor:
                      WidgetStatePropertyAll(AppColor.buttonColor),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    onPressed: () async {

                        if(formKey.currentState!.validate()){
                          if(withdrawController.selectedAccount.value!=null){
                            await withdrawController.updateDepositRequest(
                              widget.withdrawId,
                              widget.depositRequest,
                            );
                          }
                        }
                    },
                    child: withdrawController.isLoading.value
                        ? CircularProgressIndicator(
                      valueColor:
                      AlwaysStoppedAnimation<Color>(AppColor.textColor),
                    )
                        : Text(
                      'ویرایش درخواست',
                      style: AppTextStyle.bodyText,
                    ),
                  ),
                ),
              ),
              withdrawController.balanceList.isEmpty ?
              Center(child: CircularProgressIndicator(),)
                  :
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                child: BalanceWidget(
                  listBalance: withdrawController.balanceList,
                  size: 400,),
              ),
            ],
          ),
        ),
      );
    });
  }
}