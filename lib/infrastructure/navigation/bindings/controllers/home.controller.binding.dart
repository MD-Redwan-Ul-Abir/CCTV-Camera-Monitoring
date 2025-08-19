import 'package:get/get.dart';
import 'package:skt_sikring/presentation/messaging/common/socket_controller.dart';

import '../../../../presentation/home/controllers/home.controller.dart';

class HomeControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.lazyPut<SocketController>(
      () => SocketController(),
    );
  }
}
