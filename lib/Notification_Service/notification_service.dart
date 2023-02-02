import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
class NotificationService{
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin=FlutterLocalNotificationsPlugin();
  Future<void> initializeNotification() async{
    const AndroidInitializationSettings initializationSettingsAndroid=AndroidInitializationSettings('@mipmap/ic_launcher');
    const IOSInitializationSettings initializationSettingsiosIOS=IOSInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false
    );
    const InitializationSettings initializationSettings=InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsiosIOS
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }
  Future<void> showNotification(int id,String title,String body)async{
    var dateTime=DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,DateTime.now().hour,DateTime.now().minute,DateTime.now().second+2);
    tz.initializeTimeZones();
    final sound='click1.wav';
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(dateTime,tz.local),
      NotificationDetails(
        android: AndroidNotificationDetails(
          id.toString()+'s',
          'Go To Bed',
          importance: Importance.max,
          priority: Priority.max,
          icon: '@mipmap/ic_launcher',
          sound: RawResourceAndroidNotificationSound(sound.split('.').first),
        ),
        iOS: const IOSNotificationDetails(
            sound: 'deafault.wav',
            presentAlert: true,
            presentBadge: true,
            presentSound: true
        ),
      ),
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}