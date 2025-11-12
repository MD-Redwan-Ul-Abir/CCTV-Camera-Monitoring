import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skt_sikring/infrastructure/utils/log_helper.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  late String fcmToken = '';
  FirebaseService._internal();

  late FirebaseMessaging messaging;

  Future<void> initialize() async {
    await Firebase.initializeApp();
    messaging = FirebaseMessaging.instance;

    // Request permission for notifications
    await _requestNotificationPermission();

    // Get the token (handle potential errors)
    try {
      final token = await messaging.getToken();
       fcmToken = token!;
      debugPrint('Firebase token: $fcmToken');
    } catch (e) {
      debugPrint('Failed to get Firebase token: $e');
      // Continue initialization even if token retrieval fails
    }

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Foreground message received: ${message.notification?.title}');
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
    debugPrint('Message data: ${message.data}');
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  debugPrint('Handling a background message: ${message.messageId}');
  debugPrint('Message data: ${message.data}');
  LoggerHelper.warn('Handling a background message: ${message.messageId}');
  if (message.notification != null) {
    debugPrint('Message notification: ${message.notification!.title}');
  }
}