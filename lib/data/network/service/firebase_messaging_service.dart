import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/firebase_options.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/view_model/main_view_model.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupFlutterNotifications();
  showFlutterNotification(message);
}

late AndroidNotificationChannel channel;

bool isFlutterLocalNotificationsInitialized = false;

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  channel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  FirebaseMessaging.instance.requestPermission(
    announcement: true,
    carPlay: true,
    criticalAlert: true,
  );
  isFlutterLocalNotificationsInitialized = true;
}

void showFlutterNotification(RemoteMessage message) {
  if(Get.isRegistered<MainViewModel>()){
    Get.find<MainViewModel>().notificationCount.value++;
  }

  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          icon: 'app_logo',
          color: AppColors.btnBackgroundColor,
        ),
      ),
    );
  }
}

late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

class FirebaseMessagingService {
  static FirebaseMessagingService? _instance;

  factory FirebaseMessagingService() {
    _instance ??= FirebaseMessagingService._initialize();
    return _instance!;
  }

  FirebaseMessagingService._initialize() {
    setupFlutterNotifications();
    FirebaseMessaging.onMessage.listen(showFlutterNotification);
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if(userBox.isNotEmpty)Get.toNamed(AppRoutes.notificationScreen);
    });
  }

  Future subscribeToTopic({required String topic}) async {
    await FirebaseMessaging.instance.subscribeToTopic(topic);
  }

  Future unsubscribeFromTopic({required String topic}) async {
    await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
  }

  static FirebaseMessagingService? get instance => _instance;
}
