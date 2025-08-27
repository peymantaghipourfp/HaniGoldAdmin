import 'package:flutter/material.dart';
import 'package:hanigold_admin/src/widget/side_menu_fix.widget.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../config/const/app_color.dart';
import 'side_menu.widget.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;
  final bool showSidebar;

  const MainLayout({
    super.key,
    required this.child,
    this.appBar,
    this.showSidebar = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;

    // For mobile devices, show sidebar as drawer
    if (isMobile) {
      return Scaffold(
        appBar: appBar,
        drawer: showSidebar ? _buildDrawer() : null,
        body: child,
      );
    }

    // For desktop devices, show fixed sidebar on the right
    return Scaffold(
      appBar: appBar,
      body: showSidebar
          ? Row(
        children: [
          // Fixed Sidebar on the right
          const SideMenuFix(),
          // Main Content Area
          Expanded(
            child: child,
          ),

        ],
      )
          : child,
    );
  }

  Widget _buildDrawer() {
    return Container(
      width: 300,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Drawer(
        backgroundColor: AppColor.secondaryColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: const SideMenuFix(),
      ),
    );
  }
}
