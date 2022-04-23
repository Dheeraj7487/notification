import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notification/screen.dart';

import 'firebasenotification.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String notificationTitle = "Title";
  String notificationBody = "Body";
  String notificationData = 'No Data';

  late FirebaseMessaging messaging;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  _changeData(String msg) => setState(() => notificationData = msg);
  _changeBody(String msg) => setState(() => notificationBody = msg);
  _changeTitle(String msg) => setState(() => notificationTitle = msg);

  onSelectLocalNotification(payload) {
    if (notificationTitle == notificationBody) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewScreen1(payload: "Screen1")));
    } else {Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewScreen2(payload: "Screen2")));}
  }

  onSelectLocalInitialize() {
    var androidSettings = AndroidInitializationSettings('mipmap/ic_launcher');
    var iOSSettings = IOSInitializationSettings(requestSoundPermission: false, requestBadgePermission: false, requestAlertPermission: false,);
    var initSetttings = InitializationSettings(android: androidSettings, iOS: iOSSettings);
    flutterLocalNotificationsPlugin.initialize(initSetttings, onSelectNotification: onSelectLocalNotification);
  }

  @override
  void initState() {

    final firebaseMessaging = FCM();
    firebaseMessaging.setNotifications();

    firebaseMessaging.streamCtlr.stream.listen(_changeData);
    firebaseMessaging.bodyCtlr.stream.listen(_changeBody);
    firebaseMessaging.titleCtlr.stream.listen(_changeTitle);

    //Get FCM Token
    FirebaseMessaging.instance.getToken().then((value) => print('Token: $value'));

    //ForeGround FireBase Notification
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      FlutterLocalNotificationsPlugin localNotifPlugin = new FlutterLocalNotificationsPlugin();
      var androidChannelSpecifics = AndroidNotificationDetails('default', 'Test App Notifications',);
      var iOSChannelSpecifics = IOSNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(android: androidChannelSpecifics, iOS: iOSChannelSpecifics);
      localNotifPlugin.show(0, event.notification!.title, event.notification!.body, platformChannelSpecifics);

      var androidSettings = AndroidInitializationSettings('mipmap/ic_launcher');
      var iOSSettings = IOSInitializationSettings(requestSoundPermission: false, requestBadgePermission: false, requestAlertPermission: false,);

      var initSetttings = InitializationSettings(android: androidSettings, iOS: iOSSettings);
      flutterLocalNotificationsPlugin.initialize(initSetttings,onSelectNotification: onSelectLocalNotification);
    });

    //Background Firebase Notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.notification!.title == message.notification!.body) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewScreen1(payload: "Screen1")));
      } else {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewScreen2(payload: "Screen2")));
      }
    });

    onSelectLocalInitialize();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(notificationTitle),
            Text(notificationBody),
            RaisedButton(
              onPressed: () {
                FlutterLocalNotificationsPlugin localNotifPlugin =
                new FlutterLocalNotificationsPlugin();
                var androidChannelSpecifics = AndroidNotificationDetails('default', 'Test App Notifications',);
                var iOSChannelSpecifics = IOSNotificationDetails();
                var platformChannelSpecifics = NotificationDetails(
                    android: androidChannelSpecifics, iOS: iOSChannelSpecifics);localNotifPlugin.show(0, notificationTitle, notificationBody, platformChannelSpecifics);
              },
              child: new Text('showNotification',),
            ),
          ],
        ),
      ),
    );
  }
}