import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/product/controller/product.controller.dart';
import 'package:hanigold_admin/src/domain/product/model/item.model.dart';

import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';

class BuyStatusWidget extends StatefulWidget {
  final ItemModel item;

  const BuyStatusWidget({
    super.key,
    required this.item,
  });

  @override
  State<BuyStatusWidget> createState() => BuyStatusWidgetState();
}

class BuyStatusWidgetState extends State<BuyStatusWidget> {
  ProductController productController = Get.find<ProductController>();
  bool isLoading = false;
  bool isSubmitting = false;
  late bool currentBuyStatus;

  @override
  void initState() {
    super.initState();
    currentBuyStatus = widget.item.buyStatus ?? false;
  }

  Future<void> updateBuyStatus(bool newStatus) async {
    if (isSubmitting || isLoading) return;

    isSubmitting = true;
    setState(() => isLoading = true);

    try {
      await productController.updateStatusItem(
        widget.item.id ?? 0,
        widget.item.status ?? false,
        widget.item.sellStatus ?? false,
        newStatus,
      );

      // Update local state
      setState(() {
        currentBuyStatus = newStatus;
      });

    } catch (e) {
      // Revert to previous state on error
      setState(() {
        currentBuyStatus = widget.item.buyStatus ?? false;
      });
      Get.snackbar(
        'خطا',
        'خطا در بروزرسانی وضعیت خرید',
        titleText: Text(
          'خطا',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColor.textColor),
        ),
        messageText: Text(
          'خطا در بروزرسانی وضعیت خرید',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColor.textColor),
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
      isSubmitting = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (isLoading)
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor),
              ),
            )
          else
            Switch(
              value: currentBuyStatus,
              onChanged: updateBuyStatus,
              activeColor: AppColor.buttonColor,
            ),
        ],
      ),
    );
  }
}