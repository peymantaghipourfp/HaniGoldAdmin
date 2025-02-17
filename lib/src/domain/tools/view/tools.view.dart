import 'package:flutter/material.dart';
import '../../../widget/custom_appbar.widget.dart';

class ToolsView extends StatelessWidget {
  const ToolsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'تنظیمات'),
    );
  }
}
