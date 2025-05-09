import 'dart:async';
import 'dart:math';
import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mood_prints/services/user/user_services.dart';
import 'package:mood_prints/services/user/user_type_service.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

class NotificationServices {
  // final enableNotification =
  //     UserService.instance.parentData.value.notificationStatus;

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();
  FlutterLocalNotificationsPlugin notificationPlugin =
      FlutterLocalNotificationsPlugin();

  // final curdServices = CurdServices();

  Future<void> notificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      AppSettings.openAppSettings();

      // appSe.ope
      print('User denied permission');
    }
  }

  // ---------- Get Device Token ---------------

  // Future<String> getDeviceToken() async {
  //   String? token = await messaging.getToken();
  //   print('token: $token');
  //   return token!;
  // }

  // ---------- Display Message ---------------

  void firebaseInit() {
    FirebaseMessaging.onMessage.listen((message) {
      print('---------------------------------------------------');
      print('---------------------------------------------------');
      print('---------------------------------------------------');
      print("New Notification: ${message.notification?.title}");
      if (kDebugMode) {
        print(message.notification!.title.toString());
        print(message.notification!.body.toString());
      }
      // curdServices.postNotificationToFireStore(
      //     title: message.notification!.title.toString(),
      //     description: message.notification!.body.toString());

      showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      // Handle when notification is clicked
      if (message.data.containsKey("requestId")) {
        // String requestId = message.data["requestId"];
        // Navigate to accept/decline screen
        // navigateToRequestScreen(requestId);
      }
    });
  }

  Future<void> backgroundHandler(RemoteMessage message) async {
    print("Background message received: ${message.notification?.title}");
  }

  // ---------- init Local Notification ---------------

  void initLocalNotification() async {
    var androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSettings = DarwinInitializationSettings();

    var initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    //--------- Pay Load -----------

    await notificationPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (payload) {});

    tz.initializeTimeZones();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));
  }

  // ---------- show Notification from local notification plugin ---------------

  Future<void> showNotification(RemoteMessage message) async {
    // ------ Channel

    AndroidNotificationChannel channel = AndroidNotificationChannel(
        Random.secure().nextInt(100000).toString(),
        'High Importance Notifications',
        importance: Importance.max);

    // ------ Android Notification Detail

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channel.id.toString(),
      channel.name.toString(),
      channelDescription: 'mood_print',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );

    // ------ Update Client Side when recived accepted notification

    // if (UserTypeService.instance.userType == 'client') {
    //   print(
    //       '------- Notification Recived ${UserTypeService.instance.userType} ------');

    //   UserService.instance.getUserInformation();
    // }

    // ------ ios notification setting

    DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    // ------ Motification Details
    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    Future.delayed(Duration.zero, () {
      notificationPlugin.show(0, message.notification!.title.toString(),
          message.notification!.body.toString(), notificationDetails);
    });
  }

  // Future<void> scheduleFirstDayNotification() async {
  //   tz.initializeTimeZones();
  //   await notificationPlugin.zonedSchedule(
  //     0,
  //     'Day 1 Challenge',
  //     'Check today’s challenge and stay consistent!',
  //     tz.TZDateTime.now(tz.local).add(const Duration(seconds: 3)),
  //     const NotificationDetails(
  //       android: AndroidNotificationDetails(
  //         'challenge_channel',
  //         'Daily Challenge Notifications',
  //         channelDescription: 'Reminder for your 30-day challenge',
  //         importance: Importance.high,
  //         priority: Priority.high,
  //       ),
  //     ),
  //     androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  //     uiLocalNotificationDateInterpretation:
  //         UILocalNotificationDateInterpretation.absoluteTime,
  //   );
  //   print('scchhdule sucessfully 1');
  // }

  Future<void> scheduleNotification({
    String? title,
    String? body,
    int hours = 8,
  }) async {
    // Get the current date/time in device's local timezone

    int uniqueId = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    // final now = tz.TZDateTime.now(tz.local);

    // create a date/time for today at the specified hour/min

    // var scheduleDate = tz.TZDateTime(
    //   tz.local,
    //   now.year,
    //   now.month,
    //   now.day,
    //   hour,
    //   minute,
    // );

    final scheduledTime = tz.TZDateTime.now(tz.local).add(Duration(
      hours: hours,
    ));

    // Schedule the notification

    await notificationPlugin.zonedSchedule(
      uniqueId,
      title ?? 'Time to enter data!',
      body ?? 'You can now enter your data again.',
      scheduledTime,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'Time to enter data!',
          'You can now enter your data again.',
          channelDescription: 'Reminder You can now enter your data again.',
          importance: Importance.high,
          playSound: true,
          priority: Priority.high,
        ),
      ),
      // androidAllowWhileIdle: true,

      // for iOS
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,

      // for Android
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,

      // Make Notification repeat daily at same time
      // matchDateTimeComponents: DateTimeComponents.time
    );

    print('----------- ✅ Notification Scheduled -------------');
  }

  // Cancel all notifications
  Future<void> cancelAllNotification() async {
    await notificationPlugin.cancelAll();
  }

// -------- Now
  Future<void> sendNotification(int id, String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'hazard_channel', // Channel ID
      'Hazard Alerts', // Channel name
      channelDescription: 'Notifications for nearby hazards',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await notificationPlugin.show(
      id, // Notification ID
      title, // Notification title
      body, // Notification body
      platformChannelSpecifics,
    );
  }

  Future<void> showNowNotification(int id, String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'alert',
      'alert Notifications',
      channelDescription: 'Channel for alert notifications',
      importance: Importance.high,
      priority: Priority.high,
      showProgress: true,
      maxProgress: 100,
      enableVibration: true,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await notificationPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }
}
