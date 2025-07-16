import 'package:get/get.dart';
import 'package:skt_sikring/presentation/home/controllers/home.controller.dart';

import '../../../../presentation/errorPage/controllers/error_page.controller.dart';

class ErrorPageControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ErrorPageController>(
      () => ErrorPageController(),
    );

  }
}
