import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../widget/custom_dropdown.widget.dart';
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
                      SizedBox(height: 12),

                      // Dropdown انتخاب کاربر
                      Container(
                        padding: EdgeInsets.only(bottom: 5),
                        child: CustomDropdownWidget(
                          dropdownSearchData: DropdownSearchData<String>(
                            searchController: withdrawController.searchController,
                            searchInnerWidgetHeight: 50,
                            searchInnerWidget: Container(
                              height: 50,
                              padding: const EdgeInsets.only(
                                top: 8,
                                right: 15,
                                left: 15,
                              ),
                              child: TextFormField(
                                style: AppTextStyle.bodyText,
                                controller: withdrawController.searchController,
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding:
                                  const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 8,
                                  ),
                                  hintText: 'جستجوی کاربر...',
                                  hintStyle: AppTextStyle.labelText,
                                  border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          value: withdrawController.selectedAccount.value,
                          validator: (value) {
                            if (value == 'انتخاب کنید' || value == null || value.isEmpty) {
                              return 'کاربر را انتخاب کنید';
                            }
                            return null;
                          },
                          showSearchBox: true,
                          items: [
                            'انتخاب کنید',
                            ...withdrawController.searchedAccounts.map((account) => account.name ?? "")
                          ].toList(),
                          selectedValue: withdrawController.selectedAccount.value?.name,
                          onChanged: (String? newValue){
                            if (newValue == 'انتخاب کنید') {
                              withdrawController.changeSelectedAccount(null);
                            } else {
                              var selectedAccount = withdrawController.searchedAccounts
                                  .firstWhere((account) => account.name == newValue);
                              withdrawController.changeSelectedAccount(selectedAccount);
                            }
                          },
                          onMenuStateChange: (isOpen) {
                            if (!isOpen) {
                              withdrawController.resetAccountSearch();
                            }
                          },
                          backgroundColor: AppColor.textFieldColor,
                          borderRadius: 7,
                          borderColor: AppColor.secondaryColor,
                          hideUnderline: true,
                        ),
                      ),
                      SizedBox(height: 15),

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
                        height: 50,
                        padding: EdgeInsets.only(bottom: 5),
                        child: TextFormField(
                          controller: withdrawController.requestAmountController,
                          style: AppTextStyle.labelText,
                          keyboardType: TextInputType.number,
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

                        await withdrawController.updateDepositRequest(
                          widget.withdrawId,
                          widget.depositRequest.id!,
                        );
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