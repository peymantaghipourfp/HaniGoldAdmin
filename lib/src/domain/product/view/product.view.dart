import 'package:flutter/material.dart';
import '../../../widget/custom_appbar.widget.dart';

class ProductView extends StatelessWidget {
  const ProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'محصولات'),
    );
  }
}
