import 'dart:io';

import 'package:E_louma/Pages/HomePage/homePage.dart';
import 'package:E_louma/my_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  debugPrint('Handling a background message ${message.messageId}');
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title// description
    importance: Importance.high,
    playSound: true);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
enableIOSNotifications() async {
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true, // Required to display a heads up notification
    badge: true,
    sound: true,
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey:
            "AIzaSyDfpaq3U1bhBRs1HA3mZbiQ_Lw7jxGtp2g", // paste your api key here
        appId:
            "1:183159945301:android:358e2adeed6cd08d22fcdc", //paste your app id here
        messagingSenderId: "6769424425", //paste your messagingSenderId here
        projectId: "app-e-louma-b20de", //paste your project id here
      ),
    );
  } else {
    await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyCfWeCJ1jpZWyuB0UvxNltg70MTao_U-_4",
          appId: "1:183159945301:ios:3a03ad15ce4f4cba22fcdc",
          messagingSenderId: "183159945301",
          projectId: "e-louma-b20de"),
    );
  }

  await enableIOSNotifications();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  // Ajoutez cette ligne pour initialiser la localisation

  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) => runApp(MyApp()));
}
