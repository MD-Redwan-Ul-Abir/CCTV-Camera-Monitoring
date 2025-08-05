import 'package:get/get.dart';
import 'package:skt_sikring/presentation/messaging/common/socket_controller.dart';

class CommonController extends GetxController {
  RxString senderId = ''.obs;
  RxString conversationId = ''.obs;
  RxString userName = ''.obs;
  RxString profileImage = ''.obs;
  RxString token = ''.obs;

  // Get socket controller instance
  SocketController get socketController => Get.find<SocketController>();

  @override
  void onInit() {
    super.onInit();
    // Initialize socket controller if not already initialized
    if (!Get.isRegistered<SocketController>()) {
      Get.put(SocketController(), permanent: true);
    }
  }
}