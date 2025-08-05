// Controller for the conversation page
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:skt_sikring/presentation/messaging/common/commonController.dart';

import '../../../../infrastructure/utils/log_helper.dart';
import '../../common/socket_controller.dart';
import '../model/conversationModel.dart';

class ConversationPageController extends GetxController {
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final CommonController commonController = Get.put(CommonController());
  late final SocketController socketController;

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
    super.onInit();

    socketController = Get.find<SocketController>();
    currentUserId.value = commonController.senderId.value;

    // No need to connect socket here - it should already be connected
    // Just setup listeners and join conversation
    joinConversation();
    setupScrollListener();
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

    if (!socketController.isSocketConnected.value) {
      LoggerHelper.error('Socket not connected. Cannot join conversation.');
      isLoading.value = false;
      return;
    }

    socketController.emitWithAck(
      'join',
      {"conversationId": commonController.conversationId.value},
      ack: (response) async {
        LoggerHelper.warn(response.toString());
      },
    );

    await getAllMessages();
    await newMessageReceived();
  }

  // Helper method to extract image URL from different possible locations
  String _extractImageUrl(Map<String, dynamic> messageData) {
    if (messageData['image'] != null && messageData['image']['imageUrl'] != null) {
      return messageData['image']['imageUrl'];
    }
    if (messageData['senderImage'] != null) {
      return messageData['senderImage'];
    }
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

    _previousScrollExtent = scrollController.position.maxScrollExtent;

    currentPage.value++;
    await getAllMessages(isLoadMore: true);
  }

  Future<void> getAllMessages({bool isLoadMore = false}) async {
    if (!isLoadMore) {
      isLoading.value = true;
    }

    if (!socketController.isSocketConnected.value) {
      LoggerHelper.error('Socket not connected. Cannot get messages.');
      isLoading.value = false;
      isLoadingMore.value = false;
      _isLoadingMessages = false;
      return;
    }

    socketController.emitWithAck(
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

              Map<String, dynamic> responseMap = _convertResponseToStringMap(response);

              AllConversationsBetweenTwoUserModel conversationModel =
              AllConversationsBetweenTwoUserModel.fromJson(responseMap);

              if (conversationModel.data?.results != null) {
                List<Result> newMessages = conversationModel.data!.results!;

                if (isLoadMore) {
                  conversationList.insertAll(0, newMessages.reversed);

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _maintainScrollPosition();
                  });
                } else {
                  conversationList.assignAll(newMessages.reversed);

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollToBottom(animate: false);
                  });
                }

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
      double currentScrollExtent = scrollController.position.maxScrollExtent;
      double scrollDifference = currentScrollExtent - _previousScrollExtent;

      double newScrollPosition = scrollController.position.pixels + scrollDifference;
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

        bool isCurrentUser = message.senderId?.userId == currentUserId.value;

        // Extract attachment URLs
        List<String> attachmentUrls = [];
        if (message.attachments != null && message.attachments!.isNotEmpty) {
          attachmentUrls = message.attachments!
              .where((attachment) => attachment.attachment != null && attachment.attachment!.isNotEmpty)
              .map((attachment) => attachment.attachment!)
              .toList();
        }

        grouped.add({
          'type': 'message',
          'text': message.text ?? '',
          'isUser': isCurrentUser,
          'timestamp': message.createdAt,
          'senderName': message.senderId?.name ?? '',
          'senderImage': message.senderId?.profileImage?.imageUrl ?? '',
          'messageId': message.messageId ?? '',
          'attachments': attachmentUrls, // Add attachments to the message data
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
      messageController.clear();

      if (!socketController.isSocketConnected.value) {
        LoggerHelper.error('Socket not connected. Cannot send message.');
        return;
      }

      socketController.emitWithAck('send-new-message', {
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

              bool messageExists = conversationList.any((msg) =>
              msg.messageId == newMessage.messageId ||
                  (msg.text == newMessage.text &&
                      msg.senderId?.userId == newMessage.senderId?.userId &&
                      (msg.createdAt?.difference(newMessage.createdAt ?? DateTime.now()).abs().inSeconds ?? 0) < 5)
              );

              if (!messageExists) {
                conversationList.add(newMessage);

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollToBottom(animate: true);
                });
              }
            }
          } else {
            LoggerHelper.error('Failed to send message: $response');
          }
        } catch (e) {
          LoggerHelper.error('Error processing message send response: $e');
        }
      });
    }
  }

  Future<void> newMessageReceived() async {
    socketController.on('new-message-received::${commonController.conversationId.value}', (data) {
      LoggerHelper.error('New message received: $data');

      try {
        if (data != null && data is Map) {
          Map<String, dynamic> messageData = _convertResponseToStringMap(data);

          Map<String, dynamic> actualMessage = messageData;
          if (messageData.containsKey('message')) {
            actualMessage = messageData['message'];
          }

          // Handle attachments properly
          List<Attachment> attachments = [];
          if (actualMessage['attachments'] != null && actualMessage['attachments'] is List) {
            attachments = (actualMessage['attachments'] as List).map((attachment) {
              if (attachment is Map<String, dynamic>) {
                return Attachment.fromJson(attachment);
              } else if (attachment is String) {
                // If it's just a string URL, create an Attachment object
                return Attachment(
                  attachment: attachment,
                  attachmentId: null,
                );
              }
              return Attachment();
            }).toList();
          }

          Result newMessage = Result(
            text: actualMessage['text']?.toString() ?? '',
            senderId: SenderId(
              userId: actualMessage['senderId']?.toString() ?? '',
              name: messageData['senderName']?.toString() ?? messageData['name']?.toString() ?? 'Unknown',
              // profileImage: ProfileImage(
              //   imageUrl: extractImageUrl(messageData),
              // ),
            ),
            createdAt: _parseDateTime(actualMessage['createdAt']),
            updatedAt: _parseDateTime(actualMessage['updatedAt']),
            messageId: actualMessage['_messageId']?.toString() ?? actualMessage['_id']?.toString() ?? '',
            conversationId: actualMessage['conversationId']?.toString() ?? '',
            attachments: attachments,
            isDeleted: actualMessage['isDeleted'] ?? false,
          );

          if (newMessage.senderId?.userId != currentUserId.value) {
            bool messageExists = conversationList.any((msg) =>
            msg.messageId == newMessage.messageId ||
                (msg.text == newMessage.text &&
                    msg.senderId?.userId == newMessage.senderId?.userId &&
                    (msg.createdAt?.difference(newMessage.createdAt ?? DateTime.now()).abs().inSeconds ?? 0) < 5)
            );

            if (!messageExists) {
              conversationList.add(newMessage);

              WidgetsBinding.instance.addPostFrameCallback((_) {
                _scrollToBottom(animate: true);
              });
            }
          }
        }
      } catch (e) {
        LoggerHelper.error('Error processing new message: $e');
      }
    });
  }

  void refreshConversation() {
    currentPage.value = 1;
    hasMoreData.value = true;
    conversationList.clear();
    _isLoadingMessages = false;
    getAllMessages();
  }

  // Method to leave conversation screen
  void leaveConversationScreen({String? toScreen}) {
    // Remove specific listeners for this conversation
    socketController.off('new-message-received::${commonController.conversationId.value}');

    // Notify socket controller about leaving
    socketController.leaveMessagingFlow('ConversationPage', toScreen: toScreen);
  }

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    // Don't disconnect socket here - let the socket controller manage it
    super.onClose();
  }
}