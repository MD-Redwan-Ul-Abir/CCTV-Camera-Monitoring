import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:skt_sikring/infrastructure/services/soundPlay.dart';
import 'package:skt_sikring/infrastructure/theme/app_colors.dart';
import 'package:skt_sikring/infrastructure/utils/log_helper.dart';

import '../utils/notificationAudio.dart';
import 'notificationHelperService.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  late String fcmToken = '';

  FirebaseService._internal();

  late FirebaseMessaging messaging;

  Future<void> initialize() async {
    try {
      await Firebase.initializeApp();
    } on Exception catch (e) {
      debugPrint('Firebase initialization failed: $e');
      // If Firebase fails to initialize, we can still continue with other services
      // This might happen if configuration files are missing
      return;
    }

    await NotificationHelper.initialize();

    messaging = FirebaseMessaging.instance;

    final SoundPlay play = SoundPlay();

    // Request permission for notifications
    await _requestNotificationPermission();

    // Get the token (handle potential errors)
    try {
      final token = await messaging.getToken();
      if (token != null) {
        fcmToken = token;
        debugPrint('Firebase token: $fcmToken');
      } else {
        debugPrint('Firebase token is null');
      }
    } catch (e) {
      debugPrint('Failed to get Firebase token: $e');
      // Continue initialization even if token retrieval fails
    }

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      play.playSound();

      // Show system notification
      _showSystemNotification(message);

      // Show Get.snackbar in foreground
      Get.snackbar("${message.notification!.title}", '${message.notification!.body}',backgroundColor: AppColors.greenDark,colorText: AppColors.primaryLightActive);
      LoggerHelper.warn(message.notification!.body);
      //debugPrint('Foreground message received: ${message.notification?.title}');
    });

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Handle tap on notification when app is in background or terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('Notification tapped when app was in background');
      // Handle navigation based on notification data
      _handleNotificationTap(message);
    });
  }

  void _showSystemNotification(RemoteMessage message) {
    final imageUrl = message.data['image'] ?? 
                     message.data['image_url'] ?? 
                     message.data['senderImage'] ?? 
                     message.data['sender_image']; // Your backend sends image in senderImage
    
    NotificationHelper.showNotification(
      title: message.notification?.title ?? 'No title',
      body: message.notification?.body ?? '',
      imageUrl: imageUrl,
    );
  }

  Future<void> _requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      // Provisional permissions are only available on iOS
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      debugPrint('User granted provisional permission');
    } else {
      debugPrint('User declined or has not accepted permission');
    }
  }

  Future<void> _handleNotificationTap(RemoteMessage message) async {
    // Handle navigation when notification is tapped
    // You can extract data from the message and navigate accordingly
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationTap(initialMessage);
    }


   // Get.snackbar("New Message", '${message.data}',backgroundColor: AppColors.primaryNormal,colorText: AppColors.primaryLightActive);
   // debugPrint('Message data: ${message.data}');
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp();
  } on Exception catch (e) {
    debugPrint('Firebase initialization failed in background: $e');
    return; // Exit if Firebase couldn't initialize
  }

  await NotificationHelper.initialize();

  final notification = message.notification;

  // Extract image URL from multiple sources
  // Your backend sends image in senderImage field in the data object
  // and also potentially in the notification object's imageUrl field
  final imageUrl = message.data['image'] ??
                   message.data['image_url'] ??
                   message.data['senderImage'] ??
                   message.data['sender_image']; // Common variations

  if (notification != null) {
    await NotificationHelper.showNotification(
      title: notification.title ?? 'No title',
      body: notification.body ?? '',
      imageUrl: imageUrl,
    );
  }
}