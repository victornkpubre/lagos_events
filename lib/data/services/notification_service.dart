import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lagos_events/domain/models/event.dart';
import 'package:lagos_events/domain/models/reminder.dart';
import 'package:lagos_events/presentation/widgets.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();  

  static final NotificationService _notificationService = NotificationService._internal();
  factory NotificationService() {
    return _notificationService;
  }

  AndroidNotificationDetails androidPlatformChannelSpecifics = const AndroidNotificationDetails(
    'dbfood',
    'dbfood',
    importance: Importance.max,
    styleInformation: BigTextStyleInformation(
      "Default", 
      htmlFormatBigText: true,
      contentTitle: "Default",
      htmlFormatContentTitle: true,
    ),
    priority: Priority.max,
    playSound: true,
    sound: RawResourceAndroidNotificationSound("notification")
  );

  NotificationService._internal();

  Future<void> initialize() async {
    await requestPermission();
    await initInfo();
  }

  requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if(settings.authorizationStatus == AuthorizationStatus.authorized ){
    }
    else if(settings.authorizationStatus == AuthorizationStatus.provisional ){
    }
    else {
    }
  }

  Future<void> initInfo() async {
    var androidInitialize = const AndroidInitializationSettings("@mipmap/ic_launcher");
    var iOSInitialize = const DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(android: androidInitialize, iOS: iOSInitialize);

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response){
        try{
          String? payload = response.payload;
          if(payload != null && payload.isNotEmpty) {
            // Navigator.push(context, MaterialPageRoute (builder: (BuildContext context){
            //   return NewPage(info: payload.toString());
            // }));
          }else {
            
          }
        }
        catch(e){
          showErrorToastbar(e.toString());
        }
      }
    );

    FirebaseMessaging.onMessage.listen((message) async {

      // showNotification(message, "App was in the Foreground");

    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      try{
        // Navigator.push(context, MaterialPageRoute (builder: (BuildContext context){
        //   return NewPage(info: "App was in the Background");
        // }));
      }
      catch(e){
        showErrorToastbar(e.toString());
      }
    });

  }

  Future<void> showDefaultNotification() async {
    NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await _flutterLocalNotificationsPlugin.show(
      0,
      "Foreground Notification",
      "Default",
      platformChannelSpecifics,
      payload: "Default"
    );
  }

  int scheduleNotification(DateTime date, Event event) {
    NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    int id = DateTime.now().second * Random().nextInt(1000);
    _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      event.title,
      "Starting soon",
      tz.TZDateTime.from(date, tz.local),
      platformChannelSpecifics,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.alarmClock,
    );
    return id;
  }

  void cancleScheduledNotification(Reminder reminder) {
    _flutterLocalNotificationsPlugin.cancel(reminder.notificationid);
  }
  
}