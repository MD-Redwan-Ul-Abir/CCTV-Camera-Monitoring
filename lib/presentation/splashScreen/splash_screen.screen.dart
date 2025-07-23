import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skt_sikring/infrastructure/utils/app_images.dart';

import '../../infrastructure/theme/app_colors.dart';
import 'controllers/splash_screen.controller.dart';

class SplashScreenScreen extends StatefulWidget {
  const SplashScreenScreen({super.key});

  @override
  State<SplashScreenScreen> createState() => _SplashScreenScreenState();
}

class _SplashScreenScreenState extends State<SplashScreenScreen> {
  final SplashScreenController splashScreenController = Get.find<SplashScreenController>();
  @override
  void initState() {

    super.initState();
    splashScreenController.checkInitialConnectivity();

    splashScreenController.startSplashTimer();
  }

  Widget build(BuildContext context) {
    // Start timer to navigate after 3 seconds



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
