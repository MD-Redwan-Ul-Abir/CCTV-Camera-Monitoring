import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skt_sikring/infrastructure/utils/app_images.dart';

import '../../infrastructure/theme/app_colors.dart';
import 'controllers/splash_screen.controller.dart';

class SplashScreenScreen extends GetView<SplashScreenController> {
  const SplashScreenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Start timer to navigate after 3 seconds
    controller.startSplashTimer();

    return Scaffold(
      backgroundColor: AppColors.secondaryDark,
      body: Center(
        child: Image.asset(AppImages.appLogo,
        height: 92.h,
          width: 233.w,
        ),
      ),
    );
  }
}
