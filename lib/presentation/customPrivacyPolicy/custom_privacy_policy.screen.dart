import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../infrastructure/theme/app_colors.dart';
import '../../infrastructure/theme/text_styles.dart';
import '../../infrastructure/utils/app_images.dart';
import 'controllers/custom_privacy_policy.controller.dart';

class CustomPrivacyPolicyScreen extends GetView<CustomPrivacyPolicyController> {
  const CustomPrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get arguments passed from route
    final Map<String, dynamic> arguments = Get.arguments ?? {};
    final String title = arguments['title'] ?? 'Privacy Setting';
    //final String bodyText = arguments['bodyText'] ?? 'No content available';
    final Widget? customWidget = arguments['customWidget'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.secondaryDark,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 80.h,
        title: Text(
          title,
          style: AppTextStyles.paragraph3.copyWith(
            fontWeight: FontWeight.w400,
            height: 1.5,
            color: AppColors.primaryLight,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: SvgPicture.asset(
                AppImages.backIcon,
                color: AppColors.primaryLight,
                  height: 24.h,
                  width: 24.w
              ),
              onPressed: () {
                Get.back();
              },
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
        child: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(

            child: Align(alignment: Alignment.topCenter,child: customWidget!),
          ),
        ),
      ),
    );
  }
}