import 'package:flutter/material.dart';

class BackgroundImageTotal extends StatelessWidget {
  final String imagePath;
  final EdgeInsetsGeometry padding;
  final double opacity;
  final BoxFit fit;

  const BackgroundImageTotal({
    this.imagePath = 'assets/images/bgHaniGold.png',
    this.padding = const EdgeInsets.all(30),
    this.opacity = 0.02,
    this.fit = BoxFit.fill,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: fit,
            opacity: opacity,
          ),
        ),
      ),
    );
  }
}