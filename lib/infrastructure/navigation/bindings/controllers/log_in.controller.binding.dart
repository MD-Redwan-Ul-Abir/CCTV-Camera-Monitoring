import 'package:get/get.dart';

import '../../../../presentation/logIn/controllers/log_in.controller.dart';

class LogInControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LogInController>(
      () => LogInController(),
    );
  }
}
