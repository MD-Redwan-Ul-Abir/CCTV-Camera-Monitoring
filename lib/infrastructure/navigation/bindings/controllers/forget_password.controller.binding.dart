import 'package:get/get.dart';

import '../../../../presentation/forgetPassword/controllers/forget_password.controller.dart';

class ForgetPasswordControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForgetPasswordController>(
      () => ForgetPasswordController(),
    );
  }
}
