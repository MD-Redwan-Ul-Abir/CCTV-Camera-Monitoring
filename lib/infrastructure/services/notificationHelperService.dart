import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class NotificationHelper {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // Notification sound file name
  static const String notificationSound = 'notificationaudio';

  static Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      defaultPresentAlert: true,
      defaultPresentBadge: true,
      defaultPresentSound: true,
    );

    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        // Handle notification tap when app is terminated
        // Navigate to the appropriate screen
      },
    );

    // Create Android notification channel with custom sound
    await _createNotificationChannel();
  }

  // Create notification channel for Android with custom sound
  static Future<void> _createNotificationChannel() async {
    final AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
      playSound: true,
      sound: const RawResourceAndroidNotificationSound(notificationSound),
      enableVibration: true,
      vibrationPattern: Int64List.fromList(const [100, 500, 100, 500]),
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  static Future<void> showNotification({
    required String title,
    required String body,
    String? imageUrl,
  }) async {
    AndroidNotificationDetails androidDetails;

    if (imageUrl != null && imageUrl.isNotEmpty) {
      try {
        // Download the image to show in the notification
        final http.Response response = await http.get(Uri.parse(imageUrl));
        final Uint8List imageData = response.bodyBytes;

        final BigPictureStyleInformation bigPicture = BigPictureStyleInformation(
          ByteArrayAndroidBitmap(imageData),
          contentTitle: title,
          summaryText: body,
        );

        androidDetails = AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          channelDescription: 'This channel is used for important notifications.',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          sound: const RawResourceAndroidNotificationSound(notificationSound),
          enableVibration: true,
          vibrationPattern: Int64List.fromList([100, 500, 100, 500]),
          styleInformation: bigPicture,
        );
      } catch (e) {
        debugPrint('Failed to download image for notification: $e');
        // If image download fails, show notification without image
        androidDetails = AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          channelDescription: 'This channel is used for important notifications.',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          sound: const RawResourceAndroidNotificationSound(notificationSound),
          enableVibration: true,
          vibrationPattern: Int64List.fromList([100, 500, 100, 500]),
        );
      }
    } else {
      androidDetails = AndroidNotificationDetails(
        'high_importance_channel',
        'High Importance Notifications',
        channelDescription: 'This channel is used for important notifications.',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        sound: const RawResourceAndroidNotificationSound(notificationSound),
        enableVibration: true,
        vibrationPattern: Int64List.fromList([100, 500, 100, 500]),
      );
    }

    // iOS notification details with custom sound
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: '$notificationSound.mp3',
    );

    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.show(
      DateTime.now().microsecond ~/ 1000,
      title,
      body,
      notificationDetails,
    );
  }
}
