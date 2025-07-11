import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ResetPasswordController extends GetxController {
  //TODO: Implement ResetPasswordController

  final count = 0.obs;


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

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }



  void increment() => count.value++;
}
