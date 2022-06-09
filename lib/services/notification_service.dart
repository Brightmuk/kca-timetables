

import 'package:excel_reader/models/notification.dart';
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

  NotificationService() {
    
    init();
  }

  ///Initialise method thats called when the service starts
  Future<NotificationPayload?> init() async {


    NotificationPayload? selectedNotificationPayload =
        NotificationPayload(itemId: '', route: '/');

    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (String? payload) {
        selectedNotificationPayload = NotificationPayload.fromJson(payload!);
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

  tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local,date.year,date.month,date.day,date.hour,date.minute);

  tz.TZDateTime _nextTimeInstance() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  tz.TZDateTime _nextDayInstance() {
    tz.TZDateTime scheduledDate = _nextTimeInstance();
    while (DateTime.now().weekday != date.weekday) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
        
    await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        description,
        _nextDayInstance(),
        
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
            );

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

