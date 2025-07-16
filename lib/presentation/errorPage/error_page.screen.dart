import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:gif/gif.dart';
import 'package:skt_sikring/presentation/home/controllers/home.controller.dart';
import 'package:skt_sikring/presentation/mainNavigationScreen/controllers/main_navigation_screen.controller.dart';

import '../../infrastructure/navigation/routes.dart';
import '../../infrastructure/theme/app_colors.dart';
import '../../infrastructure/utils/app_images.dart';
import '../shared/widgets/buttons/primary_buttons.dart';
import 'controllers/error_page.controller.dart';

class ErrorPageScreen extends GetView<ErrorPageController> {
  const ErrorPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ErrorPageController errorPageController =
        Get.find<ErrorPageController>();
   

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 24.w,vertical: 20.h),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Spacer(),
              Gif(
                //color: AppColors.primaryLight,
               // colorBlendMode: BlendMode.srcATop,
                height: 300.h,
                width: 400.w,
                image: AssetImage(AppImages.error400Gif),
                controller: errorPageController.gifController,
                autostart: Autostart.loop,
                onFetchCompleted: () {
                  errorPageController.gifController.reset();
                  errorPageController.gifController.forward();
                },
              ),
             Spacer(),
              PrimaryButton(
                width: double.infinity,
                onPressed: () {
                  //Get.toNamed(Routes.CREATE_REPORT);
                 Get.offAllNamed(Routes.LOG_IN);
                },
                text: 'Please log in again',
              ),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }
}
