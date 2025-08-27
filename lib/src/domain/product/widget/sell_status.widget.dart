import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/product/controller/product.controller.dart';
import 'package:hanigold_admin/src/domain/product/model/item.model.dart';

import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';

class SellStatusWidget extends StatefulWidget {
  final ItemModel item;

  const SellStatusWidget({
    super.key,
    required this.item,
  });

  @override
  State<SellStatusWidget> createState() => SellStatusWidgetState();
}

class SellStatusWidgetState extends State<SellStatusWidget> {
  ProductController productController = Get.find<ProductController>();
  bool isLoading = false;
  bool isSubmitting = false;
  late bool currentSellStatus;

  @override
  void initState() {
    super.initState();
    currentSellStatus = widget.item.sellStatus ?? false;
  }

  Future<void> updateSellStatus(bool newStatus) async {
    if (isSubmitting || isLoading) return;

    isSubmitting = true;
    setState(() => isLoading = true);

    try {
      await productController.updateStatusItem(
        widget.item.id ?? 0,
        widget.item.status ?? false,
        newStatus,
        widget.item.buyStatus ?? false,
      );

      // Update local state
      setState(() {
        currentSellStatus = newStatus;
      });

    } catch (e) {
      // Revert to previous state on error
      setState(() {
        currentSellStatus = widget.item.sellStatus ?? false;
      });
      Get.snackbar(
        'خطا',
        'خطا در بروزرسانی وضعیت فروش',
        titleText: Text(
          'خطا',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColor.textColor),
        ),
        messageText: Text(
          'خطا در بروزرسانی وضعیت فروش',
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
              value: currentSellStatus,
              onChanged: updateSellStatus,
              activeColor: AppColor.buttonColor,
            ),
        ],
      ),
    );
  }
}