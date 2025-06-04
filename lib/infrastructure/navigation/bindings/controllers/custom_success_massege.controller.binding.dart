import 'package:get/get.dart';

import '../../../../presentation/customSuccessMassege/controllers/custom_success_massege.controller.dart';

class CustomSuccessMassegeControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomSuccessMassegeController>(
      () => CustomSuccessMassegeController(),
    );
  }
}
