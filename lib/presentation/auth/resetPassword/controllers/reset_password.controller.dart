import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../infrastructure/navigation/routes.dart';
import '../../../../infrastructure/theme/app_colors.dart';
import '../../../../infrastructure/theme/text_styles.dart';
import '../../../../infrastructure/utils/api_client.dart';
import '../../../../infrastructure/utils/api_content.dart';
import '../../forgetPassword/model/forgetPasswordModel.dart';

class ResetPasswordController extends GetxController {
  final ApiClient _apiClient = Get.find<ApiClient>();
  final isLoading = false.obs;
  final emailError = ''.obs;
  var message;

  var otp;
  var otpEmail;

  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  RxBool isButtonActive = false.obs;

  void validatePasswords() {
    final newPassword = newPasswordController.text;
    final confirmPassword = confirmPasswordController.text;

    isButtonActive.value =
        newPassword.length >= 8 &&
        confirmPassword.length >= 8 &&
        newPassword == confirmPassword;
  }

  Future<bool> resetPassword() async {
    isLoading.value = true;
    update();

    try {
      final Map<String, String> verifyOtp = {
        'email': otpEmail,
        'otp': otp,
        'password': confirmPasswordController.text,
      };
      print("---------------reset value--------------");
      print(otpEmail);
      print(otp);
      print(confirmPasswordController.text);

      final response = await _apiClient.postData(
        ApiConstants.resetPassUrl,
        verifyOtp,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        isLoading.value = false;
        update();

        Get.snackbar(
          "",
          "",
          titleText: Text(
            "Reset Password success",
            style: AppTextStyles.paragraph2.copyWith(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryLighthover,
            ),
          ),
          messageText: Text(
            "Your new password is ready",
            style: AppTextStyles.button.copyWith(
              color: AppColors.primaryLighthover,
            ),
          ),
          backgroundColor: AppColors.primaryNormal,
        );
        //  Get.snackbar("Check Email", message!,backgroundColor: AppColors.primaryNormal,colorText: AppColors.primaryLighthover);

        Get.offAllNamed(Routes.CUSTOM_SUCCESS_MASSEGE);
        return true; // Success
      } else {
        try {
          isLoading.value = false;
          update();
          // final errorResponse = response.body.;
          Get.snackbar(
            response.statusCode as String,
            "Unable to reset password",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        } catch (e) {
          Get.snackbar(
            "",
            "",
            backgroundColor: AppColors.primaryLight,
            snackPosition: SnackPosition.TOP,
            //borderRadius: 8.r,
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            titleText: Text(
              "Oops!",
              style: AppTextStyles.paragraph2.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.redDark,
              ),
            ),
            messageText: Text(
              "Failed to reset password. Please try again.",
              style: AppTextStyles.button.copyWith(
                fontSize: 14.sp,
                color: AppColors.redDark,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            duration: Duration(seconds: 2),
            isDismissible: true,
            //forwardAnimationCurve: Curves.easeOutBack,
          );
          isLoading.value = false;
          update();
        }
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: ${e.toString()}");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
