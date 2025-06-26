import 'package:get/get.dart';

import '../../../../presentation/customPrivacyPolicy/controllers/custom_privacy_policy.controller.dart';

class CustomPrivacyPolicyControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomPrivacyPolicyController>(
      () => CustomPrivacyPolicyController(),
    );
  }
}
