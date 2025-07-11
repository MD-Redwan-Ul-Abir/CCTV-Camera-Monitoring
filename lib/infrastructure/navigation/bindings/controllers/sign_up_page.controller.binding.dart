import 'package:get/get.dart';

import '../../../../presentation/auth/signUpPage/controllers/sign_up_page.controller.dart';

class SignUpPageControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignUpPageController>(
      () => SignUpPageController(),
    );
  }
}
