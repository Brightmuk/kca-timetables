

import 'dart:async';

import 'package:excel_reader/models/notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/timezone.dart' as tz;


///Stream to get info about notification while app is in background or foreground
final BehaviorSubject<String?> selectNotificationSubject =
    BehaviorSubject<String?>();

///Stream to get info about notification while app is in background or foreground
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();


class NotificationService {
  
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();


String navigationActionId = 'id_3';
final StreamController<String?> selectNotificationStream = StreamController<String?>.broadcast();
  ///Initialise method thats called when the service starts
  Future<NotificationPayload?> init() async {


    NotificationPayload? selectedNotificationPayload =
        NotificationPayload(itemId: '', route: '/');

    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
final DarwinInitializationSettings initializationSettingsDarwin =
    DarwinInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin,
        );

  flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse notificationResponse)async {
      switch (notificationResponse.notificationResponseType) {
        case NotificationResponseType.selectedNotification:
          selectNotificationStream.add(notificationResponse.payload);
          break;
        case NotificationResponseType.selectedNotificationAction:
          if (notificationResponse.actionId == navigationActionId) {
            selectNotificationStream.add(notificationResponse.payload);
          }
          break;
      }
    },
   
  );
    return selectedNotificationPayload;
  }


  ///A notification that dissapears after the set timeout
  Future<void> showTimeoutNotification(int? mils) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('0', 'Popup',
            channelDescription: 'Short reminder',
            timeoutAfter: mils,
            priority: Priority.high,
            importance: Importance.high,
            sound: const RawResourceAndroidNotificationSound('guitar'),
            fullScreenIntent: true,
            styleInformation: const DefaultStyleInformation(true, true));
    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, 'Time notification',
        'Times out after ${mils! / 1000} seconds', platformChannelSpecifics);
  }



  ///Schedule a notification to a certain time or date
  Future<void> zonedScheduleNotification(
      {required int id,
      required String title,
      required String description,
      required String payload,
      required DateTime date,
      }) async {
        debugPrint("Date came as:"+date.toString());
  tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local,date.year,date.month,date.day,date.hour,date.minute);

   
    await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        description,
        scheduledDate,
        
        const NotificationDetails(
            android: AndroidNotificationDetails('1', 'Reminders',
                importance: Importance.max,
                priority: Priority.high,
                sound: RawResourceAndroidNotificationSound('guitar'),
                channelDescription: 'Reminds you about a class')),
        payload: payload,
        
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
            matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime
            ).catchError((e){
              debugPrint(e.toString());
            });
     


  }

  ///Remove a reminder
  Future<void> cancelReminder(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }



  Future onDidReceiveLocalNotification(
      int? id, String? title, String? body, String? payload) async {
    return Future.value(1);
  }

  Future<void> removeReminder(int notificationId) async {
    flutterLocalNotificationsPlugin.cancel(notificationId);
  }

}

