import 'package:skt_sikring/infrastructure/utils/api_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:skt_sikring/infrastructure/utils/log_helper.dart';
import 'package:skt_sikring/infrastructure/utils/secure_storage_helper.dart';
import '../../../../infrastructure/utils/socket_io.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../auth/otpPage/model/otpModel.dart';
import '../model/conversationListModel.dart';

class MessageScreenController extends GetxController {
  final ScrollController scrollController = ScrollController();
  RxList<AllConversationList> chatItemList = <AllConversationList>[].obs;

  IO.Socket? _socket;
  RxString receiveAbleId = ''.obs;
  String? myID;

  final RxBool isSocketConnected = false.obs;
  final RxString socketStatus = 'disconnected'.obs;
  final RxBool isConnecting = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await initSocket();
    // Ensure getUserList is called after socket initialization
    if (_socket?.connected == true) {
      isConnecting.value=false;
      getUserList();
    }
  }

  initSocket() async {
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

        // Call getUserList immediately after connection
        getUserList();
      });

      // Setup listeners before connecting
      if (_socket?.connected != true) {
        isConnecting.value = true;
        _socket?.connect();
      }

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

  void getUserList() {
    var data = {"page": 1, "limit": 10};

    _socket?.emitWithAck(
      'get-all-conversations-with-pagination',
      data,
      ack: (response) {
        LoggerHelper.warn(response.toString());

        // Clear existing list and add new data
        if (response != null && response is List) {
          chatItemList.clear();
          for (var item in response) {
            chatItemList.add(AllConversationList.fromJson(item));
          }
        } else if (response != null &&
            response is Map &&
            response['data'] != null) {
          // If response is wrapped in an object
          chatItemList.clear();
          var dataList = response['data']['results'] as List;
          for (var item in dataList) {
            chatItemList.add(AllConversationList.fromJson(item));
          }
        }
      },
    );
  }
}
