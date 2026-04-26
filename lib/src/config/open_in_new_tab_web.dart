import 'package:universal_html/html.dart' as html;

bool get supportsOpenInNewTab => true;

Future<void> openRouteInNewTab(
    String route, {
      String? title,
      int? iconCodePoint,
    }) async {
  try {
    final currentUrl = html.window.location.href;
    final baseUrl = currentUrl.split('/#/')[0];
    final newUrl = '$baseUrl/#$route';
    html.window.open(newUrl, '_blank');
  } catch (e) {
    rethrow;
  }
}
