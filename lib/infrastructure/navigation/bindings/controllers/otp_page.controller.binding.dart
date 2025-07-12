import 'package:get/get.dart';

import '../../../../presentation/auth/otpPage/controllers/otp_page.controller.dart';
import '../../../../presentation/auth/resetPassword/controllers/reset_password.controller.dart';

class OtpPageControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OtpPageController>(
      () => OtpPageController(),
    );
    Get.lazyPut<ResetPasswordController>(
      () => ResetPasswordController(),
    );
  }
}
