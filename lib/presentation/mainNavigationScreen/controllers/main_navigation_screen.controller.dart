import 'package:get/get.dart';
import 'package:skt_sikring/infrastructure/utils/log_helper.dart';
import '../../messaging/common/socket_controller.dart';

class MainNavigationScreenController extends GetxController {
  var currentIndex = 0.obs;
  late SocketController socketController;

  @override
  Future<void> onInit() async {
    super.onInit();
    socketController = Get.put(SocketController(), permanent: false);
   await socketController.initializeUserData();

  }

  void changeIndex(int index) {
    currentIndex.value = index;
  }



  // // Method to reconnect socket if needed
  // Future<void> reconnectSocket() async {
  //   if (!socketController.isSocketConnected.value) {
  //     await _initializeSocket();
  //   }
  // }

  @override
  void onClose() {
    socketController.disconnectSocket();
    socketController.dispose();

    // Don't disconnect socket here - it should persist across navigation
    // Socket will be disconnected only on logout
    super.onClose();
  }
}
