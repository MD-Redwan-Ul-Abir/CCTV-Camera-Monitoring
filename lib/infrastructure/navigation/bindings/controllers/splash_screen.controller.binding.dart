import 'package:get/get.dart';

import '../../../../presentation/home/controllers/home.controller.dart';
import '../../../../presentation/splashScreen/controllers/splash_screen.controller.dart';
import '../../../utils/api_client.dart';

class SplashScreenControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashScreenController>(
      () => SplashScreenController(),
    );
    // Get.lazyPut<HomeController>(
    //   () => HomeController(),
    // );
    Get.lazyPut<ApiClient>(
      () => ApiClient(),
    );
  }
}
