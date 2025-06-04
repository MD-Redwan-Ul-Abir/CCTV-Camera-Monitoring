// // main_screen.dart
//
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import "package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart";
//
// import 'buttomNavController.dart';
//
// class MainScreen extends StatelessWidget {
//   final NavController navController = Get.put(NavController());
//   final PersistentTabController _controller = PersistentTabController(
//     initialIndex: 0,
//   );
//
//   List<Widget> _buildScreens() => [
//     HomeScreen(),
//     BookingScreen(),
//     ProfileScreen(),
//   ];
//
//   List<PersistentBottomNavBarItem> _navBarsItems() => [
//     PersistentBottomNavBarItem(
//       icon: Obx(
//         () => SvgPicture.asset(
//           navController.currentIndex.value == 0
//               ? AppImages.homeActive
//               : AppImages.homeInactive,
//         ),
//       ),
//       title: ("Home"),
//       activeColorPrimary: AppColors.primaryColor,
//       inactiveColorPrimary: AppColors.secondaryColor,
//     ),
//     PersistentBottomNavBarItem(
//       contentPadding: 0,
//       icon: Obx(
//         () => SvgPicture.asset(
//           navController.currentIndex.value == 1
//               ? AppImages.bookingActive
//               : AppImages.bookingInactive,
//         ),
//       ),
//       title: ("Search"),
//       activeColorPrimary: AppColors.primaryColor,
//       inactiveColorPrimary: AppColors.secondaryColor,
//     ),
//     PersistentBottomNavBarItem(
//       icon: Obx(
//         () => SvgPicture.asset(
//           navController.currentIndex.value == 2
//               ? AppImages.personActive
//               : AppImages.personInactive,
//         ),
//       ),
//       title: ("Profile"),
//       textStyle: AppTextStyles.textButton,
//       activeColorPrimary: AppColors.primaryColor,
//       inactiveColorPrimary: AppColors.secondaryColor,
//     ),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return PersistentTabView(
//       backgroundColor: AppColors.backgroundColor,
//       context,
//       navBarHeight: 70,
//       controller: _controller,
//       screens: _buildScreens(),
//       items: _navBarsItems(),
//       navBarStyle: NavBarStyle.style1,
//       onItemSelected: (index) {
//         navController.changeTab(index);
//         _controller.index = index;
//       },
//     );
//   }
// }
