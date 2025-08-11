import 'package:get/get.dart';

 import '../../../../presentation/messaging/AddConversations/controllers/add_conversations.controller.dart';

class AddConversationsControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddConversationsController>(
      () => AddConversationsController(),
    );
  }
}
