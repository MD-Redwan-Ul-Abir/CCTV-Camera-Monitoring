import 'package:get/get.dart';

import '../../../../presentation/splashLanguage/controllers/splash_language.controller.dart';

class SplashLanguageControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashLanguageController>(
      () => SplashLanguageController(),
    );
  }
}
