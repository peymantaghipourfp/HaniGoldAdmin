import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/users/model/balance_item.model.dart';
import 'package:hanigold_admin/src/utils/num_display.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../controller/user_info_detail_transaction.controller.dart';

class BalanceUserWidget extends StatefulWidget {
  final List<BalanceItemModel> listBalance;
  final double size;
  final String? title;
  const BalanceUserWidget({super.key, required this.listBalance, required this.size, this.title});

  @override
  State<BalanceUserWidget> createState() => _BalanceUserWidgetState();
}

class _BalanceUserWidgetState extends State<BalanceUserWidget> {
  final UserInfoDetailTransactionController controller = Get.find<UserInfoDetailTransactionController>();
  int? selectedItemId;

  bool isSelectableItem(int? itemId) {
    return itemId == 10 || itemId == 12 || itemId == 13 ||
        itemId == 14 || itemId == 15 || itemId == 16;
  }

  @override
  Widget build(BuildContext context) {
    //final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    return Container(
      width: widget.size,
      //height: controller.isOpenMore.value?300:200,
      constraints: BoxConstraints(
        // maxHeight: controller.isOpenMore.value?300:120,
      ),
      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColor.secondaryColor
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    ' تراز کاربر ',
                    style: AppTextStyle.labelText.copyWith(fontSize: 14,
                      fontWeight: FontWeight.bold, ),
                  ),
                  Text(
                    widget.title??"",
                    style: AppTextStyle.labelText.copyWith(fontSize: 13,color: AppColor.secondary3Color,
                      fontWeight: FontWeight.normal, ),
                  ),
                ],
              ),
              // Button to execute getChangeOneWallet when an item is selected
              if (selectedItemId != null)
                ElevatedButton(
                  onPressed: () {
                    if (selectedItemId != null) {
                      controller.getChangeOneWallet(controller.id.value, selectedItemId!);
                      // Clear selection after execution
                      setState(() {
                        selectedItemId = null;
                      });
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(AppColor.primaryColor),
                    padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 12, vertical: 6)),
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    )),
                  ),
                  child: Text(
                    'تغییر ولت',
                    style: AppTextStyle.labelText.copyWith(
                      fontSize: 11,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const Divider(height: 10.0,color: Colors.white,thickness: 0.5,),
          SizedBox(height: 5,),
          Column(
            children:
            widget.listBalance.map((e)=>
                GestureDetector(
                  onTap: () {
                    // Only allow selection for specific item IDs
                    if (isSelectableItem(e.item?.id)) {
                      setState(() {
                        selectedItemId = selectedItemId == e.item?.id ? null : e.item?.id;
                      });
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: isSelectableItem(e.item?.id)
                          ? (selectedItemId == e.item?.id
                          ? AppColor.primaryColor.withAlpha(20)
                          : AppColor.textColor.withAlpha(20))
                          : Colors.transparent,
                      border: isSelectableItem(e.item?.id) && selectedItemId == e.item?.id
                          ? Border.all(color: AppColor.primaryColor, width: 2)
                          : null,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            // Selection indicator for selectable items
                            if (isSelectableItem(e.item?.id))
                              Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: selectedItemId == e.item?.id
                                      ? AppColor.primaryColor
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: AppColor.primaryColor,
                                    width: 2,
                                  ),
                                ),
                                child: selectedItemId == e.item?.id
                                    ? Icon(
                                  Icons.check,
                                  size: 10,
                                  color: Colors.white,
                                )
                                    : null,
                              )
                            else
                              CircleAvatar(
                                radius: 5,
                                backgroundColor: AppColor.textColor,
                              ),
                            SizedBox(width: 5,),
                            Text(
                              e.item?.name??"",
                              style: AppTextStyle.labelText.copyWith(
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                                color: isSelectableItem(e.item?.id)
                                    ? (selectedItemId == e.item?.id
                                    ? AppColor.primaryColor
                                    : AppColor.iconViewColor)
                                    : AppColor.iconViewColor,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            e.item?.itemUnit?.name=="ریال" ?
                            Text(
                              (e.balance ?? 0.0) < 0 ?
                              "-${e.balance?.abs().toStringAsFixed(0).seRagham()??0.0}":
                        "${e.balance?.toStringAsFixed(0).seRagham()??0.0}",
                              style: AppTextStyle.labelText.copyWith(fontSize: 14,
                                  //fontWeight: FontWeight.normal,color:e.balance!>0?AppColor.primaryColor: AppColor.accentColor ),textDirection: TextDirection.ltr,
                                  fontWeight: FontWeight.bold,color:(e.balance ?? 0.0) > 0?AppColor.primaryColor:(e.balance ?? 0.0) < 0 ? AppColor.accentColor : AppColor.textColor ),textDirection: TextDirection.ltr,
                            ):
                            Text(
                            (e.balance ?? 0.0) < 0 ?
                              "-${e.balance?.abs().toDisplayString().seRagham()??0.0}":
                              "${e.balance?.toDisplayString().seRagham()??0.0}",
                              style: AppTextStyle.labelText.copyWith(fontSize: 14,
                                  //fontWeight: FontWeight.normal,color:e.balance!>0?AppColor.primaryColor: AppColor.accentColor ),textDirection: TextDirection.ltr,
                                  fontWeight: FontWeight.bold,color:(e.balance ?? 0.0) > 0?AppColor.primaryColor: (e.balance ?? 0.0) < 0 ? AppColor.accentColor : AppColor.textColor ),textDirection: TextDirection.ltr,
                            ),

                            SizedBox(width: 8,),
                            Text(
                              e.item?.itemUnit?.name??"",
                              style: AppTextStyle.labelText.copyWith(fontSize: 10,
                                  fontWeight: FontWeight.normal,color: AppColor.textColor ),textDirection: TextDirection.ltr,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )).toList(),
          ),
          widget.listBalance.isNotEmpty ?
          const Divider(height: 10.0,color: Colors.white,thickness: 0.5,) :SizedBox.shrink(),
          widget.listBalance.isNotEmpty ?
          Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 5,
                          backgroundColor: AppColor.dividerColor,
                        ),
                        SizedBox(width: 5,),
                        Text(
                          "مانده طلایی",
                          style: AppTextStyle.labelText.copyWith(fontSize: 13,
                              fontWeight: FontWeight.normal,color: AppColor.dividerColor ),
                        ),
                      ],
                    ),
                    SizedBox(width: 10,),
                    Row(
                      children: [
                        widget.listBalance.where((balance) => balance.item?.itemUnit?.name == 'گرم')
                            .fold(0.0, (sum, balance) => sum + (balance.balance ?? 0))<0 ?
                        Text("-${widget.listBalance.where((balance) => balance.item?.itemUnit?.name == 'گرم').fold(0.0, (sum, balance) => sum + (balance.balance ?? 0)).abs().toStringAsFixed(3).seRagham()}",
                          style: AppTextStyle.labelText.copyWith(fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: AppColor.accentColor ),
                          textDirection: TextDirection.ltr,):
                        widget.listBalance.where((balance) => balance.item?.itemUnit?.name == 'گرم')
                            .fold(0.0, (sum, balance) => sum + (balance.balance ?? 0))>0 ?
                        Text(widget.listBalance.where((balance) => balance.item?.itemUnit?.name == 'گرم')
                            .fold(0.0, (sum, balance) => sum + (balance.balance ?? 0)).toStringAsFixed(3).seRagham(),
                          style: AppTextStyle.labelText.copyWith(fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color:AppColor.primaryColor ),
                          textDirection: TextDirection.ltr,):
                        Text(widget.listBalance.where((balance) => balance.item?.itemUnit?.name == 'گرم')
                            .fold(0.0, (sum, balance) => sum + (balance.balance ?? 0)).toStringAsFixed(3),
                          style: AppTextStyle.labelText.copyWith(fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color:AppColor.textColor ),
                          textDirection: TextDirection.ltr,),
                        SizedBox(width: 8,),
                        Text(
                          "گرم",
                          style: AppTextStyle.labelText.copyWith(fontSize: 10,
                              fontWeight: FontWeight.normal,color: AppColor.textColor ),textDirection: TextDirection.ltr,
                        ),
                      ],
                    ),
                  ],
                )
              ]
          ) :SizedBox.shrink(),
        ],
      ),
    );
  }
}
