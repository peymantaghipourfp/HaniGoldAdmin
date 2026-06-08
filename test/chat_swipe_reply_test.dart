import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hanigold_admin/src/domain/chat/widget/swipe_toReply.widget.dart';

void main() {
  testWidgets('SwipeToReply triggers onSwipe past threshold', (tester) async {
    var swiped = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.dark(useMaterial3: true),
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: SwipeToReply(
              onSwipe: () => swiped = true,
              child: const SizedBox(
                width: 200,
                height: 48,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Colors.blue),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.drag(find.byType(SwipeToReply), const Offset(80, 0));
    await tester.pumpAndSettle();

    expect(swiped, isTrue);
  });

  testWidgets('SwipeToReply does not fire when disabled', (tester) async {
    var swiped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: SwipeToReply(
          enabled: false,
          onSwipe: () => swiped = true,
          child: const SizedBox(width: 200, height: 48),
        ),
      ),
    );

    await tester.drag(find.byType(SwipeToReply), const Offset(80, 0));
    await tester.pumpAndSettle();

    expect(swiped, isFalse);
  });
}
