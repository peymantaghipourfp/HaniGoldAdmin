import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/product/controller/product.controller.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../widget/custom_appbar.widget.dart';

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
            height: Get.height*0.5,
            child: Card(
              color: AppColor.backGroundColor,
              elevation: 5,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Obx(() {
                  return Form(
                    key: formKey,
                      child: Column(
                        children: [
                          // محصول
                          Container(
                            padding: EdgeInsets.only(bottom: 3, top: 5),
                            child: Text(
                              'محصول',
                              style: AppTextStyle.bodyText,
                            ),
                          ),
                          SizedBox(height: 5,),
                          // محصول
                          Container(
                            padding: EdgeInsets.only(bottom: 5),
                            child: DropdownButtonFormField2(
                              validator: (value) {
                                if (value == null) {
                                  return 'محصول را انتخاب کنید';
                                }
                                return null;
                              },
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                                // افزایش padding عمودی
                                border: InputBorder.none,
                              ),
                              isExpanded: true,
                              hint: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "انتخاب کنید",
                                      style: AppTextStyle.labelText.copyWith(
                                        fontSize: 14,
                                        color: AppColor.textColor,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              items: productController.itemList.map((item) {
                                return DropdownMenuItem(
                                    value: item,
                                    child: Text(item.name ?? "",
                                      style: AppTextStyle.bodyText,));
                              }).toList(),
                              value: productController.selectedItem.value,
                              onChanged: (newValue) {
                                if (newValue != null) {
                                  productController.changeSelectedItem(newValue);
                                }
                              },
                              buttonStyleData: ButtonStyleData(height: 43,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  color: AppColor.textFieldColor,
                                  border: Border.all(
                                      color: AppColor.backGroundColor, width: 1),
                                ),
                                elevation: 0,
                              ),
                              iconStyleData: IconStyleData(
                                icon: const Icon(Icons.keyboard_arrow_down),
                                iconSize: 23,
                                iconEnabledColor: AppColor.textColor,
                                iconDisabledColor: Colors.grey,
                              ),
                              dropdownStyleData: DropdownStyleData(
                                maxHeight: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  color: AppColor.textFieldColor,
                                ),
                                offset: const Offset(0, 0),
                                scrollbarTheme: ScrollbarThemeData(
                                  radius: const Radius.circular(7),
                                  thickness: WidgetStateProperty.all(6),
                                  thumbVisibility: WidgetStateProperty.all(true),
                                ),
                              ),
                              menuItemStyleData: const MenuItemStyleData(
                                height: 40,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                              ),
                            ),
                          ),
                          SizedBox(height: 8,),
                          // قیمت
                          Container(
                            padding: EdgeInsets.only(bottom: 3, top: 5),
                            child: Text(
                              'قیمت (ریال)',
                              style: AppTextStyle.bodyText,
                            ),
                          ),
                          SizedBox(height: 5,),
                          // قیمت
                          SizedBox(height: 70,
                            child: Container(
                              padding: EdgeInsets.only(bottom: 5),
                              child:
                              IntrinsicHeight(
                                child: TextFormField(
                                  validator: (value){
                                    if(value==null || value.isEmpty){
                                      return 'لطفا قیمت محصول را وارد کنید';
                                    }
                                    return null;
                                  },
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  controller: productController.priceController,
                                  style: AppTextStyle.labelText,
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    // حذف کاماهای قبلی و فرمت جدید
                                    String cleanedValue = value.replaceAll(',', '');
                                    if (cleanedValue.isNotEmpty) {
                                      productController.priceController.text =
                                          cleanedValue.toPersianDigit().seRagham();
                                      productController.priceController.selection =
                                          TextSelection.collapsed(
                                              offset: productController
                                                  .priceController.text.length);
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
                            ),
                          ),
                          SizedBox(height: 8,),
                          // تفاوت قیمت
                          Container(
                            padding: EdgeInsets.only(bottom: 3, top: 5),
                            child: Text(
                              'تفاوت قیمت (ریال)',
                              style: AppTextStyle.bodyText,
                            ),
                          ),
                          SizedBox(height: 5,),
                          // تفاوت قیمت
                          SizedBox(height: 70,
                            child: Container(
                              height: 50,
                              padding: EdgeInsets.only(bottom: 5),
                              child:
                              IntrinsicHeight(
                                child: TextFormField(
                                  validator: (value){
                                    if(value==null || value.isEmpty){
                                      return 'لطفا تفاوت قیمت را وارد کنید';
                                    }
                                    return null;
                                  },
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  controller: productController.differentPriceController,
                                  style: AppTextStyle.labelText,
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    // حذف کاماهای قبلی و فرمت جدید
                                    String cleanedValue = value.replaceAll(',', '');
                                    if (cleanedValue.isNotEmpty) {
                                      productController.differentPriceController.text =
                                          cleanedValue.toPersianDigit().seRagham();
                                      productController.differentPriceController.selection =
                                          TextSelection.collapsed(
                                              offset: productController
                                                  .differentPriceController.text.length);
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
                            ),
                          ),
                          SizedBox(height: 8,),
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
                      )
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
