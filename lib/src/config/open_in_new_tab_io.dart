import 'dart:io';

bool get supportsOpenInNewTab =>
    Platform.isWindows || Platform.isMacOS || Platform.isLinux;

Future<void> openRouteInNewTab(
    String route, {
      String? title,
      int? iconCodePoint,
    }) async {
  if (!supportsOpenInNewTab) return;
  try {
    final args = <String>['--route=$route', '--tear-off'];
    if (title != null && title.isNotEmpty) args.add('--tab-title=$title');
    if (iconCodePoint != null) args.add('--tab-icon=$iconCodePoint');
    await Process.run(Platform.resolvedExecutable, args);
  } catch (e) {
    rethrow;
  }
}
