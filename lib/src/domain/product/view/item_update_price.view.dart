import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widget/custom_appbar.widget.dart';

class ProductUpdatePriceView extends StatelessWidget {
  const ProductUpdatePriceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'بروزرسانی قیمت محصولات',onBackTap: ()=>Get.back(),),
    );
  }
}
