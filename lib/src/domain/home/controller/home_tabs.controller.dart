import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/tear_off_context.dart';

/// Simple model representing one internal tab.
class HomeTab {
  HomeTab({
    required this.id,
    required this.route,
    required this.title,
    this.icon,
  });

  final String id; // stable id for DnD + persistence
  final String route;
  final String title;
  final IconData? icon;

  HomeTab copyWith({
    String? id,
    String? route,
    String? title,
    IconData? icon,
  }) {
    return HomeTab(
      id: id ?? this.id,
      route: route ?? this.route,
      title: title ?? this.title,
      icon: icon ?? this.icon,
    );
  }
}

/// Controller managing internal "browser-like" tabs for the desktop layout.
class HomeTabsController extends GetxController {

  final RxList<HomeTab> tabs = <HomeTab>[].obs;
  final RxnString activeTabId = RxnString();

  /// Convenience getter for the currently active tab.
  HomeTab? get activeTab =>
      tabs.firstWhereOrNull((t) => t.id == activeTabId.value);

  @override
  void onInit() {
    super.onInit();
    _applyTearOffContext();
  }

  /// If this process was launched as a tear-off window, add only that tab.
  void _applyTearOffContext() {
    final route = tearOffRoute;
    if (route == null) return;

    final savedTitle = tearOffTitle;

    tearOffRoute = null;
    tearOffTitle = null;
    tearOffIconCodePoint = null;

    final title = savedTitle != null && savedTitle.isNotEmpty
        ? savedTitle
        : _routeToDefaultTitle(route);
    const IconData? icon = null;

    final id = DateTime.now().microsecondsSinceEpoch.toString();
    final tab = HomeTab(id: id, route: route, title: title, icon: icon);
    tabs.add(tab);
    activeTabId.value = id;
    _navigateTo(route);
  }

  String _routeToDefaultTitle(String route) {
    final base = route.replaceFirst('/', '').replaceAll('/', ' ');
    if (base.isEmpty) return 'Home';
    return base[0].toUpperCase() + base.substring(1);
  }

  /// Open (or focus) a tab for the given route.
  void openTab({
    required String route,
    required String title,
    IconData? icon,
  }) {
    // If a tab with the same route already exists, just focus it.
    final existing =
    tabs.firstWhereOrNull((t) => t.route == route && t.title == title);
    if (existing != null) {
      activeTabId.value = existing.id;
      _navigateTo(existing.route);
      return;
    }

    final id = DateTime.now().microsecondsSinceEpoch.toString();
    final tab = HomeTab(id: id, route: route, title: title, icon: icon);
    tabs.add(tab);
    activeTabId.value = id;
    WidgetsBinding.instance.addPostFrameCallback((_) => _navigateTo(tab.route));
  }

  /// Close a tab by id. Returns the new active tab (if any).
  HomeTab? closeTab(String id) {
    final index = tabs.indexWhere((t) => t.id == id);
    if (index == -1) return activeTab;

    tabs.removeAt(index);

    HomeTab? newActive;
    if (tabs.isEmpty) {
      activeTabId.value = null;
    } else {
      // Prefer previous tab, otherwise first.
      final newIndex = index > 0 ? index - 1 : 0;
      newActive = tabs[newIndex];
      activeTabId.value = newActive.id;
    }

    if (newActive != null) {
      _navigateTo(newActive.route);
    } else {
      // If no tabs remain, go back to home dashboard.
      if (Get.currentRoute != '/home') {
        Get.offNamed('/home');
      }
    }

    return newActive;
  }

  /// Reorder tabs after a drag & drop.
  void reorderTabs(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    if (oldIndex < 0 ||
        oldIndex >= tabs.length ||
        newIndex < 0 ||
        newIndex >= tabs.length) {
      return;
    }
    final item = tabs.removeAt(oldIndex);
    tabs.insert(newIndex, item);
  }

  /// Explicitly activate a tab.
  void activateTab(String id) {
    final tab = tabs.firstWhereOrNull((t) => t.id == id);
    if (tab == null) return;

    activeTabId.value = id;
    _navigateTo(tab.route);
  }

  void _navigateTo(String route) {
    if (Get.currentRoute != route) {
      Get.offNamed(route);
    }
  }
}

