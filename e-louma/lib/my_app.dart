import 'package:E_louma/Pages/HomePage/homePage.dart';
import 'package:E_louma/Utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'main.dart';

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  _saveTokenFirebase(String token) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'tokenFirebase';
    var value = prefs.setString(key, token);
    debugPrint("value $value");
  }

  _config() {
    try {
      var initializationSettingsAndroid =
          new AndroidInitializationSettings('ic_launcher');
      var iOSSettings = DarwinInitializationSettings(
        requestSoundPermission: false,
        requestBadgePermission: false,
        requestAlertPermission: false,
      );
      var initialzationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      var initializationSettings = InitializationSettings(
          android: initialzationSettingsAndroid, iOS: iOSSettings);
      flutterLocalNotificationsPlugin.initialize(
          settings: initializationSettings);

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print("notification message $message");
        print("notification message ${message.notification?.apple}");
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification!.android;
        if (notification != null && android != null) {
          print("notification ${notification.title}");
          flutterLocalNotificationsPlugin.show(
            id: notification.hashCode,
            title: notification.title ?? '',
            body: notification.body,
            notificationDetails: NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                color: Colors.blue,
                // ignore: todo
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: "@mipmap/ic_launcher",
              ),
            ),
          );
        }
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification!.android;
        if (notification != null && android != null) {
          showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title.toString()),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(notification.body.toString())],
                  ),
                ),
              );
            },
          );
        }
      });
    } catch (error) {
      print("error push notif $error");
    }
  }

  @override
  void initState() {
    super.initState();
    _readToken();
    // ignore: unused_local_variable
    _config();
    getDeviceToken();
  }

  String? tokenFirebase;
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  Future<String?> getDeviceToken() async {
    // 1. Request notification permissions (Required for iOS)
    // NotificationSettings settings = await messaging.requestPermission(
    //   alert: true,
    //   badge: true,
    //   sound: true,
    // );

    // if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    // 2. Retrieve the FCM registration token
    String? token = await messaging.getToken();
    print("FCM Token: $token");
    _saveTokenFirebase(token ?? "");
    setState(() {
      tokenFirebase = token;
    });
    return token;
    // }

    // return null;
  }
  // getToken() async {
  //   // tokenFirebase = (await FirebaseMessaging.instance.getToken())!;

  //   String? apnsToken;
  //   // do {
  //   await Future.delayed(const Duration(seconds: 1));
  //   apnsToken = await FirebaseMessaging.instance.getToken();
  //   print("token firebase $apnsToken");
  //   await _saveTokenFirebase(apnsToken ?? "");

  //   _saveTokenFirebase(apnsToken ?? "");
  //   // } while (apnsToken == null);
  // }

  String token = "";
  _readToken() async {
    final prefs = await SharedPreferences.getInstance();

    var tokenValue = prefs.getString('token') ?? "";
    setState(() {
      token = tokenValue;
      print("tokenValue $token");
    });
  }

  @override
  Widget build(BuildContext context) {
    // var localizationDelegate = LocalizedApp.of(context).delegate;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-LOUMA',

      // localizationsDelegates: [
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      //   // localizationDelegate
      // ],
      theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          //primarySwatch: Colors.purple,

          ),
      home: HomePage(),
    );
  }
}
