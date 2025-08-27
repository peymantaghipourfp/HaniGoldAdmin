import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ZoomWrapper extends StatefulWidget {
  final Widget child;

  const ZoomWrapper({
    super.key,
    required this.child,
  });

  @override
  State<ZoomWrapper> createState() => _ZoomWrapperState();
}

class _ZoomWrapperState extends State<ZoomWrapper> {
  double _scale = 1.0;
  final double _minScale = 0.5;
  final double _maxScale = 2.0;

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (event) {},
      child: Listener(
        onPointerSignal: (pointerSignal) {
          final isCtrlPressed = HardwareKeyboard.instance.isControlPressed;
          if (isCtrlPressed && pointerSignal is PointerScrollEvent) {
            final scrollDelta = pointerSignal.scrollDelta.dy;
            setState(() {
              if (scrollDelta < 0) {
                _scale *= 1.05;
              } else {
                _scale *= 0.95;
              }
              _scale = _scale.clamp(_minScale, _maxScale);
            });
          }
        },
        child: Transform.scale(
          scale: _scale,
          child: widget.child,
        ),
      ),
    );
  }
}