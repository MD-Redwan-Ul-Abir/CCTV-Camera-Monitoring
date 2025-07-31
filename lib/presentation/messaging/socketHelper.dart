import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../infrastructure/utils/api_content.dart';
import '../../infrastructure/utils/log_helper.dart';
import '../../infrastructure/utils/secure_storage_helper.dart';


class SocketHelper {
  // SocketHelper._();

  final RxBool isSocketConnected = false.obs;
  final RxString socketStatus = 'disconnected'.obs;
  final RxBool isConnecting = false.obs;
  IO.Socket? _socket;
  RxString receiveAbleId = ''.obs;
  String? myID;

  initSocket() async {
    LoggerHelper.error('''
    Side den vai ami call hocci........
    ''');

    String token = await SecureStorageHelper.getString('accessToken');
    myID = await SecureStorageHelper.getString('id');
    print(myID);

    try {
      Map<String, dynamic> options = {
        'transports': ['websocket'],
        'autoConnect': false,
      };

      // Add token to headers if provided
      if (token.isNotEmpty) {
        options['extraHeaders'] = {'token': token};
      }

      _socket = IO.io(ApiConstants.socketUrl, options);

      _socket?.onConnect((_) {
        LoggerHelper.info('====Connected to server=====');
        isSocketConnected.value = true;
        socketStatus.value = 'connected';
      });

      // Setup listeners before connecting
      if (_socket?.connected != true) {
        isConnecting.value = true;
        _socket?.connect();

      }
      _socket?.on('related-user-online-status::685a211bcb3b476c53324c1b', ((
          data,
          ) {
        LoggerHelper.info(data);
      }));
      _socket?.onDisconnect((_) {
        LoggerHelper.info('====Disconnected from server====');
        isSocketConnected.value = false;
        socketStatus.value = 'disconnected';
        isConnecting.value = false;
      });
    } catch (e) {
      print('Socket connection error: $e');
      isConnecting.value = false;
    }
  }


  void emit(String emitText,Map<String,dynamic> body) {
    var data = body;

    _socket?.emitWithAck(
      emitText,
      data,
      ack: (response) {
        LoggerHelper.warn(response.toString());


        if (response != null  ) {
          return response;
        }
      },
    );
  }
}