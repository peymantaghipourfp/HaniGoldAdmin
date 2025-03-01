import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widget/custom_appbar.widget.dart';

class WithdrawCreate extends StatelessWidget {
  const WithdrawCreate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'ایجاد درخواست برداشت',
      onBackTap: ()=>Get.back(),
      ),
    );
  }
}
