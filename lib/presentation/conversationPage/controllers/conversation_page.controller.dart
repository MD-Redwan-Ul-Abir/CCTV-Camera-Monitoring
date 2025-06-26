// Controller for the conversation page
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ConversationPageController extends GetxController {
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  // Observable list of messages
  final RxList<Map<String, dynamic>> _messages = <Map<String, dynamic>>[
    {
      'text': 'Please provide more details about the malfunction.',
      'isUser': false,
      'timestamp': DateTime.now().subtract(Duration(days: 1)),
    },
    {
      'text': 'Okay that is understanding ?',
      'isUser': true,
      'timestamp': DateTime.now().subtract(Duration(days: 1, hours: 1)),
    },
    {
      'text': 'Please provide more details about the malfunction.',
      'isUser': false,
      'timestamp': DateTime.now(),
    },
    {
      'text': 'Okay that is understanding ?',
      'isUser': true,
      'timestamp': DateTime.now().subtract(Duration(hours: 1)),
    },
    {
      'text': 'Please provide more details about the malfunction. Okay that is understanding ?',
      'isUser': false,
      'timestamp': DateTime.now().subtract(Duration(minutes: 30)),
    },
    {
      'text': 'Okay that is understanding ?',
      'isUser': true,
      'timestamp': DateTime.now().subtract(Duration(minutes: 15)),
    },
  ].obs;

  // Get messages grouped by date
  List<Map<String, dynamic>> get groupedMessages {
    final List<Map<String, dynamic>> grouped = [];
    String? lastDate;

    for (final message in _messages) {
      final messageDate = _formatDate(message['timestamp']);

      if (lastDate != messageDate) {
        grouped.add({
          'type': 'date',
          'date': messageDate,
        });
        lastDate = messageDate;
      }

      grouped.add({
        'type': 'message',
        'text': message['text'],
        'isUser': message['isUser'],
        'timestamp': message['timestamp'],
      });
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
      _messages.add({
        'text': text,
        'isUser': true,
        'timestamp': DateTime.now(),
      });

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

      // Simulate a response after 1 second
      Future.delayed(Duration(seconds: 1), () {
        _messages.add({
          'text': 'Thank you for the information. I will look into this matter.Okay that is understanding ?',
          'isUser': false,
          'timestamp': DateTime.now(),
        });

        // Scroll to bottom again
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (scrollController.hasClients) {
            scrollController.animateTo(
              scrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      });
    }
  }

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}