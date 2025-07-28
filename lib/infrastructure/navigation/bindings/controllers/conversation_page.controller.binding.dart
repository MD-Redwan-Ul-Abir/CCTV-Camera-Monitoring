import 'package:get/get.dart';

import '../../../../presentation/messaging/conversationPage/controllers/conversation_page.controller.dart';

class ConversationPageControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ConversationPageController>(
      () => ConversationPageController(),
    );
  }
}
