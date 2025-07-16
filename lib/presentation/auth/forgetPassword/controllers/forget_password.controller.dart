import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skt_sikring/infrastructure/theme/text_styles.dart';

import '../../../../infrastructure/navigation/routes.dart';
import '../../../../infrastructure/theme/app_colors.dart';
import '../../../../infrastructure/utils/api_client.dart';
import '../../../../infrastructure/utils/api_content.dart';
import '../../otpPage/controllers/otp_page.controller.dart';
import '../model/forgetPasswordModel.dart';

class ForgetPasswordController extends GetxController {
  final ApiClient _apiClient = Get.find<ApiClient>();
  Rxn<ForgetPassword> loginResponse = Rxn<ForgetPassword>();
  final OtpPageController otpPageController = Get.find<OtpPageController>();

  final forgetEmailController = TextEditingController();
  final isLoading = false.obs;
  final emailError = ''.obs;
  var message;

  Future<bool> sendOTP() async {
    isLoading.value = true;
    update();

    try {
      final Map<String, String> sendOtpToThisEmail = {
        'email': forgetEmailController.text.trim(),
      };

      final response = await _apiClient.postData(
        ApiConstants.forgetPassUrl,
        sendOtpToThisEmail,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        loginResponse.value = ForgetPassword.fromJson(response.body);
        message = loginResponse.value!.message;
        ///----------------------send credential to otp page--------------
        otpPageController.otpEmail= forgetEmailController.text.trim();
        otpPageController.otpToken =
            loginResponse.value?.data?.attributes?.resetPasswordToken;
        print("_________otp token_________");
        print(otpPageController.otpToken);
        print( otpPageController.otpEmail);
        Get.snackbar(
          "",
          "",
          titleText: Text(
            "Check Email",
            style: AppTextStyles.paragraph2.copyWith(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryLighthover,
            ),
          ),
          messageText: Text(
            message!,
            style: AppTextStyles.button.copyWith(
              color: AppColors.primaryLighthover,
            ),
          ),
          backgroundColor: AppColors.primaryNormal,
        );
        //  Get.snackbar("Check Email", message!,backgroundColor: AppColors.primaryNormal,colorText: AppColors.primaryLighthover);

        Get.toNamed(Routes.OTP_PAGE);
        return true; // Success
      } else {
        try {
          final errorResponse = ForgetPassword.fromRawJson(response.body);
          Get.snackbar(
            "Failed to send OTP",
            errorResponse.message ?? "Unknown error",
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
              "Failed to send OTP. Please try again.",
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
}
