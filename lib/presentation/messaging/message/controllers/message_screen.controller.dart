import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:skt_sikring/infrastructure/services/soundPlay.dart';
import 'package:skt_sikring/infrastructure/utils/log_helper.dart';
import 'package:skt_sikring/presentation/messaging/common/commonController.dart';
import '../../../../infrastructure/utils/secure_storage_helper.dart';
import '../../common/socket_controller.dart';
import '../model/conversationListModel.dart';

class MessageScreenController extends GetxController {
  final SoundPlay playMessageSound = SoundPlay();
  final ScrollController scrollController = ScrollController();
  final CommonController commonController = Get.put(CommonController());
  late final SocketController socketController;
  RxString token = ''.obs;
  RxString userID = ''.obs;

  RxList<AllConversationList> chatItemList = <AllConversationList>[].obs;
  final RxBool isLoading = true.obs;


  @override
  Future<void> onInit() async {
    super.onInit();


    socketController = Get.find<SocketController>();
    socketController.enterMessagingFlow('MessageScreen');
    token.value = await SecureStorageHelper.getString('accessToken');
    userID.value = await SecureStorageHelper.getString('id');
    isLoading.value = true;
    setupSocketListeners();
    getUserList();
  }

  void setupSocketListeners() {
    socketController.on(
      'conversation-list-updated::${userID.value}',
          (data) {
        // print('=========================${socketController.userId.value}==============================');
        LoggerHelper.warn(
          'Conversation list updated: $data \n\n\n${userID.value}',
        );
        playMessageSound.playSound();

        getUserList();
      },
    );

    // Listen for user online status updates
    socketController.on(
      'related-user-online-status::${userID.value}',
          (data) {
        // print('=========================${socketController.userId.value}==============================');
        LoggerHelper.info(
          'User online status updated: $data \n\n\n${userID.value}',
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
    socketController.emitWithAck(
      'get-all-conversations-with-pagination',
      {"page": 1, "limit": 100},
      ack: (response) async {
        LoggerHelper.warn(' Message screens list fetched successfully');
        LoggerHelper.error(response.toString());

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
  // void leaveMessageScreen({String? toScreen}) {
  //   socketController.off('conversation-list-updated::$userID');
  //   socketController.off('related-user-online-status::$userID');
  //   socketController.leaveMessagingFlow('MessageScreen', toScreen: toScreen);
  // }

  // Clear user-specific data (call on logout)
  void clearUserData() {
    chatItemList.clear();
    socketController.off('conversation-list-updated::$userID');
    socketController.off('related-user-online-status::$userID');
  }
  @override
  void onClose() {
    scrollController.dispose();

    commonController.clearCommonValues();
    chatItemList.clear();

    super.onClose();
  }
}