import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hanigold_admin/src/domain/chat/theme/chat_theme.dart';

/// Which side of the row the bubble sits on (drives swipe direction and reply cue).
enum SwipeToReplyAlignment {
  /// Bubble on the physical left (incoming): drag right, cue on the left.
  incoming,

  /// Bubble on the physical right (outgoing): drag left, cue on the right.
  outgoing,
}

/// RTL-friendly swipe-to-reply: drag toward the conversation edge to quote.
class SwipeToReply extends StatefulWidget {
  const SwipeToReply({
    super.key,
    required this.child,
    required this.onSwipe,
    this.enabled = true,
    this.alignment = SwipeToReplyAlignment.incoming,
  });

  final Widget child;
  final VoidCallback onSwipe;
  final bool enabled;

  /// Mirrors gesture and reply-icon placement for end-aligned (own) bubbles.
  final SwipeToReplyAlignment alignment;

  @override
  State<SwipeToReply> createState() => _SwipeToReplyState();
}

class _SwipeToReplyState extends State<SwipeToReply>
    with SingleTickerProviderStateMixin {
  double _dragOffset = 0.0;
  static const double _swipeThreshold = 56.0;
  static const double _maxDrag = 72.0;
  late AnimationController _animController;
  late Animation<double> _animation = const AlwaysStoppedAnimation(0);
  bool _hasTriggered = false;

  bool get _isOutgoing =>
      widget.alignment == SwipeToReplyAlignment.outgoing;

  double get _dragMagnitude => _dragOffset.abs();

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
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
      _dragOffset += details.delta.dx;
      _dragOffset = _isOutgoing
          ? _dragOffset.clamp(-_maxDrag, 0.0)
          : _dragOffset.clamp(0.0, _maxDrag);
    });

    if (_dragMagnitude >= _swipeThreshold && !_hasTriggered) {
      _hasTriggered = true;
      HapticFeedback.lightImpact();
    } else if (_dragMagnitude < _swipeThreshold && _hasTriggered) {
      _hasTriggered = false;
    }
  }

  void _onDragEnd(DragEndDetails details) {
    if (!widget.enabled) return;

    if (_dragMagnitude >= _swipeThreshold) {
      widget.onSwipe();
    }

    _animation = Tween<double>(begin: _dragOffset, end: 0.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
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
    final theme = context.chatTheme;
    final progress = (_dragMagnitude / _swipeThreshold).clamp(0.0, 1.0);
    final iconOpacity = progress;
    final iconScale = 0.55 + (progress * 0.45);

    final replyCue = AnimatedOpacity(
      opacity: iconOpacity,
      duration: const Duration(milliseconds: 80),
      child: Transform.scale(
        scale: iconScale,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: _hasTriggered
                ? theme.swipeReplyBackgroundActive
                : theme.swipeReplyBackground,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(40),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(
              Icons.reply_rounded,
              size: 20,
              color: _hasTriggered
                  ? theme.swipeReplyIconActive
                  : theme.swipeReplyIcon,
            ),
          ),
        ),
      ),
    );

    return GestureDetector(
      onHorizontalDragUpdate: _onDragUpdate,
      onHorizontalDragEnd: _onDragEnd,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        clipBehavior: Clip.none,
        alignment:
        _isOutgoing ? Alignment.centerRight : Alignment.centerLeft,
        children: [
          if (_isOutgoing)
            Positioned(right: 10, child: replyCue)
          else
            Positioned(left: 10, child: replyCue),
          Transform.translate(
            offset: Offset(_dragOffset, 0),
            child: widget.child,
          ),
        ],
      ),
    );
  }
}
