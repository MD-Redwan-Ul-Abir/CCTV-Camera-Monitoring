import 'package:get/get.dart';

import '../../../infrastructure/navigation/routes.dart';

class SplashScreenController extends GetxController {
  //TODO: Implement SplashScreenController

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  void startSplashTimer() {
    Future.delayed(Duration(seconds: 3), () {
      // Navigate to next page, replace '/next' with your route
      Get.offNamed(Routes.SPLASH_LANGUAGE);
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
