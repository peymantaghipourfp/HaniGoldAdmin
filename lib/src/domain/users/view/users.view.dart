import 'package:flutter/material.dart';
import '../../../widget/custom_appbar.widget.dart';

class UsersView extends StatelessWidget {
  const UsersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'کاربران'),
    );
  }
}
