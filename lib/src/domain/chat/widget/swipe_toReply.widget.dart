import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SwipeToReply extends StatefulWidget {
  final Widget child;
  final VoidCallback onSwipe;
  final bool enabled;

  const SwipeToReply({
    Key? key,
    required this.child,
    required this.onSwipe,
    this.enabled = true,
  }) : super(key: key);

  @override
  State<SwipeToReply> createState() => _SwipeToReplyState();
}

class _SwipeToReplyState extends State<SwipeToReply>
    with SingleTickerProviderStateMixin {
  double _dragOffset = 0.0;
  static const double _swipeThreshold = 60.0;
  late AnimationController _animController;
  late Animation<double> _animation;
  bool _hasTriggered = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (!widget.enabled) return;

    setState(() {
      // فقط به سمت راست اجازه کشیدن بده (مقدار مثبت)
      _dragOffset += details.delta.dx;
      _dragOffset = _dragOffset.clamp(0.0, 70.0);
    });

    // وقتی به حد آستانه رسید، ویبره بزن
    if (_dragOffset >= _swipeThreshold && !_hasTriggered) {
      _hasTriggered = true;
      HapticFeedback.lightImpact();
    }
  }

  void _onDragEnd(DragEndDetails details) {
    if (!widget.enabled) return;

    if (_dragOffset >= _swipeThreshold) {
      widget.onSwipe(); // ← Reply را فراخوانی کن
    }

    // انیمیشن برگشت به جای اول
    _animation = Tween<double>(begin: _dragOffset, end: 0.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    )..addListener(() {
      setState(() {
        _dragOffset = _animation.value;
      });
    });

    _animController.forward(from: 0.0);
    _hasTriggered = false;
  }

  @override
  Widget build(BuildContext context) {
    // محاسبه میزان نمایش آیکون reply
    double iconOpacity = (_dragOffset / _swipeThreshold).clamp(0.0, 1.0);
    double iconScale = (_dragOffset / _swipeThreshold).clamp(0.5, 1.0);

    return GestureDetector(
      onHorizontalDragUpdate: _onDragUpdate,
      onHorizontalDragEnd: _onDragEnd,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          // ── آیکون Reply که پشت پیام ظاهر می‌شود ──
          Positioned(
            left: 8,
            child: AnimatedOpacity(
              opacity: iconOpacity,
              duration: const Duration(milliseconds: 50),
              child: Transform.scale(
                scale: iconScale,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: _hasTriggered
                        ? Colors.blue.withOpacity(0.3)
                        : Colors.grey.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.reply,
                    size: 20,
                    color: _hasTriggered ? Colors.blue : Colors.grey,
                  ),
                ),
              ),
            ),
          ),

          // ── خود پیام که جابجا می‌شود ──
          Transform.translate(
            offset: Offset(_dragOffset, 0),
            child: widget.child,
          ),
        ],
      ),
    );
  }
}