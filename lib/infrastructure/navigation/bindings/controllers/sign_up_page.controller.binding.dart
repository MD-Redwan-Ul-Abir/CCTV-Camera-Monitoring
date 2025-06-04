import 'package:get/get.dart';

import '../../../../presentation/signUpPage/controllers/sign_up_page.controller.dart';

class SignUpPageControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignUpPageController>(
      () => SignUpPageController(),
    );
  }
}
