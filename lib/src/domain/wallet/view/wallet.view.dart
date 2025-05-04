import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/widget/custom_appbar1.widget.dart';
import '../../../widget/custom_appbar.widget.dart';

class WalletView extends StatelessWidget {
  const WalletView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar1(title: 'کیف پول',
      onBackTap: ()=>Get.back(),
      ),
    );
  }
}
