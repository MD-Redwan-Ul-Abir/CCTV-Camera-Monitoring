import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:skt_sikring/infrastructure/utils/app_images.dart';

import '../../infrastructure/theme/app_colors.dart';
import '../home/home.screen.dart';

import '../messaging/message/message_screen.screen.dart';
import '../profile/profile.screen.dart';
import '../reportScreen/report_screen.screen.dart';
import '../shared/widgets/bottomNav/custom_nav_bar.dart';
import '../shared/widgets/bottomNav/nav_bar_model.dart';
import 'controllers/main_navigation_screen.controller.dart';

class MainNavigationScreenScreen extends GetView<MainNavigationScreenController> {
  const MainNavigationScreenScreen({super.key});
  @override
  Widget build(BuildContext context) {

    // Define your navigation items
    final List<CustomNavItem> navItems = [
      CustomNavItem(

        label: 'Home', svgAssetPath: AppImages.home,
      ),
      CustomNavItem(

        label: 'Message', svgAssetPath: AppImages.message,
      ),
      CustomNavItem(

        label: 'Report', svgAssetPath: AppImages.report,
      ),
      CustomNavItem(

        label: 'Profile', svgAssetPath: AppImages.profile2,
      ),
    ];

    // Define your screens corresponding to each nav item
    final List<Widget> screens = [
      const  HomeScreen(),
      const  MessageScreen(),
      const  ReportScreen(),
      const  ProfileScreen(),
    ];



    return Obx(() => Scaffold(
      body: screens[controller.currentIndex.value],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: controller.currentIndex.value,
        onTap: (index) {
          controller.changeIndex(index);
        },
        items: navItems,
        backgroundColor: AppColors.secondaryDark,
        selectedItemColor: AppColors.primaryNormalhover,
        unselectedItemColor: AppColors.grayDarker,
        cornerRadius: 0.0,
        elevation: 8.0,
        height: 90.h,
      ),
    ));
  }
}
