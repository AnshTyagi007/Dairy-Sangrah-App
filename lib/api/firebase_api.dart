import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// This must be a top-level function
@pragma('vm:entry-point')
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();

  final _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications',
    importance: Importance.high,
  );

  // Initialize local notifications
  Future<void> initLocalNotifications() async {
    // App icon in Android
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@drawable/ic_launcher');

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );

    // Initialize the plugin
    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tap
        final payload = response.payload;
        if (payload != null) {
          final data = jsonDecode(payload);
          // Handle the notification payload
          print('Notification tapped with payload: $data');
        }
      },
    );

    // Create the Android notification channel
    await _localNotifications
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_androidChannel);
  }

  // Initialize Firebase Messaging
  Future<void> initNotifications() async {
    try {
      // Must be called before other Firebase messaging methods
      await initLocalNotifications();

      // Request permission (required for iOS, recommended for Android)
      final settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      print('User notification settings: ${settings.authorizationStatus}');

      // Get the token
      final fcmToken = await _firebaseMessaging.getToken();
      if (fcmToken != null) {
        print('FCM Token: $fcmToken');
        // Here you would typically send this token to your server
      } else {
        print('Failed to get FCM token');
      }

      // Register background message handler
      FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        final notification = message.notification;
        if (notification == null) return;

        _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              _androidChannel.id,
              _androidChannel.name,
              channelDescription: _androidChannel.description,
              icon: '@drawable/ic_launcher',
            ),
          ),
          payload: jsonEncode(message.toMap()),
        );

        print('Foreground message received: ${notification.title}');
      });

      // Handle when the app is opened from a notification
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('App opened from notification: ${message.notification?.title}');
        // Here you can navigate to specific screens based on the message
      });
    } catch (e) {
      print('Error initializing Firebase notifications: $e');
    }
  }
}