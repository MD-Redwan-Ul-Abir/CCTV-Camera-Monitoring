import 'package:get/get.dart';

import '../../../../presentation/messaging/message/controllers/message_screen.controller.dart';


class MessageScreenControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MessageScreenController>(
      () => MessageScreenController(),
    );
  }
}
