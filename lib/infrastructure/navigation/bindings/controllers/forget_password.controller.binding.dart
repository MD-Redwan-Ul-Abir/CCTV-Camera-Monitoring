import 'package:get/get.dart';

import '../../../../presentation/auth/forgetPassword/controllers/forget_password.controller.dart';
import '../../../../presentation/auth/otpPage/controllers/otp_page.controller.dart';
import '../../../../presentation/auth/resetPassword/controllers/reset_password.controller.dart';

class ForgetPasswordControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForgetPasswordController>(
      () => ForgetPasswordController(),
    );
    Get.lazyPut<OtpPageController>(
      () => OtpPageController(),
    );
    Get.lazyPut<ResetPasswordController>(
          () => ResetPasswordController(),
    );
  }
}
