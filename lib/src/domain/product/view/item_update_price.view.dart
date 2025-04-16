import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/product/controller/product.controller.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../widget/custom_appbar.widget.dart';
import '../model/item.model.dart';

class ProductUpdatePriceView extends StatelessWidget {
  ProductUpdatePriceView({super.key});
  final formKey = GlobalKey<FormState>();
  ProductController productController = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'بروزرسانی قیمت محصولات', onBackTap: () => Get.back(),),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 50,horizontal: 20),
          child: SizedBox(
            width: Get.width,
            height: Get.height,
            child: Card(
              color: AppColor.secondaryColor,
              elevation: 5,
              child: Padding(
                padding: EdgeInsets.all(20),
                child:
                Obx(() {
                  return  Column(
                          children: [
                            // محصول
                            SizedBox(height: 8,),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                      children: productController.itemList.map((item) =>
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 4),
                                            child: SizedBox(height: 35,width: Get.width,
                                              child: Card(color: AppColor.secondaryColor,
                                                child: Text(textAlign: TextAlign.center,
                                                  "${item.name}",
                                                  style: AppTextStyle.smallTitleText,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ).toList(),

                                    ),
                                ),
                              ),
                            // دکمه تغییر قیمت
                            Spacer(),
                            Row(mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  style: ButtonStyle(fixedSize: WidgetStatePropertyAll(Size(Get.width*.5,40)),
                                      padding: WidgetStatePropertyAll(
                                          EdgeInsets.symmetric(horizontal: 7)),
                                      elevation: WidgetStatePropertyAll(5),
                                      backgroundColor:
                                      WidgetStatePropertyAll(AppColor.primaryColor),
                                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10)))),
                                  onPressed: () async{if(formKey.currentState!.validate()){
                                    await productController.insertPriceItem().then((_){

                                    });
                                  }
                                  productController.clearList();
                                  },
                                  child:productController.isLoading.value
                                      ?
                                  CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor),
                                  ) :
                                  Text(
                                    'تغییر قیمت',
                                    style: AppTextStyle.labelText,
                                  ),
                                )
                              ],
                            )
                          ],
                        );


                }),
              ),
            ),
          ),
        ),
      ),
    );
  }


}
