import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widget/custom_appbar.widget.dart';

class DepositsList extends StatelessWidget {
  const DepositsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'واریزی ها',
        onBackTap: ()=>Get.back(),
      ),
    );
  }
}
