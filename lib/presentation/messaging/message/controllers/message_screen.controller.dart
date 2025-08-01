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
  final RxBool isLoading = true.obs; // Add loading state

  @override
  void onInit() {
    super.onInit();
    connectAndFetchData();
     // Fetch data after connection
  }

  void connectAndFetchData() async {
    if (isConnecting.value) return;

    isLoading.value = true;
    isConnecting.value = true;

    try {
      String token = await SecureStorageHelper.getString('accessToken');
      myID = await SecureStorageHelper.getString('id');
      print(myID);

      // Configure socket
      _socket = IO.io(
        ApiConstants.socketUrl,
        <String, dynamic>{
          'transports': ['websocket'],
          'autoConnect': true,
          'extraHeaders': {'token': token},
        },
      );

      // Setup listeners
      _socket?.onConnect((_) {
        LoggerHelper.info('==== Connected to server ====');
        isLoading.value=false;
        isSocketConnected.value = true;
        socketStatus.value = 'connected';
        isConnecting.value = false;
        getUserList();

      });

      _socket?.onDisconnect((_) {
        LoggerHelper.info('==== Disconnected from server ====');
        isSocketConnected.value = false;
        socketStatus.value = 'disconnected';
        isConnecting.value = false;
        isLoading.value = false;
      });

      _socket?.onConnectError((error) {
        LoggerHelper.error('Socket connection error: $error');
        isSocketConnected.value = false;
        socketStatus.value = 'error';
        isConnecting.value = false;
        isLoading.value = false;
      });

      // Connect to the socket
      _socket?.connect();

      _socket?.on('new-message-received::687b8a28debdfb0089188e6d', (data) {
        LoggerHelper.error('New message received: $data');
        // Refresh the conversation list when new message arrives
        getUserList();
      });

      _socket?.on('related-user-online-status::$myID', (data) {
        LoggerHelper.info('New message received: $data');
        // Refresh the conversation list when new message arrives
        getUserList();
      });





    } catch (e) {
      LoggerHelper.error('Error in connectAndFetchData: $e');
      isConnecting.value = false;
      isLoading.value = false;
    }
  }


  Future<void> getUserList() async {
    // Only proceed if socket is connected
    if (!isSocketConnected.value || _socket?.connected != true) {
      LoggerHelper.warn('Socket not connected, cannot get user list');
      isLoading.value = false;
      return;
    }

    var data = {"page": 1, "limit": 10};

    // Add a small delay before making the request
    await Future.delayed(Duration(milliseconds: 100));

    _socket?.emitWithAck(
      'get-all-conversations-with-pagination',
      data,
      ack: (response) async {
        LoggerHelper.warn(response.toString());

        // Add delay before processing response
        await Future.delayed(Duration(milliseconds: 50));

        isLoading.value = false; // Set loading to false when data is received

        try {
          // Clear existing list and add new data
          if (response != null && response is Map && response['success'] == true) {
            // Handle the specific response structure from your logs
            var responseData = response['data'];
            if (responseData != null && responseData['results'] != null) {
              chatItemList.clear();
              var dataList = responseData['results'] as List;
              for (var item in dataList) {
                chatItemList.add(AllConversationList.fromJson(item));
              }
            } else {
              chatItemList.clear();
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
    _socket?.disconnect();
    _socket?.dispose();
    LoggerHelper.error('=========================================Socket closed================================================');
    scrollController.dispose();
    super.onClose();
  }
}