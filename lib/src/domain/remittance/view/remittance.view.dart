import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../widget/custom_appbar.widget.dart';
import '../controller/remittance.controller.dart';

class RemittanceView extends GetView<RemittanceController> {
   RemittanceView({super.key});


  @override
  Widget build(BuildContext context) {
    return Obx(()=>Scaffold(
      appBar: CustomAppBar(
        title: 'لیست حواله', onBackTap: () => Get.back(),),
      body: SafeArea(
        child:controller.state.value==PageState.loading?
        Center(
          child: CircularProgressIndicator(),
        ):controller.state.value==PageState.list?
        SizedBox(
          child: Column(
            children: [
              //فیلد جستجو
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                height: 41,
                child: TextFormField(
                  controller: controller.searchController,
                  style: AppTextStyle.labelText,
                  textInputAction: TextInputAction.search,
                  onFieldSubmitted: (value) async {
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: AppColor.textFieldColor,
                    hintText: "جستجو ... ",
                    hintStyle: AppTextStyle.labelText,
                    prefixIcon: IconButton(
                        onPressed: () async {
                        },
                        icon: Icon(
                          Icons.search, color: AppColor.textColor,
                          size: 30,)
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(15),
                  color: AppColor.secondaryColor,

                  child: PlutoGrid(
                    rowColorCallback: (rowColorContext) {
                      return AppColor.backGroundColor;
                    },
                    columns:controller.columns,
                    // rows: [
                    //   PlutoRow(
                    //     cells: {
                    //       'register': PlutoCell(value: ""),
                    //       'Reciept': PlutoCell(value:""),
                    //       'Payer': PlutoCell(value: ""),
                    //       'Product': PlutoCell(value: ""),
                    //       'Total': PlutoCell(value: ""),
                    //       'Status': PlutoCell(value: "نامشخص"),
                    //       'Description': PlutoCell(value: ""),
                    //       'DateTime': PlutoCell(value: ""),
                    //       'Action': PlutoCell(value: "گزینه 1"),
                    //       // 'BalanceC': PlutoCell(value: (jsonDecode(e.balancePayer!)as List).map((e)=>e["ItemName"]).toList()),
                    //     },
                    //   ),
                    //   PlutoRow(
                    //     cells: {
                    //       'register': PlutoCell(value: ""),
                    //       'Reciept': PlutoCell(value:""),
                    //       'Payer': PlutoCell(value: ""),
                    //       'Product': PlutoCell(value: ""),
                    //       'Total': PlutoCell(value: ""),
                    //       'Status': PlutoCell(value: "نامشخص"),
                    //       'Description': PlutoCell(value: ""),
                    //       'DateTime': PlutoCell(value: ""),
                    //       'Action': PlutoCell(value: "گزینه 1"),
                    //       // 'BalanceC': PlutoCell(value: (jsonDecode(e.balancePayer!)as List).map((e)=>e["ItemName"]).toList()),
                    //     },
                    //   ),
                    //   PlutoRow(
                    //     cells: {
                    //       'register': PlutoCell(value: ""),
                    //       'Reciept': PlutoCell(value:""),
                    //       'Payer': PlutoCell(value: ""),
                    //       'Product': PlutoCell(value: ""),
                    //       'Total': PlutoCell(value: ""),
                    //       'Status': PlutoCell(value: "نامشخص"),
                    //       'Description': PlutoCell(value: ""),
                    //       'DateTime': PlutoCell(value: ""),
                    //       'Action': PlutoCell(value: "گزینه 1"),
                    //       // 'BalanceC': PlutoCell(value: (jsonDecode(e.balancePayer!)as List).map((e)=>e["ItemName"]).toList()),
                    //     },
                    //   ),
                    // ],

                    rows: controller.remittanceList.map((e)=>
                        PlutoRow(
                          cells: {
                            'register': PlutoCell(value: e.createdBy?.name),
                            'Reciept': PlutoCell(value: e.walletReciept?.account?.name),
                            'Payer': PlutoCell(value: e.walletPayer?.account?.name),
                            'Product': PlutoCell(value: e.item?.name),
                            'Total': PlutoCell(value:e.item?.itemUnit?.id==1? "${e.quantity} عدد ":e.item?.itemUnit?.id==2?"${e.quantity} گرم ":"${e.quantity} ریال "),
                            'Status': PlutoCell(value: e.status==1?"تایید شده":e.status==0?"تایید نشده":"نامشخص"),
                            'Description': PlutoCell(value: e.description??""),
                            'DateTime': PlutoCell(value: e.date),
                            'Action': PlutoCell(value: "گزینه 1"),
                           // 'BalanceC': PlutoCell(value: (jsonDecode(e.balancePayer!)as List).map((e)=>e["ItemName"]).toList()),
                          },
                        ),
                    ).toList(),
                    // columnGroups: columnGroups,
                    onLoaded: (PlutoGridOnLoadedEvent event) {
                      controller.setStateRemittance(event);
                    },
                    onChanged: (PlutoGridOnChangedEvent event) {
                      print(event);
                    },
                    configuration:  PlutoGridConfiguration(
                      style: PlutoGridStyleConfig(gridBackgroundColor: AppColor.appBarColor,
                        columnTextStyle: AppTextStyle.labelText.copyWith(fontSize: 13,
                          fontWeight: FontWeight.bold, ),activatedColor: AppColor.textFieldColor,
                      ),
                    ),




                  ),
                ),
              ),




            ],
          ),
        ):Center(
          child:  Text(
            'خطا در سمت سرور رخ داده',
            style: AppTextStyle.labelText.copyWith(fontSize: 14,
              fontWeight: FontWeight.bold, ),
          ),
        ),
      ),
    ));
  }
}



