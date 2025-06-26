import 'package:get/get.dart';

import '../../../../presentation/mainNavigationScreen/controllers/main_navigation_screen.controller.dart';

class MainNavigationScreenControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainNavigationScreenController>(
      () => MainNavigationScreenController(),
    );
  }
}
