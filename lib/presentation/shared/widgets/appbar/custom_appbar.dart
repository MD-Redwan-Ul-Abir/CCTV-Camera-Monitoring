import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../infrastructure/theme/text_styles.dart';
import '../../../../infrastructure/utils/app_images.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final bool centerTitle;
  final Color backgroundColor;
  final Color iconColor;
  // final TextStyle titleStyle;
  final Widget? customLeading; // Add custom leading support

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.onBackPressed,
    this.actions,
    this.centerTitle = false,
    this.backgroundColor = Colors.white,
    this.iconColor = Colors.black,
    // this.titleStyle = const TextStyle(
    //   fontSize: 24,
    //   fontWeight: FontWeight.bold,
    // ),
    this.customLeading, // Optional custom leading
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: centerTitle,
      backgroundColor: backgroundColor,
      leading: customLeading ??
          (showBackButton
              ? IconButton(
            icon: SvgPicture.asset(
              AppImages.backIcon,
              height: 24.h,
              width: 24.w,
            ),
            onPressed: () => Get.back(),
          )
              : null),
      title: Text(title, style: AppTextStyles.headLine6),
      actions: actions,
      elevation: 0, // Add elevation to match original
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}