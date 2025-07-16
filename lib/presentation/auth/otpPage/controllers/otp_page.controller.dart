import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skt_sikring/presentation/auth/resetPassword/controllers/reset_password.controller.dart';
import '../../../../infrastructure/navigation/routes.dart';
import '../../../../infrastructure/theme/app_colors.dart';
import '../../../../infrastructure/theme/text_styles.dart';
import '../../../../infrastructure/utils/api_client.dart';
import '../../../../infrastructure/utils/api_content.dart';
import '../../forgetPassword/model/forgetPasswordModel.dart';
import '../model/otpModel.dart';

class OtpPageController extends GetxController {
  final otpTextEditingController = TextEditingController();
  final ResetPasswordController resetPasswordController = Get.find<ResetPasswordController>();
  final ApiClient _apiClient = Get.find<ApiClient>();
  Rxn<OtpVerifyModel> otpVerify = Rxn<OtpVerifyModel>();

  final isLoading = false.obs;
  final emailError = ''.obs;
  var message;

  var otpToken;
  var otpEmail;

  RxList<int?> pinValues = List<int?>.filled(6, null).obs;
  RxInt currentPinIndex = 0.obs;
  RxBool isPinComplete = false.obs;

  void addDigit(int digit) {
    if (currentPinIndex.value < pinValues.length) {
      pinValues[currentPinIndex.value] = digit;
      currentPinIndex.value++;

      isPinComplete.value = currentPinIndex.value == pinValues.length;
    }
  }

  Future<bool> verifyOtp() async {
    isLoading.value = true;
    update();

    try {
      final Map<String, String> verifyOtp = {
        'email':otpEmail,
        'otp': otpTextEditingController.text.trim(),
        'token': otpToken,
      };

      final response = await _apiClient.postData(
        ApiConstants.verifyEmail,
        verifyOtp,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {

        isLoading.value = false;
        update();
        resetPasswordController.otp= otpTextEditingController.text.trim();
        resetPasswordController.otpEmail= otpEmail;
        Get.snackbar(
          "",
          "",
          titleText: Text(
            "Reset Password",
            style: AppTextStyles.paragraph2.copyWith(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryLighthover,
            ),
          ),
          messageText: Text(
            "Set your new password.",
            style: AppTextStyles.button.copyWith(
              color: AppColors.primaryLighthover,
            ),
          ),
          backgroundColor: AppColors.primaryNormal,
        );
        //  Get.snackbar("Check Email", message!,backgroundColor: AppColors.primaryNormal,colorText: AppColors.primaryLighthover);

        Get.toNamed(Routes.RESET_PASSWORD);
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


  void removeDigit() {
    if (currentPinIndex.value > 0) {
      currentPinIndex.value--;
      pinValues[currentPinIndex.value] = null;
      isPinComplete.value = false;
    }
  }
}
