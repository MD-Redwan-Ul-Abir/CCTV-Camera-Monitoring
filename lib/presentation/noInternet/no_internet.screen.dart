import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:gif/gif.dart';
import 'package:skt_sikring/infrastructure/theme/app_colors.dart';
import 'package:skt_sikring/infrastructure/theme/text_styles.dart';
import '../languageChanging/appString.dart';

import '../../infrastructure/navigation/routes.dart';
import '../../infrastructure/utils/app_images.dart';
import '../shared/widgets/buttons/primary_buttons.dart';
import 'controllers/no_internet.controller.dart';

class NoInternetScreen extends GetView<NoInternetController> {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NoInternetController noInternet =
    Get.find<NoInternetController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
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
                image: AssetImage(AppImages.noInternet),
                controller: noInternet.gifController,
                autostart: Autostart.once,
                onFetchCompleted: () {
                  noInternet.gifController.reset();
                  noInternet.gifController.forward();
                },
              ),
              SizedBox(
                height: 10.h,
              ),

              Text(AppStrings.internetNotAvailableMessage.tr,
                style: AppTextStyles.headLine4.copyWith(
                    color: AppColors.primaryNormal),),
              Spacer(),
              PrimaryButton(
                width: double.infinity,
                onPressed: () async {
                  // Use the updated tryAgain method
                  await noInternet.tryAgain();
                },
                text: AppStrings.tryAgainButton.tr,
              ),

              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }
}