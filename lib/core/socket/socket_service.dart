import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService extends GetxService {
  late IO.Socket socket;

  static SocketService get to => Get.find();

  @override
  void onInit() {
    super.onInit();
    _initSocket();
  }

  void _initSocket() {
    socket = IO.io('YOUR_SOCKET_SERVER_URL', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket.connect();
  }

  @override
  void onClose() {
    socket.dispose();
    super.onClose();
  }
}
