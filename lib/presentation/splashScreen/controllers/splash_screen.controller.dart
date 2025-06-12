import 'package:get/get.dart';

import '../../../infrastructure/navigation/routes.dart';

class SplashScreenController extends GetxController {
  //TODO: Implement SplashScreenController

  final count = 0.obs;

  void startSplashTimer() {
    Future.delayed(Duration(seconds: 3), () {
      // Navigate to next page, replace '/next' with your route
      Get.offNamed(Routes.SPLASH_LANGUAGE);
    });
  }



  void increment() => count.value++;
}
