import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../widget/custom_appbar.widget.dart';
import '../controller/remittance.controller.dart';

class RemittanceView extends GetView<RemittanceController> {
  const RemittanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'لیست حواله', onBackTap: () => Get.back(),),
      body: SafeArea(
        child: SizedBox(
          child: Column(
            children: [
              //فیلد جستجو
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
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
              ),



            ],
          ),
        ),
      ),
    );
  }
}
