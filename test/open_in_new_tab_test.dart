import 'package:flutter_test/flutter_test.dart';
import 'package:hanigold_admin/src/config/open_in_new_tab.dart';

void main() {
  group('open_in_new_tab', () {
    test('openRouteInNewTab with valid route does not throw', () async {
      await expectLater(
        openRouteInNewTab('/orderList'),
        completes,
      );
    });
    test('supportsOpenInNewTab is boolean', () {
      expect(supportsOpenInNewTab, isA<bool>());
    });
  });
}
