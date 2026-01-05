import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

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
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode(); // تغییر: مقداردهی در initState
  }

  @override
  void dispose() {
    _focusNode.dispose(); // اضافه شده: dispose کردن FocusNode
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // On mobile web, avoid global listeners/transforms that can interfere with input focus
    final bool isMobileWeb = kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS) &&
        MediaQuery.of(context).size.width < 900;

    if (isMobileWeb) {
      return widget.child;
    }
    return KeyboardListener(
      //focusNode: FocusNode(),
      //autofocus: true,
      focusNode: _focusNode,
      autofocus: false,
      onKeyEvent: (event) {
        /*if (event is KeyDownEvent) {
          // کلید فشرده شده
          print('Key down: ${event.logicalKey}');
        } else if (event is KeyUpEvent) {
          // کلید رها شده
          print('Key up: ${event.logicalKey}');
        }*/
      },
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