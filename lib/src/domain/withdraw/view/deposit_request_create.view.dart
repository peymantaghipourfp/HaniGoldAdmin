

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

class InsertDepositRequestWidget extends StatefulWidget {
  final int id;
  final int? walletId;
  final double? unDividedAmount;

  const InsertDepositRequestWidget({
    super.key,
    required this.id,
    this.walletId,
    this.unDividedAmount,
  });

  @override
  State<InsertDepositRequestWidget> createState() => _InsertDepositRequestWidgetState();
}

class _InsertDepositRequestWidgetState extends State<InsertDepositRequestWidget> {

  final withdrawController = Get.find<WithdrawController>();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return Obx(() {
      return  SizedBox(
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
                        'ایجاد درخواست واریزی',
                        style: AppTextStyle.smallTitleText,
                      ),
                      IconButton(
                        onPressed: () {
                          Get.back();
                          withdrawController.clearList();// برای بستن BottomSheet
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
                        if ((widget.unDividedAmount ?? 0) > 0)
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColor.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppColor.primaryColor.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.edit,
                                  color: AppColor.primaryColor,
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'مبلغ باقیمانده: ${widget.unDividedAmount?.toInt().toString().seRagham(separator: ',')}',
                                    style: AppTextStyle.labelText.copyWith(
                                        color: AppColor.primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
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
                        SizedBox(height: 10),
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
                            controller:
                            withdrawController.requestAmountController,
                            style: AppTextStyle.labelText,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[۰-۹0-9]')),
                            ],
                            onChanged: (value) {
                              // حذف کاماهای قبلی و فرمت جدید
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
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
        
                //const Spacer(),
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
                            await withdrawController.insertDepositRequest(widget.id,widget.walletId!);
                          }
                        }
                      },
                      child: withdrawController.isLoading.value
                          ? CircularProgressIndicator(
                        valueColor:
                        AlwaysStoppedAnimation<Color>(AppColor.textColor),
                      )
                          : Text(
                        'ایجاد درخواست',
                        style: AppTextStyle.bodyText,
                      ),
                    ),
                  ),
                ),
                withdrawController.isLoadingBalance.value==false ?
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
