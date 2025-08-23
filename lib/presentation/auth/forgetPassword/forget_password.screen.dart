 import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import '../../languageChanging/appString.dart';

import '../../../infrastructure/navigation/routes.dart';
import '../../../infrastructure/theme/app_colors.dart';
import '../../../infrastructure/theme/text_styles.dart';
import '../../../infrastructure/utils/app_images.dart';
import '../../shared/widgets/buttons/primary_buttons.dart';
import '../../shared/widgets/custom_text_form_field.dart';
import 'controllers/forget_password.controller.dart';

class ForgetPasswordScreen extends GetView<ForgetPasswordController> {
  const ForgetPasswordScreen({super.key});
  @override
  Widget build(BuildContext context) {

    final ForgetPasswordController forgetPasswordController = Get.find<ForgetPasswordController>();
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.secondaryDark,
        leading: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: IconButton(
              icon: SvgPicture.asset(
                AppImages.backIcon,
                color: AppColors.primaryLight,
                  height: 24.h,
                  width: 24.w
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
      body: SafeArea(
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 24.w),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.forgetEmailTitle.tr,
                    style: AppTextStyles.headLine6.copyWith(color: Color(0xFFFFFFFF)),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    AppStrings.forgetEmailSubtitle.tr,
                    style: AppTextStyles.button,
                  ),


                  SizedBox(height: 50.h),
                  CustomTextFormField(
                    validator: (value) => (value?.trim().isEmpty ?? true) ? AppStrings.enterEmailAddressValidation.tr : null,
                    controller: forgetPasswordController.forgetEmailController,
                    hintText: AppStrings.emailHint.tr,
                    keyboardType: 'email',
                    prefixSvg: AppImages.emailIcon,
                  ),
                  SizedBox(height: 18.h),

                  GetBuilder<ForgetPasswordController>(
                    builder: (controller) {
                      if (controller.isLoading.value) {
                        return Center(child: CircularProgressIndicator(color: AppColors.primaryLight,));
                      }
                      return PrimaryButton(
                        width: double.infinity,
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                           forgetPasswordController.sendOTP();
                            //  var x =logInController.getStoredUserData();
                            //  print("------------------------------------------------------------------");
                            // print(x);
                          }

                        },
                        text: AppStrings.sendOtpButton.tr,
                      );
                    },
                  ),

                  // PrimaryButton(
                  //   width: double.infinity,
                  //   onPressed: () {
                  //     Get.toNamed(Routes.OTP_PAGE);
                  //   },
                  //   text: "Send OTP",
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
