import 'package:flutter/material.dart';

class BackgroundImage extends StatelessWidget {
  final String imagePath;
  final EdgeInsetsGeometry padding;
  final double opacity;
  final BoxFit fit;

  const BackgroundImage({
    this.imagePath = 'assets/images/bgHaniGold.png',
    this.padding = const EdgeInsets.all(30),
    this.opacity = 0.06,
    this.fit = BoxFit.contain,
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