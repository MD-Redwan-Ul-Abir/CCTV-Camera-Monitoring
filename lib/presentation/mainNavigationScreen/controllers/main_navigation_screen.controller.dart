import 'package:get/get.dart';
import 'package:skt_sikring/infrastructure/utils/log_helper.dart';
import '../../messaging/common/socket_controller.dart';

class MainNavigationScreenController extends GetxController {
  var currentIndex = 0.obs;
  late SocketController socketController;

  @override
  void onInit() {
    super.onInit();
    
    // Initialize socket controller and connect
    socketController = Get.put(SocketController(), permanent: true);
    _initializeSocket();
  }

  void changeIndex(int index) {
    currentIndex.value = index;
  }

  Future<void> _initializeSocket() async {
    try {
      LoggerHelper.info('Initializing socket in main navigation');
      
      // Initialize user data first
      await socketController.initializeUserData();
      
      // Connect socket if user data is available
      if (socketController.token.value.isNotEmpty && socketController.userId.value.isNotEmpty) {
        await socketController.connectSocket();
        LoggerHelper.info('Socket connected successfully in main navigation');
      } else {
        LoggerHelper.warn('User data not available, socket not connected');
      }
    } catch (e) {
      LoggerHelper.error('Error initializing socket in main navigation: $e');
    }
  }

  // Method to reconnect socket if needed
  Future<void> reconnectSocket() async {
    if (!socketController.isSocketConnected.value) {
      await _initializeSocket();
    }
  }

  @override
  void onClose() {
    // Don't disconnect socket here - it should persist across navigation
    // Socket will be disconnected only on logout
    super.onClose();
  }
}
