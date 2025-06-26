import 'package:flutter/material.dart';

import 'custom_nav_bar.dart';
import 'nav_bar_model.dart';

class AppScaffoldWithNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onNavItemTap;
  final List<CustomNavItem> navItems;
  final Widget body;
  final String? title;
  final List<Widget>? actions;
  final Color? navBarColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;

  const AppScaffoldWithNav({
    super.key,
    required this.currentIndex,
    required this.onNavItemTap,
    required this.navItems,
    required this.body,
    this.title,
    this.actions,
    this.navBarColor = Colors.black,
    this.selectedItemColor = Colors.green,
    this.unselectedItemColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          title != null
              ? AppBar(
                title: Text(title!),
                actions: actions,
                backgroundColor: navBarColor,
                foregroundColor: Colors.white,
              )
              : null,
      body: body,
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: currentIndex,
        onTap: onNavItemTap,
        items: navItems,
        //backgroundColor:  AppColors.secondaryDark,
        selectedItemColor: selectedItemColor,
        unselectedItemColor: unselectedItemColor,
        cornerRadius: 16.0,
      ),
    );
  }
}
