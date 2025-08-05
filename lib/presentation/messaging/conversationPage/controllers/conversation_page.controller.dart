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

  // Variables for smooth scrolling
  double _previousScrollExtent = 0.0;
  bool _isLoadingMessages = false;

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
      // Load more when user scrolls near the top (within 50 pixels)
      if (scrollController.position.pixels <= 10 &&
          !_isLoadingMessages &&
          hasMoreData.value &&
          conversationList.isNotEmpty) {
        _loadMoreMessagesSmooth();
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

    //implement this function
    await getAllMessages();
    await newMessageReceived();
  }


// Helper method to extract image URL from different possible locations
  String _extractImageUrl(Map<String, dynamic> messageData) {
    // Try different possible locations for the image URL
    if (messageData['image'] != null && messageData['image']['imageUrl'] != null) {
      return messageData['image']['imageUrl'];
    }
    if (messageData['senderImage'] != null) {
      return messageData['senderImage'];
    }
    // Return default image or empty string
    return '/uploads/users/user.png';
  }

// Helper method to safely parse DateTime
  DateTime? _parseDateTime(dynamic dateTime) {
    if (dateTime == null) return DateTime.now();

    try {
      if (dateTime is String) {
        return DateTime.parse(dateTime);
      } else if (dateTime is DateTime) {
        return dateTime;
      }
    } catch (e) {
      LoggerHelper.error('Error parsing datetime: $e');
    }

    return DateTime.now();
  }

  Future<void> _loadMoreMessagesSmooth() async {
    if (_isLoadingMessages || !hasMoreData.value) return;

    _isLoadingMessages = true;
    isLoadingMore.value = true;

    // Store the current scroll extent before loading more messages
    _previousScrollExtent = scrollController.position.maxScrollExtent;

    currentPage.value++;
    await getAllMessages(isLoadMore: true);
  }

  Future<void> getAllMessages({bool isLoadMore = false}) async {
    if (!isLoadMore) {
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

                  // Maintain scroll position after loading more messages
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _maintainScrollPosition();
                  });
                } else {
                  // Replace the list with new messages for initial load
                  conversationList.assignAll(newMessages.reversed);

                  // Scroll to bottom only for initial load
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollToBottom(animate: false);
                  });
                }

                // Check if there are more messages to load
                int totalPages = conversationModel.data?.totalPages ?? 0;
                hasMoreData.value = currentPage.value < totalPages;
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
          _isLoadingMessages = false;
        }
      },
    );
  }

  void _maintainScrollPosition() {
    if (!scrollController.hasClients) return;

    try {
      // Calculate the difference in scroll extent
      double currentScrollExtent = scrollController.position.maxScrollExtent;
      double scrollDifference = currentScrollExtent - _previousScrollExtent;

      // Adjust scroll position to maintain the user's view
      double newScrollPosition = scrollController.position.pixels + scrollDifference;

      // Ensure we don't scroll beyond bounds
      newScrollPosition = newScrollPosition.clamp(0.0, currentScrollExtent);

      scrollController.jumpTo(newScrollPosition);
    } catch (e) {
      LoggerHelper.error('Error maintaining scroll position: $e');
    }
  }

  void _scrollToBottom({bool animate = true}) {
    if (!scrollController.hasClients) return;

    try {
      if (animate) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      } else {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      }
    } catch (e) {
      LoggerHelper.error('Error scrolling to bottom: $e');
    }
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
      // Clear the input field immediately for better UX
      messageController.clear();

      // Emit the message to the socket with acknowledgment
      _socket?.emitWithAck('send-new-message', {
        'text': text,
        'conversationId': commonController.conversationId.value,
        'senderId': currentUserId.value,
      }, ack: (response) {
        LoggerHelper.warn('Message sent response: $response');

        try {
          if (response != null && response is Map && response['success'] == true) {
            Map<String, dynamic> responseData = _convertResponseToStringMap(response);

            if (responseData['messageDetails'] != null) {
              Map<String, dynamic> messageDetails = responseData['messageDetails'];

              // Create a Result object from the server response
              Result newMessage = Result(
                text: messageDetails['text']?.toString() ?? text,
                senderId: SenderId(
                  userId: messageDetails['senderId']?.toString() ?? currentUserId.value,
                  name: messageDetails['name']?.toString() ?? commonController.userName.value,
                  profileImage: ProfileImage(
                    imageUrl: messageDetails['image']?['imageUrl']?.toString() ??
                        commonController.profileImage.value,
                  ),
                ),
                createdAt: _parseDateTime(messageDetails['timestamp']),
                messageId: messageDetails['messageId']?.toString() ?? '',
                conversationId: messageDetails['conversationId']?.toString() ?? commonController.conversationId.value,
                attachments: [],
                isDeleted: false,
              );

              // Check if message already exists to avoid duplicates
              bool messageExists = conversationList.any((msg) =>
              msg.messageId == newMessage.messageId ||
                  (msg.text == newMessage.text &&
                      msg.senderId?.userId == newMessage.senderId?.userId &&
                      (msg.createdAt?.difference(newMessage.createdAt ?? DateTime.now()).abs().inSeconds ?? 0) < 5)
              );

              if (!messageExists) {
                // Add the message to the conversation list
                conversationList.add(newMessage);

                // Scroll to bottom to show the new message
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollToBottom(animate: true);
                });
              }
            }
          } else {
            // Handle error case - maybe show a snackbar or retry mechanism
            LoggerHelper.error('Failed to send message: $response');
            // Optionally, you can show an error message to the user
            // Get.snackbar(
            //   'Error',
            //   'Failed to send message. Please try again.',
            //   snackPosition: SnackPosition.BOTTOM,
            // );
          }
        } catch (e) {
          LoggerHelper.error('Error processing message send response: $e');
        }
      });
    }
  }

// Updated newMessageReceived method - only handles messages from others
  Future<void> newMessageReceived() async {
    _socket?.on('new-message-received::${commonController.conversationId.value}', (data) {
      LoggerHelper.error('New message received: $data');

      try {
        // Parse the received message data
        if (data != null && data is Map) {
          Map<String, dynamic> messageData = _convertResponseToStringMap(data);

          // Check if it's a message object or wrapped in a 'message' field
          Map<String, dynamic> actualMessage = messageData;
          if (messageData.containsKey('message')) {
            actualMessage = messageData['message'];
          }

          // Create a Result object from the received data
          Result newMessage = Result(
            text: actualMessage['text']?.toString() ?? '',
            senderId: SenderId(
              userId: actualMessage['senderId']?.toString() ?? '',
              name: messageData['senderName']?.toString() ?? messageData['name']?.toString() ?? 'Unknown',
              profileImage: ProfileImage(
                imageUrl: _extractImageUrl(messageData),
              ),
            ),
            createdAt: _parseDateTime(actualMessage['createdAt']),
            updatedAt: _parseDateTime(actualMessage['updatedAt']),
            messageId: actualMessage['_messageId']?.toString() ?? actualMessage['_id']?.toString() ?? '',
            conversationId: actualMessage['conversationId']?.toString() ?? '',
            attachments: (actualMessage['attachments'] as List?)?.cast<String>() ?? [],
            isDeleted: actualMessage['isDeleted'] ?? false,
          );

          // Only process messages from other users (not from current user)
          if (newMessage.senderId?.userId != currentUserId.value) {
            // Check for duplicates
            bool messageExists = conversationList.any((msg) =>
            msg.messageId == newMessage.messageId ||
                (msg.text == newMessage.text &&
                    msg.senderId?.userId == newMessage.senderId?.userId &&
                    (msg.createdAt?.difference(newMessage.createdAt ?? DateTime.now()).abs().inSeconds ?? 0) < 5)
            );

            if (!messageExists) {
              // Add the new message from other user
              conversationList.add(newMessage);

              // Scroll to bottom to show the new message
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _scrollToBottom(animate: true);
              });
            }
          }
          // If it's from current user, ignore it as it's already handled in sendMessage ack
        }
      } catch (e) {
        LoggerHelper.error('Error processing new message: $e');
      }
    });
  }
  // Method to refresh conversation
  void refreshConversation() {
    currentPage.value = 1;
    hasMoreData.value = true;
    conversationList.clear();
    _isLoadingMessages = false;
    getAllMessages();
  }

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    _socket?.disconnect();
    super.onClose();
  }
}