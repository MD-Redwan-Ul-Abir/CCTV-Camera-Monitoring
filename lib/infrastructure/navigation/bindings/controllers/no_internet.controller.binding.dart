import 'package:get/get.dart';

import '../../../../presentation/noInternet/controllers/no_internet.controller.dart';

class NoInternetControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NoInternetController>(
      () => NoInternetController(),
    );
  }
}
