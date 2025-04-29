

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../controller/inventory_create_payment.controller.dart';
import '../model/inventory_detail.model.dart';
import 'package:get/get.dart';

class ItemTempDetailWidget extends StatefulWidget {
  final InventoryDetailModel detail;
  final double quantity;
  final Function(double)? onQuantityChanged;
  const ItemTempDetailWidget({
    super.key,
    required this.detail,
    required this.quantity,
    this.onQuantityChanged,
  });

  @override
  State<ItemTempDetailWidget> createState() => _ItemTempDetailWidgetState();
}

class _ItemTempDetailWidgetState extends State<ItemTempDetailWidget> {
  TextEditingController quantityController = TextEditingController();
  InventoryCreatePaymentController inventoryCreatePaymentController=Get.find<InventoryCreatePaymentController>();

  @override
  void initState() {
    quantityController.text = widget.quantity.toString();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Card(color: AppColor.backGroundColor,
      child: ConstrainedBox(
          constraints: BoxConstraints(
              minHeight: 60,minWidth: 100
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.detail.item?.name ?? '',
                  style: AppTextStyle.bodyText,),
                SizedBox(height: 4,),
                Text('مقدار: ${widget.detail.quantity}',
                  style: AppTextStyle.bodyText,),
                SizedBox(height: 4,),
                Text('وزن750: ${widget.detail.weight750}',
                  style: AppTextStyle.bodyText,),
                SizedBox(height: 4,),
                // مقدار
                widget.detail.itemUnit?.id !=2 ?
                Container(
                  //height: 50,
                  padding: EdgeInsets.only(bottom: 5),
                  child:
                  IntrinsicHeight(
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: quantityController,
                      style: AppTextStyle.labelText,
                      keyboardType: TextInputType.numberWithOptions(
                          decimal: true),
                      inputFormatters: [FilteringTextInputFormatter.allow(
                          RegExp(r'^[\d٠-٩۰-۹]*\.?[\d٠-٩۰-۹]*$')),
                        TextInputFormatter.withFunction((oldValue, newValue) {
                          // تبدیل اعداد فارسی به انگلیسی برای پردازش راحت‌تر
                          String newText = newValue.text
                              .replaceAll('٠', '0')
                              .replaceAll('١', '1')
                              .replaceAll('٢', '2')
                              .replaceAll('٣', '3')
                              .replaceAll('٤', '4')
                              .replaceAll('٥', '5')
                              .replaceAll('٦', '6')
                              .replaceAll('٧', '7')
                              .replaceAll('٨', '8')
                              .replaceAll('٩', '9');

                          return newValue.copyWith(text: newText,
                              selection: TextSelection.collapsed(
                                  offset: newText.length));
                        }),
                      ],
                      decoration: InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: AppColor.textFieldColor,
                        errorMaxLines: 1,
                      ),
                      onChanged: (value) {
                        final newQuantity = double.tryParse(value) ?? 0.0;
                        widget.onQuantityChanged?.call(newQuantity);
                      },
                    ),
                  ),
                ) : SizedBox.shrink(),
              ],
            ),
          )
      ),
    );
  }
}