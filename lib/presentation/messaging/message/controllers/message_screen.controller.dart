import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:skt_sikring/infrastructure/utils/log_helper.dart';
import 'package:skt_sikring/presentation/messaging/common/commonController.dart';

import '../../../../infrastructure/utils/secure_storage_helper.dart';
import '../../common/socket_controller.dart';
import '../model/conversationListModel.dart';

class MessageScreenController extends GetxController {
  final ScrollController scrollController = ScrollController();
  final CommonController commonController = Get.put(CommonController());
  late final SocketController socketController;

  RxList<AllConversationList> chatItemList = <AllConversationList>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    socketController = Get.find<SocketController>();

    socketController.enterMessagingFlow('MessageScreen');

    isLoading.value = true;
    socketController.initializeUserData();
    setupSocketListeners();
    getUserList();
  }

  void setupSocketListeners() {
    // Listen for conversation list updates
    socketController.on(
      'conversation-list-updated::${socketController.userId.value}',
      (data) {
        // print('=========================${socketController.userId.value}==============================');
        LoggerHelper.info(
          'Conversation list updated: $data \n\n\n${socketController.userId.value}',
        );
        getUserList();
      },
    );

    // Listen for user online status updates
    socketController.on(
      'related-user-online-status::${socketController.userId.value}',
      (data) {
        // print('=========================${socketController.userId.value}==============================');
        LoggerHelper.info(
          'User online status updated: $data \n\n\n${socketController.userId.value}',
        );
        getUserList();
      },
    );
  }

  Future<void> getUserList() async {
    if (!socketController.isSocketConnected.value) {
      LoggerHelper.error(' Cannot fetch user list.');
      isLoading.value = false;
      return;
    }
    // isLoading.value = true;


    socketController.emitWithAck(
      'get-all-conversations-with-pagination',
      {"page": 1, "limit": 100},
      ack: (response) async {
        LoggerHelper.warn(response.toString());

        try {
          if (response != null &&
              response is Map &&
              response['success'] == true) {
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
            chatItemList.clear();
            for (var item in response) {
              chatItemList.add(AllConversationList.fromJson(item));
            }
          } else {
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
    socketController.retryConnection();
    isLoading.value = false;

    // Once connected, fetch user list
    setupSocketListeners();
    getUserList();
  }

  // Method to leave message screen
  void leaveMessageScreen({String? toScreen}) {
    // Remove specific listeners for this screen
    // socketController.off('conversation-list-updated::${socketController.userId.value}');
    // socketController.off('related-user-online-status::${socketController.userId.value}');

    // Notify socket controller about leaving
    socketController.leaveMessagingFlow('MessageScreen', toScreen: toScreen);
  }

  @override
  void onClose() {
    scrollController.dispose();
    socketController.dispose();
    chatItemList.clear();
    // Don't disconnect socket here - let the socket controller manage it
    super.onClose();
  }
}
