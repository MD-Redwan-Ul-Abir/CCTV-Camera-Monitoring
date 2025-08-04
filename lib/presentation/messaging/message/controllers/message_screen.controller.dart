import 'package:skt_sikring/infrastructure/utils/api_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:skt_sikring/infrastructure/utils/log_helper.dart';
import 'package:skt_sikring/infrastructure/utils/secure_storage_helper.dart';
import 'package:skt_sikring/presentation/messaging/common/commonController.dart';
import '../../../../infrastructure/utils/socket_io.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../auth/otpPage/model/otpModel.dart';
import '../model/conversationListModel.dart';

class MessageScreenController extends GetxController {
  final ScrollController scrollController = ScrollController();
  final CommonController commonController = Get.put(CommonController());
  RxList<AllConversationList> chatItemList = <AllConversationList>[].obs;

  IO.Socket? socket;
  RxString receiveAbleId = ''.obs;
  RxString? myID = ''.obs;

  final RxBool isSocketConnected = false.obs;
  final RxString socketStatus = 'disconnected'.obs;
  final RxBool isConnecting = false.obs;
  final RxBool isLoading = true.obs; // Add loading state
  RxString token = ''.obs;

  @override
  void onInit() {
    super.onInit();
    connectAndFetchData();
    // getUserList();
    // Fetch data after connection
  }

  void connectAndFetchData() async {
    if (isConnecting.value) return;

    isLoading.value = true;
    isConnecting.value = true;

    try {
      String tokens = await SecureStorageHelper.getString('accessToken');
      token.value = tokens;
      String userId = await SecureStorageHelper.getString('id');
      myID?.value = userId;
      print(myID?.value);

      //Configure socket
      socket = IO.io(ApiConstants.socketUrl, <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
        'extraHeaders': {'token': tokens},
      });

      socket?.connect();

      // Setup listeners
      socket?.onConnect((_) {
        LoggerHelper.info('==== Connected to server ====');

        getUserList();
      });
      socket?.on('conversation-list-updated::$myID', (data) {
        LoggerHelper.error('New message received: $data');
        // Refresh the conversation list when new message arrives
        getUserList();
      });

      socket?.on('related-user-online-status::$myID', (data) {
        LoggerHelper.info('New message received: $data');
        // Refresh the conversation list when new message arrives

        getUserList();
      });

      socket?.onDisconnect((_) {
        LoggerHelper.info('==== Disconnected from server ====');
        isSocketConnected.value = false;
        socketStatus.value = 'disconnected';
        isConnecting.value = false;
        isLoading.value = false;
      });

      socket?.onConnectError((error) {
        LoggerHelper.error('Socket connection error: $error');
        isSocketConnected.value = false;
        socketStatus.value = 'error';
        isConnecting.value = false;
        isLoading.value = false;
      });

      // Connect to the socket

      // _socket?.on('new-message-received::687b8a28debdfb0089188e6d', (data) {
      //   LoggerHelper.error('New message received: $data');
      //   // Refresh the conversation list when new message arrives
      //   getUserList();
      // });
    } catch (e) {
      LoggerHelper.error('Error in connectAndFetchData: $e');
      isConnecting.value = false;
      isLoading.value = false;
    }
  }

  Future<void> getUserList() async {
    // Only proceed if socket is connected
    // if (!isSocketConnected.value || _socket?.connected != true) {
    //   LoggerHelper.warn('Socket not connected, cannot get user list');
    //   isLoading.value = false;
    //   return;
    // }
    // isLoading.value = false;
    // var data = {"page": 1, "limit": 10};

    // Add a small delay before making the request
    // await Future.delayed(Duration(milliseconds: 100));

    socket?.emitWithAck(
      'get-all-conversations-with-pagination',
      {"page": 1, "limit": 10},
      ack: (response) async {
        LoggerHelper.warn(response.toString());

        // Add delay before processing response
        // await Future.delayed(Duration(milliseconds: 50));

        // isLoading.value = false; // Set loading to false when data is received

        try {
          // Clear existing list and add new data
          if (response != null &&
              response is Map &&
              response['success'] == true) {
            // Handle the specific response structure from your logs
            var responseData = response['data'];
            if (responseData != null && responseData['results'] != null) {
              chatItemList.clear();
              var dataList = responseData['results'] as List;
              for (var item in dataList) {
                chatItemList.add(AllConversationList.fromJson(item));
              }
            } else {
              chatItemList = <AllConversationList>[].obs;
            }
          } else if (response != null && response is List) {
            // Handle direct list response
            chatItemList.clear();
            for (var item in response) {
              chatItemList.add(AllConversationList.fromJson(item));
            }
          } else {
            // Handle empty or null response
            chatItemList.clear();
          }
        } catch (e) {
          LoggerHelper.error('Error parsing user list response: $e');
        } finally {
          isLoading.value = false;
        }
      },
    );
  }

  // Method to retry connection
  void retryConnection() {
    if (!isSocketConnected.value && !isConnecting.value) {
      connectAndFetchData();
    }
  }

  @override
  void onClose() {
    socket?.disconnect();

    socket?.dispose();

    LoggerHelper.error(
      '=========================================Socket closed================================================',
    );
    scrollController.dispose();
    super.onClose();
  }
}
