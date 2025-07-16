import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:skt_sikring/presentation/shared/widgets/buttons/primary_buttons.dart';

import '../../infrastructure/theme/app_colors.dart';
import '../../infrastructure/theme/text_styles.dart';
import '../../infrastructure/utils/app_images.dart';
import '../shared/widgets/custom_text_form_field.dart';
import 'controllers/change_password.controller.dart';

class ChangePasswordScreen extends GetView<ChangePasswordController> {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.secondaryDark,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 80.h,
        title: Text(
          "Change password",
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
        padding:  EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,

          children: [
            CustomTextFormField(
              hintText: "Current password",

              keyboardType: 'visiblePassword',
              prefixSvg: AppImages.password,
            ),
            SizedBox(height: 16.h),
            CustomTextFormField(
              hintText: "New Password",

              keyboardType: 'visiblePassword',
              prefixSvg: AppImages.password,
            ),
            SizedBox(height: 16.h),
            CustomTextFormField(
              hintText: "Confirm New Password",

              keyboardType: 'visiblePassword',
              prefixSvg: AppImages.password,
            ),
            SizedBox(height: 25.h),

            PrimaryButton(
              width: double.infinity,
              onPressed: () {},
              text: "Done",
            ),
          ],
        ),
      ),
    );
  }
}
