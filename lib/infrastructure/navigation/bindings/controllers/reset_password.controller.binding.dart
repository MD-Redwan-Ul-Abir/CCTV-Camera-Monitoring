import 'package:get/get.dart';

import '../../../../presentation/resetPassword/controllers/reset_password.controller.dart';

class ResetPasswordControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ResetPasswordController>(
      () => ResetPasswordController(),
    );
  }
}
