import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../infrastructure/navigation/routes.dart';
import '../../../infrastructure/theme/app_colors.dart';
import '../../../infrastructure/theme/text_styles.dart';
import '../../../infrastructure/utils/api_client.dart';
import '../../../infrastructure/utils/api_content.dart';
import '../../../infrastructure/utils/secure_storage_helper.dart';
import '../../shared/widgets/customSnakBar.dart';

class ChangePasswordController extends GetxController {
  final ApiClient _apiClient = Get.find<ApiClient>();
  final isLoading = false.obs;
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  RxBool isButtonActive = false.obs;
  String? token;

  void validatePasswords() {
    final newPassword = newPasswordController.text;
    final confirmPassword = confirmPasswordController.text;

    isButtonActive.value =
        newPassword.length >= 8 &&
            confirmPassword.length >= 8 &&
            newPassword == confirmPassword;
  }


  Future<bool> changePassword() async {
    isLoading.value = true;
    update();

    try {
      token = await SecureStorageHelper.getString("accessToken");
      final Map<String, String> changePassword = {
        'currentPassword': currentPasswordController.text,

        'newPassword': confirmPasswordController.text,
      };
      print("---------------reset value--------------");

      print(confirmPasswordController.text);

      final response = await _apiClient.postData(
        headers: {"Authorization": "Bearer $token"},
        ApiConstants.changPassUrl,
        changePassword,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        isLoading.value = false;

        CustomSnackbar.show(
          title:  "Password Changed",
          message: "Your new password is ready",
          backgroundColor: AppColors.primaryNormal
        );


        return true; // Success
      } else {
        try {
          isLoading.value = false;
          CustomSnackbar.show(
            title: "Failed!",
            message: response.body['message'],
          );
          Get.back();
        } catch (e) {
          isLoading.value = false;
          update();
        }
        return false;
      }
    } catch (e) {
      CustomSnackbar.show(
        title: "Error",
        message: "An error occurred",
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }





  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
