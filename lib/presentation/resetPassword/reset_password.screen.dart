import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../../infrastructure/navigation/routes.dart';
import '../../infrastructure/theme/app_colors.dart';
import '../../infrastructure/theme/text_styles.dart';
import '../../infrastructure/utils/app_images.dart';
import '../shared/widgets/buttons/primary_buttons.dart';
import '../shared/widgets/custom_text_form_field.dart';
import 'controllers/reset_password.controller.dart';

class ResetPasswordScreen extends GetView<ResetPasswordController> {
  const ResetPasswordScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        backgroundColor: AppColors.secondaryDark,
        leading: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: IconButton(
              icon: SvgPicture.asset(
                AppImages.backIcon,
                color: AppColors.primaryLight,
                height: 30.h,
                width: 30.w,
              ),
              onPressed: () {
                Get.offAllNamed(Routes.LOG_IN);
              },
            ),
          ),
        ),
        centerTitle: true,
        toolbarHeight: 95.h,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 5.h),
            Align(
              alignment: Alignment.topLeft,
              child: Text("Reset password", style: AppTextStyles.headLine6.copyWith(color: Color(0xFFFFFFFF))),
            ),
            SizedBox(height: 12.h),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Enter Your new password as you want",
                style: AppTextStyles.button,
              ),
            ),
            SizedBox(height: 30.h),
            CustomTextFormField(
              hintText: "Enter New password",
              controller: controller.newPasswordController,
              onChanged: (_) => controller.validatePasswords(),

              keyboardType: 'visiblePassword',
              prefixSvg: AppImages.password,
            ),
            SizedBox(height: 11.h),
            CustomTextFormField(
              hintText: "Confirm New password",
              controller: controller.confirmPasswordController,
              onChanged: (_) => controller.validatePasswords(),

              keyboardType: 'visiblePassword',
              prefixSvg: AppImages.password,
            ),
            SizedBox(height: 30.h),
            Obx(
                  () => PrimaryButton(
                isActive: controller.isButtonActive.value,
                width: double.infinity,
                onPressed:
                controller.isButtonActive.value
                    ? () {
                  Get.offAllNamed(Routes.CUSTOM_SUCCESS_MASSEGE );
                }
                    : null,
                text: "Done",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
