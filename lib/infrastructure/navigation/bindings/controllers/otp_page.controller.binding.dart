import 'package:get/get.dart';

import '../../../../presentation/otpPage/controllers/otp_page.controller.dart';

class OtpPageControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OtpPageController>(
      () => OtpPageController(),
    );
  }
}
