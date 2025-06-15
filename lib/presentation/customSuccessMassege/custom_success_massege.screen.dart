import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../../infrastructure/navigation/routes.dart';
import '../../infrastructure/theme/text_styles.dart';
import '../../infrastructure/utils/app_images.dart';
import '../shared/widgets/buttons/primary_buttons.dart';
import 'controllers/custom_success_massege.controller.dart';

class CustomSuccessMassegeScreen
    extends GetView<CustomSuccessMassegeController> {
  const CustomSuccessMassegeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 24.w,vertical: 24.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "password Successful",
              style: AppTextStyles.headLine5,
            ),
            SizedBox(height: 10.h),
            Text(
              "Your password already changed",
              style: AppTextStyles.textCaption1,
            ),
            SizedBox(height: 30.h),
            Center(
              child: SvgPicture.asset(
                AppImages.successfullyDone,
                height: 95.h,
                width: 145.w,

              ),
            ),
            SizedBox(height: 40.h),
            PrimaryButton(
              width: double.infinity,
              onPressed: () {
                Get.offAllNamed(Routes.HOME);
              },
              text: "Done",
            ),
          ],
        ),
      ),
    );
  }
}
