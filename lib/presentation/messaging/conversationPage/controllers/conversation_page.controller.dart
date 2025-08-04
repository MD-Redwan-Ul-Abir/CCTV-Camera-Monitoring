// Controller for the conversation page
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:skt_sikring/presentation/messaging/common/commonController.dart';

import '../../../../infrastructure/utils/api_content.dart';
import '../../../../infrastructure/utils/log_helper.dart';
import '../model/conversationModel.dart';

class ConversationPageController extends GetxController {
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  IO.Socket? _socket;
  final CommonController commonController = Get.put(CommonController());

  // Observable list for conversation messages
  RxList<Result> conversationList = <Result>[].obs;

  // Pagination variables
  RxInt currentPage = 1.obs;
  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;
  RxBool hasMoreData = true.obs;
  final int limit = 10;

  // Current user ID for message comparison
  RxString currentUserId = ''.obs;

  @override
  void onInit() {
    // Get current user ID from commonController or wherever it's stored
    currentUserId.value = commonController.senderId.value;
    _socket = IO.io(ApiConstants.socketUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'extraHeaders': {'token': commonController.token.value},
    });

    _socket?.connect();

    joinConversation();
    setupScrollListener();
    super.onInit();
  }

  void setupScrollListener() {
    scrollController.addListener(() {
      // Load more when user scrolls to top
      if (scrollController.position.pixels <= 100 &&
          !isLoadingMore.value &&
          hasMoreData.value) {
        loadMoreMessages();
      }
    });
  }

  Future<void> joinConversation() async {
    isLoading.value = true;

    _socket?.emitWithAck(
      'join',
      {"conversationId": commonController.conversationId.value},
      ack: (response) async {
        LoggerHelper.warn(response.toString());
      },
    );

    await getAllMessages();
  }

  Future<void> getAllMessages({bool isLoadMore = false}) async {
    if (isLoadMore) {
      isLoadingMore.value = true;
    } else {
      isLoading.value = true;
    }

    _socket?.emitWithAck(
      'get-all-message-by-conversationId',
      {
        "conversationId": commonController.conversationId.value,
        "page": currentPage.value,
        "limit": limit
      },
      ack: (response) async {
        LoggerHelper.warn(response.toString());

        try {
          if (response != null &&
              response is Map &&
              response['success'] == true) {

            var responseData = response['data'];
            if (responseData != null && responseData['results'] != null) {

              // Properly cast the socket response to the correct type
              Map<String, dynamic> responseMap = _convertResponseToStringMap(response);

              // Parse the response using your model
              AllConversationsBetweenTwoUserModel conversationModel =
              AllConversationsBetweenTwoUserModel.fromJson(responseMap);

              if (conversationModel.data?.results != null) {
                List<Result> newMessages = conversationModel.data!.results!;

                if (isLoadMore) {
                  // Add new messages to the beginning of the list (older messages)
                  conversationList.insertAll(0, newMessages.reversed);
                } else {
                  // Replace the list with new messages
                  conversationList.assignAll(newMessages.reversed);
                }

                // Check if there are more messages to load
                int totalPages = conversationModel.data?.totalPages ?? 0;
                hasMoreData.value = currentPage.value < totalPages;

                // Scroll to bottom only for initial load
                if (!isLoadMore) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (scrollController.hasClients) {
                      scrollController.jumpTo(scrollController.position.maxScrollExtent);
                    }
                  });
                }
              }
            } else {
              if (!isLoadMore) {
                conversationList.clear();
              }
            }
          } else {
            if (!isLoadMore) {
              conversationList.clear();
            }
          }
        } catch (e) {
          LoggerHelper.error('Error parsing conversation response: $e');
        } finally {
          isLoading.value = false;
          isLoadingMore.value = false;
        }
      },
    );
  }

  // Helper method to convert Map<dynamic, dynamic> to Map<String, dynamic>
  Map<String, dynamic> _convertResponseToStringMap(dynamic response) {
    if (response is Map<String, dynamic>) {
      return response;
    } else if (response is Map) {
      Map<String, dynamic> converted = {};
      response.forEach((key, value) {
        String stringKey = key.toString();
        if (value is Map) {
          converted[stringKey] = _convertResponseToStringMap(value);
        } else if (value is List) {
          converted[stringKey] = value.map((item) {
            if (item is Map) {
              return _convertResponseToStringMap(item);
            }
            return item;
          }).toList();
        } else {
          converted[stringKey] = value;
        }
      });
      return converted;
    }
    return {};
  }

  Future<void> loadMoreMessages() async {
    if (!hasMoreData.value || isLoadingMore.value) return;

    currentPage.value++;
    await getAllMessages(isLoadMore: true);
  }

  // Get messages grouped by date for UI
  List<Map<String, dynamic>> get groupedMessages {
    final List<Map<String, dynamic>> grouped = [];
    String? lastDate;

    for (final message in conversationList) {
      if (message.createdAt != null) {
        final messageDate = _formatDate(message.createdAt!);

        if (lastDate != messageDate) {
          grouped.add({
            'type': 'date',
            'date': messageDate,
          });
          lastDate = messageDate;
        }

        // Check if message is sent by current user
        bool isCurrentUser = message.senderId?.userId == currentUserId.value;

        grouped.add({
          'type': 'message',
          'text': message.text ?? '',
          'isUser': isCurrentUser,
          'timestamp': message.createdAt,
          'senderName': message.senderId?.name ?? '',
          'senderImage': message.senderId?.profileImage?.imageUrl ?? '',
          'messageId': message.messageId ?? '',
        });
      }
    }

    return grouped;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(Duration(days: 1));
    final tomorrow = today.add(Duration(days: 1));
    final messageDate = DateTime(date.year, date.month, date.day);

    if (messageDate == today) {
      return 'Today';
    } else if (messageDate == yesterday) {
      return 'Yesterday';
    } else if (messageDate == tomorrow) {
      return 'Tomorrow';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void sendMessage() {
    final text = messageController.text.trim();
    if (text.isNotEmpty) {
      // Create a temporary message object for immediate UI update
      Result tempMessage = Result(
        text: text,
        senderId: SenderId(
          userId: currentUserId.value,
          name: commonController.userName.value,
          profileImage: ProfileImage(
            imageUrl: commonController.profileImage.value,
          ),
        ),
        createdAt: DateTime.now(),
        messageId: DateTime.now().millisecondsSinceEpoch.toString(),
      );

      // Add to conversation list immediately
      conversationList.add(tempMessage);

      messageController.clear();

      // Scroll to bottom
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });

      // Here you should emit the message to the socket
      _socket?.emit('sendMessage', {
        'text': text,
        'conversationId': commonController.conversationId.value,
        'senderId': currentUserId.value,
      });
    }
  }

  // Method to refresh conversation
  void refreshConversation() {
    currentPage.value = 1;
    hasMoreData.value = true;
    conversationList.clear();
    getAllMessages();
  }

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}